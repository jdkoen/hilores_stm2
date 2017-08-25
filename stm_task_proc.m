%% Clear screen and workspace
clear all;
clearvars -except subID setID;

%% Add Paths
path(path,genpath(pwd));
cd(fileparts(mfilename('fullpath')));

%% Get Subject ID and phase info
% Subject ID
if ~exist('subID','var')
    subID = input('Enter Subject ID: ','s');
end

% Material Set ID
setID = input('Enter ID for stimulus set (e.g., 101, 102, etc.): ');
setID = sprintf('set%d',setID);
setDir = fullfile('stim_sets',setID);
if ~exist(setDir,'dir')
    error('stimulus set does not exist.');
end

% Phase ID
fprintf('\nSelect Phase:\n\t1) Practice\n\t2) Real\n');
phaseID = input('Enter Phase ID: ');
if ~ismember(phaseID,[1 2])
    error('Incorrect phase selection. Must be a value of 1 or 2.')
end

%% Timing and Size Options
monID = 1; % ID of monitor to display stims
textSize = 30; % Size of text on the screen
stimDuration = 3; % Duration of stimulus in seconds
stDelay = 1; % Length of delay between study period and first test probe
testISI = .25; % Length of ISI between test probes
trialISI = 1.25; % Length of ISI between trials
imageDim.x = 150; % Size of the image in X
imageDim.y = imageDim.x; % Size of the image in Y
baseRect = [0 0 imageDim.x imageDim.y]; % Rectangle for use with psychtoolbox
xOffset = 100; % Value used to determine the coordinates of 4 quadrants
yOffset = 100; % Value used to determine the coordinates of 4 quadrants
bgColor = [128 128 128]; % Define background color
if phaseID == 1
    breaks = [];
elseif phaseID == 2
    breaks = [37 73]; % Trials in which a break happens
end

%% Load Response Scale Image
% Load scale image
scaleIMG = imread('lr_scale.png');

% Set Rect for response scale image
scaleRect = [0 0 432 144];

%% Response options
KbName('UnifyKeyNames'); % Make sure same across OS
moveOn = 'space';
leftResp = 'f';
rightResp = 'j';

%% Load stims
% Make subject directory
subDir = fullfile('data',subID);
if ~exist(subDir,'dir')
    mkdir(subDir);
else
    error('subID already exists. Copy to a new location before deleting, then restart.')
end

% Check if stim file exists, and determine best action
phases = {'_stm_prac.mat' '_stm_crit.mat'};
setFile = fullfile(setDir,strcat(setID,phases{phaseID}));
stimFile = fullfile(subDir,strcat(subID,phases{phaseID}));
copyfile(setFile,stimFile);

% Copy and rename stimFile
load(stimFile); % Load the file

% Add subject id
[stims.sub_id] = deal(subID);

% Make a backup
thisField = datestr(now,'mmm_dd_yyyy_HH_MM_SS_AM');
thisField = strrep(thisField,' ','');
archive.(thisField) = stims;

% Save the stims incase of crash
save(stimFile,'stims','archive');

%% Add start date and time
[stims.session_date] = deal(datestr(now,'mm/dd/yyyy'));
[stims.session_start] = deal(datestr(now,'HH:MM:SS'));

%% Run the experiment nested in try-catch loop
try
    
    %% Initialize Psychtoolbox
    % Hide the mouse cursor:
    HideCursor;
    
    % Initialize screen
    Screen('Preference', 'SkipSyncTests', 1);
    [w,wRect] = Screen('OpenWindow',monID,bgColor);
    
    % Get XY center of screen
    [xCenter,yCenter] = RectCenter(wRect);
    
    % Determine coordinates of quads for ss4
    q41Rect = CenterRectOnPointd(baseRect,xCenter-xOffset,yCenter+yOffset);
    q42Rect = CenterRectOnPointd(baseRect,xCenter+xOffset,yCenter+yOffset);
    q43Rect = CenterRectOnPointd(baseRect,xCenter-xOffset,yCenter-yOffset);
    q44Rect = CenterRectOnPointd(baseRect,xCenter+xOffset,yCenter-yOffset);
    
    % Determine coordinates of quads for ss2 and test (show left and right)
    q21RectTest = CenterRectOnPointd(baseRect,xCenter-xOffset,yCenter);
    q22RectTest = CenterRectOnPointd(baseRect,xCenter+xOffset,yCenter);
    
    % Determine coordinates of quads for ss2 and test (show left and right)
    q21RectStudy = CenterRectOnPointd(baseRect,xCenter,yCenter+yOffset);
    q22RectStudy = CenterRectOnPointd(baseRect,xCenter,yCenter-yOffset);
    
    % Determine coordinates for resposne scale
    scaleRect = CenterRectOnPointd(scaleRect,xCenter,yCenter+180);
    
    % Do dummy calls to GetSecs, WaitSecs, KbCheck to make sure
    % they are loaded and ready when we need them - without delays
    % in the wrong moment:
    KbCheck;
    WaitSecs(0.1);
    GetSecs;

    % Set priority for script execution to realtime priority:
    priorityLevel=MaxPriority(w);
    Priority(priorityLevel);  
    
    % Load and Draw instructions
    instructions = imread(fullfile('instruction_docs','stm','stm_instruction_slide.png'));
    tex = Screen('MakeTexture',w,instructions);
    Screen('DrawTexture',w,tex);
    Screen('Flip',w);
    
    % Wait for spacebar
    while true
        [t, keyCode, deltat] = KbWait([],2);
        if strcmpi(KbName(keyCode),moveOn)
            break;
        end
    end

    % Draw get ready
    DrawFormattedText(w,'Get Ready!','center','center',[255 255 255]);
    Screen('Flip',w);
    WaitSecs(2);
    
    % Draw fixation cross
    DrawFormattedText(w,'+','center','center',[255 255 255]);
    Screen('Flip',w);
    WaitSecs(2);
    
    % Clear buffers so far
    Screen('Close');
    
    %% Loop through stims
    for i = 1:length(stims)
        
        % Take a break if necessary
        if ismember(i,breaks)
            
            % Load and Draw instructions
            DrawFormattedText(w,'Take a Break!','center','center',[255 255 255]);
            Screen('Flip',w);
            
            % Wait for spacebar
            while true
                [t, keyCode, deltat] = KbWait([],2);
                if strcmpi(KbName(keyCode),moveOn)
                    break;
                end
            end
            
        end
        
        %% Study Period
        % Draw Study Cue
        DrawFormattedText(w,'+','center','center',[0 255 0]);      
        Screen('Flip',w);
        
        % Wait for ST Delay
        WaitSecs(.5);
        
        % Make texture and determine xy coordinates and rotation
        tex = [];
        thisRect = [];
        thisDeg = [];
        if stims(i).setSize == 2
            thisRect = [q21RectStudy' q22RectStudy'];
            thisDeg = [stims(i).targAng1 stims(i).targAng2];
            tex(1) = Screen('MakeTexture',w,stims(i).imgMat1);            
            tex(2) = Screen('MakeTexture',w,stims(i).imgMat2);
        elseif stims(i).setSize == 4
            thisRect = [q41Rect' q42Rect' q43Rect' q44Rect'];
            thisDeg = [stims(i).targAng1 stims(i).targAng2 ...
                stims(i).targAng3 stims(i).targAng4];
            tex(1) = Screen('MakeTexture',w,stims(i).imgMat1);            
            tex(2) = Screen('MakeTexture',w,stims(i).imgMat2);            
            tex(3) = Screen('MakeTexture',w,stims(i).imgMat3);            
            tex(4) = Screen('MakeTexture',w,stims(i).imgMat4);
        else
            error('The Set Size is wrong on trial %d',i);
        end
        
        % Draw textures to screen
        Screen('DrawTextures',w,tex,[],thisRect,thisDeg);        
        DrawFormattedText(w,'+','center','center',[255 255 255]);
        [timeStamp,stimStart] = Screen('Flip',w);
        if phaseID == 1
            stims(i).studyIMG = Screen('GetImage',w);
        end
            
        
        % Save Stim Start
        stims(i).timeStamp = timeStamp;
        stims(i).studyOnset = stimStart;
        
        % Wait for duration
        WaitSecs(stimDuration);
        
        % Screen Close
        Screen('Close');
        
        %% ST Delay
        % Draw fixation for ST Delay
        DrawFormattedText(w,'+','center','center',[255 255 255]);      
        Screen('Flip',w);
        
        % Wait for ST Delay
        WaitSecs(stDelay);
        
        %% Test Phase
        for j = 1:stims(i).setSize
            
            % Clear stuff
            thisRect = [];
            thisDeg = [];
            tex = [];
            
            % Get rect make textures
            thisRect = [q21RectTest' q22RectTest'];
            tex(1) = Screen('MakeTexture',w,stims(i).(strcat('imgMat',num2str(j))));   
            tex(2) = tex(1);
            
            % Get correct side, and angles
            corSide = stims(i).(strcat('testCor',num2str(j)));
            targAng = stims(i).(strcat('targAng',num2str(j)));
            lureAng = stims(i).(strcat('lureAng',num2str(j)));
            
            % Determine thisDeg based on corSide
            if strcmpi(corSide,'left')
                thisDeg = [targAng lureAng];
            elseif strcmpi(corSide,'right')
                thisDeg = [lureAng targAng];
            end
            
            % Add Response Scale            
            tex(3) = Screen('MakeTexture',w,scaleIMG);
            thisRect = [thisRect scaleRect'];
            thisDeg = [thisDeg 0];            
            
            % Draw textures to screen
            Screen('DrawTextures',w,tex,[],thisRect,thisDeg);
            DrawFormattedText(w,'+','center','center',[255 0 0]);
            [timeStamp,stimStart] = Screen('Flip',w);
            if phaseID == 1
                stims(i).(strcat('testIMG',num2str(j))) = Screen('GetImage',w);
            end
            
            % Wait for resp
            while true
                [t, keyCode, deltat] = KbWait([],2);
                if ismember(KbName(keyCode),[leftResp rightResp])
                    break;
                end
            end
        
            % Log response
            stims(i).(strcat('key_press',num2str(j))) = find(keyCode);
            stims(i).(strcat('resp',num2str(j))) = KbName(keyCode);
        
            % Score accuracy
            if strcmpi(stims(i).(strcat('resp',num2str(j))),'f') && strcmpi(stims(i).(strcat('testCor',num2str(j))),'left')
                stims(i).(strcat('acc',num2str(j))) = 1;
            elseif strcmpi(stims(i).(strcat('resp',num2str(j))),'j') && strcmpi(stims(i).(strcat('testCor',num2str(j))),'right')
                stims(i).(strcat('acc',num2str(j))) = 1;
            else
                stims(i).(strcat('acc',num2str(j))) = 0;
            end
            
            % Compute and log RT
            onset = stimStart;
            stims(i).(strcat('testOnset',num2str(j))) = onset;
            rtt = t; 
            stims(i).(strcat('testRT_Time',num2str(j))) = rtt;
            rt = rtt - onset;
            stims(i).(strcat('testRT',num2str(j))) = rt;
        
            % Test ISI
            % Draw fixation for a variable amount of time
            DrawFormattedText(w,'+','center','center',[255 255 255]);
            Screen('Flip',w);
            WaitSecs(testISI);
            
        end
        
        %% ISI Between Sets
        % Draw fixation for a variable amount of time
        DrawFormattedText(w,'+','center','center',[255 255 255]);
        Screen('Flip',w);
        WaitSecs(trialISI);
        
        % Screen Close
        Screen('Close');
        
    end
    
    % Draw fixation for a variable amount of time
    DrawFormattedText(w,'Phase Completed','center','center',[255 255 255]);
    Screen('Flip',w);
    WaitSecs(3);
    
    % Clear imgMat field for space
    stims = rmfield(stims,{'imgMat1' 'imgMat2' 'imgMat3' 'imgMat4'});
    
    % Session end    
    [stims.session_end] = deal(datestr(now,'HH:MM:SS'));
          
    % Save the stims and close the log file
    save(stimFile,'stims','archive');
    
    % Do same cleanup as at the end of a regular session...
    Screen('CloseAll');
    ShowCursor;
    fclose('all');
    Priority(0);
    
catch ME
    
    % catch error: This is executed in case something goes wrong in the
    % 'try' part due to programming error etc.:
    
    % Save the stims and close the log file
    save(stimFile,'stims','archive');
    
    % Do same cleanup as at the end of a regular session...
    Screen('CloseAll');
    ShowCursor;
    fclose('all');
    Priority(0);
    
    % Output the error message that describes the error:
    rethrow(ME);
    psychrethrow(psychlasterror);
    
end

            
    
    
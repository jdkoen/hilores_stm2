%% Script for the Gabor Task
% Uses Psychtoolbox
%
% 

%% Clear screen and workspace
clear all;
clearvars -except subID;

%% Add Paths
path(genpath(pwd),path);

%% Get Subject ID and phase info
if ~exist('subID','var')
    subID = input('Enter Subject ID: ','s');
end
fprintf('\nSelect Phase:\n\t1) Practice\n\t2) Real\n');
phaseID = input('Enter Phase ID: ');
if ~ismember(phaseID,[1 2])
    error('Incorrect phase selection. Must be a value of 1 or 2.')
end

%% Timing and Size Options
monID = 0; % ID of monitor to display stims
textSize = 30; % Size of text on the screen
delta = 13; % Change, in degrees, of different trials
if phaseID == 1 % Number of list repetitions (actual trials numbers is 8*nReps)
    nReps = 1;
elseif phaseID == 2
    nReps = 20;
end
stimDuration = .3; % Duration of stimulus in seconds
itiDuration = .5; % Length of ITI in seconds
x.left = -180; % X position on left
x.right = -1*x.left; % X position on right
gaborDim.x = 200; % Size of the gabor patch in X
gaborDim.y = gaborDim.x; % Size of the gabor patch in Y
xOffset = gaborDim.x/2+50; % Offset of left and right stims
if phaseID == 1
    breaks = [];
elseif phaseID == 2
    breaks = 41:40:160; % Trials in which a break happens
end

%% Response options
KbName('UnifyKeyNames'); % Make sure same across OS
moveOn = KbName('space');
sameResp = KbName('f');
diffResp = KbName('j');

%% Load Gabor and Scale Image and get some settings
% Load image
gIMG = imread('gabor.png');
gIMG = imresize(gIMG,[gaborDim.x gaborDim.y]);

% Load scale image
scaleIMG = imread('sd_scale.png');
scaleRect = [0 0 432 144];

% Define initial rect of image (basically image dims)
baseRect = [0 0 gaborDim.x gaborDim.y];

%% Make stims
% Manage directories
subDir = fullfile('data',subID);
if ~exist(subDir,'dir'), mkdir(subDir); end;

% Check if stim file exists, and determine best action
if phaseID == 1
    stimFile = fullfile(subDir,strcat(subID,'_gabor_prac.mat'));
elseif phaseID == 2
    stimFile = fullfile(subDir,strcat(subID,'_gabor_crit.mat'));
end
if exist(stimFile,'file')
    load(stimFile);
else    
    stims = create_gabor_task_stims(subID,nReps,delta);
end

% Backup the current stims
thisField = datestr(now,'mmm_dd_yyyy_HH_MM_SS_AM');
thisField = strrep(thisField,' ','');
origStims.(thisField) = stims;

% Save the stims incase of crash
save(stimFile,'stims','origStims');

%% Add start date and time
[stims.session_date] = deal(datestr(now,'mm/dd/yyyy'));
[stims.session_start] = deal(datestr(now,'HH:MM:SS'));

%% Run the experiment nexted in try-catch loop
try
    
    %% Initialize Psychtoolbox
    % Hide the mouse cursor:
    HideCursor;
    
    % Returns as default the mean gray value of screen:
    bgColor = GrayIndex(monID); 
    
     % Turn of Sync
    Screen('Preference', 'SkipSyncTests', 1);
    
    % Initialize screen
    [w,wRect] = Screen('OpenWindow',monID,bgColor);
    
    % Get XY center of screen
    [xCenter,yCenter] = RectCenter(wRect);
    
    % Determine left and right coordinates
    leftRect = CenterRectOnPointd(baseRect,xCenter-xOffset,yCenter);
    rightRect = CenterRectOnPointd(baseRect,xCenter+xOffset,yCenter);
    imgRect = [leftRect; rightRect];
    
    % Determine coordinates for resposne scale
    scaleRect = CenterRectOnPointd(scaleRect,xCenter,yCenter+120);
    
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
    instructions = imread(fullfile('instruction_docs','gabor','gabor_instruction_slide.png'));
    tex = Screen('MakeTexture',w,instructions);
    Screen('DrawTexture',w,tex);
    Screen('Flip',w);
    
    % Wait for spacebar
    [KeyIsDown, t, KeyCode] = KbCheck;
    while true
        if KeyCode(moveOn) == 1
            break;
        end
        [KeyIsDown, t, KeyCode]=KbCheck;
    end
%     get_response(Inf);

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
        
        % initialize KbCheck and variables to make sure they're
        % properly initialized/allocted by Matlab - this to avoid time
        % delays in the critical reaction time measurement part of the
        % script:
        [KeyIsDown, endrt, KeyCode]=KbCheck;
        
        % Take a break if necessary
        if ismember(i,breaks)
            
            % Load and Draw instructions
            DrawFormattedText(w,'Take a Break!','center','center',[255 255 255]);
            Screen('Flip',w);
            
            % Wait for spacebar
            [KeyIsDown, t, KeyCode] = KbCheck;
            while true
                if KeyCode(moveOn) == 1
                    break;
                end
                [KeyIsDown, t, KeyCode]=KbCheck;
            end
            
        end
        
        % Draw Study Cue
        DrawFormattedText(w,'+','center','center',[0 255 0]);      
        Screen('Flip',w);
        
        % Wait for ST Delay
        WaitSecs(.5);
        
        % Draw Left Gabor Patches
        tex(1) = Screen('MakeTexture',w,gIMG);
        tex(2) = Screen('MakeTexture',w,gIMG);
                
        % Determine order of angels
        if strcmpi(stims(i).item_type,'same')
            thisDeg = [stims(i).targ_deg stims(i).targ_deg];
        else
            if strcmpi(stims(i).diff_side,'left')
                thisDeg = [stims(i).lure_deg stims(i).targ_deg];
            elseif strcmpi(stims(i).diff_side,'right')
                thisDeg = [stims(i).targ_deg stims(i).lure_deg];
            else
                error('Something is wrong with stims...');
            end
        end
                
        % Draw the gabor patch
        Screen('DrawTextures',w,tex,[],imgRect',thisDeg);        
        DrawFormattedText(w,'+','center','center',[255 255 255]);
        [timeStamp,stimStart] = Screen('Flip',w);
        if phaseID == 1
            stims(i).dispIMG = Screen('GetImage',w);
        end
                
        % Save Stim Start
        stims(i).stimStart = stimStart;
        
        % Wait for duration
        WaitSecs(stimDuration);
        
        % Draw fixation
        tex = Screen('MakeTexture',w,scaleIMG);
        Screen('DrawTexture',w,tex,[],scaleRect');
        DrawFormattedText(w,'+','center','center',[255 0 0]);      
        Screen('Flip',w);
        if phaseID == 1
            stims(i).respIMG = Screen('GetImage',w);
        end
        
        % Wait for resp
        [KeyIsDown, t, KeyCode] = KbCheck;
        while true
            if (KeyCode(sameResp) == 1) || (KeyCode(diffResp) == 1)
                break;
            end
            [KeyIsDown, t, KeyCode]=KbCheck;
        end
        
        % Log response
        stims(i).key_press = find(KeyCode);
        stims(i).resp = KbName(KeyCode);
        
        % Score accuracy and RT
		stims(i).rtt = t + stims(i).stimStart;
        stims(i).rt = t;
        if strcmpi(stims(i).resp,'f') && strcmpi(stims(i).item_type,'same')
            stims(i).acc = 1;
        elseif strcmpi(stims(i).resp,'j') && strcmpi(stims(i).item_type,'diff')
            stims(i).acc = 1;
        else
            stims(i).acc = 0;
        end       
        
        % Draw fixation for a variable amount of time
        DrawFormattedText(w,'+','center','center',[255 255 255]);      
        Screen('Flip',w);
        WaitSecs(itiDuration);
        
        % Screen Close
        Screen('Close');
        
    end
    
    % Draw fixation for a variable amount of time
    DrawFormattedText(w,'Phase Completed','center','center',[255 255 255]);
    Screen('Flip',w);
    WaitSecs(3);
    
    % Session end    
    [stims.session_end] = deal(datestr(now,'HH:MM:SS'));
      
    % Save the stims and close the log file
    save(stimFile,'stims','origStims');
    
    % Do same cleanup as at the end of a regular session...
    Screen('CloseAll');
    ShowCursor;
    fclose('all');
    Priority(0);
    
catch
    
    % catch error: This is executed in case something goes wrong in the
    % 'try' part due to programming error etc.:
    
    % Do same cleanup as at the end of a regular session...
    Screen('CloseAll');
    ShowCursor;
    fclose('all');
    Priority(0);
    
    % Output the error message that describes the error:
    psychrethrow(psychlasterror);
    
end

        
        
    

    
    
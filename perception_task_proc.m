%% Clear screen and workspace
clear all;
clearvars -except subID;

%% Add Paths
path(path,genpath(pwd));

%% Get Subject ID and phase info
if ~exist('subID','var')
    subID = input('Enter Subject ID: ','s');
end
fprintf('\nSelect Phase:\n\t1) Practice\n\t2) Real\n');
phaseID = input('Enter Phase ID: ');
if ~ismember(phaseID,[1 2])
    error('Incorrect phase selection. Must be a value of 1 or 2.')
end
if phaseID == 2
    rngSeed = input('Enter material ID if yoking stims: ');
end

%% Timing and Size Options
monID = 0; % ID of monitor to display stims
textSize = 30; % Size of text on the screen
delta.low = 45; % Change, in degrees, of different trials for different resolutions
delta.mid = 20;
delta.high = 13;
stimDuration = .5; % Duration of stimulus in seconds
itiDuration = 1.25; % Length of ITI in seconds
imageDim.x = 150; % Size of the gabor patch in X
imageDim.y = imageDim.x; % Size of the gabor patch in Y
if phaseID == 1
    breaks = [];
elseif phaseID == 2
    breaks = 49:48:288; % Trials in which a break happens
end
baseRect = [0 0 imageDim.x imageDim.y]; % Rectangle for use with psychtoolbox
xOffset = 100; % Value used to determine the coordinates of 4 quadrants
yOffset = 100; % Value used to determine the coordinates of 4 quadrants

%% Load Response Scale Image
% Load scale image
scaleIMG = imread('sd_scale.png');

% Set Rect for response scale image
scaleRect = [0 0 432 144];

%% Response options
KbName('UnifyKeyNames'); % Make sure same across OS
moveOn = KbName('space');
sameResp = KbName('f');
diffResp = KbName('j');

%% Make stims
% Manage directories
subDir = fullfile('data',subID);
if ~exist(subDir,'dir'), mkdir(subDir); end;

% Check if stim file exists, and determine best action
if phaseID == 1
    stimFile = fullfile(subDir,strcat(subID,'_perception_prac.mat'));
elseif phaseID == 2
    stimFile = fullfile(subDir,strcat(subID,'_perception_crit.mat'));
end
if exist(stimFile,'file')
    load(stimFile);
else
    if phaseID == 1
        stims = create_perception_stims_prac(subID,delta);
    elseif phaseID == 2
        stims = create_perception_stims_crit(subID,delta,rngSeed);
    end
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
    gray = GrayIndex(monID); 
    
    % Turn of Sync
    Screen('Preference', 'SkipSyncTests', 1);
    
    % Initialize screen
    [w,wRect] = Screen('OpenWindow',monID,gray);
    
    % Get XY center of screen
    [xCenter,yCenter] = RectCenter(wRect);
    
   % Determine coordinates of quads for ss4
    q41Rect = CenterRectOnPointd(baseRect,xCenter-xOffset,yCenter+yOffset);
    q42Rect = CenterRectOnPointd(baseRect,xCenter+xOffset,yCenter+yOffset);
    q43Rect = CenterRectOnPointd(baseRect,xCenter-xOffset,yCenter-yOffset);
    q44Rect = CenterRectOnPointd(baseRect,xCenter+xOffset,yCenter-yOffset);
    
    % Determine coordinates of quads for ss2 and test
    q21Rect = CenterRectOnPointd(baseRect,xCenter-xOffset,yCenter);
    q22Rect = CenterRectOnPointd(baseRect,xCenter+xOffset,yCenter);
    
    % Determine coordinates for resposne scale
    scaleRect = CenterRectOnPointd(scaleRect,xCenter,yCenter+120);
    
    % Load each image (for speed of drawing to screen)
    for i = 1:length(stims)
        stims(i).imgMat = imread(stims(i).image,'BackgroundColor',repmat(gray/255,1,3));
    end

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
    instructions = imread(fullfile('instruction_docs','perception','perception_instruction_slide.png'));
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
            Screen('Flip');
            
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
        
        % Make texture and determine xy coordinates and rotation
        thisRect = []; tex = []; thisDeg = [];
        if stims(i).set_size == 2
            thisRect = [q21Rect' q22Rect'];
            thisDeg = stims(i).deg_vec;
            tex(1) = Screen('MakeTexture',w,stims(i).imgMat);
            tex(2) = tex(1);
        elseif stims(i).set_size == 4
            thisRect = [q41Rect' q42Rect' q43Rect' q44Rect'];
            thisDeg = stims(i).deg_vec;
            tex(1) = Screen('MakeTexture',w,stims(i).imgMat);
            tex(2:4) = tex(1);
        end
        
        % Draw textures to screen
        Screen('DrawTextures',w,tex,[],thisRect,thisDeg);        
        DrawFormattedText(w,'+','center','center',[255 255 255]);
        [timeStamp,stimStart] = Screen('Flip',w);
        if phaseID == 1
            stims(i).thisIMG = Screen('GetImage',w);
        end
        
        % Save Stim Start
        stims(i).stimStart = stimStart;
        
         % Wait for duration
        WaitSecs(stimDuration);
        
        % Draw fixation and response scale
        tex = Screen('MakeTexture',w,scaleIMG);
        Screen('DrawTexture',w,tex,[],scaleRect');
        DrawFormattedText(w,'+','center','center',[255 0 0]);
        Screen('Flip',w);
        
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
        stims(i).rtt = t;
        stims(i).rt = stims(i).rtt - stims(i).stimStart;
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
    
    % Clear imgMat field for space
    stims = rmfield(stims,'imgMat');
      
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
     ShowCursor;
    fclose('all');
    Priority(0);
    
    % Output the error message that describes the error:
    psychrethrow(psychlasterror);
    
end

            
    
    
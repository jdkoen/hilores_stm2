%% Script for the Gabor Task
% Uses Psychtoolbox
%
% 

%% Run the settings scripts
cd(fileparts(mfilename('fullpath')));
path(path,genpath(pwd));
run hiloresSTM2_settings.m

%% Define when breaks happen
if phaseID == 1
    breaks = [];
elseif phaseID == 2
    breaks = 41:40:160; % Trials in which a break happens
end

%% Load stims
% Make subject directory
subDir = fullfile('data',subID);
if ~exist(subDir,'dir')
    mkdir(subDir);
end

% Copy set files to stim files
phases = {'_gabor_prac.mat' '_gabor_crit.mat'};
setFile = fullfile(setDir,strcat(setID,phases{phaseID}));
stimFile = fullfile(subDir,strcat(subID,phases{phaseID}));
copyfile(setFile,stimFile);

% Load stimFile
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
    leftRect = CenterRectOnPointd(baseRect,xCenter-gabor.xOffset,yCenter);
    rightRect = CenterRectOnPointd(baseRect,xCenter+gabor.xOffset,yCenter);
    imgRect = [leftRect; rightRect];
    
    % Determine coordinates for resposne scale
    gabor.scaleRect = CenterRectOnPointd(gabor.scaleRect,xCenter,yCenter+120);
    
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
        
        % Draw fixation
        DrawFormattedText(w,'+','center','center',[0 255 0]);      
        Screen('Flip',w);
        
        % Wait for ST Delay
        WaitSecs(.5);
        
        % Draw Gabor Patches
        tex(1) = Screen('MakeTexture',w,gIMG);
        tex(2) = Screen('MakeTexture',w,gIMG);
                
        % Determine order of angles
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
        stims(i).timeStamp = timeStamp;
        stims(i).stimStart = stimStart;
        
        % Wait for duration
        WaitSecs(duration.gabor.stim);
        
        % Screen Close
        Screen('Close');
        
        %% Draw resposne screne (test phase)
        % Draw fixation with scale
        tex = Screen('MakeTexture',w,gabor.scaleIMG);
        Screen('DrawTexture',w,tex,[],gabor.scaleRect');
        DrawFormattedText(w,'+','center','center',[255 0 0]);      
        [timeStamp,stimStart] = Screen('Flip',w);
        if phaseID == 1
            stims(i).respIMG = Screen('GetImage',w);
        end
        
        % Wait for resp
        while true
            [t, keyCode, deltat] = KbWait([],2);
            if ismember(KbName(keyCode),[leftResp rightResp])
                break;
            end
        end
        
        % Log response
        stims(i).key_press = find(keyCode);
        stims(i).resp = KbName(keyCode);
        
        % Score accuracy        
        if strcmpi(stims(i).resp,'f') && strcmpi(stims(i).item_type,'same')
            stims(i).acc = 1;
        elseif strcmpi(stims(i).resp,'j') && strcmpi(stims(i).item_type,'diff')
            stims(i).acc = 1;
        else
            stims(i).acc = 0;
        end       
        
        % Log RT 
        onset = stimStart;
        stims(i).testOnset = onset;
        rtt = t;
        stims(i).testRT_Time = rtt;
        rt = rtt - onset;
        stims(i).testRT = rt;
        
        % Draw fixation for a variable amount of time
        DrawFormattedText(w,'+','center','center',[255 255 255]);      
        Screen('Flip',w);
        WaitSecs(duration.gabor.iti);
        
        % Screen Close
        Screen('Close');
        
    end
    
    % Draw phase completed
    DrawFormattedText(w,'Phase Completed','center','center',[255 255 255]);
    Screen('Flip',w);
    WaitSecs(3);
    
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
    rethrow(ME)
    psychrethrow(psychlasterror);
    
end

        
        
    

    
    
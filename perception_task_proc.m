%% Perception Task Proc
% Runs the experimental perceptual task. 
%
% In this task participants are shown displays of the same object in 2 or 4
% locations (left/right or a 4-square grid). On some trials, ALL of the
% images will have the same orientation. On other trials, one of the images
% will have a different rotation. Participants are task with reporting if
% the all images in the set have the SAME rotation, or if one has a
% DIFFERENT rotation. 
%
% A self-paced break is given to participants every 48 trials. 
%
% Timing and other features are controlled in the hiloresSTM2_settings.m
% file.
%
% Orientations are controlled by the Screen function of Psychtoolbox. 
%% Run the settings scripts
cd(fileparts(mfilename('fullpath')));
path(path,genpath(pwd));
run hiloresSTM2_settings.m

%% Define when Breaks Happen
if phaseID == 1
    breaks = [];
elseif phaseID == 2
    breaks = 49:48:288; % Trials in which a break happens
end

%% Load stims
% Make subject directory
subDir = fullfile('data',subID);
if ~exist(subDir,'dir')
    mkdir(subDir);
end

% Copy set files to stim files
phases = {'_perception_prac.mat' '_perception_crit.mat'};
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
    q21Rect = CenterRectOnPointd(baseRect,xCenter,yCenter+yOffset);
    q22Rect = CenterRectOnPointd(baseRect,xCenter,yCenter-yOffset);
    
    % Determine coordinates for resposne scale
    per.scaleRect = CenterRectOnPointd(per.scaleRect,xCenter,yCenter+120);
    
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
        stims(i).timeStamp = timeStamp;
        stims(i).stimStart = stimStart;
        
         % Wait for duration
        WaitSecs(duration.per.stim);
        
        % Screen Close
        Screen('Close');
        
        %% Draw resposne screne (test phase)
        % Draw fixation and response scale
        tex = Screen('MakeTexture',w,per.scaleIMG);
        Screen('DrawTexture',w,tex,[],per.scaleRect');
        DrawFormattedText(w,'+','center','center',[255 0 0]);
        Screen('Flip',w);
        
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
        WaitSecs(duration.per.iti);
        
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

            
    
    
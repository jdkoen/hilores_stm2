%% Make Stimulus Sets for HiLoResSTM2
% This script calls functions to generate stimulus sets for the
% HiLoRes_STM2 study. 
%
% When running this for a new version, update the version variable
% accordingly. For pilot studies aimed at determining performance, use a
% 'p' in front of a number (e.g., 'p1', 'p2' for pilots 1 and 2). For the
% proper experiments, use numbers (but input as a string; e.g., 1 and 2 for
% experiments 1 and 2).  
%
% When making a new version, also add settings to the if statement. This is
% simply meant to document changes over time (although Git will track them,
% this makes it more trasparent, although somewhat not as asthetically
% pleasing)

%% Version #
version = 'p1';

%% Make save directory
saveDir = fullfile(fileparts(mfilename('fullpath')),'stim_sets');

%% Define Background Color
bgColor = [128 128 128];

%% Determine settings based on version (this is to keep record of everything
if strcmpi(version,'p1') % Pilot 1
    
    % STM settings
    stm.low = 45; % Change, in degrees, of different trials for different resolutions
    stm.high = 20; % Change, in degrees, of different trials for different resolutions
    
    % Gabor settings
    gabor.delta = 13; % Change, in degrees, of different trials for t
    nReps.practice = 1; % Produces 8 * nReps.practice trials.
    nReps.critical = 20; % Produces 8 * nReps.crtical trials
    
    % Perception settings
    per.low = stm.low; % Change, in degrees, of different trials for different resolutions. Always same as stm.low
    per.mid = stm.high; % Always same as stm.low
    per.high = gabor.delta; % Always same as gabor.delta
    
    % Determine number of sets to make
    nSets = 10;

    % Seed RNG
    rng(201);
    
else
    
    error('The specifed version has no settings. Add these first.');
    
end

%% Make Stim lists for STM, Gabor, and Perception
for i = 1:nSets
    
    %% Create setID
    setID = sprintf('set%s%2.2d',version,i);
    setDir = fullfile(saveDir,setID);
    if exist(setDir,'dir')
        warning('Stim set already created. Copying directory first the deleting.');
        copyDir = fullfile(saveDir,'safety_first',strcat(setID,'_',datestr(datetime('now'),'dd_mm_yyyy_HH_MM')));
        copyfile(setDir,copyDir);
        rmdir(setDir,'s');
    end
    mkdir(setDir);
    
    %% Make a critical STM stimulus set
    stims = create_stm_stims_crit(setID,stm,bgColor);
    [stims.sub_id] = deal('');
    saveFile = fullfile(setDir,strcat(setID,'_stm_crit.mat'));
    save(saveFile,'stims');
    clear saveFile stims;
    
    %% Make a practice STM stimulus set
    stims = create_stm_stims_prac(setID,stm,bgColor);
    [stims.sub_id] = deal('');
    saveFile = fullfile(setDir,strcat(setID,'_stm_prac.mat'));
    save(saveFile,'stims');
    clear saveFile stims;
    
    %% Make a critical gabor stimulus set
    stims = create_gabor_task_stims(setID,nReps.critical,gabor.delta);
    [stims.sub_id] = deal('');
    saveFile = fullfile(setDir,strcat(setID,'_gabor_crit.mat'));
    save(saveFile,'stims');
    clear saveFile stims;
    
    %% Make a practice gabor stimulus set
    stims = create_gabor_task_stims(setID,nReps.practice,gabor.delta);
    [stims.sub_id] = deal('');
    saveFile = fullfile(setDir,strcat(setID,'_gabor_prac.mat'));
    save(saveFile,'stims');
    clear saveFile stims;
    
    %% Make a critical perception stimulus set
    stims = create_perception_stims_crit(setID,per);
    [stims.sub_id] = deal('');
    saveFile = fullfile(setDir,strcat(setID,'_perception_crit.mat'));
    save(saveFile,'stims');
    clear saveFile stims;
    
    %% Make practice perception stimulus set
    stims = create_perception_stims_prac(setID,per);
    [stims.sub_id] = deal('');
    saveFile = fullfile(setDir,strcat(setID,'_perception_prac.mat'));
    save(saveFile,'stims');
    clear saveFile stims;
    
end

    
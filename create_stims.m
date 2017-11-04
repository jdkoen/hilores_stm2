%% Make Stim Sets for HiLoResSTM2

% Version #
version = 'p1';

% Make save directory
saveDir = fullfile(fileparts(mfilename('fullpath')),'stim_sets');

% Define Background Color
bgColor = [128 128 128];

% STM settings
stm.low = 45; % Change, in degrees, of different trials for different resolutions
stm.high = 20; % Change, in degrees, of different trials for different resolutions

% Gabor settings
gabor.delta = 13; % Change, in degrees, of different trials for t  
nReps.practice = 1;
nReps.critical = 20;

% Perception settings
per.low = stm.low; % Change, in degrees, of different trials for different resolutions. Always same as stm.low
per.mid = stm.high; % Always same as stm.low
per.high = gabor.delta; % Always same as gabor.delta

%% Make Stim lists for STM, Gabor, and Perception
nSets = 1;
rng(201);
for i = 1:nSets
    
    %% Create setID
    setID = sprintf('set%s%2.2d',version,i);
    setDir = fullfile(saveDir,setID);
    if exist(setDir,'dir')
        warning('Stim set already created. Copying directory first the deleting.');
        copyDir = fullfile(saveDir,'safety_first',strcat(setID,'_',datestr(datetime('now'),'DD_MM_YYYY')));
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
    stims = create_perception_stims_crit(subID,per);
    [stims.sub_id] = deal('');
    saveFile = fullfile(setDir,strcat(setID,'_perception_crit.mat'));
    save(saveFile,'stims');
    clear saveFile stims;
    
    %% Make practice perception stimulus set
    stims = create_perception_stims_prac(subID,per);
    [stims.sub_id] = deal('');
    saveFile = fullfile(setDir,strcat(setID,'_perception_prac.mat'));
    save(saveFile,'stims');
    clear saveFile stims;
    
end

    
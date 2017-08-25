%% Make Stim Sets for HiLoResSTM2

% Version #
version = '1';

% Make save directory
saveDir = fullfile(fileparts(mfilename('fullpath')),'stim_sets');

% Define Background Color
bgColor = [128 128 128];

% Other options
stm.low = 45; % Change, in degrees, of different trials for different resolutions
stm.high = 20; % Change, in degrees, of different trials for different resolutions
    
    
%% Make Stim lists for STM, Gabor, and Perception
nSets = 10;
rng(201);
for i = 1:nSets
    
    %% Create setID
    setID = sprintf('set%s%2.2d',version,i);
    setDir = fullfile(saveDir,setID);
    if exist(setDir,'dir')
        error('Stim set already created. Cautiously delete existing stims, but copy first.');
    else
        mkdir(setDir);
    end
    
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
    
end

    
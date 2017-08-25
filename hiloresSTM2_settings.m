%% HiLoResSTM2 Setup Information
% This script runs setup information and controls settings for the phases
% in HiLoResSTM2. 

%% Clear screen and workspace
clear all;
clearvars -except subID setID monID;

%% Get Monitor ID, Subject ID, Material Set ID, and Phase Info
% Monitor ID
if ~exist('monID','var')
    fprintf('\nSelect monitor setting:\n\t0 - Laptop or Desktop with 1 monitor\n');
    fprintf('\t1 - Desktop with 2 monitors\n');
    monID = input('Enter monitor ID: ');
end

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

%% Experiment Settings
textSize = 30; % Size of text on the screen
baseRect = [0 0 imageDim.x imageDim.y]; % Rectangle for use with psychtoolbox
xOffset = 100; % Value used to determine the coordinates of 4 quadrants
yOffset = 100; % Value used to determine the coordinates of 4 quadrants
bgColor = [128 128 128]; % Define background color

% Duration variables for STM
duration.stm.study = 3; % Duration of stimulus in seconds
duration.stm.st_delay = 1; % Length of delay between study period and first test probe
duration.stm.test_isi = .25; % Length of ISI between test probes
duration.stm.trial_isi = 1.25; % Length of ISI between trials

% Response Options
moveOn = 'space';
leftResp = 'f';
rightResp = 'j';

%% Load Response Scale Image
% Load scale image
scaleIMG = imread('lr_scale.png');

% Set Rect for response scale image
scaleRect = [0 0 432 144];
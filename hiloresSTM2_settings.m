%% HiLoResSTM2 Setup Information
% This script runs setup information and controls settings for the phases
% in HiLoResSTM2. 

%% Clear screen and workspace
clearvars -except subID setID setDir monID;
clc;

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
if ~exist('setID','var') || ~exist('setDir','var')
    setID = input('Enter ID for stimulus set (e.g., 101, 102, etc.): ','s');
    setID = sprintf('set%s',setID);
    setDir = fullfile('stim_sets',setID);
end
if ~exist(setDir,'dir')
    clear;
    error('stimulus set does not exist.');
end

% Phase ID
fprintf('\nSelect Phase:\n\t1) Practice\n\t2) Real\n');
phaseID = input('Enter Phase ID: ');
if ~ismember(phaseID,[1 2])
    error('Incorrect phase selection. Must be a value of 1 or 2.')
end

%% Common settings and steps for all tasks
% Monitor resolution
monRes.w = 1024;
monRes.h = 768;

% keyboard stuff
moveOn = 'space';
KbName('UnifyKeyNames'); % Make sure same across OS

%% Experiment Settings - STM
% Dimension and rect scalings
imageDim.x = 150; % Size of the gabor patch in X
imageDim.y = imageDim.x; % Size of the gabor patch in Y
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

% Load scale image and set rect
stm.scaleIMG = imread('lr_scale.png');
stm.scaleRect = [0 0 432 144];

% Response Options
leftResp = 'f';
rightResp = 'j';

%% Experiment Settings - Gabor
% Dimension and rect settings
gabor.x.left = -180; % X position on left
gabor.x.right = -1*gabor.x.left; % X position on right
gabor.dim.x = 200; % Size of the gabor patch in X
gabor.dim.y = gabor.dim.x; % Size of the gabor patch in Y
gabor.xOffset = 150; % Offset of left and right stims
gabor.baseRect = [0 0 gabor.dim.x gabor.dim.y];

% Duration variables for Gabor task
duration.gabor.stim = .3; % Duration of gabor image in seconds
duration.gabor.iti = .2; % Duration of iti after response in seconds

% Load Gabor image
gIMG = imread(fullfile('gabors','gabor_08f.png'));
gIMG = imresize(gIMG,[gabor.dim.x gabor.dim.y]);

% Load scale image and set rect
gabor.scaleIMG = imread('sd_scale.png');
gabor.scaleRect = [0 0 432 144];

% Response options
sameResp = 'f';
diffResp = 'j';

%% Experiment Settings - Perception
% Dimension and rect scalings
% Uses the same as the STM task

% Duration variables for perception task
duration.per.stim = .5; % Duration of stimulus in seconds
duration.per.iti = 1.25; % Length of ITI in seconds

% Load scale image and set rect
per.scaleIMG = imread('sd_scale.png');
per.scaleRect = [0 0 432 144];

% Response options
% Uses the same as the Gabor
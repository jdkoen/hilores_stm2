function stims = create_gabor_task_stims(subID,nReps,delta)
% This script makes stims for the gabor task. This script simply determines
% the orientation and number of trials (same and different) for the Gabor
% task. The nReps variable determines the number of cycles of 4 same and 4
% different trials, therefore the total number of trials equals nReps * 8. 
%
% The orientation of the gabor is randomly selected from 1-360 FOR
% EACH TRIAL. 

%% Define number of trials
nTrials.same = nReps*4;
nTrials.diff_ll = nReps;
nTrials.diff_lr = nReps;
nTrials.diff_rl = nReps;
nTrials.diff_rr = nReps;
if ~isfield(nTrials,'all')
    nTrials.all = sum(struct2array(nTrials));
end

%% Define possible angles
allDegs = transpose(1:360);
allDegs = allDegs(randperm(length(allDegs)));

%% Make a matrix of conditions
myStims = vertcat( ...
    repmat({'same' 'na' nan},nTrials.same,1), ...
    repmat({'diff' 'left' 1},nTrials.diff_ll,1), ...
    repmat({'diff' 'left' -1},nTrials.diff_ll,1), ...
    repmat({'diff' 'right' 1},nTrials.diff_ll,1), ...
    repmat({'diff' 'right' -1},nTrials.diff_ll,1) ...
    );

%% Add degs to myStims
for i = 1:size(myStims,1)
    myAngles = num2cell(randomize_matrix(transpose(1:360)));
    myStims(i,4) = myAngles(1);
end

%% Create target and lure degrees
for i = 1:nTrials.all
    
    targDeg = myStims{i,4};
    if strcmpi(myStims{i,1},'same')
        lureDeg = targDeg;
    else
        lureDeg = targDeg + (myStims{i,3} * delta);
    end
    myStims{i,5} = lureDeg;
    
end

%% Randomize stim structure
myStims = myStims(randperm(nTrials.all),:);

%% Make stims structure
stims = create_stim_structure( ...
    subID, 'prop-val', ...
    'item_type',myStims(:,1), ...
    'diff_side',myStims(:,2), ...
    'delta',repmat({delta},nTrials.all,1), ...
    'delta_mod',myStims(:,3), ...
    'targ_deg',myStims(:,4), ...
    'lure_deg',myStims(:,5) ...
    );

end
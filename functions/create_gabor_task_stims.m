% function stims = create_gabor_task_stims(subID,nReps,delta,rngSeed)
function stims = create_gabor_task_stims(subID,nReps,delta)
% This script makes stims for the gabor task. This creates a stim file with
%
% subID - ID for participant
% nReps - number of different trials in each of four different conditions.
% The number of same (no change) trials 

%% Set random seed if given
% if ~isempty(rngSeed)
%     rng(rngSeed);
% else
%     rng(935);
% end

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
% allDegs = linspace(0,360,180);
allDegs = transpose(0:2:358);
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
myStims = [myStims num2cell(allDegs(1:nTrials.all))];

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
    subID, ...
    'item_type',myStims(:,1), ...
    'diff_side',myStims(:,2), ...
    'delta',repmat({delta},nTrials.all,1), ...
    'delta_mod',myStims(:,3), ...
    'targ_deg',myStims(:,4), ...
    'lure_deg',myStims(:,5) ...
    );

end
function stims = create_perception_stims_crit(subID,delta)
% This script creates the critical perception stimuli for HiLoResSTM2. 
%
% There are in total 288 trials created. There are two factors: Complexity
% (set size 2 vs 4) and resolution (low, middle, high). A total of 48
% images are assigned to each of the 6 cells formed by crossing these two
% factors. Half of the trials in each set are same trials (all images have
% the same rotation) whereas the other half are different trials (one image
% has a different rotationl On different trials, the image that is rotated
% is equally likely to be in each quadrant and each direction.
%
% The initial orientation of the image is randomly selected from 1-360 FOR
% EACH TRIAL. 
%
% Unlike the STM stimulus generation script, the images here are not
% loaded. Instead, this occurs in the perception_task_proc.m script prior
% to presenting the trials. Additionally, the angles don't have a minimum
% difference of 20 degrees as it is same different. 

%% Get names of images
% Define direcory
% imgDir = fullfile('..','images');
imgDir = fullfile('images');

% Get list of file names
myImgs = dir(fullfile(imgDir,'*.png'));
myImgs = cellfun(@(x) fullfile(imgDir,x),{myImgs.name}','UniformOutput',false);

% Randomize image list
myImgs = randomize_matrix(myImgs);

%% Make Critical Stims
% Images for low res ss2 in each Quad X Lure Direction combination
mySel = reshape(1:48,8,6);
nTrials.diff = 6; % Per Quadrant X Lure Direction Cell
nTrials.same = 24;
temp1 = [myImgs(mySel(1,:)) repmat({'low' delta.low},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({1},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp2 = [myImgs(mySel(2,:)) repmat({'low' delta.low},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp3 = [myImgs(mySel(3,:)) repmat({'low' delta.low},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({1},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp4 = [myImgs(mySel(4,:)) repmat({'low' delta.low},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
mySel = mySel(5:end,:);
temp5 = [myImgs(mySel(:)) repmat({'NA' NaN},nTrials.same,1) repmat({2},nTrials.same,1) repmat({'NA'},nTrials.same,1) repmat({NaN},nTrials.same,1) repmat({'same'},nTrials.same,1)];
imgs.low2 = vertcat(temp1,temp2,temp3,temp4,temp5);
 
% Images for mid res ss2 in each Quad X Lure Direction combination
mySel = reshape(49:96,8,6);
nTrials.diff = 6; % Per Quadrant X Lure Direction Cell
nTrials.same = 24;
temp1 = [myImgs(mySel(1,:)) repmat({'mid' delta.mid},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({1},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp2 = [myImgs(mySel(2,:)) repmat({'mid' delta.mid},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp3 = [myImgs(mySel(3,:)) repmat({'mid' delta.mid},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({1},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp4 = [myImgs(mySel(4,:)) repmat({'mid' delta.mid},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
mySel = mySel(5:end,:);
temp5 = [myImgs(mySel(:)) repmat({'NA' NaN},nTrials.same,1) repmat({2},nTrials.same,1) repmat({'NA'},nTrials.same,1) repmat({NaN},nTrials.same,1) repmat({'same'},nTrials.same,1)];
imgs.mid2 = vertcat(temp1,temp2,temp3,temp4,temp5);

% Images for high res ss2 in each Quad X Lure Direction combination
mySel = reshape(97:144,8,6);
nTrials.diff = 6; % Per Quadrant X Lure Direction Cell
nTrials.same = 24;
temp1 = [myImgs(mySel(1,:)) repmat({'high' delta.high},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({1},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp2 = [myImgs(mySel(2,:)) repmat({'high' delta.high},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp3 = [myImgs(mySel(3,:)) repmat({'high' delta.high},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({1},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp4 = [myImgs(mySel(4,:)) repmat({'high' delta.high},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
mySel = mySel(5:end,:);
temp5 = [myImgs(mySel(:)) repmat({'NA' NaN},nTrials.same,1) repmat({2},nTrials.same,1) repmat({'NA'},nTrials.same,1) repmat({NaN},nTrials.same,1) repmat({'same'},nTrials.same,1)];
imgs.high2 = vertcat(temp1,temp2,temp3,temp4,temp5);

% Images for low res ss4 in each Quad X Lure Direction combination
mySel = reshape(145:192,16,3);
nTrials.diff = 3; % Per Quadrant X Lure Direction Cell
nTrials.same = 24;
temp1 = [myImgs(mySel(1,:)) repmat({'low' delta.low},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({1},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp2 = [myImgs(mySel(2,:)) repmat({'low' delta.low},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp3 = [myImgs(mySel(3,:)) repmat({'low' delta.low},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({3},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp4 = [myImgs(mySel(4,:)) repmat({'low' delta.low},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp5 = [myImgs(mySel(5,:)) repmat({'low' delta.low},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({1},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp6 = [myImgs(mySel(6,:)) repmat({'low' delta.low},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp7 = [myImgs(mySel(7,:)) repmat({'low' delta.low},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({3},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp8 = [myImgs(mySel(8,:)) repmat({'low' delta.low},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
mySel = mySel(9:end,:);
temp9 = [myImgs(mySel(:)) repmat({'NA' NaN},nTrials.same,1) repmat({4},nTrials.same,1) repmat({'NA'},nTrials.same,1) repmat({NaN},nTrials.same,1) repmat({'same'},nTrials.same,1)];
imgs.low4 = vertcat(temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8,temp9);

% Images for mid res ss4 in each Quad X Lure Direction combination
mySel = reshape(193:240,16,3);
nTrials.diff = 3; % Per Quadrant X Lure Direction Cell
nTrials.same = 24;
temp1 = [myImgs(mySel(1,:)) repmat({'mid' delta.mid},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({1},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp2 = [myImgs(mySel(2,:)) repmat({'mid' delta.mid},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp3 = [myImgs(mySel(3,:)) repmat({'mid' delta.mid},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({3},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp4 = [myImgs(mySel(4,:)) repmat({'mid' delta.mid},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp5 = [myImgs(mySel(5,:)) repmat({'mid' delta.mid},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({1},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp6 = [myImgs(mySel(6,:)) repmat({'mid' delta.mid},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp7 = [myImgs(mySel(7,:)) repmat({'mid' delta.mid},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({3},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp8 = [myImgs(mySel(8,:)) repmat({'mid' delta.mid},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
mySel = mySel(9:end,:);
temp9 = [myImgs(mySel(:)) repmat({'NA' NaN},nTrials.same,1) repmat({4},nTrials.same,1) repmat({'NA'},nTrials.same,1) repmat({NaN},nTrials.same,1) repmat({'same'},nTrials.same,1)];
imgs.mid4 = vertcat(temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8,temp9);

% Images for mid res ss4 in each Quad X Lure Direction combination
mySel = reshape(241:288,16,3);
nTrials.diff = 3; % Per Quadrant X Lure Direction Cell
nTrials.same = 24;
temp1 = [myImgs(mySel(1,:)) repmat({'high' delta.high},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({1},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp2 = [myImgs(mySel(2,:)) repmat({'high' delta.high},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp3 = [myImgs(mySel(3,:)) repmat({'high' delta.high},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({3},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp4 = [myImgs(mySel(4,:)) repmat({'high' delta.high},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'left'},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp5 = [myImgs(mySel(5,:)) repmat({'high' delta.high},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({1},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp6 = [myImgs(mySel(6,:)) repmat({'high' delta.high},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({2},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp7 = [myImgs(mySel(7,:)) repmat({'high' delta.high},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({3},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
temp8 = [myImgs(mySel(8,:)) repmat({'high' delta.high},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'right'},nTrials.diff,1) repmat({4},nTrials.diff,1) repmat({'different'},nTrials.diff,1)];
mySel = mySel(9:end,:);
temp9 = [myImgs(mySel(:)) repmat({'NA' NaN},nTrials.same,1) repmat({4},nTrials.same,1) repmat({'NA'},nTrials.same,1) repmat({NaN},nTrials.same,1) repmat({'same'},nTrials.same,1)];
imgs.high4 = vertcat(temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8,temp9);

%% Build the stim list
% Initialize variable
stimList = {};
myFields = fieldnames(imgs);
for i = 1:length(myFields)
    stimList = vertcat(stimList,imgs.(myFields{i}));
end

% Add angles of rotation
for i = 1:size(stimList,1)
    myAngles = num2cell(randomize_matrix(transpose(1:360)));
    stimList(i,8) = myAngles(1);
end

% Randomize stimList
stimList = randomize_matrix(stimList);

% Make stims structure
stims = create_stim_structure(subID, 'prop-val', ...
    'image',stimList(:,1), ...
    'item_type',stimList(:,7), ...
    'set_size',stimList(:,4), ...
    'resolution',stimList(:,2), ...
    'targ_tilt',stimList(:,8), ...
    'delta_tilt',stimList(:,3), ...
    'delta_dir',stimList(:,5), ...
    'delta_quad',stimList(:,6));

%% Update stims structure with lure_tilt
for i = 1:length(stims)
    
    % Fix some stuff if it is a same trial blank out info
    if strcmpi(stims(i).item_type,'same')
        stims(i).lure_tilt = nan;
        stims(i).deg_vec = repmat(stims(i).targ_tilt,1,stims(i).set_size);
    else
        
        % determine lure degree
        if strcmpi(stims(i).delta_dir,'left')
            stims(i).lure_tilt = wrapTo360(stims(i).targ_tilt - stims(i).delta_tilt);
        else
            stims(i).lure_tilt = wrapTo360(stims(i).targ_tilt + stims(i).delta_tilt);
        end
        
        % Determine degree vector for this trial
        stims(i).deg_vec = repmat(stims(i).targ_tilt,1,stims(i).set_size);
        stims(i).deg_vec(stims(i).delta_quad) = stims(i).lure_tilt;
        
    end
    
end

end 
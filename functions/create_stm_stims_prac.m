function stims = create_stm_stims_prac(subID,delta,bgColor)
% This script creates the practice STM stimuli for HiLoResSTM2. 
%
% Not that the gandom number generator is seeded, so the practice phase
% will be identical for each person. 
%
% There are in total 4 trials created, 2 trials assigned to set size 2
% (2 images each) and 2 trials (4 images per set) in set size 4. Half of
% each set have high resolution change (defined by delta.high) and low
% resolution change (defined by delta.low) (see create_stims.m). The
% initial orientation of the image, which is the critical manipulation, is
% randomly selected from 1-360 FOR EACH SET. The angle differences within a
% set must be greater than 20 degrees. 
%
% At the end, the images are loaded into Matlab matrices, and have the
% Alpha channel (the transparent voxels) set to bgColor. 
% Define some usful anonymous functions for angles
normDeg = @(a,b) mod(a-b,360);
absDiffDeg = @(c) min(360-c, c);

%% Set random seed
rng(130);

%% Get names of images
% Define direcory
imgDir = fullfile('prac_images');

% Get list of file names
myIMGs = dir(fullfile(imgDir,'*.png'));
% myIMGs = cellfun(@(x) fullfile(imgDir,x),{myIMGs.name}','UniformOutput',false);
myIMGs = {myIMGs.name}';

% Randomize image list
myIMGs = randomize_matrix(myIMGs);

%% Make Practice Stims
% Group Images into set sizes of 2 and 4 and by high and low res
ss2.lowRes = {[myIMGs(1:2) repmat({'low' delta.low},2,1) repmat({'left'; 'right'},1,1)]};   
ss2.highRes = {[myIMGs(3:4) repmat({'high' delta.high},2,1) repmat({'left'; 'right'},1,1)]};   
ss4.lowRes = {[myIMGs(5:8) repmat({'low' delta.low},4,1) repmat({'left'; 'right'},2,1)]};   
ss4.highRes = {[myIMGs(9:12) repmat({'high' delta.high},4,1) repmat({'left'; 'right'},2,1)]};   

%% Build the stim list
% Build the sequence (hard code for this
ssSeq = [2 4 4 2]'; % Set size of 2 and 4
resSeq = [2 1 2 1]'; % 1 = low res, 2 = high res

% Loop through to create each set (define counters first)
count.ss2low = 1;
count.ss2high = 1;
count.ss4low = 1;
count.ss4high = 1;
stimList = {};
for i = 1:length(ssSeq) % This should do
    
    % Get current stim set
    if ssSeq(i) == 2 && resSeq(i) == 1 % ss2low
        
        curSet = ss2.lowRes{count.ss2low};
        curSet = vertcat(curSet,repmat({'NA' 'NA' nan 'NA'},2,1)); % Add on empty stuff
        count.ss2low = count.ss2low + 1;
        
    elseif ssSeq(i) == 2 && resSeq(i) == 2 % ss2high
        
        curSet = ss2.highRes{count.ss2high};
        curSet = vertcat(curSet,repmat({'NA' 'NA' nan 'NA'},2,1)); % Add on empty stuff
        count.ss2high = count.ss2high + 1;
        
    elseif ssSeq(i) == 4 && resSeq(i) == 1 % ss4low
        
        curSet = ss4.lowRes{count.ss4low};
        count.ss4low = count.ss4low + 1;
        
    elseif ssSeq(i) == 4 && resSeq(i) == 2 % ss4high
        
        curSet = ss4.highRes{count.ss4high};
        count.ss4high = count.ss4high + 1;
        
    else
        
        error('Uhh ohhh, my conditions are off...');
        
    end
    
    % Work with angles based on set size
    while true
        
        % Add angles of rotation
        myAngles = num2cell(randomize_matrix(transpose(1:360)));
        
        % Get some angles based on set size
        curAngles = cell2mat(myAngles(1:ssSeq(i)));
        
        % Loop through to get all absolute angle differences
        angDiffs = [];
        for a = 1:ssSeq(i)
            for b = 1:ssSeq(i)
                
                % Skip if a == b
                if a == b, continue; end
                
                % Compute absolute difference
                angA = curAngles(a);
                angB = curAngles(b);
                angDiffs = vertcat(angDiffs,absDiffDeg(normDeg(angA,angB)));
                
            end
        end
        
        % If angle difference (which has duplicate elements, which is
        % expected and OK) is less than 20 degrees in a set, redo until
        if ~any(angDiffs < 20), break; end
        
    end
    
    % Add set size to current set
    curSet = horzcat(curSet,repmat({ssSeq(i)},4,1));
    curSet(:,[4 5]) = curSet(:,[5 4]);
    
    % Update curAngles with lureangles
    if ssSeq(i) == 2
        curAngles = vertcat(curAngles,nan,nan);
    end
    curSet = horzcat(curSet,num2cell(curAngles));
    
    % Add lure angle
    lureAngles = [];
    for j = 1:size(curSet,1)
        
        % Determine direction of change
        if strcmpi(curSet{j,5},'left')
            thisDir = -1;
        else % Sometimes the direction is NA (set size 2), but it will always return NaN, so I ignore
            thisDir = 1;
        end
        
        % Make the lure Angle
        thisDiff = wrapTo360(curSet{j,6} + curSet{j,3}*thisDir);
        lureAngles = vertcat(lureAngles,thisDiff);
        
    end
    curSet = horzcat(curSet,num2cell(lureAngles));
    
    % Add to stimList
    stimList = vertcat(stimList,curSet(:)');
    
end

% Make stims structure
stims = create_stim_structure(subID,'prop-val', ...
    'image1',stimList(:,1), ...
    'image2',stimList(:,2), ...
    'image3',stimList(:,3), ...
    'image4',stimList(:,4), ...
    'resCond',stimList(:,5), ...
    'angDelta',stimList(:,9), ...
    'setSize',stimList(:,13), ...
    'lureDir1',stimList(:,17), ...
    'lureDir2',stimList(:,18), ...
    'lureDir3',stimList(:,19), ...
    'lureDir4',stimList(:,20), ...
    'targAng1',stimList(:,21), ...
    'targAng2',stimList(:,22), ...
    'targAng3',stimList(:,23), ...
    'targAng4',stimList(:,24), ...
    'lureAng1',stimList(:,25), ...
    'lureAng2',stimList(:,26), ...
    'lureAng3',stimList(:,27), ...
    'lureAng4',stimList(:,28) ...
    );

% Add test order and correct response
for i = 1:length(stims)
    
    % Determine set size
    curSS = stims(i).setSize;
    
    % Test image order
    if curSS == 2
        
        testOrder = randomize_matrix(transpose(1:2));
        testCorSide = randomize_matrix({'left'; 'right'});
        stims(i).test1 = stims(i).(strcat('image',num2str(testOrder(1))));
        stims(i).test2 = stims(i).(strcat('image',num2str(testOrder(2))));
        stims(i).test3 = 'NA';
        stims(i).test4 = 'NA';
        stims(i).testCor1 = testCorSide{1};
        stims(i).testCor2 = testCorSide{2};
        stims(i).testCor3 = 'NA';
        stims(i).testCor4 = 'NA';
        
    else
        
        testOrder = randomize_matrix(transpose(1:4));
        testCorSide = randomize_matrix({'left'; 'right'; 'left'; 'right'});
        stims(i).test1 = stims(i).(strcat('image',num2str(testOrder(1))));
        stims(i).test2 = stims(i).(strcat('image',num2str(testOrder(2))));
        stims(i).test3 = stims(i).(strcat('image',num2str(testOrder(4))));
        stims(i).test4 = stims(i).(strcat('image',num2str(testOrder(4))));
        stims(i).testCor1 = testCorSide{1};
        stims(i).testCor2 = testCorSide{2};
        stims(i).testCor3 = testCorSide{3};
        stims(i).testCor4 = testCorSide{4};
        
    end
    
end

% Load each image (for speed of drawing to screen)
cd(imgDir);
for i = 1:length(stims)
    stims(i).imgMat1 = imread(stims(i).image1,'BackgroundColor',bgColor/255);
    stims(i).imgMat2 = imread(stims(i).image2,'BackgroundColor',bgColor/255);
    if ~strcmpi(stims(i).image3,'NA')
        stims(i).imgMat3 = imread(stims(i).image3,'BackgroundColor',bgColor/255);
        stims(i).imgMat4 = imread(stims(i).image4,'BackgroundColor',bgColor/255);
    end
end
cd('..');

    
end 
function stims = create_perception_stims_prac(subID,delta)

%% Set random seed
rng(102);

%% Get names of images
% Define direcory
% imgDir = fullfile('..','prac_images');
imgDir = fullfile('prac_images');

% Get list of file names
myImgs = dir(fullfile(imgDir,'*.png'));
myImgs = cellfun(@(x) fullfile(imgDir,x),{myImgs.name}','UniformOutput',false);

% Randomize image list
myImgs = randomize_matrix(myImgs);

%% Make Practice Stims
stimList = [ ...
    myImgs(1) 'NA' NaN 2 'NA' NaN 'same'; 
    myImgs(2) 'mid' delta.mid 2 'left' 1 'different';
    myImgs(3) 'high' delta.high 2 'right' 2 'different';
    myImgs(4) 'NA' NaN 2 'NA' NaN 'same'; 
    myImgs(5) 'mid' delta.mid 2 'left' 1 'different';
    myImgs(6) 'NA' NaN 2 'NA' NaN 'same';
    myImgs(7) 'low' delta.low 4 'left' 4 'different'; 
    myImgs(8) 'NA' NaN 4 'NA' NaN 'same';
    myImgs(9) 'high' delta.high 4 'right' 3 'different';
    myImgs(10) 'NA' NaN 4 'NA' NaN 'same'; 
    myImgs(11) 'mid' delta.mid 4 'right' 2 'different';
    myImgs(12) 'NA' NaN 4 'NA' NaN 'same';
    ];

%% Build the stim list
% Add angles of rotation
myAngles = num2cell(randomize_matrix(transpose(1:360))); 
stimList = [stimList myAngles(1:size(stimList,1))];

% Randomize stimList
stimList = randomize_matrix(stimList);

% Make stims structure
stims = create_stim_structure(subID, ...
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
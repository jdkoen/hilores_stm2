function stimStruct = create_stim_structure(subID,method,varargin)
% USE:
%   STIMSTRUCT = CREATE_STIM_STRUCTURE(subID,method,varargin)
%
% DESCRIPTION:
%   CREATE_STIM_STRUCTURE creates an array structure variable with fields and
%   values supplied by the user. The input can be in one of two formats:
%
%   1) A property-value format:
%
%   CREATE_STIM_STRUCTURE(subID,method, ...
%           'itemType',{'old' 'new' 'old' 'new'}', ...
%           'imageType',{'face' 'face' 'scene' 'scene'}');
%
%   2) A header-data matrix format:
%
%   CREATE_STIM_STRUCTURE(subID,method, ...
%           {'itemType' 'imageType'}, ...
%           {'old' 'face'; 'new' 'face'; 'old' 'scene'; 'new' 'scene'});
%
%   The data inputs, regardless of method, should be in a column-vector,
%   such that rows represent trails, and, if using the head-data format,
%   the columns represent the different fields (in the same order as the
%   fields
%   
%   Some default fields are created, and include: subject id (sub_id), date
%   the structure was created (date_created), date of the experiment
%   session (session_date), start (session_start) and end (session_end)
%   time, and the trial number (trial_num). 
%
% INPUT:
%   subID - A string or numeric ID for the subject. 
%
%   method - A string input with one of two values. 
%       'prop-val': Uses multiple property-value pairs to specify fields
%                   and data. Inputs will be comprise a property (i.e.,
%                   string) value,  which will be stored as a field name in
%                   the structure, and a vector  that is cell array of
%                   strings or a numeric vector that has the values for
%                   each trial.  
%       'head-data': Uses two inputs, one for fields and one for the data cell
%                array, to create stims structre. The fields input should
%                be input first, and the cell array with the the data
%                second. The number of columns in the cell array should
%                equal the number of elements in the field names, elese an
%                error is returned. 
%
% Created by Joshua D. Koen
% Created on 12/02/2014

% Check for inputs (must have at least one property-value pair)
if nargin < 3
    error('Must input at least one property-value pair argument.')
end

% Check for method and define as numeric
methodCheck = strcmpi(method,{'prop-val' 'head-data'});
if ~any(methodCheck)
    error('Incorect method input. Must be ''prop-val'' or ''f-mat''.')
else
    methodID = find(methodCheck);
end

% If methodID == 2, error if varargin1  does not equal varargin2 columns
if methodID == 2
    if length(varargin{1}) ~= size(varargin{2},2)
        error('Different number of columns and field names input.');
    end
end

% Initialize the structure
stimStruct = struct('sub_id',[],'date_created',[], ...
    'session_date',[],'session_start',[],'session_end',[], ...
    'trial_num',[]);

% Get current date and time for date created
curDate = datestr(now);

% If methodID == 2, the f-mat method, make it like methodID == 1
if methodID == 2
    fields = varargin{1}; % Get field names
    data = varargin{2}; % Get the data matrix
    varargin = {};
    for i = 1:length(fields)
        varargin = horzcat(varargin,fields(i),{data(:,i)});
    end
end    

% Add user supplied field names
for i = 1:2:length(varargin)
    stimStruct.(varargin{i}) = [];
end

% Get the number of trials from the first value vector
nTrials = length(varargin{2});

% Return error if first property-value pair has an empty matrix for the
% values.
if nTrials == 0
    error('The value vector for the first property-value pair cannot be empty.');
end

% Loop through and add sub_id and date created values
for i = 1:nTrials
    stimStruct(i,1).sub_id = subID;
    stimStruct(i,1).date_created = curDate;
    stimStruct(i,1).trial_num = i;
end

% Loop through the inputs to log the values
for i = 1:2:length(varargin)
    
    % Initialize the current field name
    curField = varargin{i};
    
    % Get the values for the current fields and convert to a cell array
    emptyFlag = false;
    curVals = varargin{i+1};
    if isnumeric(curVals)
        curVals = num2cell(curVals);
    elseif isempty(curVals)
        emptyFlag = true;
    elseif ~iscell(curVals) || ~isvector(curVals)
        error('All value inputs must be a cell array or numeric vector.')
    end
    
    % Loop through curVals and add values to the current field
    if ~emptyFlag
        for j = 1:length(curVals)
            
            stimStruct(j).(curField) = curVals{j};
            
        end
    end
end

end
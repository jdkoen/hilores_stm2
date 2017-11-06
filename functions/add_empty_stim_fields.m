function stimStruct = add_empty_stim_fields(stimStruct,varargin)
% USE:
%   STIMSTRUCT = ADD_EMPTY_STIM_FIELDS(stimStruct,varargin)
%
% DESCRIPTION:
%   ADD_EMPTY_STIM_FIELDS will add new fields to a stimulus structure
%   created by CREATE_STIM_STRUCTURE with empty values for each element of
%   the structure array. This is useful for adding fields to store data
%   during an experimental run (e.g., responses, rt, onset, etc.) and makes
%   the use of the stimulus structure more flexible.
%
% INPUT:
%   stimStruct - A structure created by CREATE_STIM_STRUCTURE. 
%
%   After stimStruct, a list of strings, refering to field names you want
%   to be empty, can be given to the function (a minimum of 1 must be
%   given). 
%
% Created by Joshua D. Koen
% Created on 12/02/2014

% Error check number of input arguments
if nargin < 2
    error('Must specify at least one new field to add.')
end

% Loop through varargin and add new fields
for i = 1:length(varargin)
    
    % Error check for string input
    if ~isstr(varargin{i})
        error('All inputs for field names must be strings.')
    end
    
    % Add the new field with values
    [stimStruct.(varargin{i})] = deal([]);
    
end
    
    
    
    
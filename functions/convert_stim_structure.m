function data = convert_stim_structure(stimStruct)
% USE:
%   DATA = CONVERT_STIM_STRUCTURE(stimStruct)
%
% DESCRIPTION:
%   CONVERT_STIM_STRUCTURE converts a stimulus structure created by
%   CREATE_STIM_STRUCTURE into a cell array such that every field becomes a
%   column, and the rows represent different trials. 
%
% INPUT:
%   stimStruct - A structure created by CREATE_STIM_STRUCTURE.
%
% Created by Joshua D. Koen
% Created on 12/03/2014

% Initialize the data variable and add column names (the field names)
data = cell(length(stimStruct)+1,length(fieldnames(stimStruct)));
data(1,:) = fieldnames(stimStruct(1))';

% Loop through each trial in stimStruct, and convert structure to cell
% array
for i = 1:length(stimStruct)
    data(i+1,:) = struct2cell(stimStruct(i));
end

end
function files = get_file_names(directory,filestem,fullpath)
% USE:
%   FILES = GET_FILE_NAMES(DIRECTORY,FILESTEM,FULLPATH)
%
% DESCRIPTION:
%   GET_FILE_NAMES returns a cell array of strings with files found in a
%   specified directory using the DIR function. This function can be used
%   to find all files in a given directory, or files with a specific
%   string. 
%
% INPUT:
%   DIRECTORY - A string specifying the directory to search.
%
%   FILESTEM - A string specifying a substring of the fiels to find in the
%       DIRECTORY. To return all files, use '*'. To find files with a
%       specific substring, such as all BMP files, use e.g., '*bmp'. 
%
%   FULLPATH - A logical input that, if TRUE, will return the file name
%       with the DIRECTORY specified before the file name. If FALSE, only
%       the file names are returned. 
%
% Created by Joshua D. Koen
% Created on 02/02/2017

% Determine what to do with fullpath
if isempty(fullpath) || ~islogical(fullpath)
    fullpath = false;
end

% Get the file names
files = dir(fullfile(directory,filestem));
files = {files.name}';

% If fullpath, add directory to string
if fullpath
    files = cellfun(@(x) fullfile(directory,x),files,'UniformOutput',false);
end

end
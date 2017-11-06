function rMat = randomize_matrix(matrix)
% USE:
%   RMAT = RANDOMIZE_MATRIX(MATRIX)
%
% DESCRIPTION:
%   RANDOMIZE_MATRIX returns a matrix of the same size as the input, but
%   randomized in the row dimension. This is meant for experimental
%   materials such that each row is an individual trial that needs to be
%   randomized, and the columns are features of a trial that do not need to
%   be randomized.
%
% INPUT:
%   MATRIX - A numeric matrix or cell array.  
%
%   rngSeed - A numeric value to seen the random number generator. 
%
% Created by Joshua D. Koen
% Created on 12/02/2014

% Randomize the order of rows in the matrix, keeping all columns constant
nTrials = size(matrix,1); % Number of rows in matrix
rSeq = randperm(nTrials); % A random sequence of numbers to select rows
rMat = matrix(rSeq,:); % Return the randomized matrix

end
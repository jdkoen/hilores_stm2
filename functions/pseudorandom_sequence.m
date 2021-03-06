function [trialSequence,iterCount] = pseudorandom_sequence(nPerCond,nMaxRepeat)
% Usage:
%   trialSequence = pseudorandom_sequence(nPerCond,nMaxRepeat)
%   [trialSequence,iterCount] = pseudorandom_sequence(nPerCond,nMaxRepeat)
%
% This function creates a pseudorandomized sequence of numbers. The output
% is a vector of numbers ranging from 1 to length(nPerCond). The frequency
% of a given number is determined by the value in the vector nPerCond. For
% example, nPerCond of [5 4] will return a column vector with 5 1's and 4
% 2's. These will be randomly ordered such that the 1's and 2's that occur
% consecutively will not exceed nMaxRepeat.
%
% The function returns the sequence of events that meet the nMaxRepeat
% constraint to trialSequence and, if requested, the number of iterations
% checked by the function to iterCount. There is a max of 10,000
% iterations, otherwise the function 
%
% Required Input:
%   nPerCond - This is a row or column vector specifying the number of
%   trials in each condition. The condition is indexed by the element of
%   a value in nPerCond (e.g., for [2 3 4], condition 1 will have 2
%   occurences; nPerCond(1)). The length of the output vector is calculated
%   by summing across the values in nPerCond.
%
%   nMaxRepeat - This is a scalar value or a row/column vector identifying
%   the number of consectutive repeats of a specific condition. If this is
%   a scalar input, then nMaxRepeat is assumed to be the same for all
%   conditions. If this is a row or column vector of equal length to
%   nPerCond, then, for example, then nMaxRepeat(1) specifies the number of
%   consectuive repetitions for nPerCond(1) trials. 
%
%   Currently, this only works for one factor designs. This will be updated
%   in the future to incorporate factorial designs.
%
% Authored by: Joshua D. Koen, Center for Vital Longevity, UT Dallas
% Created on: 8/28/2013
% Modified on: 4/11/2014
% Email questions to joshua.koen@utdallas.edu

% Define the max number of iterations
maxIter = 10000;

% Convert all vectors to column vectors and do some error checks
if isrow(nPerCond) 
    nPerCond = nPerCond';
elseif ~iscolumn(nPerCond)
    error('nPerCond input must be a row or column vector.')
end

if isscalar(nMaxRepeat)
    nMaxRepeat = nMaxRepeat*ones(length(nPerCond),1);
elseif isrow(nMaxRepeat) 
    nMaxRepeat = nMaxRepeat';
elseif ~iscolumn(nMaxRepeat)
    error('nMaxRepeat input must be a scalar value or a row/column vector.')
end

if ~all(size(nPerCond)==size(nMaxRepeat))
    error('nPerCond and nMaxRepeat must be equal length.')
end

% Create trialSequence and fill with the number of trials specified in
% nPerCond.
trialSequence = [];
for i = 1:length(nPerCond)
    trialSequence = [trialSequence; i*ones(nPerCond(i),1)];
    repeatCheck{i} = i*ones(nMaxRepeat(i)+1,1);
end

% Start a while loope that shuffles the trialSequence vector, and then
% checks to see if any of the repeatCheck vectors occurs. The while
% loop continues until (1) none of the repeatCheck vectors is present in
% trialSequence or (2) 10000 iterations have been reached without a
% successful solution. An error message is output if the latter. The code
% is written to (hopefully) avoid repeated sampling of random orderings.
iterCount = 1;
% fprintf('Pseudorandom sequence iteration ')
while iterCount <= maxIter
    % Show iteration on screen
%     fprintf('%s ',num2str(iterCount))
    % Start a while loop to generate and check for testing random
    % permutation of trialSequence order.
    curPerm = randperm(length(trialSequence));
    if iterCount > 1
        while 1 % Infinite while loop to avoid sampling with replacement
            if any(cellfun(@(x)isequal(curPerm,x),allPerms))
                curPerm = randperm(length(trialSequence));
            else
                break;
            end
        end
    end
    
    % Store curPerm into allPerms to avoid sampling with replacement in
    % subsequent iterations.
    allPerms{iterCount} = curPerm;
    
    % Reorder trialSequence with curPerm
    trialSequence = trialSequence(curPerm);
    
    % Check if a nMaxRepeat is exceeded for any condition. I
    repeatsPresent = 0;
    for i = 1:length(repeatCheck)
        if ~isempty(strfind(num2str(trialSequence'),num2str(repeatCheck{i}')))
            repeatsPresent = repeatsPresent + 1;
        end
    end
    
    % If repeatsPresent is > 0, then continue the while loop. If no repeats
    % are present, break the while loop and return trialSequence.
    if repeatsPresent ~= 0
        iterCount = iterCount + 1;
    else
%         fprintf('DONE\n');
        break;
    end
end

% Update the output if the sequence failed to mean nMaxRepeat
if iterCount == maxIter && repeatsPresent ~= 0 
    trialSequence = [];
    warning('The function failed to find an error free sequence. Try running it again.');
end 

end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
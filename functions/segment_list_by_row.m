function listOut = segment_list_by_row(list,breaks)
% This function splits a list (a cell array or matrix) along the row
% dimensions according to the breaks variable. For example, if there is a
% list of 100 elements, and breaks is 1:25:100, then there will be four
% sets returned (1-25, 26-50, etc.).
%
% The output is in a structure variable, with fields labeled set1, set2,
% etc.

% Update breaks
segments = [];
for i = 1:length(breaks)
    
    % Get bounds
    lb = breaks(i);
    if i+1 > length(breaks)
        ub = size(list,1);
    else
        ub = breaks(i+1)-1;
    end
    
    segments = vertcat(segments,[lb ub]);
    
end

% Segment the list
set = 1;
for i = 1:size(segments,1)
    
    % Set current field
    curField = strcat('set',num2str(set));
    set = set+1;
    
    % Segment the list
    listOut.(curField) = list(segments(i,1):segments(i,2),:);
    
end

end



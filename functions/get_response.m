function [key, secs] = get_response(deadline)
% [key, secs] = get_response(deadline)
% time based on key release, accuracy not known
% returns 0 if no response made by deadline
% use "Inf" as deadline if no deadline desired
% scott guerin, fall 05
% -------------------------------------------------------------------------
st = GetSecs;
t = 0;
yes = 0;
release = 0;


if deadline < Inf
    while t < deadline;                % duration of trial
        while yes == 0 && release == 0         % continually check for first key pressed
            [yes,secs,key] = KbCheck;           
            t = GetSecs-st;
            WaitSecs(0.001);
            if t >= deadline           % stop checking if time elapsed
                break
            end
        end % continually check
        while yes == 1 && release == 0          % continually check for key release
            [yes,secs] = KbCheck;
            rt = secs-st;           
            t = GetSecs-st;
            WaitSecs(0.001);
            if t >= deadline           % stop checking if time elapsed
                break
            end
        end % continually check
        release = 1;             % indicates key release detected or terminated
        t = GetSecs-st;
    end % while t

    if any(key)==1;                 % if response made
        key = find(key>0);
        secs = rt;
    else
        key = 0;
        secs = 0;
    end
    
    
else
    while yes == 0 && release == 0         % continually check for first key pressed
        [yes,secs,key] = KbCheck;           
        t = GetSecs-st;        
        rt = secs-st;
        WaitSecs(0.001);
    end % continually check
%     while yes == 1 && release == 0          % continually check for key release
%         [yes,secs] = KbCheck;
%         rt = secs-st;           
%         t = GetSecs-st;
%         WaitSecs(0.001);
%     end % continually check
    
    if any(key)==1;                 % if response made
        key = find(key>0);
        secs = rt;
    else
        key = 0;
        secs = 0;
    end
end

% if multiple keys pressed, record as no response
if length(key)>1
    key  = 0;
    secs = 0;
end
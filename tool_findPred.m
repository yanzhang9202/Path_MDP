%% Given input state s, find predecessor states of s;
%  Input:
%  s - [x_t, y_t, x_p, y_p, if_on_board], 5*1 vector, 650 states;
%      s(5) = 1 - not on board; s(5) = 2 - on board;
%  Output:
%  pred - rows of predecessor of s;
function [ pred ] = tool_findPred(s)

%% Check validity of input arguments
if (s(1) < 0 || s(1) > 4 || s(2) < 0 || s(2) > 4 || s(3) < 0 || ... 
    s(3) > 4 || s(4) < 0 || s(4) > 4 || s(5) < 1 || s(5) > 2 )
    error('Error: Invalid input argument to domain model!');
end

if (s(5) == 2)
   if (s(1:2) ~= s(3:4))
       error('Error: Invalid input argument to domain model!');
   end
end

%% Find predecessor states
if (s(5) == 1) % Currently passenger is not on board
    pred = repmat(s, 4, 1);
    pred(1,2) = pred(1,2) - 1; % Previous state moves upward;
    pred(2,2) = pred(2,2) + 1; % Previous state moves downward;
    pred(3,1) = pred(3,1) + 1; % Previous state moves to left;
    pred(4,1) = pred(4,1) - 1; % Previous state moves to right;
    if (pred(1,2) < 0) % No downwards previous state;
        pred(1,2) = s(1,2);
    end
    if (pred(2,2) > 4) % No upwards previous state;
        pred(2,2) = s(1,2);
    end
    if (pred(3,1) > 4 || (pred(3,1) == 2 && pred(3,2) > 2) || ...
        (pred(3,1) == 1 && pred(3,2) < 2) || ...
        (pred(3,1) == 3 && pred(3,2) < 2)) % No previous state on the right;
        pred(3,1) = s(1,1);
    end
    if (pred(4,1) < 0 || (pred(4,1) == 1 && pred(4,2) > 2) || ...
        (pred(4,1) == 0 && pred(4,2) < 2) || ...
        (pred(4,1) == 2 && pred(4,2) < 2)) % No previous state on the left;
        pred(4,1) = s(1,1);
    end
    if (s(1:2) == s(3:4)) % Possible that taxi just drop off the passenger;
        pred(5,:) = [s(1:4), 2];
    end
else           % Currently passenger is on board
    pred = repmat(s(1:2), 4, 1);
    pred(1,2) = pred(1,2) - 1; % Previous state moves upward;
    pred(2,2) = pred(2,2) + 1; % Previous state moves downward;
    pred(3,1) = pred(3,1) + 1; % Previous state moves to left;
    pred(4,1) = pred(4,1) - 1; % Previous state moves to right;
    if (pred(1,2) < 0) % No downwards previous state;
        pred(1,2) = s(1,2);
    end
    if (pred(2,2) > 4) % No upwards previous state;
        pred(2,2) = s(1,2);
    end
    if (pred(3,1) > 4 || (pred(3,1) == 2 && pred(3,2) > 2) || ...
        (pred(3,1) == 1 && pred(3,2) < 2) || ...
        (pred(3,1) == 3 && pred(3,2) < 2)) % No previous state on the right;
        pred(3,1) = s(1,1);
    end
    if (pred(4,1) < 0 || (pred(4,1) == 1 && pred(4,2) > 2) || ...
        (pred(4,1) == 0 && pred(4,2) < 2) || ...
        (pred(4,1) == 2 && pred(4,2) < 2)) % No previous state on the left;
        pred(4,1) = s(1,1);
    end
    pred = repmat(pred, 1, 2);
    pred(:,5) = 2;
    if (s(1:2) == s(3:4))
        pred(5,:) = [s(1:4), 1];
    else
        error('Error: Invalid input argument to domain model!');
    end
end

pred = unique(pred, 'rows');

end
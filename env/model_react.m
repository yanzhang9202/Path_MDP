function [r, s_prime, T] = model_react(s, a, instance, ref)
% Given state and action, list all possible next states, rewards and
% probability distribution

goal = instance.depot(instance.goal,:);
maxH = instance.maxH;
% Check validitity of the input arguments

% transition and reward model
pos = s(1:2);
t = s(3);
reach_goal = all(pos == goal);
switch reach_goal
    case 1  % Already at the goal
        s_prime = [pos, min(t+1, maxH)];
        T = 1;
        r = 0;
    case 0  % Not at the goal
        s_prime = move(s, a, instance);
        T = 1;
        if all(s_prime(1:2) == goal) 
            r = 20;
        else
            r = -1; 
        end           
end
end

% reach_time = ~(t < maxH);
% state = num2str([reach_goal, reach_time]);
% switch state
%     case '1 1'  % Reach goal and the time limit
%         
%     case '1 0'  % Reach goal, still time left
%         
%     case '0 1'  % Not at goal, time is up
%         
%     case '0 0'  % Not at goal, still time left
%         
% end
function [s_prime] = move(s, a, instance)
maxH = instance.maxH;
pos = s(1:2);
t = s(3);
% Movements with no obstacles
switch a
    case 1, s_prime = [min(pos(1)+1,4), pos(2), min(t+1, maxH)];          
    case 2, s_prime = [pos(1), min(pos(2)+1,4), min(t+1, maxH)];
    case 3, s_prime = [max(pos(1)-1,0), pos(2), min(t+1, maxH)];
    case 4, s_prime = [pos(1), max(pos(2)-1,0), min(t+1, maxH)];            
end
% Movement with obstacles
switch sprintf('%d', pos)
    case {'00', '10', '02', '12', '31', '41'}
        if a == 2
            s_prime(1:2) = pos;
        end
    case {'01', '11', '03', '13', '32', '42'}
        if a == 4
            s_prime(1:2) = pos;
        end
    otherwise
        % Do nothing
end
end
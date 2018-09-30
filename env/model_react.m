function [r, s_prime, T] = model_react(s, a, instance, ref)
% Given state and action, list all possible next states, rewards and
% probability distribution
global use_ref

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
% Add additional rewards using reference
if use_ref
    if t < maxH
        r = r - norm(s_prime(1:2) - ref(t+1,:));
    end
end
end
function [J, pi] = solver_mdp(ref, instance)
% This function solves the motion planning of a MDP model. Using the
% orignal cost function plus the distance to the reference trajectory as
% the new cost function, we solve the MDP problem and outputs the optimal
% trajectory.
%
% We assume that the system is deterministic. So the output trajectory
% given a starting point is also deterministic.
%
% The MDP problem uses the taxi-passenger example from the RL class, 2015
% Fall, except that we make the environment deterministic and the taxi only
% needs to drive to the goal position.
%
% State variable: s = [s1, s2, t], s_i \in {0,1,2,3,4}, t is time.
% Action set: A(s) = [a1, a2, a3, a4] (indexed by [1,2,3,4])
%                     up right down left
% Transition: s_{k+1} = T(s_{k}, a_i)
% Reward function: R(s_{k}, a_i, s_{k+1})
%   case 1: if not at the goal position, and the action doesn't lead to the
%   goal position, the reward is -1 minus the current distance to the
%   reference trajectory.
%   case 2: if not at the goal position, and the action leads to the goal
%   position, the reward is +10 minus the current distance to the reference
%   trajectory.
%   case 3: if at the goal position, whatever action it takes, the reward
%   is 0 minus the current distance to the reference trajectory.
global verbose
% Initialize value function
maxH = instance.maxH;
Jeps = instance.epsilon;
maxIter = instance.maxIter;
nAct = instance.nAct;
gamma = instance.gamma;
J = zeros(5,5,maxH);    % initialize value function (matrix)
pi = zeros(5,5,maxH);   % initialize policy function (matrix)

for cnt_itr = 1 : maxIter
    Jinov_max = 0;  % Reset the maximum innovation before every round of value iteration
    for sx = 0 : 4  % Compute the current state value given the current J
        for sy = 0 : 4
            for st = 1 : maxH
                s = [sx, sy, st];
                % Evaluate the value of each (s,a) pair
                Js = zeros(1,nAct); % Value of Q(s,a) at current state
                prior = zeros(1,nAct);
                for aa = 1 : nAct
                   [Js(aa), prior(aa)] = ...
                       model_value_update(s, aa, J, instance, ref); 
                end
                % Find the current greedy policy
                s(1:2) = s(1:2) + 1; % changed to matrix coordinates
                temp = num2cell(s);
                amax = find(Js == max(Js));
                pi(temp{:}) = amax(1);
                % Compute the innovation of value at current state
                Jinov = abs(max(Js) - J(temp{:}));
                if Jinov > Jinov_max
                    Jinov_max = Jinov;
                end
                % Udpate the value function
                J(temp{:}) = max(Js);
            end
        end
    end
    % Check the stopping condition for the value iteration
    if Jinov_max < Jeps
        if verbose
           fprintf(['Value iter. succeeds at the ', num2str(cnt_itr), ...
               ' iterations!\n']) 
           fprintf(['The maximum innovation at this iteration is ', ...
               num2str(Jinov_max), '.\n'])
        end
        break;
    else
        if verbose
            if mod(cnt_itr, 10) == 1
            fprintf(['MDP value ', num2str(cnt_itr), ' th iters:', ...
                ' current maximum innovation is ', num2str(Jinov_max), ...
                '...\n'])
            end
        end
    end
end
if verbose && Jinov_max > Jeps
    fprintf(['Value iter. fails at the ', num2str(cnt_itr), ...
       ' iterations!\n']) 
    fprintf(['The maximum innovation at this iteration is ', ...
    num2str(Jinov_max), '.\n'])
end
end
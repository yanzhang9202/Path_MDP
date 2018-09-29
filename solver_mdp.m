function [dec] = solver_mdp(ref)
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
% State variable: s = [s1, s2]
% Action set: A(s) = [a1, a2, a3, a4]
%                     up down left right
% Transition: s_{k+1} = T(s_{k}, a_i)
% Reward function:
%   case 1: if not at the goal position, and the action doesn't lead to the
%   goal position, the reward is -1 minus the current distance to the
%   reference trajectory.
%   case 2: if not at the goal position, and the action leads to the goal
%   position, the reward is +10 minus the current distance to the reference
%   trajectory.
%   case 3: if at the goal position, whatever action it takes, the reward
%   is 0 minus the current distance to the reference trajectory.



end
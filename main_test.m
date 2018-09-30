%% Test the solver_mdp function
clear;
close all;
clc;
global verbose
% Add current path
addpath(genpath(pwd));

% Generate problem instance
gen_instance;
verbose = 1;

% Generate reference trajectory
ref = zeros(instance.maxH, 2);  % [u_k, x_{k+1}]_{ref}, k = 0,1,...,maxH.

% Call solver_mdp function
[J, pi] = solver_mdp(ref, instance);
% J \in R^{n \times n \times maxH}, pi \in R^{n \times n \times maxH},
% xu \in R^{maxH \times 4}

% Visualize the value function and trajectory
%% Test the solver_mdp function
clear;
close all;
clc;
global verbose use_ref
% Add current path
addpath(genpath(pwd));

% Generate problem instance
gen_instance;
verbose = 1;
use_ref = 1;

% Call solver_mdp function
[xu, J, pi] = solver_mdp(ref, instance);
% J \in R^{n \times n \times maxH}, pi \in R^{n \times n \times maxH},
% xu \in R^{maxH \times 4}

% Visualize the value function and trajectory
plotxu;
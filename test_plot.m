%% Test plotting the field
clear;
close all;
clc;
% Define color map
map = [1,1,1;   % white
       1,0,0;   % red
       0,1,0;   % green
       0,0,1;   % blue
       1,1,0];  % yellow

%% create the field
C = ones(5);
figure(101)
image(0.5, 0.5, C);
colormap(map)
ax = gca;
cleanplot;

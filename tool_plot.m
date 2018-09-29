%% Plot results for Vanilla DP and Prioritized Sweeping DP
% clear all;
% close all;
% clc;

load('vanilla.mat');
load('ps.mat');

plot_vanilla = 0;
plot_ps = 0;
plot_backup_compare = 1;

if (plot_vanilla == 1)
    instance = vanilla;
end
if (plot_ps == 1)
    instance = ps;
end
fig = 1;

%% Plot Value function;
if (plot_vanilla || plot_ps)
which_instance = 10;
V_cur = instance{which_instance}.V_cur;
passenger_init = instance{which_instance}.passenger;
goal = instance{which_instance}.goal;
%  Plot value function before passenger is picked up;
figure(fig)
before = V_cur(1:5,1:5,passenger_init(1)+1, passenger_init(2)+1 ,1)';
b = bar3(before);
colorbar;
for kk = 1 : length(b)
    zdata = b(kk).ZData;
    b(kk).CData = zdata;
    b(kk).FaceColor = 'interp';
end
% Plot walls;
line([1.5,1.5],[0.5,2.5], 'linewidth', 5, 'Color', 'r');
line([3.5,3.5],[0.5,2.5], 'linewidth', 5, 'Color', 'r');
line([2.5,2.5],[5.5,3.5], 'linewidth', 5, 'Color', 'r');
for kk = 1 : 5
    for jj = 1 : 5
        text(jj-0.2, kk, -before(kk,jj), num2str(before(kk,jj)));
        text(jj-0.2, kk, before(kk,jj)+0.5, num2str(before(kk,jj)));
    end
end
% Plot passenger initial position;
line([passenger_init(1)+0.5, passenger_init(1)+1.5],...
     [passenger_init(2)+0.5, passenger_init(2)+1.5], [100, 100], 'linewidth', 1, 'Color', 'b');
line([passenger_init(1)+1.5, passenger_init(1)+0.5],...
     [passenger_init(2)+0.5, passenger_init(2)+1.5], [100, 100], 'linewidth', 1, 'Color', 'b');
 % Plot goal position;
line([goal(1)+0.5, goal(1)+1.5],...
     [goal(2)+0.5, goal(2)+1.5], [100, 100], 'linewidth', 1, 'Color', 'g');
line([goal(1)+1.5, goal(1)+0.5],...
     [goal(2)+0.5, goal(2)+1.5], [100, 100], 'linewidth', 1, 'Color', 'g');
view(2);
xlabel('x'); ylabel('y');
ax = gca; ax.XTickLabel = 1:6; ax.YTickLabel = 1:6;
title({['Value function of greedy policy before passenger is picked up'];...
       [sprintf('instance %i: goal = [%i, %i](green cross), passenger = [%i, %i](blue cross)',...
        which_instance, goal(1)+1, goal(2)+1, passenger_init(1)+1, passenger_init(2)+1)]})
fig = fig + 1;

%% Plot value function after passenger is picked up;
after = zeros(5,5);
for ii = 1 : 5
    for jj = 1 : 5
        after(ii, jj) = V_cur(ii, jj, ii, jj, 2);
    end
end
figure(fig)
after = after';
% surf(0:4,0:4,after);
b = bar3(after);
colorbar;
for kk = 1 : length(b)
    zdata = b(kk).ZData;
    b(kk).CData = zdata;
    b(kk).FaceColor = 'interp';
end
line([1.5,1.5],[0.5,2.5], 'linewidth', 5, 'Color', 'r');
line([3.5,3.5],[0.5,2.5], 'linewidth', 5, 'Color', 'r');
line([2.5,2.5],[5.5,3.5], 'linewidth', 5, 'Color', 'r');
for kk = 1 : 5
    for jj = 1 : 5
        text(jj-0.2, kk, after(kk,jj)+0.5, num2str(after(kk,jj)));
%         text(jj-0.2, kk, -after(kk,jj)-0.5, num2str(after(kk,jj)));
    end
end
% Plot passenger initial position;
line([passenger_init(1)+0.5, passenger_init(1)+1.5],...
     [passenger_init(2)+0.5, passenger_init(2)+1.5], [100, 100], 'linewidth', 1, 'Color', 'b');
line([passenger_init(1)+1.5, passenger_init(1)+0.5],...
     [passenger_init(2)+0.5, passenger_init(2)+1.5], [100, 100], 'linewidth', 1, 'Color', 'b');
% Plot goal position;
line([goal(1)+0.5, goal(1)+1.5],...
     [goal(2)+0.5, goal(2)+1.5], [100, 100], 'linewidth', 1, 'Color', 'g');
line([goal(1)+1.5, goal(1)+0.5],...
     [goal(2)+0.5, goal(2)+1.5], [100, 100], 'linewidth', 1, 'Color', 'g');
view(2);
xlabel('x'); ylabel('y');
ax = gca; ax.XTickLabel = 1:5; ax.YTickLabel = 1:5;
title({['Value function of greedy policy after passenger is picked up'];...
       [sprintf('instance %i: goal = [%i, %i](green cross), passenger = [%i, %i](blue cross)',...
        which_instance, goal(1)+1, goal(2)+1, passenger_init(1)+1, passenger_init(2)+1)]})
fig = fig + 1;

end
%% Plot backup numbers of Vanilla and P.S. DP
if (plot_backup_compare == 1)
    figure(fig)
    num_instance = size(vanilla,2);
    backup_vanilla = zeros(num_instance,1);
    backup_ps = zeros(num_instance,1);
    for ii = 1 : num_instance
       backup_vanilla(ii) = vanilla{ii}.count_backup;
       backup_ps(ii) = ps{ii}.count_backup;
    end
    hold on;
    plot(1:num_instance, backup_vanilla, 'bo-')
    plot(1:num_instance, backup_ps, 'g^-')
    legend('Vanilla', 'Prioritized Sweeping');
    title({['Number of backups for Vanilla DP and Prioritized Sweeping'];...
          ['threshold for both methods are 1']})
    xlabel('instance'); ylabel('Number of backups');
    ax = gca;
    ax.XTick = 1 : num_instance;
    grid on;
    hold off;
    fig = fig + 1;
end


% Define color map
map = [1,1,1;   % white - 1
       1,0,0;   % red - 2
       0,1,0;   % green - 3
       0,0,1;   % blue - 4
       1,1,0];  % yellow - 5

%% create the field
C = ones(5);
C(1,1) = 5;
C(5,5) = 3;
C(5,1) = 2;
C(1,4) = 4;
figure(201)
hold on;
% the field
image(0.5, 0.5, C);
colormap(map)
% add walls
line([1,1],[0,2],'LineWidth',8, 'Color', 'k')
line([2,2],[3,5],'LineWidth',8, 'Color', 'k')
line([3,3],[0,2],'LineWidth',8, 'Color', 'k')
% axes
limx = [0,5];
limy = [0,5];
cleanplot;
for tt = 1 : instance.maxH
    text(xu(tt,2)+0.5, xu(tt,1)+0.5, num2str(xu(tt,3)), ...
        'FontSize', 20)
end
hold off;

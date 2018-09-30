%% Plot frames
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
figure(301)
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
clear F
for tt = 1 : instance.maxH
    hm = plot(xu(tt,2)+0.5, xu(tt,1)+0.5, 'ko', 'MarkerFaceColor', ...
        [0,0,0], 'MarkerSize', 20);
    ht = text(5.2, 4.5, ['t = ', num2str(tt)], 'FontSize', 20);
    if tt > 1
        line([xu(tt-1,2), xu(tt,2)]+0.5, [xu(tt-1,1), xu(tt,1)]+0.5, ...
            'Color', 'c');
    end
    F(tt) = getframe(gcf);
    delete(hm); delete(ht);
end
hold off;
%%
vObj = VideoWriter(vfilename);
vObj.FrameRate = 2;
open(vObj);
for ii = 1 : length(F)
    frame = F(ii);
    writeVideo(vObj, frame);
end
close(vObj);

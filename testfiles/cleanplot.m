% Setting tick labels
ax1 = gca;
ax1.XTick = 0.5:4.5;
ax1.XTickLabelMode = 'manual';
% ax1.XTickLabel = num2cell(string(0:4));
ax1.XTickLabel = sprintfc('%d', 0:4);
ax1.YTick = 0.5:4.5;
ax1.YTickLabelMode = 'manual';
% ax1.YTickLabel = num2cell(string(0:4));
ax1.YTickLabel = sprintfc('%d', 0:4);
ax1.FontSize = 20;
ax1.LineWidth = 4;
ax1.DataAspectRatio = [1,1,1];
% XY limits
ax1.XLim = limx;
ax1.YLim = limy;
% Setting grid positions
ax2 = axes('Position', ax1.Position, ...
    'XAxisLocation', 'bottom', 'YAxisLocation', 'left', ...
    'Color', 'none', ...
    'XLim', ax1.XLim, 'YLim', ax1.YLim, ...
    'XTick', 0:5, 'YTick', 0:5, ...
    'XTickLabel', [], 'YTickLabel', [], ...
    'GridAlpha', 1, 'GridColor', [0,0,0], ...
    'LineWidth', 1.5, ...
    'DataAspectRatio', [1,1,1]);
linkaxes([ax1, ax2], 'xy')
grid on
set(gcf, 'CurrentAxes', ax1);
axis xy
box on;
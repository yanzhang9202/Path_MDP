axis equal
axis xy
ax.XLim = [0,5];
ax.YLim = [0,5];
% Setting tick labels
ax.XTick = 0.5:4.5;
ax.XTickLabelMode = 'manual';
ax.XTickLabel = num2cell(string(0:4));
ax.YTick = 0.5:4.5;
ax.YTickLabelMode = 'manual';
ax.YTickLabel = num2cell(string(0:4));
% Setting grid positions
ax.MinorGridColor = [0,0,0];
ax.MinorGridAlpha = 1;
ax.MinorGridLineStyle = '-'
grid minor
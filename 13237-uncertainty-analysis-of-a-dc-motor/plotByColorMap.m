function plotByColorMap(time,velocity,colorVar)
% TODO
%
if ndims(time) ~= ndims(velocity)
    error('Time and Velocity are not same size')
end

% Is there a current figure?
h = get(0,'CurrentFigure');
if isempty(h)
  h = figure;
end

% set colormap environment
colormap('autumn');
cmap = colormap;
[cmapVar, cax] = mcColorMap(colorVar,cmap);
figure(h), set(h,'Colormap',cmap), caxis(cax), colorbar, hold on

% add lines to plot
for i = 1:length(time)
   line(time{i},velocity{i},'color',cmapVar(i,:))
end

% add labels
xlabel('Time (s)')
ylabel('Angular Velocity (rpm)')
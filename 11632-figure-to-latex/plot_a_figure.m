% David Krause, david.krause@ece.queensu.ca
% Queen's University
% July 4, 2006
% Create a two axes plot

% Clean up!
close all
clear all
clc

% Some plot data
x_bottom = [0, 1, 2, 3, 4] * 1e-10;
x_top = [-4, -2, -1, 0, 1] * 1e9;
y_left = [0.5, 0.6, 0.3, -0.1, -0.2] * 1e9;
y_right = [0, 4, -5, 5, 6] * 1e4;

% Create the figure
figure(1);
axes;
plot(x_bottom, y_left, 'k.-');
xlimits = get(gca,'XLim');
ylimits = get(gca,'YLim');
xinc = (xlimits(2)-xlimits(1))/5;
yinc = (ylimits(2)-ylimits(1))/5;
set(gca,'XTick',[xlimits(1):xinc:xlimits(2)],...
        'YTick',[ylimits(1):yinc:ylimits(2)])
xlabel('Time (s)');
ylabel('Intensity (W/m)');
text(0.7e-10, 0e9, '$\bullet$ Black Line');
text(0.7e-10, -0.1e9, '$\circ$ Blue Line');    

axes;
plot(x_top, y_right, 'bo-');
set(gca, 'color', 'none', 'YAxisLocation', 'right', ...
                          'XAxisLocation', 'top');
xlimits = get(gca,'XLim');
ylimits = get(gca,'YLim');
xinc = (xlimits(2)-xlimits(1))/5;
yinc = (ylimits(2)-ylimits(1))/5;
set(gca,'XTick',[xlimits(1):xinc:xlimits(2)],...
        'YTick',[ylimits(1):yinc:ylimits(2)]);
xlabel('Time (s)');
ylabel('Widgets ($\mu$ W)');

% Create a structure with the output parameters
st.filename = 'the_figure.tex';
st.comments = 'Hello world';
st.figure_box = [25, 15, 100, 90]; % In mm, the size of the plot area (not including the labels)
st.x_tick_weight = 0.25; % The weight (line thickness) of the ticks
st.x_tick_length = 2; % The length of the ticks
st.x_label_y_offset = 8; % How far (in mm), to offset the xlabel
st.x_ticklabel_y_offset = 3;

st.y_tick_weight = 0.25;
st.y_tick_length = 2;
st.y_label_x_offset = 18;
st.y_ticklabel_x_offset = 2;
st.y_ticklabel_pow10 = 6;

st.plot_line_thickness = 0.35;

% Convert to .tex
figure2latex(1, st);
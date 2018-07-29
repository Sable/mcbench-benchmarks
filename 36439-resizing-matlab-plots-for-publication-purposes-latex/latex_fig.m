function latex_fig(font_size, f_width, f_height)

% font_size: the font size used in the paper;
% f_width: the figure width (in inches)
% f_height: the figure height (in inches)

font_rate=10/font_size;
set(gcf,'Position',[100   200   round(f_width*font_rate*144)   round(f_height*font_rate*144)])

function str_pb = progress_bar(percentage)

% Made by Nicolas Le Roux on this beautiful day of July, 20th, 2005
% Distribute this code as much as you want.
% You can send any comment at lerouxni@iro.umontreal.ca

% progress_bar(percentage) draws a progress bar at the position percentage

str_perc = [' ' num2str(percentage)];

% To draw, we only need to consider the closest integer
percentage = floor(percentage);

if percentage < 49
	str_o = char(ones(1,percentage)*111);
	str_dots_beg = char(ones(1, max(0, 48 - percentage))*46);
	str_dots_end = char([32 ones(1, 48)*46]);
	str_pb = strcat('[', str_o, str_dots_beg, str_perc, str_dots_end, ']');
else
	str_o_beg = char(ones(1,48)*111);
	str_o_end = char([32 ones(1, max(0, percentage-51))*111]);
	str_dots = char(ones(1, 100 - percentage)*46);
	str_pb = strcat('[', str_o_beg, str_perc, str_o_end, str_dots, ']');
end

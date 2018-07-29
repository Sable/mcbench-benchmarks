function figure2latex(fig_handle, st)
% David Krause
% Queen's University
% June 30, 2006
% From a figure, create the latex file
%
% fig_handle - the figure handle, typically 1 for figure 1, 2 for figure 2
% The figure can have one or two axes (for left and right axes figures)
% st - a structure with the output settings
% st.filename - the output filename
% st.comments - a string that has useful comments about the figure
% st.figure_box - 4 element vector specifying [x, y, x_end, y_end] for plot
% box
% st.x_tick_weight - the weight of the x ticks, 0.25
% st.x_tick_length - the length of the x ticks, 2
% st.x_label_y_offset - for the xlabel, the distance from the box, 8
% st.x_ticklabel_y_offset - for the x tick labels, the distance from the
% box, 3
% st.y_tick_weight = 0.25;
% st.y_tick_length = 2;
% st.y_label_x_offset = 18;
% st.y_ticklabel_x_offset = 2;
% st.y_ticklabel_pow10 - the offset for the power of 10 from the top corner, 6;
% 
% st.plot_line_thickness = 0.35;
% Create the file
[fid, message] = fopen(st.filename, 'w');

% Write the comments
fprintf(fid, '%%Written by figure2latex\n');
fprintf(fid, '%%Author: David Krause\n');
fprintf(fid, '%%Email: david.krause@ece.queensu.ca\n');
fprintf(fid, ['%%Clock output: ', num2str(clock), '\n']);
fprintf(fid, ['%%Comments: ', st.comments, '\n']);

% Write the starting material
fprintf(fid, '\\psset{xunit=1mm,yunit=1mm,runit=1mm}\n');
fprintf(fid, ['\\begin{pspicture}(0,0)(', ...
              num2str(st.figure_box(3) + st.figure_box(1)), ...
              ',', ...
              num2str(st.figure_box(4) + st.figure_box(2)), ')\n']);
          
% Create the main figure box
fprintf(fid, ['%% Main figure box\n']);
fprintf(fid, ['\\psframe[linewidth=0.35,linecolor=black](', ...
              num2str(st.figure_box(1)), ',', ...
              num2str(st.figure_box(2)), ')(', ...
              num2str(st.figure_box(3)), ',', ...
              num2str(st.figure_box(4)), ')\n']);

% Get the figure children
fig_children = get(fig_handle, 'children');

% For each child, if it is an axes, generate the labels, ticks, and then
% plot the lines
for count = 1 : length(fig_children)
    axes_tag = get(fig_children(count), 'Tag');
    axes_type = get(fig_children(count), 'Type');
    if isempty(axes_tag) & strcmp(axes_type, 'axes')
        % Yes, an axes, now get on with it
        fprintf(fid, ['%% Axes handle = ', num2str(fig_children(count)), '\n']);
        
        % X-axis label, ticks, and tick labels
        % First, determine the positions for the x-labels
        if strcmp(get(fig_children(count), 'XAxisLocation'), 'bottom')
            x_label_ypos = st.figure_box(2) - st.x_label_y_offset;
            x_ticklabel_ypos = st.figure_box(2) - st.x_ticklabel_y_offset;
            x_tick_ystart = st.figure_box(2);
            x_tick_yend = st.figure_box(2) + st.x_tick_length;
        else
            x_label_ypos = st.figure_box(4) + st.x_label_y_offset;
            x_ticklabel_ypos = st.figure_box(4) + st.x_ticklabel_y_offset;
            x_tick_ystart = st.figure_box(4);
            x_tick_yend = st.figure_box(4) - st.x_tick_length;
        end
        x_label_xpos = (st.figure_box(1) + st.figure_box(3)) / 2;        
        % Place the X axis label
        x_label_hnd = get(fig_children(count), 'XLabel');
        
        if ~isempty(get(x_label_hnd, 'String'));
            fprintf(fid, ['\\rput(', num2str(x_label_xpos), ',', ...
                                     num2str(x_label_ypos), '){', ...
                                     latex2fprintf(get(x_label_hnd, 'String')), '}\n']);
        end        
        % Next, place the x-axis tick labels and ticks
        x_tick_label = get(fig_children(count), 'XTickLabel');        
        for xtick_Count = 1 : length(x_tick_label(:, 1))
            x_temp = st.figure_box(1) + (xtick_Count - 1) * ...
                                       (st.figure_box(3) - st.figure_box(1)) / ...
                                       (length(x_tick_label(:, 1)) - 1);
            fprintf(fid, ['\\rput(', num2str(x_temp), ...
                          ',', num2str(x_ticklabel_ypos), '){', ...
                          num2str(str2num(x_tick_label(xtick_Count, :))), '}\n']);
            if (xtick_Count > 1) & (xtick_Count < length(x_tick_label(:, 1)))
                fprintf(fid, ['\\psline[linewidth=', num2str(st.x_tick_weight), ', linecolor=black]{-}(', ...
                              num2str(x_temp), ',', num2str(x_tick_ystart), ...
                              ')(', num2str(x_temp), ',', num2str(x_tick_yend), ')\n']);
            end
            % If it is the last tick, see if a power of 10 label is needed
            if xtick_Count == length(x_tick_label(:, 1))
                temp_label = str2num(x_tick_label(xtick_Count, :));
                temp_tick = get(fig_children(count), 'XTick');
                
                temp_tick = temp_tick(end);
                
                if temp_label == 0
                    temp_label = str2num(x_tick_label(1, :));
                    temp_tick = get(fig_children(count), 'XTick');
                    temp_tick = temp_tick(1);
                end
                

                if round(log10(temp_tick / temp_label)) ~= 0
                    fprintf(fid, ['\\rput[r](', num2str(x_temp), ',', ...
                                        num2str(x_label_ypos), '){$\\times 10^{', ...
                                        num2str(round(log10(temp_tick / temp_label))), ...
                                        '}$}\n']);
                end
            end
        end
        
        % Y-axis label, ticks, and tick labels
        if strcmp(get(fig_children(count), 'YAxisLocation'), 'left')
            y_label_xpos = st.figure_box(1) - st.y_label_x_offset;
            y_ticklabel_xpos = st.figure_box(1) - st.y_ticklabel_x_offset;
            y_ticklabel_just = 'r';
            y_tick_xstart = st.figure_box(1);
            y_tick_xend = st.figure_box(1) + st.y_tick_length;
            y_tick_pow10 = st.figure_box(1) - st.y_ticklabel_pow10;
        else
            y_label_xpos = st.figure_box(3) + st.y_label_x_offset;
            y_ticklabel_xpos = st.figure_box(3) + st.y_ticklabel_x_offset;
            y_ticklabel_just = 'l';
            y_tick_xstart = st.figure_box(3);
            y_tick_xend = st.figure_box(3) - st.y_tick_length;
            y_tick_pow10 = st.figure_box(3) + st.y_ticklabel_pow10;
        end
        y_label_ypos = (st.figure_box(2) + st.figure_box(4)) / 2;        
        % Place the Y axis label
        y_label_hnd = get(fig_children(count), 'YLabel');
        if ~isempty(get(y_label_hnd, 'String'));
            fprintf(fid, ['\\rput(', num2str(y_label_xpos), ',', ...
                                     num2str(y_label_ypos), '){\\rotatebox{90}{', ...
                                     latex2fprintf(get(y_label_hnd, 'String')), '}}\n']);
        end        
        % Next, place the y-axis tick labels and ticks
        y_tick_label = get(fig_children(count), 'YTickLabel');        
        for ytick_Count = 1 : length(y_tick_label(:, 1))
            y_temp = st.figure_box(2) + (ytick_Count - 1) * ...
                                       (st.figure_box(4) - st.figure_box(2)) / ...
                                       (length(y_tick_label(:, 1)) - 1);
            fprintf(fid, ['\\rput[', y_ticklabel_just, '](', ...
                          num2str(y_ticklabel_xpos), ...
                          ',', num2str(y_temp), '){', ...
                          num2str(str2num(y_tick_label(ytick_Count, :))), '}\n']);
            if (ytick_Count > 1) & (ytick_Count < length(y_tick_label(:, 1)))
                fprintf(fid, ['\\psline[linewidth=', num2str(st.y_tick_weight), ', linecolor=black]{-}(', ...
                              num2str(y_tick_xstart), ',', num2str(y_temp), ...
                              ')(', num2str(y_tick_xend), ',', num2str(y_temp), ')\n']);
            end
            % If it is the last tick, see if a power of 10 label is needed
            if ytick_Count == length(y_tick_label(:, 1))
                temp_label = str2num(y_tick_label(ytick_Count, :));
                temp_tick = get(fig_children(count), 'YTick');
                temp_tick = temp_tick(end);
                
                if temp_label == 0
                    temp_label = str2num(y_tick_label(1, :));
                    temp_tick = get(fig_children(count), 'YTick');
                    temp_tick = temp_tick(1);
                end
                
                if round(log10(temp_tick / temp_label)) ~= 0
                    fprintf(fid, ['\\rput[', y_ticklabel_just, '](', num2str(y_tick_pow10), ',', ...
                                        num2str(y_temp - st.y_ticklabel_pow10), '){$\\times 10^{', ...
                                        num2str(round(log10(temp_tick / temp_label))), ...
                                        '}$}\n']);
                end
            end
        end 
        
        % For each of the children of the axes
        axes_children = get(fig_children(count), 'Children');
        for child_count = 1 : length(axes_children)
            child_tag = get(axes_children(child_count), 'Tag');
            child_type = get(axes_children(child_count), 'Type');
            x_lim = get(fig_children(count), 'XLim');
            y_lim = get(fig_children(count), 'YLim');
            
            % Next, if the child is a line, draw it
            if isempty(child_tag) & strcmp(child_type, 'line')
                % Yes, a line, get some line data
                x_data = get(axes_children(child_count), 'XData');
                y_data = get(axes_children(child_count), 'YData');
                
                if ~strcmp(get(axes_children(child_count), 'LineStyle'), 'none')
                    % So, we do have a line style, plot it                                        
                    for line_count = 1 : (length(x_data) - 1)
                        % Test to see if the line is within the current
                        % axis limits   
                        draw_line = false;
                        if (x_data(line_count) == x_data(line_count + 1))
                            % Vertical line
                            if y_data(line_count) ~= y_data(line_count + 1)
                                % Not some strange single point line
                                if (x_data(line_count) >= x_lim(1)) & (x_data(line_count) <= x_lim(2))
                                    % X position is within limits
                                    if y_data(line_count + 1) > y_data(line_count)
                                        t_start = (y_lim(1) - y_data(line_count)) / (y_data(line_count + 1) - y_data(line_count));
                                        t_stop = (y_lim(2) - y_data(line_count)) / (y_data(line_count + 1) - y_data(line_count));
                                    else
                                        t_start = (y_lim(2) - y_data(line_count)) / (y_data(line_count + 1) - y_data(line_count));
                                        t_stop = (y_lim(1) - y_data(line_count)) / (y_data(line_count + 1) - y_data(line_count));
                                    end

                                    if (t_start > 1) | (t_stop < 0)
                                        % Do nothing
                                    else
                                        draw_line = true;
                                        if t_start < 0
                                            t_start = 0;
                                        end
                                        if t_stop > 1
                                            t_stop = 1;
                                        end
                                        x_line_coors = [x_data(line_count), x_data(line_count)];
                                        y_line_coors = y_data(line_count) + [t_start, t_stop] * (y_data(line_count + 1) - y_data(line_count));
                                    end
                                end                                        
                            end
                        elseif (y_data(line_count) == y_data(line_count + 1))
                            % Horizontal line
                            if x_data(line_count) ~= x_data(line_count + 1)
                                % Not some strange single point line
                                if (y_data(line_count) >= y_lim(1)) & (y_data(line_count) <= y_lim(2))
                                    % Y position is within limits
                                    if x_data(line_count + 1) > x_data(line_count)
                                        t_start = (x_lim(1) - x_data(line_count)) / (x_data(line_count + 1) - x_data(line_count));
                                        t_stop = (x_lim(2) - x_data(line_count)) / (x_data(line_count + 1) - x_data(line_count));
                                    else
                                        t_start = (x_lim(2) - x_data(line_count)) / (x_data(line_count + 1) - x_data(line_count));
                                        t_stop = (x_lim(1) - x_data(line_count)) / (x_data(line_count + 1) - x_data(line_count));
                                    end

                                    if (t_start > 1) | (t_stop < 0)
                                        % Do nothing
                                    else
                                        draw_line = true;
                                        if t_start < 0
                                            t_start = 0;
                                        end
                                        if t_stop > 1
                                            t_stop = 1;
                                        end
                                        y_line_coors = [y_data(line_count), y_data(line_count)];
                                        x_line_coors = x_data(line_count) + [t_start, t_stop] * (x_data(line_count + 1) - x_data(line_count));
                                    end                                    
                                end
                            end
                        else
                            % Line is neither horizontal or vertical
                            if x_data(line_count + 1) > x_data(line_count)
                                t_start_x = (x_lim(1) - x_data(line_count)) / (x_data(line_count + 1) - x_data(line_count));
                                t_stop_x = (x_lim(2) - x_data(line_count)) / (x_data(line_count + 1) - x_data(line_count));
                            else
                                t_start_x = (x_lim(2) - x_data(line_count)) / (x_data(line_count + 1) - x_data(line_count));
                                t_stop_x = (x_lim(1) - x_data(line_count)) / (x_data(line_count + 1) - x_data(line_count));
                            end
                            if y_data(line_count + 1) > y_data(line_count)
                                t_start_y = (y_lim(1) - y_data(line_count)) / (y_data(line_count + 1) - y_data(line_count));
                                t_stop_y = (y_lim(2) - y_data(line_count)) / (y_data(line_count + 1) - y_data(line_count));
                            else
                                t_start_y = (y_lim(2) - y_data(line_count)) / (y_data(line_count + 1) - y_data(line_count));
                                t_stop_y = (y_lim(1) - y_data(line_count)) / (y_data(line_count + 1) - y_data(line_count));
                            end
                            
                            if (t_start_x > 1) | (t_start_y > 1) | (t_stop_x < 0) | (t_stop_y < 0)
                                % Do nothing
                            else
                                draw_line = true;
                                t_start = max([t_start_x, t_start_y, 0]);
                                t_stop = min([t_stop_x, t_stop_y, 1]);
                                
                                x_line_coors = x_data(line_count) + [t_start, t_stop] * (x_data(line_count + 1) - x_data(line_count));
                                y_line_coors = y_data(line_count) + [t_start, t_stop] * (y_data(line_count + 1) - y_data(line_count));
                            end                            
                        end
                        
                        if draw_line == true
                            % First, get the line colour
                            temp_colour = get(axes_children(child_count), 'Color');
                            fprintf(fid, ['\\newrgbcolor{userLineColor}{' num2str(temp_colour(1)) ...       
                                                         ' ' num2str(temp_colour(2)) ...
                                                         ' ' num2str(temp_colour(3)) '}\n']);
                            % Next, get the new coordinates
                            x_line_tex = st.figure_box(1) + (st.figure_box(3) - st.figure_box(1)) * (x_line_coors - x_lim(1)) / (x_lim(2) - x_lim(1));
                            y_line_tex = st.figure_box(2) + (st.figure_box(4) - st.figure_box(2)) * (y_line_coors - y_lim(1)) / (y_lim(2) - y_lim(1));
                            fprintf(fid, ['\\psline[linewidth=', num2str(st.plot_line_thickness), ',linecolor=userLineColor]{-}(' ...
                                num2str(x_line_tex(1), '%3.2f') ',' num2str(y_line_tex(1), '%3.1f') ')(' ...
                                num2str(x_line_tex(2), '%3.2f') ',' num2str(y_line_tex(2), '%3.1f') ')\n']);
                        end
                    end                        
                end
                
                if ~strcmp(get(axes_children(child_count), 'Marker'), 'none')
                    % So, we do have a line marker, plot it
                    % First, set the colour
                    temp_colour = get(axes_children(child_count), 'Color');
                    fprintf(fid, ['\\newrgbcolor{userLineColor}{' num2str(temp_colour(1)) ...       
                                                 ' ' num2str(temp_colour(2)) ...
                                                 ' ' num2str(temp_colour(3)) '}\n']);
                    for line_count = 1 : length(x_data)
                        if (x_data(line_count) >= x_lim(1)) & (x_data(line_count) <= x_lim(2)) & ...
                           (y_data(line_count) >= y_lim(1)) & (y_data(line_count) <= y_lim(2))
                            % Yes, marker is in the window
                            x_tex = st.figure_box(1) + (st.figure_box(3) - st.figure_box(1)) * (x_data(line_count) - x_lim(1)) / (x_lim(2) - x_lim(1));
                            y_tex = st.figure_box(2) + (st.figure_box(4) - st.figure_box(2)) * (y_data(line_count) - y_lim(1)) / (y_lim(2) - y_lim(1));
                            temp = get(axes_children(child_count), 'Marker');
                            temp = matlab_marker_to_latex(temp);
                            fprintf(fid, ['\\rput(', num2str(x_tex, '%3.2f'), ',', ...
                                        num2str(y_tex, '%3.2f'), '){\\textcolor{userLineColor}{', latex2fprintf(temp), '}}\n']);
                        end
                    end
                end
            end
            % If the child is text, place it
            if isempty(child_tag) & strcmp(child_type, 'text')
                % Set the colour
                temp_colour = get(axes_children(child_count), 'Color');
                    fprintf(fid, ['\\newrgbcolor{userLineColor}{' num2str(temp_colour(1)) ...       
                                                 ' ' num2str(temp_colour(2)) ...
                                                 ' ' num2str(temp_colour(3)) '}\n']);
                temp = get(axes_children(child_count), 'Position');
                x_tex = st.figure_box(1) + (st.figure_box(3) - st.figure_box(1)) * (temp(1) - x_lim(1)) / (x_lim(2) - x_lim(1));
                y_tex = st.figure_box(2) + (st.figure_box(4) - st.figure_box(2)) * (temp(2) - y_lim(1)) / (y_lim(2) - y_lim(1));
                fprintf(fid, ['\\rput[l](', num2str(x_tex, '%3.2f'), ',', ...
                                        num2str(y_tex, '%3.2f'), '){\\textcolor{userLineColor}{', ...
                                        latex2fprintf(get(axes_children(child_count), 'String')), '}}\n']);
            end
        end
        
    end
end

% Write the ending material
fprintf(fid, '\\end{pspicture}\n');

% Close the file
fclose(fid);
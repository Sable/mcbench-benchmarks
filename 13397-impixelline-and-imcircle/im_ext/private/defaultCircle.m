function draw_API = defaultCircle(h_group)
%
%       DRAW_API.setColor         
%       DRAW_API.updateView       
%       DRAW_API.getBoundingBox 
%

  % initialize variables needing function scope
  bounding_box = [];
  %h_axes = iptancestor(h_group,'axes');
  
  % The line objects should have a width of one screen pixel.
  line_width = ceil(getPointsPerScreenPixel);
  h_circle  = rectangle(...
                        'Curvature', [1,1],...
                        'LineWidth', line_width,...
                        'faceColor', 'none',...
                        'Hittest', 'off',...
                        'Parent', h_group);
  h_patch   = patch('FaceColor', 'none', 'EdgeColor', 'none', ...
                    'HitTest', 'off', ...
                    'Parent', h_group);

  draw_API.setColor         = @setColor;
  draw_API.updateView       = @updateView;  
  draw_API.getBoundingBox   = @getBoundingBox;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  function pos = getBoundingBox
    pos = bounding_box;
  end
  %--------------------------------------------------------------------------
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  function updateView(cen, r)
  
    if ~ishandle(h_group)
        return;
    end

    new_pos = [cen(1) - r, cen(2) - r, r+r, r+r];
    if ( ~isequal(new_pos, get(h_circle, 'Position')) )
      set(h_circle, 'Position', new_pos);
      xx = [...
        new_pos(1),...
        new_pos(1),new_pos(1)+new_pos(3),new_pos(1)+new_pos(3),...
        new_pos(1)];
      yy = [...
        new_pos(2),...
        new_pos(2)+new_pos(4),new_pos(2)+new_pos(4),new_pos(2),...
        new_pos(2)];
      set(h_patch, 'XData', xx, 'YData', yy);
    end

    bounding_box = new_pos;

    
  end
  %--------------------------------------------------------------------------

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  function setColor(c)
    if ishandle(h_circle)
      set(h_circle, 'EdgeColor', c);
    end

  end
  %--------------------------------------------------------------------------
  
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function setXYDataIfChanged(h, x, y)
% % Set XData and YData of HG object h to x and y if they are different.  h
% % must be a valid HG handle to an object having XData and YData properties.
% % No validation is performed.
%     
%   if ~isequal(get(h, 'XData'), x) || ~isequal(get(h, 'YData'), y)
%     set(h, 'XData', x, 'YData', y);
%   end
% end
% %--------------------------------------------------------------------------

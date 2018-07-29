
function draw_API = pixLineSymbol(h_group)
%pixLineSymbol Creates renderer for line.  
%   draw_API = pixLineSymbol(H_GROUP,GET_POSITION_FCN) creates a
%   renderer for use in association with IMLINE that draws lines.
%   draw_API is a structure of function handles that are used
%   by IMLINE to draw the line and update its properties.
%
%       draw_API.setColor         
%       draw_API.updateView       

%   Copyright 2005 The MathWorks, Inc.
%   $Revision $  $Date: 2005/11/15 01:03:43 $
  
  
  h_axes = ancestor(h_group,'axes');

  h_pix_line = line(...
    'LineStyle', 'none',...
    'Marker', 'square',...
    'Parent', h_group,...
    'Color', 'b',...
    'ButtonDownFcn',get(h_group,'ButtonDownFcn'));
 


  draw_API.setColor         = @setColor;
  draw_API.updateView       = @updateView;  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  function setColor(c)
    if ishandle(h_pix_line)
      set(h_pix_line, 'Color', c);
    end
  end
  %--------------------------------------------------------------------------

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function updateView(position)

        if ~ishandle(h_group)
            return;
        end

        h_axes = ancestor(h_group,'axes');

        rs = position(1,2); cs = position(1,1);
        re = position(2,2); ce = position(2,1);
        [rr, cc] = LineTwoPnts(rs,cs,re,ce);
        
        points_per_one = getPointsPerOne(h_axes);
        
        set(h_pix_line,...
          'XData',cc,...
          'YData',rr,...
          'MarkerSize', points_per_one);

    end
  %--------------------------------------------------------------------------  
  
  function points_per_one = getPointsPerOne(h_axes)
    points_per_screen_pixel = getPointsPerScreenPixel;
    dx_per_screen_pixel = getAxesScale(h_axes);
    points_per_one = points_per_screen_pixel / dx_per_screen_pixel;
  end
  
end %end pixLineSymbol

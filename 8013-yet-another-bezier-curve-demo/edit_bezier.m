function edit_bezier(varargin)

if nargin==2
    v=varargin{2};
    e=varargin{1};
    p=get(gca,'CurrentPoint');
    ud=get(gca,'UserData');
    
    % ButtonDown event
    if strcmpi(e,'down')
        if ~strcmpi(ud.mode,'normal')
            % something wrong! fix it and return!
            ud.mode='normal';
            ud.point_to_drag=-1; % nothing is to drag
            set(gcf,'Pointer','arrow');
            set(gca,'UserData',ud);
            return;
        end
        % change the mode to drag
        ud.mode='drag';
        ud.point_to_drag=v; % number of point to drag
        set(gcf,'Pointer','cross');
        set(gca,'UserData',ud);
        return;
    end
    
    if strcmpi(e,'up')
        ud.mode='normal';
        ud.point_to_drag=-1; % nothing is to drag
        set(gcf,'Pointer','arrow');
        set(gca,'UserData',ud);
        return;
    end

   if strcmpi(e,'move') & strcmpi(ud.mode,'drag')
      % the most complicated part 
      new_x=p(1,1);
      new_y=p(1,2);
      b=ud.bezier;
      switch ud.point_to_drag
          case 0
              b.x0=new_x;
              b.y0=new_y;
          case 1
              b.x1=new_x;
              b.y1=new_y;
          case 2
              b.x2=new_x;
              b.y2=new_y;
          case 3
              b.x3=new_x;
              b.y3=new_y;
      end    
      ud.bezier=b;
      set(gca,'UserData',ud);
      edit_curve(b,gcf);
   end    
  
end

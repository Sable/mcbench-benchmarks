function varargout=edit_curve(varargin)
% WYSIWYG editor for bezier curve
% function edit_curve(bezier)
% function bezier2=edit_curve(bezier)
% function edit_curve(bezier,figure)

if nargout>1
 error('edit_curve expects zero or 1 output parameters.');
end

b=varargin{1};   
if ~strcmpi(class(b),'bezier') 
   error('Invalid arguments') 
end    


t=0:0.01:1;
t2=t.^2;
t3=t2.*t;
x=b.ax*t3+b.bx*t2+b.cx*t+b.x0;
y=b.ay*t3+b.by*t2+b.cy*t+b.y0;

if nargin==1 
 % draw the curve from scratch    
    f=figure;
    hold on;
    l=[];
    l=[l,text([b.x0],[b.y0],'(x_0,y_0)')]; 
	l=[l,text([b.x1],[b.y1],'(x_1,y_1)')]; 
	l=[l,text([b.x2],[b.y2],'(x_2,y_2)')]; 
	l=[l,text([b.x3],[b.y3],'(x_3,y_3)')]; 
    set(l(1),'tag','text1');
    set(l(2),'tag','text2');
    set(l(3),'tag','text3');
    set(l(4),'tag','text4');
    h=plot(x,y,'b',...
     [b.x0,b.x1],[b.y0,b.y1],'r',...
     [b.x2,b.x3],[b.y2,b.y3],'r',...
     [b.x1],[b.y1],'ro',...
     [b.x2],[b.y2],'ro',...
     [b.x3],[b.y3],'r*',...
     [b.x0],[b.y0],'r*');
    set(h(1),'tag','spline');
    set(h(2),'tag','control line 1');
    set(h(3),'tag','control line 2');
    set(h(4),'tag','p1');
    set(h(5),'tag','p2');
    set(h(6),'tag','p3');
    set(h(7),'tag','p0');
    ud.bezier=b;
    ud.mode='normal'; % opposite to drag
    ud.point_to_drag=-1; % nothing is to drag
    set(gca,'UserData',ud);
    set(h(4),'ButtonDownFcn','edit_bezier(''down'',1)');
    set(h(5),'ButtonDownFcn','edit_bezier(''down'',2)');
    set(h(6),'ButtonDownFcn','edit_bezier(''down'',3)');
    set(h(7),'ButtonDownFcn','edit_bezier(''down'',0)');

    set(f,'WindowButtonUpFcn','edit_bezier(''up'',0)');
    set(f,'WindowButtonMotionFcn','edit_bezier(''move'',0)');

    set(f,'CloseRequestFcn','uiresume;');
    
    if nargout==1
      uiwait;
      ud=get(gca,'UserData');
      b=ud.bezier;
      clear ud;
      delete(gcf); 
      varargout{1}=b;
  end
end


if nargin==2 
 % redraw existing bezier curve

    f=varargin{2};   

    if ~ishandle(f)
       error('Invalid arguments') 
    end    
    
    t=findobj(f,'tag','text1');
    set(t,'Position',[b.x0,b.y0]);
    t=findobj(f,'tag','text2');
    set(t,'Position',[b.x1,b.y1]);
    t=findobj(f,'tag','text3');
    set(t,'Position',[b.x2,b.y2]);
    t=findobj(f,'tag','text4');
    set(t,'Position',[b.x3,b.y3]);

    t=findobj(f,'tag','p0');
    set(t,'XData',[b.x0]); set(t,'YData',[b.y0])
    t=findobj(f,'tag','p1');
    set(t,'XData',[b.x1]); set(t,'YData',[b.y1])
    t=findobj(f,'tag','p2');
    set(t,'XData',[b.x2]); set(t,'YData',[b.y2])
    t=findobj(f,'tag','p3');
    set(t,'XData',[b.x3]); set(t,'YData',[b.y3])
  
    t=findobj(f,'tag','spline');
    set(t,'XData',x); set(t,'YData',y)
    t=findobj(f,'tag','control line 1');
    set(t,'XData',[b.x0,b.x1]); set(t,'YData',[b.y0,b.y1])
    t=findobj(f,'tag','control line 2');
    set(t,'XData',[b.x2,b.x3]); set(t,'YData',[b.y2,b.y3])

end 

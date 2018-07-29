function oh=annotation_pinned(varargin)
% Create annotations that are pinned to the current axes. The use is the same as
% the standard annotation function (see help annotation). The only
% difference is that you can provide the axes.
% For example:
% figure
% ah1=subplot(2,1,1);
% 
% ah2=subplot(2,1,2);
% annotation_pinned('arrow',[0.1,0.2],[0.5,0.1],'axes',ah1);
% annotation_pinned('textarrow',[0.3,0.5],[0.3,0.5],'axes',ah2,'String','test $x^2$','Interpreter','Latex')
%
% Author: Fred Gruber
% August 2011

otherp={};
indo=1;
indn=1;
axesh=[];
tagn=[];
while indn<=nargin
    if strcmp(varargin{indn},'axes')
        axesh=varargin{indn+1};
        indn=indn+2;
    elseif strcmp(varargin{indn},'tag')
        tagn=varargin{indn+1};
        indn=indn+2;
    else
        otherp{indo}=varargin{indn};
        %             otherp{indo+1}=varargin{indn+1};
        indo=indo+1;
        indn=indn+1;
        
    end
    
    
end

if isempty(axesh)
   axesh= gca;
end
figh=get(axesh,'Parent');
ud=get(figh,'Userdata');

if ~isfield(ud,'annh')
   ud.annh={}; 
end

Na=length(ud.annh);
annh=[];
tempNa=Na+1;
if isempty(tagn)
    namea=['txtann' num2str(Na+1)];
   tagn=namea; 
   
else %does it exist. iF it does erase it
    namea=tagn;
    for indt=1:Na
       temp=ud.annh{indt};
       if strcmp(temp.tag,tagn)
           delete(temp.handle);
           %            annh=temp.handle;
           tempNa=indt;
       end
    end
end


set(figh,'Units','normalized');
% annh=findall(figh,'Tag',tagn);

annh=annotation( otherp{:});
set(annh,'Tag',namea);

pos=get(annh,'Position');
X(1)=pos(1);
X(2)=pos(3)+X(1);
Y(1)=pos(2);
Y(2)=pos(4)+Y(1);
[xaf,yaf] = dsxy2figxy_log(axesh,X,Y);

annf=get(annh);
if isfield(annf,'X')
    set(annh,'X',xaf,'Y',yaf);
else
    pos2=[xaf(1),yaf(1),xaf(2)-xaf(1),yaf(2)-yaf(1)];
    set(annh,'Position',pos2);
end
ud.annh{tempNa}=struct('X',X,'Y',Y,'tag',namea,'handle',annh,...
        'axes',axesh);
    
zh=zoom(figh);
set(zh,'ActionPostCallback',@afterzoom);
ph=pan(figh);
set(ph,'ActionPostCallback',@afterzoom);
set(ph,'ButtonDownFilter',@pandrag);
set(figh,'Userdata',ud);
set(figh,'WindowButtonUpFcn',@stopDragFcn);
end   

function afterzoom(obj,event_obj)

  ud=get(obj,'Userdata');
  
  if ~isempty(ud)
      for ind1=1:length(ud.annh)
          X=ud.annh{ind1}.X;
          Y=ud.annh{ind1}.Y;
           ah=ud.annh{ind1}.axes;
           av=axis(ah);
          [xaf,yaf] = dsxy2figxy_log(ah,X,Y);
          txth=ud.annh{ind1}.handle;
          pos=[xaf(1),yaf(1),xaf(2)-xaf(1),yaf(2)-yaf(1)];
          set(txth,'Position',pos);
          if av(1)>X(2) | av(4)<Y(2)|av(2)<X(2)|av(3)>Y(2)
              set(txth,'Visible','off');
          else
              set(txth,'Visible','on');
          end
      end
  end
    
     
     
     
     
end
 
function res=pandrag(obj,event_obj)
if strcmp(get(obj,'type'),'axes')
    fh=get(obj,'Parent');
else
    fh=get(get(obj,'Parent'),'Parent');
%     ud=get(get(get(obj,'Parent'),'Parent'),'Userdata');
end
set(fh,'WindowButtonMotionFcn',@draggingFcn);

  res=0;
     
end
 
   function draggingFcn(varargin)
%         aH=varargin{1};
% hl
   fh=varargin{1};
   ud=get(fh,'Userdata');
   if ~isempty(ud)
      for ind1=1:length(ud.annh)
          X=ud.annh{ind1}.X;
          Y=ud.annh{ind1}.Y;
           ah=ud.annh{ind1}.axes;
           av=axis(ah);
           
          [xaf,yaf] = dsxy2figxy_log(ah,X,Y);
          txth=ud.annh{ind1}.handle;
          pos=[xaf(1),yaf(1),xaf(2)-xaf(1),yaf(2)-yaf(1)];
          set(txth,'Position',pos);
          if av(1)>X(2) | av(4)<Y(2)|av(2)<X(2)|av(3)>Y(2)
              set(txth,'Visible','off');
          else
              set(txth,'Visible','on');
          end
      end
  end
      
    end

    function stopDragFcn(varargin)
    fh=varargin{1};
        set(fh,'WindowBUttonMotionFcn','');
    end
    
 
  

    
function varargout = dsxy2figxy_log(varargin)
% dsxy2figxy -- Transform point or position from axis to figure coords
% while correctly handling log scale for either X or Y axes
% Transforms [axx axy] or [xypos] from axes hAx (data) coords into coords
% wrt GCF for placing annotation objects that use figure coords into data
% space. The annotation objects this can be used for are
% arrow, doublearrow, textarrow
% ellipses (coordinates must be transformed to [x, y, width, height])
% Note that line, text, and rectangle anno objects already are placed
% on a plot using axes coordinates and must be located within an axes.
% Usage: Compute a position and apply to an annotation, e.g.,
% [axx axy] = ginput(2);
% set(gca, 'XScale', 'log');
% [figx figy] = dsxy2figxy_log(gca, axx, axy);
% har = annotation('textarrow',figx,figy);
% set(har,'String',['(' num2str(axx(2)) ',' num2str(axy(2)) ')'])

%% Obtain arguments (only limited argument checking is performed).
% Determine if axes handle is specified
if length(varargin{1})== 1 && ishandle(varargin{1}) && ...
strcmp(get(varargin{1},'type'),'axes')
hAx = varargin{1};
varargin = varargin(2:end);
else
hAx = gca;
end;
% Parse either a position vector or two 2-D point tuples
if length(varargin)==1 % Must be a 4-element POS vector
pos = varargin{1};
else
[x,y] = deal(varargin{:}); % Two tuples (start & end points)
end
%% Get limits
axun = get(hAx,'Units');
set(hAx,'Units','normalized'); % Need normaized units to do the xform
axpos = get(hAx,'Position');
axlim = axis(hAx); % Get the axis limits [xlim ylim (zlim)]
axxscale = get(hAx, 'XScale');
axyscale = get(hAx, 'YScale');

if strcmpi(axxscale, 'log'); % Handle log scale on X and Y axis
x = log10(x); axlim(1:2) = log10(axlim(1:2));
end
if strcmpi(axyscale, 'log');
y = log10(y); axlim(3:4) = log10(axlim(3:4));
end

%% Transform data from figure space to data space
if exist('x','var') % Transform a and return pair of points
varargout{1} = (x-axlim(1))*axpos(3)/(axlim(2)-axlim(1)) + axpos(1);
varargout{2} = (y-axlim(3))*axpos(4)/(axlim(4)-axlim(3)) + axpos(2);
else % Transform and return a position rectangle
pos(1) = (pos(1)-axlim(1))/(axlim(2)-axlim(1))*axpos(3) + axpos(1);
pos(2) = (pos(2)-axlim(3))/(axlim(4)-axlim(3))*axpos(4) + axpos(2);
pos(3) = pos(3)*axpos(3)/(axlim(2)-axlim(1));
pos(4) = pos(4)*axpos(4)/(axlim(4)-axlim(3));
varargout{1} = pos;
end
%% Restore axes units
set(hAx,'Units',axun)
end
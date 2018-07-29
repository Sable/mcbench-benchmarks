function ForwardandBackwardEulerExplorer()
% GUI for comparing the difference between Forward Euler, Backward Euler
% and Crank Nicolson for a basic time integration problem:
%
%   du/dt = lambda*u
%
% The idea behind the GUI is to facilitate the explanation of stability
% regions.  Of particular interest is when lambda*dt = 2
%   Copyright 2013 The MathWorks, Inc.


handles.FontSize = 12;
handles.Color = [
    0.00 0.00 1.00
    0.00 0.50 0.00
    1.00 0.00 0.00
    0.00 0.75 0.75
    0.75 0.00 0.75
    ];
handles.StabilityColor = [
    0.729412 0.831373 0.956863
    0.7569    0.8667    0.7765
    0.9255    0.8392    0.8392
    0.7255    0.9255    0.9216
    0.9882    0.7569    0.9882
    ];

handles.LineWidth = 2;
handles.MarkerSize = 10;

handles.StabilityXdom = [-3 3];
handles.StabilityYdom = [-3 3];



%% build the gui

fh = figure('Visible','on','Name','ForwardandBackwardEulerExplorer');

set(fh,'MenuBar','none')
pos_orig = get(fh,'Position');
Width = 750; Height = 750;
set(fh,'Position',[pos_orig(1), pos_orig(2)+pos_orig(4)-Height, Width, Height]);

set(fh,'units','normalized');

handles.textaxis = axes('parent',fh,...
    'units','normalized',...
    'position',[0 0 1 1],...
    'visible','off'); 

handles.PlotAxes = axes('Parent',fh,...
    'Position',[.1, .55, .8, .425]);
xlabel('t','FontSize',handles.FontSize)
ylabel('u','FontSize',handles.FontSize)
set(handles.PlotAxes,'XLim',[0 20]);

hEval = line;
%set(hEval,'xdata',[],'ydata',[]);
set(hEval,'Marker','o','LineStyle','none');%,'Visible','off')
set(hEval,'LineStyle','none');
set(hEval,'MarkerSize',handles.MarkerSize);
set(hEval,'Color',handles.Color(1,:));
set(hEval,'LineWidth',handles.LineWidth);

hExact = line;
%set(hExact,'xdata',[],'ydata',[]);
set(hExact,'LineStyle','--')
set(hExact,'Color',handles.Color(2,:));
set(hExact,'LineWidth',handles.LineWidth);

% store the handles for later use
handles.hExact = hExact;
handles.hEval  = hEval;
handles.Legend = legend('Numeric','Exact');

handles.StabilityAxes = axes('Parent',fh,...
    'Position',[.1, .075, .4, .425]);
xlabel('Re(\lambda\Delta t)','FontSize',handles.FontSize)
ylabel('Im(\lambda\Delta t)','FontSize',handles.FontSize)
xlim([-3 3]);
ylim([-3 3]);

grid on;

handles.MethodSelector = uicontrol(fh,'Style','popupmenu',...
    'String',{'Forward Euler', 'Backward Euler', 'Crank Nicolson'},...
    'Value',1,...
    'FontSize',handles.FontSize,...
    'units','normalized',...
    'Position',[.6 .4 .3 .1],...
    'CallBack',@UpdatePlot);

handles.LambdaEdit = uicontrol(fh,'Style','edit',...
    'String','-2',...
    'FontSize',handles.FontSize,...
    'units','normalized',...
    'Position',[.615 .2 .075 .075],...
    'CallBack',@UpdateLambda);
handles.DeltaTEdit = uicontrol(fh,'Style','edit',...
    'String','0.5',...
    'FontSize',handles.FontSize,...
    'units','normalized',...
    'Position',[.615 .1 .075 .075],...
    'CallBack',@UpdateDeltaT);
handles.WhyButton = uicontrol(fh,'Style','pushbutton',...
    'String','Why',...
    'FontSize',handles.FontSize,...
    'units','normalized',...
    'Position',[.7 .02 .2 .05],...
    'CallBack',@WhyButtonPress);
% text
axes(handles.textaxis)
str = {
    'v^{n+1} = v^{n} + \lambda\Delta t v^{n}';
    'v^{n+1} = (1 + \lambda\Delta t) v^{n}';
    };
handles.MethodText = text(.75,.4,str,...
    'unit','normalized',...
    'HorizontalAlignment','center',...
    'FontSize',handles.FontSize);
handles.LambdaText = text(.6,.24,'\lambda:',...
    'unit','normalized',...
    'HorizontalAlignment','right',...
    'FontSize',handles.FontSize);
handles.DeltaTText = text(.6,.14,'\Delta t:',...
    'unit','normalized',...
    'HorizontalAlignment','right',...
    'FontSize',handles.FontSize);

% add sliders
handles.LambdaSlider = uicontrol(fh,'Style','slider',...
    'Min',-10,'Max',10,...
    'Value',-2,...
    'FontSize',handles.FontSize,...
    'units','normalized',...
    'Position',[.715,0.2, .25, .075],...
    'CallBack',@UpdateLambda);
handles.DeltaTSlider = uicontrol(fh,'Style','slider',...
    'Min',0.1,'Max',10,...
    'Value',0.5,...
    'FontSize',handles.FontSize,...
    'units','normalized',...
    'Position',[.715,0.1, .25, .075],...
    'CallBack',@UpdateDeltaT);


setappdata(fh,'handles',handles) 

UpdateLambda(handles.LambdaEdit);


end

function UpdateLambda(hObject, eventdata)

fh = get(hObject,'Parent');
handles = getappdata(fh,'handles');
style = get(hObject,'Style');

switch lower(style)
    case 'edit' 
        lambda = str2double(get(handles.LambdaEdit,'String'));
    case 'slider'
        lambda = get(handles.LambdaSlider,'Value');
    otherwise
        error('Unexpected style');
end

lambdamin = get(handles.LambdaSlider,'Min');
lambdamax = get(handles.LambdaSlider,'Max');

if (lambda<lambdamin)
    lambda = lambdamin;
end

if (lambda>lambdamax)
    lambda = lambdamax;
end


% set the lambdas
set(handles.LambdaEdit,  'String',sprintf('%.1f',lambda));
set(handles.LambdaSlider,'Value', lambda);

UpdatePlot(hObject);

end

function UpdateDeltaT(hObject, eventdata)

fh = get(hObject,'Parent');
handles = getappdata(fh,'handles');
style = get(hObject,'Style');

switch lower(style)
    case 'edit' 
        dt = str2double(get(handles.DeltaTEdit,'String'));
    case 'slider'
        dt = get(handles.DeltaTSlider,'Value');
    otherwise
        error('Unexpected style');
end

dtmin = get(handles.DeltaTSlider,'Min');
dtmax = get(handles.DeltaTSlider,'Max');

if (dt<dtmin)
    dt = dtmin;
end

if (dt>dtmax)
    dt = dtmax;
end

% set the lambdas
set(handles.DeltaTEdit,  'String',sprintf('%.1f',dt));
set(handles.DeltaTSlider,'Value', dt);

UpdatePlot(hObject);

end


function UpdatePlot(hObject, eventdata)

fh = get(hObject,'Parent');
handles = getappdata(fh,'handles');

% get relavent handles
hExact  = handles.hExact;
hEval   = handles.hEval;
lambda  = str2double(get(handles.LambdaEdit,'String'));
dt      = str2double(get(handles.DeltaTEdit,'String'));
method  = get(handles.MethodSelector,'Value');
Color   = handles.Color;
Scolor  = handles.StabilityColor;
LW      = handles.LineWidth;
xdom    = handles.StabilityXdom;
ydom    = handles.StabilityYdom;

% remove current children
current_children = get(handles.StabilityAxes,'Children');
delete(current_children);

switch method
    case 1
        g = 1+lambda*dt;
        str = {
            'v^{n+1} = v^{n} + \Delta t f(v^{n},t^{n})';
            'v^{n+1} = v^{n} + \lambda\Delta t v^{n}';
            'v^{n+1} = (1 + \lambda\Delta t) v^{n}';
            };
        type = 'ef';

    case 2
        g = 1/(1-lambda*dt);
        str = {
            'v^{n+1} = v^{n} + \Delta t f(v^{n+1},t^{n+1})';
            'v^{n+1} = v^{n} + \lambda\Delta t v^{n+1}'
            'v^{n+1} = 1/(1-\lambda\Delta t) v^{n}'
            };
        type = 'eb';
    case 3
        g = (1+lambda*dt/2)/(1-lambda*dt/2);
        str = {
            'v^{n+1} = v^{n} + \Delta t 0.5( f(v^{n+1},t^{n+1})+f(v^{n},t^{n}) )';
            'v^{n+1} = v^{n} + \lambda\Delta t 0.5 (v^{n+1}+v^{n})'
            'v^{n+1} = (1+0.5\lambda\Delta t)/(1-0.5\lambda\Delta t) v^{n}'
            };
        type = 'cn';
    otherwise 
        error();
end

N = ceil(20/dt);
t = dt*[0:N];
v = g.^[0:N];
te = linspace(0,20,100);
ue = exp(lambda*te);
set(hExact,'xdata',te,'ydata',ue);
set(hEval ,'xdata',t ,'ydata',v);
set(handles.MethodText,'String',str);

% add the stability plots
[hp,hl] = drawstabcontour(type,xdom,ydom,handles.StabilityAxes);
set(hp,'FaceAlpha',0.2);
set(hp,'FaceColor',Scolor(1,:));
set(hp,'LineStyle','none');

set(hl,'color',Color(1,:));
set(hl,'linewidth',3);
    
% add lambdadeltat dot
axes(handles.StabilityAxes);
h = line(lambda*dt,0);
set(h,'marker','o')
set(h,'MarkerSize',handles.MarkerSize)
set(h,'Color',handles.Color(1,:));
set(h,'LineWidth',handles.LineWidth);

end


function WhyButtonPress(hObject, eventdata)
if (ispc)
    web('html\WhyExplicitvsImplicit.html')
else
    if (isunix)
        web('html/WhyExplicitvsImplicit.html')
    else
         warning('WarnTests:convertTest','Uknown platfrom ispc=0 & isunix=0, \nrun >> web(''html\\explicitvsimplicit.html'')')
    end
end
end

function [hpatch, hline] = drawstabcontour(type,xdom,ydom,axes_handle,color)
if (nargin < 1), type = 'eb'; end;
if (nargin < 2), xdom = [-3,3]; end;
if (nargin < 3), ydom = [-3,3]; end;
if (nargin < 4), axes_handle = gca; end;
if (nargin < 5), color = [0 0 1]; end;

x = linspace(xdom(1),xdom(2),301);
y = linspace(ydom(1),ydom(2),301);
[xx,yy] = meshgrid(x,y);
zz = xx + 1i*yy;

switch type
 case {'eb','eulerbackward'}
  gamma = eulerbackamp(zz);
 case {'ef','eulerforward'}
  gamma = eulerforwardamp(zz);
 case 'rk2'
  gamma = rk2amp(zz);
 case 'rk4'
  gamma = rk4amp(zz);
 case 'irk2'
  gamma = irk2amp(zz);
 case 'ab2'
  gamma = ab2amp(zz);
 case 'ab3'
  gamma = ab3amp(zz);
 case 'am2'
  gamma = am2amp(zz);
 case {'cn','cranknicolson'}
  gamma = cnamp(zz);
 case 'bdf2'
  gamma = bdf2amp(zz);
 case 'bdf3'
  gamma = bdf3amp(zz);
 otherwise
  error('unknown integrator type')    
end

gammaabs = abs(gamma);

C = contourc(x,y,gammaabs,[1,1]);

xline = C(1,2:end);
yline = C(2,2:end);

xp = [xdom(1) xdom(2) xdom(2) xdom(1) xdom(1) xline];
yp = [ydom(1) ydom(1) ydom(2) ydom(2) ydom(1) yline];

% need to handle special case of cranknicolson and irk2
switch type
    case {'cn', 'cranknicolson', 'irk2'}
        xp = [0.0     xdom(2) xdom(2) 0.0     0.0    ];
        yp = [ydom(1) ydom(1) ydom(2) ydom(2) ydom(1)];
    otherwise
        % don't need to do anything
end
axes(axes_handle);
hpatch = patch(xp,yp,color,'FaceAlpha',.2,'LineStyle','none');
hline = line(xline,yline);
set(hline,'color',color,'linewidth',3);


end






function gamma = eulerbackamp(lamt)
gamma = 1./(1-lamt);
end

function gamma = eulerforwardamp(lamt)
gamma = 1+lamt;
end

function gamma = rk2amp(lamt)
v1 = 1;
v2 = 1 + 0.5.*lamt.*v1;
gamma = 1+lamt.*v2;
end

function gamma = rk4amp(lamt)
v1 = 1;
v2 = 1 + 0.5.*lamt.*v1;
v3 = 1 + 0.5.*lamt.*v2;
v4 = 1 + lamt.*v3;
gamma = 1 + lamt.*(1/6*v1 + 1/3*v2 + 1/3*v3 + 1/6*v4);
end

function gamma = irk2amp(lamt)
A = [1/4, 1/4-sqrt(3)/6; 1/4+sqrt(3)/6, 1/4];
b = [1/2, 1/2];
c = [1/2-sqrt(3)/6, 1/2+sqrt(3)/6];
d = 1-lamt.*(A(1,1)+A(2,2))+lamt.^2.*(A(1,1)*A(2,2)-A(2,1)*A(1,2));
v1 = 1./d.*(1-lamt*A(2,2) + lamt*A(1,2));
v2 = 1./d.*(lamt*A(2,1) + 1 - lamt*A(1,1));
gamma = 1 + lamt.*(b(1)*v1 + b(2)*v2);
end

function gamma = cnamp(lamt)
gamma = (1+0.5*lamt)./(1-0.5*lamt);
end

function gamma = ab2amp(lamt)
a = 1;
b = -(1+1.5*lamt);
c = 0.5*lamt;
disc = b.^2 - 4.*a.*c;
r1 = 1/(2*a).*(-b+sqrt(disc));
r2 = 1/(2*a).*(-b-sqrt(disc));
gamma = max(abs(r1),abs(r2));
end

function gamma = ab3amp(lamt)
a = zeros(4,1);
b = zeros(4,1);
a(1) = 1;
a(2) = -1;
b(1) = 0;
b(2) = 23/12;
b(3) = -4/3;
b(4) = 5/12;
gamma = zeros(size(lamt));
for k1 = 1:size(lamt,1)
    for k2 = 1:size(lamt,2)
        p = a - b*lamt(k1,k2);
        R = roots(p);
        gamma(k1,k2) = max(abs(R));
    end
end
end


function gamma = am2amp(lamt)
a = 1-5/12*lamt;
b = -(1+2/3*lamt);
c = 1/12*lamt;
disc = b.^2 - 4.*a.*c;
r1 = 1./(2.*a).*(-b+sqrt(disc));
r2 = 1./(2.*a).*(-b-sqrt(disc));
gamma = max(abs(r1),abs(r2));
end

function gamma = bdf2amp(lamt)
a = 1-2/3*lamt;
b = -4/3;
c = 1/3;
disc = b.^2 - 4.*a.*c;
r1 = 1./(2.*a).*(-b+sqrt(disc));
r2 = 1./(2.*a).*(-b-sqrt(disc));
gamma = max(abs(r1),abs(r2));
end

function gamma = bdf3amp(lamt)
a = 1-6/11*lamt;
b = -18/11;
c = 9/11;
d = -2/11;

gamma = zeros(size(lamt));
for k1 = 1:size(lamt,1)
  for k2 = 1:size(lamt,2)
    R = roots([a(k1,k2),b,c,d]);
    gamma(k1,k2) = max(abs(R));
  end
end
end



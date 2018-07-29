function [z,a,it,ord,s,fct] = backcor(n,y,ord,s,fct)

% BACKCOR   Background estimation by minimizing a non-quadratic cost function.
%
%   [EST,COEFS,IT] = BACKCOR(N,Y,ORDER,THRESHOLD,FUNCTION) computes and estimation EST
%   of the background (aka. baseline) in a spectroscopic signal Y with wavelength N.
%   The background is estimated by a polynomial with order ORDER using a cost-function
%   FUNCTION with parameter THRESHOLD. FUNCTION can have the four following values:
%       'sh'  - symmetric Huber function :  f(x) = { x^2  if abs(x) < THRESHOLD,
%                                                  { 2*THRESHOLD*abs(x)-THRESHOLD^2  otherwise.
%       'ah'  - asymmetric Huber function :  f(x) = { x^2  if x < THRESHOLD,
%                                                   { 2*THRESHOLD*x-THRESHOLD^2  otherwise.
%       'stq' - symmetric truncated quadratic :  f(x) = { x^2  if abs(x) < THRESHOLD,
%                                                       { THRESHOLD^2  otherwise.
%       'atq' - asymmetric truncated quadratic :  f(x) = { x^2  if x < THRESHOLD,
%                                                        { THRESHOLD^2  otherwise.
%   COEFS returns the ORDER+1 vector of the estimated polynomial coefficients
%   (computed with n sorted and bounded in [-1,1] and y bounded in [0,1]).
%   IT returns the number of iterations.
%
%   [EST,COEFS,IT] = BACKCOR(N,Y) does the same, but run a graphical user interface
%   to help setting ORDER, THRESHOLD and FCT.
%
% For more informations, see:
% - V. Mazet, C. Carteret, D. Brie, J. Idier, B. Humbert. Chemom. Intell. Lab. Syst. 76 (2), 2005.
% - V. Mazet, D. Brie, J. Idier. Proceedings of EUSIPCO, pp. 305-308, 2004.
% - V. Mazet. PhD Thesis, University Henri Poincaré Nancy 1, 2005.
% 
% 22-June-2004, Revised 19-June-2006, Revised 30-April-2010,
% Revised 12-November-2012 (thanks E.H.M. Ferreira!)
% Comments and questions to: vincent.mazet@unistra.fr.


% Check arguments
if nargin < 2, error('backcor:NotEnoughInputArguments','Not enough input arguments'); end;
if nargin < 5, [z,a,it,ord,s,fct] = backcorgui(n,y); return; end; % delete this line if you do not need GUI
if ~isequal(fct,'sh') && ~isequal(fct,'ah') && ~isequal(fct,'stq') && ~isequal(fct,'atq'),
    error('backcor:UnknownFunction','Unknown function.');
end;

% Rescaling
N = length(n);
[n,i] = sort(n);
y = y(i);
maxy = max(y);
dely = (maxy-min(y))/2;
n = 2 * (n(:)-n(N)) / (n(N)-n(1)) + 1;
y = (y(:)-maxy)/dely + 1;

% Vandermonde matrix
p = 0:ord;
T = repmat(n,1,ord+1) .^ repmat(p,N,1);
Tinv = pinv(T'*T) * T';

% Initialisation (least-squares estimation)
a = Tinv*y;
z = T*a;

% Other variables
alpha = 0.99 * 1/2;     % Scale parameter alpha
it = 0;                 % Iteration number
zp = ones(N,1);         % Previous estimation

% LEGEND
while sum((z-zp).^2)/sum(zp.^2) > 1e-9,
    
    it = it + 1;        % Iteration number
    zp = z;             % Previous estimation
    res = y - z;        % Residual
    
    % Estimate d
    if isequal(fct,'sh'),
        d = (res*(2*alpha-1)) .* (abs(res)<s) + (-alpha*2*s-res) .* (res<=-s) + (alpha*2*s-res) .* (res>=s);
    elseif isequal(fct,'ah'),
        d = (res*(2*alpha-1)) .* (res<s) + (alpha*2*s-res) .* (res>=s);
    elseif isequal(fct,'stq'),
        d = (res*(2*alpha-1)) .* (abs(res)<s) - res .* (abs(res)>=s);
    elseif isequal(fct,'atq'),
        d = (res*(2*alpha-1)) .* (res<s) - res .* (res>=s);
    end;
    
    % Estimate z
    a = Tinv * (y+d);   % Polynomial coefficients a
    z = T*a;            % Polynomial
    
end;

% Rescaling
[~,j] = sort(i);
z = (z(j)-1)*dely + maxy;

    a(1) = a(1)-1;
    a = a*dely;% + maxy;

end

% delete lines below if you do not need GUI

function [z,a,it,ord,s,fct] = backcorgui(n,y)

% BACKCORGUI   Graphical User Interface for background estimation.

% Initialization
z = [];
a = [];
it = [];
ord = [];
s = [];
fct = [];

order = 4;
threshold = 0.01;
costfunction = 'atq';

% Main window
hwin = figure('Visible','off','Position',[0 0 750 400],'NumberTitle','off','Name','Background Correction',...
    'MenuBar','none','Toolbar','figure','Resize','on','ResizeFcn',{@WinResizeFcn});
bgclr = get(hwin,'Color');

% Axes
haxes = axes('Units','pixels');

% Buttons OK & Cancel
hok = uicontrol('Style','pushbutton','String','OK','Position',[600,40,80,25],'Callback',{@OKFcn},'BackgroundColor',bgclr); 
hcancel = uicontrol('Style','pushbutton','String','Cancel','Position',[510,40,80,25],'Callback',{@CancelFcn},'BackgroundColor',bgclr); 

% Cost functions menu
hfctlbl = uicontrol('Style','text','String','Cost function:','HorizontalAlignment','left','BackgroundColor',bgclr);
hfct = uicontrol('Style','popupmenu','Value',4,'BackgroundColor','white','Callback',{@CostFunctionFcn},...
    'String',{'Symmetric Huber function','Asymmetric Huber function','Symmetric truncated quadratic','Asymmetric truncated quadratic'});

% Threshold text
hthresholdlbl = uicontrol('Style','text','String','Threshold:','HorizontalAlignment','left','BackgroundColor',bgclr);
hthreshold = uicontrol('Style','edit','String',num2str(threshold),'BackgroundColor','white','Callback',{@ThresholdFcn});

% Order slider
horderlbl = uicontrol('Style','text','String','Polynomial order:','HorizontalAlignment','left','BackgroundColor',bgclr);
horder = uicontrol('Style','slider','SliderStep',[0.5 0.5],'Min',0,'Max',10,'Value',order,'SliderStep',[0.1 0.1],'Callback',{@OrderFcn});
horderval = uicontrol('Style','text','String',num2str(order),'BackgroundColor',bgclr);

% Move the GUI to the center of the screen
movegui(hwin,'center');

% Plot a first estimation
[ztmp,atmp,ittmp,order,threshold,costfunction] = compute(n,y,order,threshold,costfunction);

% Make the GUI visible
set(hwin,'Visible','on');

% Callback functions

    function CancelFcn(source,eventdata)
        % Just close the window
        uiresume(gcbf);
        close(hwin);
    end
  
    function OKFcn(source,eventdata)
        % Return the current estimation and close the window
        z = ztmp;
        a = atmp;
        it = ittmp;
        ord = order;
        s = threshold;
        fct = costfunction;
        uiresume(gcbf);
        close(hwin);
    end

    function CostFunctionFcn(source,eventdata)
        % Change cost function
        cf = get(hfct,'Value');
        if cf == 1,
            costfunction = 'sh';
        elseif cf == 2,
            costfunction = 'ah';
        elseif cf == 3,
            costfunction = 'stq';
        elseif cf == 4,
            costfunction = 'atq';
        end
        [ztmp,atmp,ittmp,ord,s,fct] = compute(n,y,order,threshold,costfunction);
    end

    function OrderFcn(source,eventdata)
        % Change order
        order = get(horder,'Value');
        set(horderval,'String',num2str(order));
        [ztmp,atmp,ittmp,ord,s,fct] = compute(n,y,order,threshold,costfunction);
    end

    function ThresholdFcn(source,eventdata)
        % Change threshold
        threshold = get(hthreshold,'String');
        threshold = str2double(threshold);
        [ztmp,atmp,ittmp,ord,s,fct] = compute(n,y,order,threshold,costfunction);
    end
  
    function [ztmp,atmp,ittmp,order,threshold,costfunction] = compute(n,y,order,threshold,costfunction)
        % Compute and plot an estimation (need to sort the data)
        [ztmp,atmp,ittmp,order,threshold,costfunction] = backcor(n,y,order,threshold,costfunction);
        [~,i] = sort(n);
        plot(n(i),y(i),'b-',n(i),ztmp(i),'r-');
    end

    function WinResizeFcn(source,eventdata)
        % Resize the window
        pos = get(hwin,'Position');
        w = pos(3);
        h = pos(4);
        if w>400 && h>100,
            set(haxes,'Position',[40,40,w-320,h-70]);
        end;
        set(hok,'Position',[w-90,30,80,25]);
        set(hcancel,'Position',[w-180,30,80,25]);
        set(hfctlbl,'Position',[w-240,h-30,220,20]);
        set(hfct,'Position',[w-240,h-50,220,25]);
        set(hthresholdlbl,'Position',[w-240,h-80,220,20]);
        set(hthreshold,'Position',[w-240,h-100,220,20]);
        set(horderlbl,'Position',[w-240,h-130,220,20]);
        set(horder,'Position',[w-210,h-150,190,20]);
        set(horderval,'Position',[w-240,h-150,20,20]);
    end

uiwait(gcf);

end
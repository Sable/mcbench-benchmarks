% line_fewer_markers - line with controlled amount of markers and correct legend behaviour
% 
%   LINE_FEWER_MARKERS(X,Y,NUM_MARKERS) adds the line in vectors X and Y to the current axes
%   with exactly NUM_MARKERS markers drawn.
% 
%   LINE_FEWER_MARKERS(X,Y,NUM_MARKERS,'PropertyName',PropertyValue,...) plots the data
%   stored in the vectors X and Y.
%
%   LINE_FEWER_MARKERS returns handles to LINE/MARKER objects.
% 
%   [H1,H2,H3] = LINE_FEWER_MARKERS(X,Y,NUM_MARKERS,'PropertyName',PropertyValue,...) 
%   performs the actions as above and returns the handles of all the plotted lines/markers.
%   H1    = handle to the main marker(1 point); it may be put in array and used with legend
%   H2    = handle to the continuous line (as in H2=plot())
%   H3    = handle to all other markers
%
%   Property/Value pairs and descriptions:
%       
%       Spacing    - 'x'      : ordinary uniform along x
%                  - 'curve'  : equal lengths along curve y(x)
% 
%       LockOnMax  - 0        : first marker on 1st data point
%                  - 1        : offset all markers such that one marker on first max of y(x)
% 
%       LegendLine - 'on'     : default, reproduce linestyle also in legend
%                  - 'off'    : shows only marker in legend
% 
%       LineSpec: same as for LINE: LineStyle,LineWidth,Marker,MarkerSize,MarkerFaceColor...
%
%
%   Example: plot 3 curves with 9,9, and 15 markers each, using different input styles
% 
%      figure; hold on;
%      t  = 0:0.005:pi;
%      line_fewer_markers(t*180/pi,cos(t) ,9,  '--bs','spacing','curve');
%      line_fewer_markers(t*180/pi,sin(t) ,9,  '-.ro','MarkerFaceColor','g', ...
%                                                     'markersize',6,'linewidth',2);
%      grey1 = [1 1 1]*0.5;
%      line_fewer_markers(t*180/pi,sin(t).*cos(t) ,15, ':','marker','h','color',grey1, ...
%                                    'markerfacecolor',grey1,'linewidth',2,'LockOnMax',1);
%      leg = legend('cos','sin','sin*cos','location','best');
%
% Inspired by Ioannis Filippidis's answer: 
% http://www.mathworks.com/matlabcentral/answers/2165-too-many-markers
% 
% rev.3, Massimo Ciacci, August 19, 2013
% 
function [H1,H2,H3] = line_fewer_markers(x,y,num_Markers, varargin)


%% find marker spec in varargin and remove it; extract special params: LockOnMax,Spacing
if mod(length(varargin),2)
    if ischar(varargin{1})
      linspec   = varargin{1};
      extraArgs = varargin(2:end);
      [varargInNoMk,varargInNoMkNoLn,lm,ms,mfc,LockOnMax,Spacing,LegendLine] = parseargsLineSpec(linspec,extraArgs);
    else
      error('odd sized [param | val] list, missing one param ?');
    end
else
      [varargInNoMk,varargInNoMkNoLn,lm,ms,mfc,LockOnMax,Spacing,LegendLine] = parseargs(varargin{:});  
end

%% input size check
if  isvector(x) &&  isvector(y)
    % make x,y row vectors
    if iscolumn(x), x = x.'; end
    if iscolumn(y), y = y.'; end
else
    error('line_fewer_markers: input arguments must be 1D vectors');
end

% How the method works: plots 3 times: 
% a) once only the line with all points with the style                                                'r--' and invisible handle, 
% b) last time the markers, using fewer points with style                                             'ro' and again invisible handle.
% c) once with a visible handle, only the first point, using the complete style you specified         (e.g. 'r--o')

%% a) once only the line with all points with the style                                                                
H2 = line(x   ,y   ,varargInNoMk{:});                               %no markers here
hasbehavior(H2,'legend',0);                                         %prevent to appear in legends!

%% b) last time the markers, using fewer points with style                                                             
if     (strcmp(Spacing,'x') || strcmp(Spacing,'X'))
    ti = round(linspace(1,length(x),num_Markers));
elseif (strcmp(Spacing,'curve') || strcmp(Spacing,'Curve'))
    scaleY     = 3/4; % 1/1 figure aspect ratio
    yNrm       = (y-min(y))./(max(y)-min(y))*scaleY;                %NORMALIZE y scale in [0 1], height of display is prop to max(abs(y))        
    xNrm       = (x-min(x))./(max(x)-min(x));                       %NORMALIZE x scale in [0 1]   
    
    if (sum(isinf(yNrm))>0) || sum(isinf(x))>0                      %spacing along curve not possible with infinites
        ti = round(linspace(1,length(x),num_Markers)); 
    else
        t        = 1:length(x);                                
        s        = [0 cumsum(sqrt(diff(xNrm).^2+diff(yNrm).^2))];   %measures length along the curve
        si       = (0:num_Markers-1)*s(end)/(num_Markers-1);        %equally spaced lengths along the curve
        si(end)  = s(end);                                          %fix last point to be within the curve                    
        ti       = round(interp1(s,t,si));                          %find x index of markers
    end
else
    error('invalid spacing parameter');
end
if LockOnMax
    %set one ti on max if found
    [Mv,idx]   = max(y); idx=idx(1);
    [mv,idxti] = min(abs(idx-ti));
    deltati    = ti(idxti)-idx;
    ti         = max(1,min(ti-deltati,length(y)));
end    
xi = x(ti);
yi = y(ti);           
H3 = line(xi,yi,varargInNoMkNoLn{:},'Marker',lm,'MarkerSize',ms,'MarkerFaceColor',mfc,'LineStyle','none');  %plot markers only
hasbehavior(H3,'legend',0); %prevent to appear in legends!

%% c) once with a visible handle, only the first point, using the complete style you specified                         
if strcmp(LegendLine,'on')
    H1 = line(xi(1),yi(1),varargInNoMk{:},'Marker',lm,'MarkerSize',ms,'MarkerFaceColor',mfc);
else
    H1 = line(xi(1),yi(1),varargInNoMk{:},'linestyle','none','Marker',lm,'MarkerSize',ms,'MarkerFaceColor',mfc);
end


%-------------------------------------------------------------
% PARSE FUNCTIONS
%-------------------------------------------------------------
% varargInNoMk = list of property pairs, marker specs removed 
% varargInNoMkNoLn = list of property pairs, marker specs and line specs removed 
function [varargInNoMk,varargInNoMkNoLn,lm,ms,mfc,LockOnMax,Spacing,LegendLine] = parseargs(varargin)
lm =[]; ms =[]; mfc=[]; LockOnMax=[]; Spacing=[]; LegendLine=[];
varargInNoMk = {};
varargInNoMkNoLn = {};
arg_index = 1;
while arg_index <= length(varargin)
	arg = varargin{arg_index};
    % extract special params and marker specs from arg list
    if strcmp(arg,'marker') || strcmp(arg,'Marker') || strcmp(arg,'Mk')  || strcmp(arg,'mk')
        lm              = varargin{arg_index+1};
    elseif strcmp(arg,'MarkerSize') || strcmp(arg,'markersize') || strcmp(arg,'Mks')  || strcmp(arg,'mks')
        ms              = varargin{arg_index+1};        
    elseif strcmp(arg,'MarkerFaceColor') || strcmp(arg,'markerfacecolor')||strcmp(arg,'MFC')||strcmp(arg,'mfc')
        mfc             = varargin{arg_index+1};
    elseif strcmp(arg,'LockOnMax') || strcmp(arg,'lockonmax')
        LockOnMax       = varargin{arg_index+1};
    elseif strcmp(arg,'Spacing')   || strcmp(arg,'spacing') 
        Spacing         = varargin{arg_index+1};
    elseif strcmp(arg,'LegendLine')   || strcmp(arg,'legendline') 
        LegendLine      = varargin{arg_index+1};
    else
        % keep other params in arg list for line command
        varargInNoMk    = {varargInNoMk{:},  varargin{arg_index},  varargin{arg_index+1}};
        if ~strcmp(arg,'LineStyle') && ~strcmp(arg,'linestyle') 
           % exclude line params for marker only plot
           varargInNoMkNoLn = {varargInNoMkNoLn{:},  varargin{arg_index},  varargin{arg_index+1}};
        end
    end
    arg_index = arg_index + 2;	
end
%EXTRA DEFAULTS ARE SET HERE
if isempty(lm),         lm          = 'o'   ; end
if isempty(ms),         ms          = 10    ; end
if isempty(mfc),        mfc         = 'none'; end
if isempty(LockOnMax),  LockOnMax   = 1     ; end
if isempty(Spacing),    Spacing     = 'x'   ; end %%'x' -> marker delta-x constant; 'curve' : spacing constant along the curve length
if isempty(LegendLine), LegendLine  = 'on'  ; end 

%-------------------------------------------------------------
% Parse LineSpec string and other arguments
% varargInNoMk     = list of property pairs, marker specs removed 
% varargInNoMkNoLn = list of property pairs, marker specs and line specs removed 
function [varargInNoMk,varargInNoMkNoLn,lm,ms,mfc,LockOnMax,Spacing,LegendLine] = parseargsLineSpec(linspec, extraArgs)
%          b     blue          .     point              -     solid
%          g     green         o     circle             :     dotted
%          r     red           x     x-mark             -.    dashdot 
%          c     cyan          +     plus               --    dashed   
%          m     magenta       *     star             (none)  no line
%          y     yellow        s     square
%          k     black         d     diamond
%          w     white         v     triangle (down)
%                              ^     triangle (up)
%                              <     triangle (left)
%                              >     triangle (right)
%                              p     pentagram
%                              h     hexagram
varargInNoMk     = {};
varargInNoMkNoLn = {};

foundLine           = false;
stringSearch        = {'-.','--','-',':'};
for ii=1:4
    if strfind(linspec, stringSearch{ii})
        foundLine   = true;
        ls          = stringSearch{ii};
        linspec     = setdiff(linspec,ls);
        break
    end
end
if foundLine
    varargInNoMk    = {varargInNoMk{:},'lineStyle',ls};
else
    varargInNoMk    = {varargInNoMk{:},'lineStyle','-'};    
end

if ~isempty(linspec)
    foundCol            = false;
    stringSearch        = {'b','g','r','c','m','y','k','w'};
    for ii=1:8
        if strfind(linspec, stringSearch{ii})
            foundCol    = true;
            colspec     = stringSearch{ii};
            linspec     = setdiff(linspec,colspec);
            break
        end
    end
    if foundCol
        varargInNoMk    = {varargInNoMk{:},'color',colspec};
        varargInNoMkNoLn    = {varargInNoMkNoLn{:},'color',colspec};
    end    
end

if ~isempty(linspec)
    foundMk             = false;
    stringSearch        = {'.','o','x','+','*','s','d','v','^','<','>','p','h'};
    for ii=1:13
        if strfind(linspec, stringSearch{ii})
            foundMk     = true;
            mkspec      = stringSearch{ii};
            break
        end
    end
    if foundMk, lm = mkspec; else lm = 'none'; end
else
    lm = 'none';
end


[extraArgs1,unused,lm2,ms,mfc,LockOnMax,Spacing,LegendLine] = parseargs(extraArgs{:});
if strcmp(lm,'none') && ~strcmp(lm2,'none') %if other marker specified in Property Pairs take that one
    lm = lm2;
end
varargInNoMk       = {varargInNoMk{:},extraArgs1{:}};
varargInNoMkNoLn   = {varargInNoMkNoLn{:},extraArgs1{:}};


function varargout = doubleintegral(fun, domain, param, verbose, makefigure)
% DOUBLEINTEGRAL  Numerical integration of f(x,y).
% The intention is to make a more flexible and more general function than
% the Matlab function dblquad. Especially the domain may be given in a more
% general way, it may be a circle, a rectangle, or any convex polygon.
% Also different methods may be used.
%
%   Q = DOUBLEINTEGRAL(FUN, DOMAIN, PARAM) 
%   FUN is (normally) a function handle. When method is 'dblquad' the 
%   function Z=FUN(X,Y) should accept a vector X and a scalar Y and return 
%   a vector Z of values as Matlab's 'dblquad'.
%   For other methods the function just need to handle single element
%   arguments. The function may accept matrix, and vector, arguments of the
%   same size and return a matrix also with this size, such that
%   Z(i) = FUN(X(i),Y(i)). The function will be used this way if parameter 
%   'matrixarg' is also included in the PARAM struct and set to true. 
%   Default is false, and used if 'matrixarg' is not a field in PARAM.
%   If FUN == 1, then area of domain is returned.
% 
%   DOMAIN is a struct where the field 'type' gives how the domain is 
%   given. Examples:
%     domain = struct('type','circle','xc',0,'yc',0,'radius',1);
%     domain = struct('type','sector','th1',-pi,'th2',pi,'r1',0,'r2',1,'xc',0,'yc',0);
%     domain = struct('type','box','x1',-1,'x2',1,'y1',-1,'y2',1);
%     domain = struct('type','area','x1',-1,'x2',1,'y1',@(x) sqrt(x),'y2',@(x) x.^2);
%     domain = struct('type','polygon','x',[0,2,2,1,0],'y',[0,0,1,2,1]);
%
%   PARAM is a struct where the field 'method' always must be included.
%   It gives the method used, often in both x and y direction.
%   Examples for Matlab quad, i.e. dblquad, fuction with argument tol, 
%   Gauss Quadrature method and Clenshaw-Curtis method:
%     param = struct('method','dblquad','tol',1e-6);
%     param = struct('method','gauss','points',6);
%     param = struct('method','cc','points',10);
%     param.matrixarg = true;     % use vector-arguments in fun
%
%   Q = DOUBLEINTEGRAL(FUN, DOMAIN, PARAM, verbose, makefigure) 
%   verbose = 0 (display only errors), 1 (+ if arguments are overruled), 2
%   (+ results), 3 (+ some status information), 4 (+ some debugging info)
%   makefigure = 0 (default) for no figure, 1 for domain, 5 for contour of
%   function in domain.
%
%  Examples: 
%   fun = @(x,y) y*sin(x)+x*cos(y);
%   domain = struct('type','box','x1',pi,'x2',2*pi,'y1',0,'y2',pi);
%   param = struct('method','dblquad','tol',1e-6);
%   Q = doubleintegral(fun, domain, param);     % -pi^2
%
%   fun = @(x,y) y.*sin(x)+x.*cos(y); % allows vectors in both x and y
%   domain = struct('type','box','x1',pi,'x2',2*pi,'y1',0,'y2',pi);
%   param = struct('method','gauss','points',6,'matrixarg',true);
%   Q = doubleintegral(fun, domain, param, 3, 5);     % -pi^2
%
%   fun = 1;  % Area is one dimensional integral of f(x) = abs(y2(x)-y1(x))
%   domain = struct('type','area','x1',0,'x2',1,'y1',@(x) x.^2,'y2',@(x) sqrt(x));
%   param = struct('method','cc','points',12);
%   Q = doubleintegral(fun, domain, param);    % 1/3
% 
%   fun = @(x,y) sqrt(max(zeros(size(x)), 1-x.^2-y.^2));  % unit sphere
%   domain = struct('type','circle','xc',0,'yc',0,'radius',1);
%   param = struct('method','gauss','points',25,'matrixarg',true);
%   Q = doubleintegral(fun, domain, param);    % 2*pi/3
%   % an alternative is to use dblquad, domain may be a circle or a box.
%   domain = struct('type','box','x1',-1,'x2',1,'y1',-1,'y2',1);
%   param = struct('method','dblquad','tol',1e-6); 
%   % or polygon to find just a sector 
%   domain = struct('type','polygon','x',[0,1,1],'y',[0,0,1]);
%   Q = doubleintegral(fun, domain, param);    % pi/12
%   % or grid of points in sector. Note still fun = @(x,y) 
%   domain = struct('type','sector','th1',0,'th2',pi/4,'r1',0,'r2',1,'xc',0,'yc',0);
%   param = struct('method','dblquad','tol',1e-6);
%   Q = doubleintegral(fun, domain, param);    % pi/12
% 
%   see also dblquad.
%
% Author: Karl Skretting, University of Stavanger 
% Email: karl.skretting@uis.no
% Release: 1.0, January 28, 2009.

% Additional documentation on the methods:
% a paper by Trefethen: "Is Gauss Quadrature better than Clenshaw-Curtis?"
% 
% More methods may be included, the m-file mygaussq (Johan Helsing, Lund)
% at http://www.maths.lth.se/~helsing/mygaussq.txt  (January 21. 2009)
% include a modification of the Netlib program gaussq.f. 
% It gives other kinds of Gauss-quadrature points and weights.

% TO BE DONE
% * FUN, DOMAIN or PARAM may be cell arrays. Then this function returns
%   several integrals in a column vector, matrix or threedimensional array.
% * Integration along a line ??, (symb/diff.m to differentiate char(y2))
% * When domain is circle, perhaps the formulas im Abramowitz and Stengun
%   section 25.4.61 could be used.

mfile = 'doubleintegral';

% Process Inputs and Initialize Defaults
if (nargin < 5)
    makefigure = 0;  % do no make any figure
    % makefigure = 10;  % make figure(1) which plots domain and contour
end
if (nargin < 4)
    % verbose = 0;   % display only error
    verbose = 1;    % display error and important messages 
    % verbose = 2;   % display some results too
    % verbose = 3;   % also display information on program state
    % verbose = 4;   % debugging information too
end
if (nargin < 3)
    disp([mfile,': 3 arguments must be given, see help.']);
    return;
end

if (makefigure > 0)
    % prepare for figure of domain
    figure(1);clf;hold on;
end

%  *********** check FUN
if (~strcmp(class(fun), 'function_handle'))
    if (fun == 1)
        onlyAreaOfDomain = true;
    else
        disp([mfile,': fun was not a function handle.']);
        return
    end
else
    onlyAreaOfDomain = false;
end
FUNC = fun;

% *********** check PARAM
if (~isstruct(param))
    disp([mfile,': param was not a struct, see help.']);
    return
end
if ~(isfield(param,'method'))
    disp([mfile,': a method was not given in param, see help.']);
    return
end
if (sum(strcmpi(param.method,{'dblquad','gauss','cc'})) ~= 1)
    if strcmpi(param.method(1),'d'); param.method = 'dblquad';
    elseif strcmpi(param.method(1),'q'); param.method = 'dblquad';
    elseif strcmpi(param.method(1),'g'); param.method = 'gauss';
    elseif strcmpi(param.method(1),'c'); param.method = 'cc';
    else
        disp([mfile,': the method was a valid one, see help.']);
        return
    end
    if (verbose >= 1)
        disp([mfile,': method is set to : ',param.method]);
    end
end
% set parameters to default or supplied
if (isfield(param,'tol') && isnumeric(param.tol))
    tol = param.tol(1);
else
    if (verbose >= 4)
        disp([mfile,': param.tol is set to default value: 1e-6.']);
    end
    tol = 1e-6;
end
if (isfield(param,'points') && isnumeric(param.points))
    points = param.points(1);
else
    if (verbose >= 4)
        disp([mfile,': param.points is set to default value: 6.']);
    end
    points = 6;
end
if isfield(param,'matrixarg');
    if islogical(param.matrixarg)
        matrixarg = param.matrixarg(1); 
    elseif isnumeric(param.matrixarg)
        matrixarg = (param.matrixarg(1) ~= 0); 
    else
        if (verbose >= 1)   % it was given, but not correct
            disp([mfile,': param.matrixarg is set to default value: false.']);
        end
        matrixarg = false; 
    end
else
    if (verbose >= 4)   % default value was probably intended
        disp([mfile,': param.matrixarg is set to default value: false.']);
    end
    matrixarg = false; 
end
% parameters not yet included in the param struct, set default values
domainTransformedToBox = false;  % for domain sector

% *********** check DOMAIN
if (~isstruct(domain))
    disp([mfile,': domain was not a struct, see help.']);
    return
end
%
% ex:  domain = struct('type','box','x1',0,'x2',1,'y1',0,'y2',1);
if  strcmpi(domain.type,'box') 
    xsegments = [-1, 1];
    if (isfield(domain,'x1') && isnumeric(domain.x1))
        xsegments(1) = domain.x1(1); 
    end
    if (isfield(domain,'x2') && isnumeric(domain.x2))
        xsegments(2) = domain.x2(1); 
    end
    if (isfield(domain,'y1') && isnumeric(domain.y1))
        y1 = domain.y1(1); 
    else
        y1 = -1; 
    end
    if (isfield(domain,'y2') && isnumeric(domain.y2))
        y2 = domain.y2(1); 
    else
        y2 = 1; 
    end
    if (verbose >= 3)   % display domain
        disp([mfile,': domain is a box where lower left is (',...
            num2str(xsegments(1)),',',num2str(y1),') and upper right is (',...
            num2str(xsegments(2)),',',num2str(y2),').']);
    end
    if onlyAreaOfDomain
        totalQ = (xsegments(2)-xsegments(1))*(y2-y1);
    end
    if (makefigure > 0)
        plot(xsegments([1,2,2,1,1]),[y1,y1,y2,y2,y1],'b-');
        xInFig = (xsegments(1)+xsegments(2))/2;
        yInFig = (y1+y2)/2;
    end
end
% 
% ex:  domain = struct('type','circle','xc',0,'yc',0,'radius',1);
if  strcmpi(domain.type,'circle')
    if (isfield(domain,'radius') && isnumeric(domain.radius))
        radius = domain.radius(1); 
    else
        radius = 1; 
    end
    if (isfield(domain,'xc') && isnumeric(domain.xc))
        xc = domain.xc(1); 
    else
        xc = 0; 
    end
    if (isfield(domain,'yc') && isnumeric(domain.yc))
        yc = domain.yc(1); 
    else
        yc = 0; 
    end
    if (verbose >= 3)   % display domain
        disp([mfile,': domain is a circle with center in (',...
            num2str(xc),',',num2str(yc),') and radius is ',num2str(radius),'.']);
    end
    if strcmpi(param.method,'dblquad')    % transform to polar coordinates
        FUNC = @(th,r) r.*(fun(xc + r.*cos(th), yc + r.*sin(th)));
        xsegments = [-pi, pi];
        y1 = 0;
        y2 = radius;
        domainTransformedToBox = true;  
    else
        xsegments = [xc-radius, xc+radius];
        y1 = @(x) yc - sqrt(max(zeros(size(x)),radius^2 -(xc+x).^2));
        y2 = @(x) yc + sqrt(max(zeros(size(x)),radius^2 -(xc+x).^2));
    end
    if onlyAreaOfDomain
        totalQ = pi*radius^2;
    end
    if (makefigure > 0)
        x = xc + radius*cos(linspace(-pi,pi,120));
        y = yc + radius*sin(linspace(-pi,pi,120));
        plot(x,y,'b-');
        xInFig = xc;
        yInFig = yc;
    end
end
%
% ex:  domain = struct('type','sector','th1',-pi,'th2',pi,'r1',0,'r2',1,'xc',0,'yc',0);
if  strcmpi(domain.type,'sector')
    if (isfield(domain,'xc') && isnumeric(domain.xc))
        xc = domain.xc(1); 
    else
        xc = 0; 
    end
    if (isfield(domain,'yc') && isnumeric(domain.yc))
        yc = domain.yc(1); 
    else
        yc = 0; 
    end
    if (isfield(domain,'th1') && isnumeric(domain.th1))
        th1 = domain.th1(1); 
    else
        th1 = -pi; 
    end
    if (isfield(domain,'th2') && isnumeric(domain.th2))
        th2 = domain.th2(1); 
    else
        th2 = pi; 
    end
    if (isfield(domain,'r1') && isnumeric(domain.r1))
        r1 = max(0,domain.r1(1)); 
    else
        r1 = 0; 
    end
    if (isfield(domain,'r2') && isnumeric(domain.r2))
        r2 = max(0,domain.r2(1)); 
    else
        r2 = 1; 
    end
    if (verbose >= 3)   % display domain
        disp([mfile,': domain is a sector with center in (',...
            num2str(xc),',',num2str(yc),') and angle from ',...
            num2str(th1),' to ',num2str(th2),' and radius from ',...
            num2str(r1),' to ',num2str(r2),'.']);
    end
    % redefine the function 
    FUNC = @(th,r) r.*(fun(xc + r.*cos(th), yc + r.*sin(th)));
    xsegments = [th1, th2];
    y1 = r1;
    y2 = r2;
    domainTransformedToBox = true;  
    if onlyAreaOfDomain
        totalQ = ((th2-th1)/2)*(r2^2-r1^2);
    end
    if (makefigure > 0)
        x = xc + [r1*cos(linspace(th1,th2,120)),r2*cos(linspace(th2,th1,120)),r1*cos(th1)];
        y = yc + [r1*sin(linspace(th1,th2,120)),r2*sin(linspace(th2,th1,120)),r1*sin(th1)];
        plot(x,y,'b-');
        xInFig = xc+((r1+r2)/2)*cos((th1+th2)/2);
        yInFig = yc+((r1+r2)/2)*sin((th1+th2)/2);
    end
end
%
% ex:  domain = struct('type','area','x1',0,'x2',1,'y1',@(x) sqrt(x),'y2',@(x) x.^2);
if  strcmpi(domain.type,'area')
    xsegments = [-1, 1];
    if (isfield(domain,'x1') && isnumeric(domain.x1))
        xsegments(1) = domain.x1(1); 
    end
    if (isfield(domain,'x2') && isnumeric(domain.x2))
        xsegments(2) = domain.x2(1); 
    end
    % check that y1 and y2 are functions or a single value (constant)
    if (isfield(domain,'y1') && isnumeric(domain.y1))
        y1 = domain.y1(1); 
    elseif (isfield(domain,'y1') && strcmp(class(domain.y1), 'function_handle'))
        y1 = domain.y1;
    else
        y1 = -1; 
    end
    if (isfield(domain,'y2') && isnumeric(domain.y2))
        y2 = domain.y2(1); 
    elseif (isfield(domain,'y2') && strcmp(class(domain.y2), 'function_handle'))
        y2 = domain.y2;
    else
        y2 = 1; 
    end
    if (verbose >= 3)   % display domain
        if strcmp(class(domain.y1), 'function_handle'); t1=char(y1); else t1=num2str(y1); end;
        if strcmp(class(domain.y2), 'function_handle'); t2=char(y2); else t2=num2str(y2); end;
        disp([mfile,': domain is an area with x from ',...
            num2str(xsegments(1)),' to ',num2str(xsegments(2)),'.']);
        disp(['Lower limit of y is given by : ',t1]);
        disp(['Upper limit of y is given by : ',t2]);
    end
    if onlyAreaOfDomain
        fx = @(x) abs(y2(x)-y1(x));
        if strcmpi(param.method,'dblquad')    % but we use quad i 1D
            totalQ = quad(fx, xsegments(1), xsegments(2), tol);
        end
        if strcmpi(param.method,'gauss')  %  Gauss Quadrature
            totalQ = quadGauss(fx, xsegments(1), xsegments(2), points, false);
        end
        if strcmpi(param.method,'cc')  %  Clenshaw-Curtis method
            totalQ = quadCC(fx, xsegments(1), xsegments(2), points, false);
        end
    end
    if (makefigure > 0)
        x = [linspace(xsegments(1), xsegments(2), 120),...
            linspace(xsegments(2), xsegments(1), 120), xsegments(1)];
        y = [y1(x(1:120)),y2(x(121:240)),y1(x(1))];
        plot(x,y,'b-');
        xInFig = (xsegments(1)+xsegments(2))/2;
        yInFig = (y1(xInFig)+y2(xInFig))/2;
    end
end
%
% ex: domain = struct('type','polygon','x',[0,2,2,1,0],'y',[0,0,1,2,1]);
if  strcmpi(domain.type,'polygon')
    if (~isfield(domain,'x') || ~isnumeric(domain.x)); 
        disp([mfile,': argument domain should have numeric field x, see help.']);
        return
    end
    if (~isfield(domain,'y') || ~isnumeric(domain.y)); 
        disp([mfile,': argument domain should have numeric field y, see help.']);
        return
    end
    x = domain.x;
    y = domain.y;
    if ((numel(x) < 3) || (numel(x) ~= numel(y))) 
        disp([mfile,': wrong size of domain.x or domain.y, see help.']);
        return
    end
    x = reshape(x,1,numel(x));   % row vector
    y = reshape(y,1,numel(y));   % row vector
    [top,bot] = ordnepolygon([x;y]);      % find bottum and top lines
    % do integration in several segments.
    xsegments = sort([bot(1,:),top(1,2:(end-1))]);
    y1 = @(x) interp1(bot(1,:),bot(2,:),x);   % default is 'linear'
    y2 = @(x) interp1(top(1,:),top(2,:),x);   % interpolation
    if (verbose >= 3)   % display domain
        t1 = [' (',num2str(bot(1,1)),',',num2str(bot(2,1)),')'];
        for i=2:size(bot,2)
            t1 = [t1,', (',num2str(bot(1,i)),',',num2str(bot(2,i)),')'];
        end
        t2 = [' (',num2str(top(1,1)),',',num2str(top(2,1)),')'];
        for i=2:size(top,2)
            t2 = [t2,', (',num2str(top(1,i)),',',num2str(top(2,i)),')'];
        end
        disp([mfile,': domain is a polygon with x from ',...
            num2str(xsegments(1)),' to ',num2str(xsegments(end)),'.']);
        disp(['Lower line is given by points:',t1]);
        disp(['Upper line is given by points:',t2]);
    end
    if onlyAreaOfDomain
        totalQ = 0;
        for seg = 1:(numel(xsegments)-1)
            x1 = xsegments(seg);
            x2 = xsegments(seg+1);
            totalQ = totalQ + (x2-x1)*(y2(x1)-y1(x1)+y2(x2)-y1(x2))/2;
        end
    end
    if (makefigure > 0)
        x = [bot(1,:),fliplr(top(1,:)),bot(1,1)];
        y = [bot(2,:),fliplr(top(2,:)),bot(2,1)];
        plot(x,y,'b-');
        xInFig = (bot(1,1)+bot(1,end))/2;
        yInFig = (y1(xInFig)+y2(xInFig))/2;
    end
end

if onlyAreaOfDomain
    if (verbose >= 2)   % display area
        disp([mfile,': Area of  domain is ',num2str(totalQ),'.']);
    end
else   
    %  do integration,
    totalQ = 0;
    xrange = xsegments(end)-xsegments(1);
    limrange = (0.1/points)*xrange;
    for seg = 1:(numel(xsegments)-1)
        x1 = xsegments(seg);
        x2 = xsegments(seg+1);
        %
        range = x2-x1;
        if (range < limrange)
            segpoints = 1;
        elseif (4*range < limrange)
            segpoints = min(2,points);
        elseif (10*range < limrange)
            segpoints = min(4,points);
        else
            segpoints = points;
        end
        %
        if strcmpi(param.method,'dblquad')    % Matlab dblquad
            matrixarg = true;
            if  (strcmpi(domain.type,'box') || domainTransformedToBox)
                q = dblquad(FUNC, x1, x2, y1, y2, tol);
            else
                disp([mfile,': dblquad can not be used with this domain.']);
                q = 0;
            end
        end
        if strcmpi(param.method,'gauss')  %  Gauss Quadrature
            [xG,wG] = getGxw(segpoints);
            yG = zeros(size(xG));             % and integral at these ponts
            for i=1:numel(xG)
                xx = 0.5*(x2-x1)*xG(i)+0.5*(x1+x2);
                % note, fy sends two vectors to fun!
                fy = @(y) FUNC(xx*ones(numel(y),1),y(:));
                [aa,bb] = getylimits(y1,y2,xx);
                yG(i) = quadGauss(fy, aa, bb, points, matrixarg);
            end
            q = 0.5*(x2-x1)*(wG*yG);                   % the integral
        end
        if strcmpi(param.method,'cc')   % Clenshaw-Curtis method
            n = max(segpoints-1,2);
            xC = cos(pi*(0:n)'/n);                  % Chebyshev points
            fx = zeros(size(xC)); % the integral along y for these points
            for i=1:numel(xC)
                xx = 0.5*(x2-x1)*xC(i)+0.5*(x1+x2);
                fy = @(y) FUNC(xx*ones(numel(y),1),y(:));
                [aa,bb] = getylimits(y1,y2,xx);
                fx(i) = quadCC(fy, aa, bb, points, matrixarg);
            end
            fx = fx/(2*n);                         % normalized for FFT ?
            g = real(fft(fx([1:(n+1), n:(-1):2]))); % FFT
            c = [g(1); g(2:n)+g(2*n:(-1):(n+2)); g(n+1)]; % Chebyshev coefficients
            w = 0*c';
            w(1:2:end) = 2./(1-(0:2:n).^2);
            q = 0.5*(x2-x1)*(w*c);                   % the integral
        end
        %
        totalQ = totalQ + q;
    end
    if (verbose >= 2)   % display result
        disp([mfile,': Integral of  ',char(fun),'  over domain is ',num2str(totalQ),'.']);
    end
end

if (makefigure > 0)
    V = axis();
    V = [1.1*V(1)-0.1*V(2),1.1*V(2)-0.1*V(1),1.1*V(3)-0.1*V(4),1.1*V(4)-0.1*V(3)];
    axis(V);
    axis equal;
    V = axis();
    tit = [mfile,': domain of integration, ',datestr(now())];
    if (~onlyAreaOfDomain && (makefigure >= 5))  
        % also try to put contourplot into the figure
        x = linspace(V(1),V(2),75);
        y = linspace(V(3),V(4),60);
        X = ones(numel(y),1)*x;
        Y = y'*ones(1,numel(x));
        % some functions may not like matrix arguments
        %     Z = FUNC(X,Y);
        % so we evaluate the function the safe way
        Z = zeros(numel(y),numel(x));
        for i=1:numel(y)
            for j=1:numel(x)
                Z(i,j) = fun(x(j),y(i));
            end
        end
        [cs,h] = contour(X,Y,Z);
        clabel(cs,h,'fontsize',10,'rotation',0)
        tit = char(tit,['Also contour plot of function : ',char(fun)]);
    end
    title(tit);
    if onlyAreaOfDomain
        h = text(xInFig,yInFig,['A = ',num2str(totalQ)]);
    else
        h = text(xInFig,yInFig,['I = ',num2str(totalQ)]);
    end
    set(h,'HorizontalAlignment','center');
    set(h,'FontSize',14); 
    set(h,'BackgroundColor',[1,1,1]);
end

% Return Outputs
if nargout
    varargout{1} = totalQ;
end

return

% *************************************************************************
% *************************************************************************

% ********* subfunction for 1-D integration, quadCC ***********
function I = quadCC(f,a,b,n,matrixarg)
n = n-1;
x = cos(pi*(0:n)'/n);                  % Chebyshev points
if matrixarg
    fx = feval(f, 0.5*(b-a)*x+0.5*(b+a) ); % the function values
    fx = reshape(fx,numel(x),1);
else
    fx = zeros(size(x));
    for i=1:numel(fx)
        fx(i) = feval(f, 0.5*(b-a)*x(i)+0.5*(b+a) ); % the function values
    end
end
fx = fx/(2*n);                         % normalized for FFT ?
g = real(fft(fx([1:(n+1), n:(-1):2]))); % FFT
c = [g(1); g(2:n)+g(2*n:(-1):(n+2)); g(n+1)]; % Chebyshev coefficients
w = 0*c';
w(1:2:end) = 2./(1-(0:2:n).^2);
I = 0.5*(b-a)*(w*c);                   % the integral
return

% ********* subfunction for 1-D integration, quadGauss ***********
function I = quadGauss(f,a,b,n,matrixarg)
[x,w] = getGxw(n);
if matrixarg
    y = feval(f, 0.5*(b-a)*x+0.5*(b+a) );  % the function values
    y = reshape(y,numel(x),1);
else
    y = zeros(size(x));             % a column vector
    for i=1:numel(y)
        y(i) = feval(f, 0.5*(b-a)*x(i)+0.5*(b+a) );  % the function values
    end
end
I = 0.5*(b-a)*(w*y);                   % the integral
return

% ********* subfunction getGxw ***********
function [x,w] = getGxw(n)
if (n==1)
    x = 0;
    w = 2;
elseif (n==2)
    x = [-0.577350269189626; 0.577350269189626];
    w = [1,1];
elseif (n==3)
    x = [-0.774596669241484; 0; 0.774596669241483];
    w = [5,8,5]/9;
elseif (n==4)
    x = [0.339981043584856; 0.861136311594053];
    x = [flipud(-x); x];
    w = [0.347854845137454, 0.652145154862546];
    w = [w, fliplr(w)];
elseif (n==5)
    x = [ 0.538469310105683; 0.906179845938664 ];
    x = [flipud(-x); 0; x];
    w = [0.236926885056189, 0.478628670499367];
    w = [w, 0.568888888888889, fliplr(w)];
elseif (n==6)
    x = [0.238619186083197; 0.661209386466264; 0.932469514203152];
    x = [flipud(-x); x];
    w = [0.171324492379171, 0.360761573048139, 0.467913934572690];
    w = [w, fliplr(w)];
elseif (n==7)
    x = [0.405845151377397; 0.741531185599395; 0.949107912342758];
    x = [flipud(-x); 0; x];
    w = [0.129484966168870, 0.279705391489277, 0.381830050505119];
    w = [w, 0.417959183673469, fliplr(w)];
elseif (n==8)
    x = [0.183434642495650; 0.525532409916329; 0.796666477413627; 0.960289856497536];
    x = [flipud(-x); x];
    w = [0.101228536290376   0.222381034453375   0.313706645877887   0.362683783378363];
    w = [w, fliplr(w)];
else
    beta = 0.5./sqrt(1-(2*(1:(n-1))).^(-2));   % 3-term recurrence coeffs
    T = diag(beta,1) + diag(beta,-1);      % Jacobi matrix
    [V,D] = eig(T);                        % eigenvalue decomposition
    x = diag(D); [x,i] = sort(x);          % nodes (= Legendre points)
    w = 2*V(1,i).^2;                       % weights
end
x = reshape(x,numel(x),1);     % a column vector
w = reshape(w,1,numel(w));     % a row vector
return

% ********* subfunction getylimits ***********
function  [c,d] = getylimits(y1,y2,x)
if strcmp(class(y1), 'function_handle')
    c = y1(x);
else
    c = y1;
end
if strcmp(class(y2), 'function_handle')
    d = y2(x);
else
    d = y2;
end
return

% ********* subfunction ordnepolygon ***********
function [topp,bunn] = ordnepolygon(punkt)
% The points, i.e. [x ; y], for the polygon may be in any order.
% This function sorts them and finds points in bottom and top lines.
% 
mp = mean(punkt,2);  % center point
ang = atan2(punkt(2,:)-mp(2),punkt(1,:)-mp(1));  % angle for line from point to center
[temp, I] = sort(ang);   
[temp, Imin] = min(punkt(1,I));   
if (Imin ~= 1)  % should have, Imin == 1
    I = [I(Imin:end),I(1:(Imin-1))];
end
punkt = punkt(:,[I,I(1)]);   % change order of points
[temp,imax] = max(punkt(1,:)); 
bunn = punkt(:,1:imax);
topp = punkt(:,size(punkt,2):(-1):imax);
% Now: bunn(:,1) == topp(:,1) and bunn(:,end) == topp(:,end)
% some small changes may be done to the polygon when some almost vertical
% lines ar in the beginning or end of top or bottom line.
% The changes should not change the area of the polygon!
tol = 1e-8;
while ((bunn(1,1)+tol) > bunn(1,2))
    dx = (bunn(1,2)-bunn(1,1))/2; 
    bunn = [[bunn(1,1)+dx; bunn(2,2)],bunn(:,3:end)];  % one point less
    topp(1,1:2) = topp(1,1:2) + [dx,-dx];
end
while ((bunn(1,end)-tol) < bunn(1,(end-1)))
    dx = (bunn(1,end)-bunn(1,end-1))/2; 
    bunn = [bunn(:,1:(end-2)),[bunn(1,end)-dx; bunn(2,end-1)]];
    topp(1,(end-1):end) = topp(1,(end-1):end) + [dx,-dx];
end
while ((topp(1,1)+tol) > topp(1,2))
    dx = (topp(1,2)-topp(1,1))/2; 
    topp = [[topp(1,1)+dx; topp(2,2)],topp(:,3:end)];  % one point less
    bunn(1,1:2) = bunn(1,1:2) + [dx,-dx];
end
while ((topp(1,end)-tol) < topp(1,(end-1)))
    dx = (topp(1,end)-topp(1,end-1))/2; 
    topp = [topp(:,1:(end-2)),[topp(1,end)-dx; topp(2,end-1)]];
    bunn(1,(end-1):end) = bunn(1,(end-1):end) + [dx,-dx];
end
% make sure that:  bunn(1,1) == topp(1,1) and bunn(1,end) == topp(1,end)
bunn(1,1) = topp(1,1);
bunn(1,end) = topp(1,end);
% the next is probably not needed
% extend top and bottom lines to avoid NaN just outside limits
% bunn = [[bunn(1,1)-1; bunn(2,1)],bunn,[bunn(1,end)+1; bunn(1,2)]];
% topp = [[topp(1,1)-1; topp(2,1)],topp,[topp(1,end)+1; topp(1,2)]];
return


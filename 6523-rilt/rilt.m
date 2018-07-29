function [g,yfit,cfg] = rilt(t,y,s,g0,alpha,varargin)
%     rilt   Regularized Inverse Laplace Transform
% 
% [g,yfit,cfg] = rilt(t,y,s,g0,alpha)
% 
% Array g(s) is the Inverse Laplace Transform of the array y(t),
% calculated by a regularized least squares method. This script is
% an emulation of S. Provencher CONTIN program, written in Fortran.
% See http://s-provencher.com/pages/contin.shtml.
% 
% y: data array, a function of the array t (for example: time).
% s: the s space, defined by the user.
% g0: the guess distribution, defined by the user.
% 
% yfit is the Laplace Transform of g and is fitted
% against y at each step of calculation.
% 
% cfg is a structure containing the parameters of the calculation.
% 
% alpha: the regularization parameter (see CONTIN manual,
% by S. Provencher: http://s-provencher.com/pages/contin.shtml,
% Section 3.2.2).
% In this script the second derivative of g is minimized with
% weight alpha^2 ("principle of parsimony"): hor high alpha
% values, the output g distribution will be smooth and
% regular. For alpha==0, the output g distribution will
% be totally 'free'.
% 
% TIP: Start with a g0(s) at low resolution (for example, 10
% points), and obtain a g. Then define an s-space at higher
% resolution and create a corrispondent g0 by interpolating the
% g, for example:
%   g0 = interp1(old_s,g,new_s,'linear');
% Finally repeat the rilt algorithm starting with the new g0.
% 
% REMARKS
% The Inverse Laplace Trasform is a highly ill-posed problem and 
% is therefore intrinsically affected by numerical instability, i.e.
% its solution may not be unique, may not exist or may not depend
% continuously on the data. The g calculated by rilt.m is only
% one of the possible solutions, and this limit is unavoidable.
% Changing the parameters, the solution may change too.
% 
% [...] = rilt(t,y,s,g0,alpha,plot_type,maxsearch,options,shape,constraints,R,w)
% 
% plot_type: defines how to plot the data during the calculation.
% Does not affect the result. Default is 'logarithmic'.
% Available options for plot_type:
%     'logarithmic' - logarithmic x axis
%     'linear' - linear x axis
% 
% maxsearch: Max number of iterations. Default: 1000.
% 
% options: options structure for fminsearch. Default:
%     options = optimset('MaxFunEvals',1e8,'MaxIter',1e8);
%     
% shape: can be 'raise' for raise-up dynamics:
%     y(t) = sum { g(s)*(1-exp(-t/s)) }
% or 'decay' for relaxation dynamics:
%     y(t) = sum { g(s)*exp(-t/s) }
% default is 'decay'.
% 
% constraints: allowed constraints on the g distribution function
% (a cell of multiple constraints can be passed). Available options
% for constraints:
%     'g>0'
%     'zero_at_the_extremes'
% Default is: constraints = {'g>0';'zero_at_the_extremes'};
% 
% R is a matrix determining the form of the Regularizor.
% (see http://s-provencher.com/pages/contin.shtml for details)
% Default settings:
%     R = zeros(length(y)-2,length(y));
% 
% w is the array of fitting weigths for each value of y
% Default settings:
%     w = ones(size(y(:)));
% 
% Leave an empty array to set the default value for the parameters.
% Feel free to contact me and suggest modifications.
% -------------------------------------------------------------
% (c) 2007 Iari-Gabriel Marino, Ph.D.
% University of Parma
% Physics Department
% Viale G.P. Usberti, 7/a
% 43100 Parma - Italy
% e-mail: iarigabriel.marino@fis.unipr.it
% web: http://www.fis.unipr.it/home/marino/
% Tel. +39 (0) 521 906212
% Fax +39 (0) 521 905223
% -------------------------------------------------------------
% 
% Example:
%
% % Target g(s) function:
% g0 = [0 0 10.1625 25.1974 21.8711 1.6377 7.3895 8.736 1.4256 0 0]';
% % s space:
% s0  = logspace(-3,6,length(g0))';
% 
% semilogx(s0,g0); title('Target times distribution - Press any key...'); shg
% pause
% 
% t = linspace(0.01,500,100)';
% [sM,tM] = meshgrid(s0,t);
% A = exp(-tM./sM);
% % Data:
% data = A*g0 + 0.07*rand(size(t));
% 
% alpha = 1e-2;
% 
% % Guess s space and g function
% s = logspace(-3,6,20)';
% g = ones(size(s));
% [g,yfit,cfg] = rilt(t,data,s,g,alpha,'logarithmic',[],[],[],{'g>0'},[],[]);
% 
% subplot(1,2,1)
% plot(t,data,'.',t,yfit,'ro'); title('data and fitting')
% subplot(1,2,2)
% semilogx(s0,g0/max(g0),s,g/max(g),'o-'); title('g-target and g');

%###########################################################

g0 = g0(:); % must be column
s = s(:); % must be column
y = y(:); % must be column
t = t(:); % must be column

if nargin == 5
    plot_type = @semilogx;
    maxsearch = 1000;
    options = optimset('MaxFunEvals',1e8,'MaxIter',1e8);
    shape = 'decay';
    constraints = {'g>0','zero_at_the_extremes'};
    R = zeros(length(g0)-2,length(g0));
    w = ones(size(y(:)));
elseif nargin == 12
    if isempty(varargin{1})
        plot_type = @semilogx;
    else
        if strcmp(varargin{1},'logarithmic')
            plot_type = @semilogx;
        elseif strcmp(varargin{1},'linear')
            plot_type = @plot;
        end
    end
    if isempty(varargin{2})
        maxsearch = 1000;
    else
        maxsearch = varargin{2};
    end
    if isempty(varargin{3})
        options = optimset('MaxFunEvals',1e8,'MaxIter',1e8);
    else
        options = varargin{3};
    end
    if isempty(varargin{4})
        shape = 'decay';
    else
        shape = varargin{4};
    end
    if isempty(varargin{5})
        constraints = {'g>0';'zero_at_the_extremes'};
    else
        constraints = varargin{5};
    end
    if isempty(varargin{6})
        R = zeros(length(g0)-2,length(g0));
    else
        R = varargin{6};
    end
    if isempty(varargin{7})
        w = ones(size(y(:)));
    else
        w = varargin{7};
    end
end

[sM,tM] = meshgrid(s,t);

% Also raising kinetics can be inverted
if strcmp(shape,'raise')
    A = 1 - exp(-tM./sM);
elseif strcmp(shape,'decay')
    A = exp(-tM./sM);
else
    error(['Unknown shape: ' shape]);
    return;
end

% Rough normalization of g0, to start with a good guess
g0 = g0*sum(y)/sum(A*g0);

% Plots initialization
fh = gcf; clf(fh);
set(fh,'doublebuffer','on');
s1h = subplot(2,2,1); plot(t,y,'.',t,A*g0); title('Data and fitting curve'); axis tight
s2h = subplot(2,2,2); feval(plot_type,s,g0,'o-'); title('Initial distribution...'); axis tight
s3h = subplot(2,2,3); msdh = plot(0,0); title('Normalized msd');
s4h = subplot(2,2,4); plot(t,abs(y-A*g0)); title('Residuals'); axis tight
msd2plot = 0;
drawnow;

% Main cycle
ly = length(y);
oldssd = Inf;
tic
for k = 1:maxsearch,
    % msd: The mean square deviation; this is the function
    % that has to be minimized by fminsearch
    [g,msdfit] = fminsearch(@msd,g0,options,y,A,alpha,R,w,constraints);
    %--- Re-apply constraints ----
    if ismember('zero_at_the_extremes',constraints)
        g(1) = 0;
        g(end) = 0;
    end
    if ismember('g>0',constraints)
        g = abs(g);
    end
    %--------------------
    g0 = g; % for the next step
    ssd = sqrt(msdfit/ly); % Sample Standard Deviation
    ssdStr = num2str(ssd);
    deltassd = oldssd-ssd; % Difference between "old ssd" and "current ssd"
    disp([int2str(k) ': ' ssdStr])
    oldssd = ssd;
    msd2plot(k) = msdfit/ly;
    plotdata(s1h,s2h,s3h,s4h,t,y,A,g,k,maxsearch,plot_type,s,msd2plot,msdh,ssdStr,deltassd);

    % Condition for the stabilization (end of cycles):
    % difference between "old ssd" and "current ssd" == 0
    if deltassd == 0, % < eps,
        disp(['Stabilization reached at step: ' int2str(k) '/' int2str(maxsearch)])
        break;
    end
end
disp(['Elapsed time: ' num2str(toc/60) ' min.'])

% Saving parameters and results
yfit = A*g; % fitting curve

cfg.t = t;
cfg.y = y;
cfg.yfit = yfit;
cfg.g0 = g0;
cfg.alpha = alpha;
cfg.R = R;
cfg.w = w;
cfg.maxsearch = maxsearch;
cfg.constraints = constraints;
cfg.date = datestr(now,30);

% Store g and s in a temporary file
% that can be loaded as a starting configuration
save rilt_temp g s cfg
disp('Temp output saved.')
set(gcf,'name','Fitting done')

% ### SUBS #####################################################
function out = msd(g,y,A,alpha,R,w,constraints)
% msd: The mean square deviation; this is the function
% that has to be minimized by fminsearch

% Constraints and any 'a priori' knowledge
if ismember('zero_at_the_extremes',constraints)
    g(1) = 0;
    g(end) = 0;
end
if ismember('g>0',constraints)
    g = abs(g); % must be g(i)>=0 for each i
end
r = diff(diff(g(1:end))); % second derivative of g
yfit = A*g;
% Sum of weighted square residuals
VAR = sum(w.*(y-yfit).^2);
% Regularizor
REG = alpha^2 * sum((r-R*g).^2);
% Output to be minimized
out = VAR+REG;

% ### SUBS #####################################################
function plotdata(s1h,s2h,s3h,s4h,t,y,A,g,k,maxsearch,plot_type,s,msd2plot,msdh,ssdStr,deltassd)
% For the "real-time" plots

axes(s1h);
plot(t,y,'.',t,A*g); title('Data')
xlabel('Time (s)');
axis tight

axes(s2h);
feval(plot_type,s,g,'o-');
title('Relaxation times distribution g(s)');
xlabel('s');
axis tight

axes(s3h);
title(['ssd: ' ssdStr '; \Deltassd: ' num2str(deltassd)])
ylabel('Sample Standard Deviation')
xlabel('Step')
set(msdh,'xdata',1:k,'ydata',msd2plot);
axis tight

axes(s4h);
plot(t,abs(y-A*g)/length(y),'o-');
title('Normalized residuals')
xlabel('Time (s)');
axis tight

set(gcf,'name',['Step:' int2str(k) '/' int2str(maxsearch)])

drawnow


%   LMFnlsqtest.m          Constrained Rosenbrock's valey
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   The script solves a testing problem of the Rosenbrock's function by
%   minimization of of a sum of squares of residuals and a curve fitting.
%   It is prepared for Matlab v.7 and above
%   Requirements:                                                 FEX ID:
%       inp         function for keyboard input with default value  9033 
%       fig         function for coded figure window placement      9035
%       separator   for separating displayed results               11725
%       LMFnlsq     function for nonlinear least squares           16063
%   Example:
%   A user may run the script multiply changing only few parameters:
%       iprint      as a step in displaying intermediate results,
%       ScaleD      diagonal scale matrix, and
%       Trace       a control variable for storing intermediate data.

% Miroslav Balda
% miroslav AT balda DOT cz
%   2008-08-18  v 1.1   Modified for analytical gradient
%   2009-01-06  v 1.2   updated for modified function LMFnlsq

clear all
close all

Id = '';
if ~exist('inp.m','file'),       Id = [Id 'inp (Id=9033) ']; end
if ~exist('fig.m','file'),       Id = [Id 'fig (Id=9035) ']; end 
if ~exist('separator.m','file'), Id = [Id 'separator (Id=11725 )']; end
if ~exist('LMFnlsq.m','file'),   Id = [Id 'LMFnlsq (Id=16063 )'];  end
if ~isempty(Id)
    error(['Download function(s) ' Id 'from File Exchange'])
end

separator([mfilename,'   ',date],'#',38)
separator('Rosenbrock without constrains',' ');

ipr= eval(inp('iprint ','5'));  %   step in printing of iterations
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   Control variable (step in iterations) for display intermediate results

sd = eval(inp('ScaleD ','[]')); %   D = diag(J'*J)
xy = eval(inp('Trace  ','1'));  %   save intermediate results
disp(' ');

fig(8);
x0 = [-1.2, 1];         %   Usual starting point for Rosenbrock valey
for k = 1:2             %   Cycle for analytical | finite differences gradient
    t  = clock;
    if k==1             %   EXAMPLE 1:  Rosenbrock without constrains
        r  = 0;
        gr = 'AG_ ';    %   Analytical gradient
        ros =  @(x) [10*(x(2)-x(1)^2)
                     1-x(1)];
        jac =  @(x) [-20*x(1), 10
                     -1, 0];
        disp('Analytical gradient')
        [xf,ssq,cnt,loops,XY] = LMFnlsq ...% With analytical Jacobian matrix
            (ros,x0,'Display',ipr, 'ScaleD',sd, 'Trace',xy,'Jacobian',jac);
    else                %   EXAMPLE 2:  Rosenbrock with constraint
        separator('Rosenbrock with constrains',' ')
        gr = 'FDG_ ';   %   Finite difference approx. of gradient
        r = 0.5;
        w = 1000;
        d = @(x) x'*x-r^2; %    delta of squares of position and radius
        ros =  @(x) [10*(x(2)-x(1)^2)
                     1-x(1)
                     (r>0)*(d(x)>0)*d(x)*w
                    ];
        disp('Gradient from finite differences')
        [xf,ssq,cnt,loops,XY] = LMFnlsq ...% With finite difference Jacobian matrix
            (ros,x0,'Display',ipr, 'ScaleD',sd, 'Trace',xy);
    end
    R = sqrt(xf'*xf);
    fprintf('\n  Distance from the origin R =%9.6f,   R^2 = %9.6f\n', R, R^2);
    separator(['t = ',num2str(etime(clock,t)),' sec'],'*')

    if xy                               %   Saved sequence [x(1), x(2)] 
        subplot(1,3,k)
        plot(-2,-2,2,2)
        axis square
        hold on
        fi=(0:pi/18:2*pi)';
        plot(cos(fi)*r,sin(fi)*r,'r')   %   circle 
        grid
        fill(cos(fi)*r,sin(fi)*r,'y')   %   circle = fesible domain
        x=-2:.1:2; 
        y=-2:.1:2;
        [X,Y]=meshgrid(x,y);
        Z=100*(Y-X.^2).^2 - (1-X).^2;   %   Rosenbrock's function
        contour(X,Y,Z,30)
        plot(x0(1),x0(2),'ok')          %   starting point
        plot(xf(1),xf(2),'or')          %   terminal point
        plot([x0(1),XY(1,:)],[x0(2),XY(2,:)],'-k.') %   iteration path
        if r>0
            tit = 'Constrained';
        else
            tit = '';
        end
        title([tit,' Rosenbrock valley - ' gr],...
            'FontSize',14,'FontWeight','demi')
        xlabel('x_1','FontSize',12,'FontWeight','demi')
        ylabel('x_2','FontSize',12,'FontWeight','demi')
    end
end

%                       EXAMPLE 3:  Curve fit of decaying exponential
separator('Exponential fit  y(x) = c1 + c2*exp(c3*x)',' ');
t = clock;
c = [1,2,-1];
x = (0:.1:3)';          %   column vector of independent variable values
y = c(1) + c(2)*exp(c(3)*x) + 0.1*randn(size(x)); % dependent variale
                        %   Initial estimates:    
c1 = y(end);            %   c1 = y(x->inf)
c2 = y(1)-c1;           %   c2 for x=0
c3 = real(x(2:end-1)\log((y(2:end-1)-c1)/c2));  %   evaluated c3  
res = @(c) real(c(1) + c(2)*exp(c(3)*x) - y);   %   anonym. funct. for residua

[C,ssq,cnt] = LMFnlsq(res,[c1,c2,c3],'Display',-1);% without displ. lambda

subplot(1,3,3)
plot(0,0, x,y,'o', x,res(C)+y,'-r', 'Linewidth',1), grid
axis 'square'
title('Regression by f(x) = c_1 + c_2exp(c_3x)',...
      'FontSize',14,'FontWeight','demi')
xlabel('x','FontSize',12,'FontWeight','demi')
ylabel('y','FontSize',12,'FontWeight','demi')
separator(['t = ',num2str(etime(clock,t)),' sec'],'*')
    
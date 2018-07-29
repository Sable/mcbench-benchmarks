function F = nonlinearBVP_FDM(a,b,alpha,beta)
% Nonlinear finite difference method for the general nonlinear 
% boundary-value problem -------------------------------------
% y''=f(x,y,y'), for a<x<b where y(a)=alpha and y(b)=beta. 
% ------------------------------------------------------------
% The interval [a,b] is divided into (N+1) equal subintervals
% with endpoints at x(i)=a+i*h for i=0,1,2,...,N+1. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Remarks: The function f should be defined as an m-file. %%
%%%          There is NO need for partial derivatives of f  %%
%%%          See given example                              %%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Example
% Solve the nonlinear boundary value problem
% y''=(1/8)*(32+2x^3-yy'), for 1<x<3, where y(1)=17 and y(3)=43/3
% Step 1... 
% Create the function f as a separate m-file and save it in the 
% current working directory.
% function f = f(x,y,yp)
% f = (1/8)*(32+2*x^3-y*yp); %Note that yp=y'
% Step 2... 
% In the command window type
% >> Y = nonlinearBVP_FDM(1,3,17,43/3);
% Note that Y(:,1) represents x and Y(:,2) is vector y(x) 
% The solution is then plotted in a new figure
% If the exact solution is given, plot it for comparison
% >> yexact = (Y(:,1)).^2+16./Y(:,1); plot(Y(:,1),yexact,'c')
%
% Try the next examples
% y'' = -(y')^2-y+ln(x), 1<x<2, y(1)=0 and y(2)=ln(2) Sol. y = ln(x)
% y'' = y'+2(y-ln(x))^3-x^-1, 2<x<3, y(2)=1/2+ln(2) and y(3)=1/3+ln(3) 
% Sol. y = x^-1+ln(x)
% y'' = (x^2(y')^2-9*y^2+4*x^6)/x^5, 1<x<2, y(1)=0 and y(2)=ln(256)
% Sol. y = x^3(ln(x))
%
% Author: Ernesto Momox B. University of Essex, UK
format long
N=39;%Number of mesh points           
h=(b-a)/(N+1); %Step size
i=1:N;
x=a+i*h;
W=zeros(N+2,1); %Preallocate W and X
X=W;
w=alpha+i'*(beta-alpha)/(b-a)*h; %Initial approximations are obtained
% by passing a straight line through (a,alpha) and (b,beta)
options=optimset('TolFun',1E-10,'TolX',1E-10,'MaxIter',1E3,...
        'MaxFunEvals',1E3,'Display','off');

w = fsolve(@(w) systemNxN(w,x,h,alpha,beta),w,options); % Solves the N x N
% nonlinear system of equations

W(1)=alpha;         X(1)=a;
W(2:length(w)+1)=w; X(2:length(x)+1)=x;
W(N+2)=beta;        X(N+2)=b;

F = [X W];

hand = figure;
set(hand,'Name','Nonlinear Finite Difference Method','NumberTitle','off');
plot(X,W,'r.','MarkerSize',16), grid on, hold on
plot(X(1),W(1),'bo','MarkerSize',10,'LineWidth',2)
plot(X(N+2),W(N+2),'go','MarkerSize',10,'LineWidth',2)
xlabel('$x$','FontSize',20,'interpreter','latex')
ylabel('$y(x)$','FontSize',20,'interpreter','latex')
legend('Numerical Solution','y(a) = alpha','y(b) = beta','Orientation',...
       'horizontal','Location','Best')
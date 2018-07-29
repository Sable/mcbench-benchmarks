function implot(fun,rangexy,ngrid)
% Implicit plot function
% function implot(fun,rangexy,ngrid)
% fun is 'inline' function f(x,y)=0 (Note function written as equal to zero)
% rangexy =[xmin,xmax,ymin,ymax] range over which x and y is ploted default(-2*pi,2*pi)
% ngrid is the number of grid points used to calculate the plot,
% Start with course grid (ngrid =20) and then use finer grid if necessary
% default ngrid=50
%
% Example 
% Plot y^3+exp(y)-tanh(x)=0
%
% write function f as an 'inline' function of x and y-- right hand side 
% equal to zero
%
% f=inline('y^3+exp(y)-tanh(x)','x','y')
% implot(f,[-3 3 -2 1])


%       A.Jutan UWO 2-2-98  ajutan@julian.uwo.ca



if nargin == 1  ;% grid value and ranges not specified calculate default
        rangexy=[-2*pi,2*pi,-2*pi,2*pi];
   ngrid=50;
end


if nargin == 2;  % grid value not specified
   ngrid=50;
end


% get 2-D grid for x and y


xm=linspace(rangexy(1),rangexy(2),ngrid);
ym=linspace(rangexy(3),rangexy(4),ngrid);
[x,y]=meshgrid(xm,ym);
fvector=vectorize(fun);% vectorize the inline function to handle vectors of x y
fvalues=feval(fvector,x,y); %calculate with feval-this works if fvector is an m file too
%fvalues=fvector(x,y); % can also calculate directly from the vectorized inline function
contour(x,y,fvalues,[0,0],'b-');% plot single contour at f(x,y)=0, blue lines
xlabel('x');ylabel('y');
grid

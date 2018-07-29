function par_est2a
% parameter estimation with derivatives                      Holzbecher September 2005
% using differential equations
% Idea from FEMLAB - there R instead of Q 
% see COMSOL News, Nr. 1, 2005, page 15
global xfit cfit Q

% specify fitting data
xfit = [0.05:0.1:0.95];
cfit = [0.9256859756097451       0.7884908536585051       0.6665396341462926...
        0.559832317073104        0.4683689024389414       0.39214939024380824...
        0.33117378048770196      0.28544207317062964      0.25495426829258294      0.23971036585356142];      
Q = -2;
D = fzero(@myfun,1.8);
display (['Best fit for D = ' num2str(D)]);
x = [0:0.01:1];
plot (xfit,cfit,'o',x,-(Q/D/2)*x.*x + (Q/D)*x + 1,'-');
legend ('given','modelled');
xlabel ('x'); ylabel ('c');

function f = myfun(D); 
global xfit cfit Q

options = bvpset;
% solve diffusion equation for c with c(0)=1 and dc/dx(1)=0 
solinit = bvpinit([0 xfit 1],@guess);
c = bvp4c (@mat4ode,@mat4bc,solinit,options,Q/D,1);
%plot (c.x,c.y(1,:),'r',xfit,-(Q/D/D)*xfit.*xfit+(Q/D)*xfit+ones(1,size(xfit,2)));

% solve Poisson equation for dc/dD (cD) with boundary conditions
solinit = bvpinit([0 xfit 1],@guess1);
cD = bvp4c (@mat4ode,@mat4bc,solinit,options,Q/D/D,0);

% specify function f to vanish
f = 2*(c.y(1,2:size(c.y,2)-1)-cfit)*cD.y(1,2:size(c.y,2)-1)';

function dydx = mat4ode(x,y,Q,c0)
dydx = [y(2); -Q];
% ------------------------------------------------------------
function res = mat4bc(y0,y1,Q,c0)
res = [y0(1)-c0; y1(2)];
% ------------------------------------------------------------
function v = guess(x)
v = [x*(x-2)+1; 2*(x-1)];
% ------------------------------------------------------------
function v = guess1(x)
v = [x*(x-2); 2*(x-1)];

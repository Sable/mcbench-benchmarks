function par_est2
% parameter estimation with derivatives                      Holzbecher May 2005
% Idea from FEMLAB - there R instead of Q 
% see COMSOL News, Nr. 1, 2005, page 15
global xfit cfit Q

% specify fitting data
xfit = [0.05:0.1:0.95];
cfit = [0.9256859756097451       0.7884908536585051       0.6665396341462926...
        0.559832317073104        0.4683689024389414       0.39214939024380824...
        0.33117378048770196      0.28544207317062964      0.25495426829258294      0.23971036585356142];      
Q = -2;
D = fzero(@myfun,2);
display (['Best fit for D = ' num2str(D)]);
x = [0:0.01:1];
plot (xfit,cfit,'o',x,-(Q/D/2)*x.*x + (Q/D)*x + 1,'-');
legend ('given','modelled');
xlabel ('x'); ylabel ('c');

function f = myfun(D); 
global xfit cfit Q

% solve diffusion equation for c with c(0)=1 and dc/dx(1)=0 
c = -(Q/D/2)*xfit.*xfit + (Q/D)*xfit + 1; 

% solve Poisson equation for dc/dD (cD) with boundary conditions
cD = (Q/D/D/2)*xfit.*xfit - (Q/D/D)*xfit;

% specify function f to vanish
f = 2*(c-cfit)*cD';

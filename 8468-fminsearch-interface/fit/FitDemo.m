%FitDemo.m
%
%Demo program for the function 'fit.m', which is an interface to MATLAB's 
%'fminsearch' routine.  
%
%fit.m allows users to choose which parameters in their model to be set free,
%and which are to be held constant.  
%
%Written by G.M Boynton, September 12,2005

%Let's first generate a data set based on the sum of a sinusoid and a
%2nd order polynomial, plus a little added noise:

x = linspace(-pi,pi,101);
y = 3*sin(4*x)+2*x.^2+x+1;
y = y+randn(size(y));

%Now plot the data and save the graphics handles.
figure(1)
clf
set(gca,'XTick',linspace(-pi,pi,5));
plot_handle = plot(x,y,'b-','LineWidth',2);
hold on
plot(x,y,'r.');
text_handle = text(mean(x),max(y)+1,'','HorizontalAlignment','center','FontSize',14);
set(gca,'YLim',[min(y)-1,max(y)+2.5]);
set(gca,'XLim',[-pi*1.1,pi*1.1]);
xlabel('X');ylabel('Y');

%Next, we'll define the initial parameters for the fit.  
%fit.m requires the fitting function to have all possible model parameters
%to be fields of a single structure.  These fields can be single elements,
%or they can be vectors or matrices.

initP.amp = 0;   %amplitude of sinusoid
initP.freq = 3.5;   %frequency of sinusoid
initP.poly = [0,0,6];  %3 coefficents ofthe 2nd order polynomial.

%'freeList' is a cell array of strings that holds the names of the model
%parameters to be allowed to vary in the optimization routine.  

%For example, let's only let the parameters for the polynomial vary:
freeList = {'poly'};

%Call 'fit'.  Note the order of the input parameters:
%1) fitted function name
%2) initial parameter structure
%3) list of free parameters
%4) 2nd parameter to be sent into the fitted function ...
[bestP,err] = fit('myTestFunction',initP,freeList,x,y,plot_handle,text_handle);

%Now starting with these parameters (bestP), let the amplitude of the sinusoid vary.
freeList = {'amp'};
[bestP,err] = fit('myTestFunction',bestP,freeList,x,y,plot_handle,text_handle);

%Or we can let the amplitude and the frequency vary together:
freeList = {'amp','freq'};
[bestP,err] = fit('myTestFunction',bestP,freeList,x,y,plot_handle,text_handle);

%'freeList' can also refer to individual values within arrays of free parameters.  
%For example this lets the linear coeficient of the polynomial be free:
freeList = {'poly(3)'};
[bestP,err] = fit('myTestFunction',bestP,freeList,x,y,plot_handle,text_handle);

%This lets the first two coeficient of the polynomial be free:
freeList = {'poly([1,2])'};
[bestP,err] = fit('myTestFunction',bestP,freeList,x,y,plot_handle,text_handle);

%Or we can let all five parameters vary togther:
%freeList = {'amp,poly'};
[bestP,err] = fit('myTestFunction',bestP,freeList,x,y,plot_handle,text_handle);






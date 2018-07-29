function M=initEnergy()
global x_iteration;
global x_frequency;
x_iteration1=str2num(x_iteration);
x_frequency1=str2num(x_frequency);
nb=floor((x_iteration1/x_frequency1)+1);
M=zeros(1,nb);
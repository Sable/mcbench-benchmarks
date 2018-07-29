% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% 	Graph of cos(x) & sin(x) , 0<=x<=2*pi


x=linspace(0,2*pi,150);
plot(x,cos(x),'r*',x,sin(x),'k')
pause(2) % pauses the program execution for 2 seconds

grid
pause(1)

xlabel('X-axis')
ylabel('Y-axis')
pause(1)

title('Graph of cos(x) & sin(x)')
pause(1)

text(3,0.3,'string1')
gtext('string2')
pause(1)

legend('cos(x)','sin(x)')
pause(2)

axis([2,4,-1,0])

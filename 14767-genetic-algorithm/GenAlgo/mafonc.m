function z =fonction(input)

x = input(1); 
y = input(2);

z =  exp(-(x-0.5)^2)+exp(-(y-0.7)^2)+(1/25)*exp(-(x+0.2)^2)+(1/25)*exp(-(x-0.2)^2)+(1/25)*exp(-(y+1)^2)+(1/25)*exp(-(y-1)^2);

drawnow;

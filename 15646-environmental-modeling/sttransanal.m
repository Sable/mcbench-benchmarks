function sttransanal
Pe = [-10,-1,-.1,0,.1,1,10];
x = [0:0.025:1]; 
figure; hold on;
for i = 1:size(Pe,2)
  plot (x,(1-exp(Pe(i).*x))./(1-exp(Pe(i).*ones(1,size(x,2))))); 
end
legend ('Pe=-10','Pe=-1','Pe=-.1','Pe=0','Pe=.1','Pe=1','Pe=10');
xlabel('x/L');
ylabel('c/c_0');
grid;
hold off;
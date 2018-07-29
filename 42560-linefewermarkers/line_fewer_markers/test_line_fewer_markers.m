clear all; close all;

figure; hold on; set(gca,'FontSize',16); set(gca,'FontName','Times'); set(gcf,'Color',[1,1,1]);
xlabel('x');ylabel('y');title('a family plot with nice legend');

x       = (1:1000);
xMid    = (x(1)+2*x(end))/3;
parVals = [1 1.5 2 3]; 

num_Markers = 8; %<--------
LineTypes   = {'-.','-','--'};
MarkerTypes = {'h','o','s','d','^','v','>','<','p'};
colors      = {'m','r','b',[1 1 1]*0.5};
for ip=1:length(parVals)
    col           =  colors{1+mod(ip,length(colors))};
    ls            =  LineTypes{1+mod(ip,length(LineTypes))};
    lm            =  MarkerTypes{1+mod(ip,length(MarkerTypes))};
    g             =  parVals(ip);
    y             =  1 + 1/g*abs(1e4./(xMid + (x-xMid/g).^(2-0.2*g)));   % a function that changes with parameter g
    legCell{ip}   = ['fA, g=',num2str(g)];         %legend text    
    [p1,p2,p3]    = line_fewer_markers(x,y,num_Markers,'color',col,'linestyle',ls, 'linewidth',2, 'marker', lm, 'markerfacecolor',col,'LockOnMax',1,'Spacing','curve','parent',gca);
end
lh = legend(legCell,'Location','NorthWest');
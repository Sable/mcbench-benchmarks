% subplotplus demo

cell71={{['-g']};{['-g']};{['-g']};{['-g']};{['-g']};{['-g']};{['-g']}};
cell41={{['-g']};{['-g']};{['-g']};{['-g']}};
cell31={{['-g']};{['-g']};{['-g']}};
cell21={{['-g']};{['-g']}};

figure(1)
C = {{{{[]},{[]}};cell41},cell71};
[h,labelfontsize] = subplotplus(C);
x=[0:1e-3:1];

subidx = 1;
set(gcf,'CurrentAxes',h(subidx));
plot(x,sin(2*pi*x),'b-');
set(h(subidx),'XGrid','on','YGrid','on','Box','on','XMinorTick','on','YMinorTick','on','XMinorGrid','off','YMinorGrid','off');
title('sin()','FontSize',labelfontsize(subidx,1))
xlabel('x [1/(2*pi)rad]','FontSize',labelfontsize(subidx,1));	ylabel('sin(2*pi*x)','FontSize',labelfontsize(subidx,2));

subidx = subidx +1;
set(gcf,'CurrentAxes',h(subidx));
plot(x,cos(2*pi*x),'r-');
set(h(subidx),'XGrid','on','YGrid','on','Box','on','XMinorTick','on','YMinorTick','on','XMinorGrid','off','YMinorGrid','off');
title('cos()','FontSize',labelfontsize(subidx,1))
xlabel('x [1/(2*pi)rad]','FontSize',labelfontsize(subidx,1));	ylabel('cos(2*pi*x)','FontSize',labelfontsize(subidx,2));

subidx = subidx +1;
set(gcf,'CurrentAxes',h(subidx));
plot(x,sin(2*pi*x).^2,'b-');
set(h(subidx),'XGrid','on','YGrid','on','Box','on','XMinorTick','on','YMinorTick','on','XMinorGrid','off','YMinorGrid','off');
title('powers of...','FontSize',labelfontsize(subidx,1))
xlabel('x [1/(2*pi)rad]','FontSize',labelfontsize(subidx,1));	ylabel('sin(2pix)^2','FontSize',labelfontsize(subidx,2));
%%
subidx = subidx +1;
set(gcf,'CurrentAxes',h(subidx));
plot(x,cos(2*pi*x).^2,'r-');
set(h(subidx),'XGrid','on','YGrid','on','Box','on','XMinorTick','on','YMinorTick','on','XMinorGrid','off','YMinorGrid','off');
%title('multiple frequencies','FontSize',labelfontsize(subidx,1))
xlabel('x [1/(2*pi)rad]','FontSize',labelfontsize(subidx,1));	ylabel('cos(2pix)^2','FontSize',labelfontsize(subidx,2));

subidx = subidx +1;
set(gcf,'CurrentAxes',h(subidx));
plot(x,sin(2*pi*x).^3,'b-');
set(h(subidx),'XGrid','on','YGrid','on','Box','on','XMinorTick','on','YMinorTick','on','XMinorGrid','off','YMinorGrid','off');
%title('powers of...','FontSize',labelfontsize(subidx,1))
xlabel('x [1/(2*pi)rad]','FontSize',labelfontsize(subidx,1));	ylabel('sin(2pix)^3','FontSize',labelfontsize(subidx,2));

subidx = subidx +1;
set(gcf,'CurrentAxes',h(subidx));
plot(x,cos(2*pi*x).^3,'r-');
set(h(subidx),'XGrid','on','YGrid','on','Box','on','XMinorTick','on','YMinorTick','on','XMinorGrid','off','YMinorGrid','off');
%title('multiple frequencies','FontSize',labelfontsize(subidx,1))
xlabel('x [1/(2*pi)rad]','FontSize',labelfontsize(subidx,1));	ylabel('cos(2pix)^3','FontSize',labelfontsize(subidx,2));
%%
subidx = subidx +1;
set(gcf,'CurrentAxes',h(subidx));
plot(x,sin(2*pi*2*x),'g-');
set(h(subidx),'XGrid','on','YGrid','on','Box','on','XMinorTick','on','YMinorTick','on','XMinorGrid','off','YMinorGrid','off');
title('different frequencies...','FontSize',labelfontsize(subidx,1))
xlabel('x [1/(2*pi)rad]','FontSize',labelfontsize(subidx,1));	ylabel('sin(2pi2x)','FontSize',labelfontsize(subidx,2));

subidx = subidx +1;
set(gcf,'CurrentAxes',h(subidx));
plot(x,sin(2*pi*3*x),'m-');
set(h(subidx),'XGrid','on','YGrid','on','Box','on','XMinorTick','on','YMinorTick','on','XMinorGrid','off','YMinorGrid','off');
xlabel('x [1/(2*pi)rad]','FontSize',labelfontsize(subidx,1));	ylabel('sin(2pi3x)','FontSize',labelfontsize(subidx,2));

subidx = subidx +1;
set(gcf,'CurrentAxes',h(subidx));
plot(x,sin(2*pi*4*x),'c-');
set(h(subidx),'XGrid','on','YGrid','on','Box','on','XMinorTick','on','YMinorTick','on','XMinorGrid','off','YMinorGrid','off');
xlabel('x [1/(2*pi)rad]','FontSize',labelfontsize(subidx,1));	ylabel('sin(2pi4x)','FontSize',labelfontsize(subidx,2));

subidx = subidx +1;
set(gcf,'CurrentAxes',h(subidx));
plot(x,sin(2*pi*8*x),'y-');
set(h(subidx),'XGrid','on','YGrid','on','Box','on','XMinorTick','on','YMinorTick','on','XMinorGrid','off','YMinorGrid','off');
xlabel('x [1/(2*pi)rad]','FontSize',labelfontsize(subidx,1));	ylabel('sin(2pi8x)','FontSize',labelfontsize(subidx,2));

subidx = subidx +1;
set(gcf,'CurrentAxes',h(subidx));
plot(x,sin(2*pi*16*x),'k-');
set(h(subidx),'XGrid','on','YGrid','on','Box','on','XMinorTick','on','YMinorTick','on','XMinorGrid','off','YMinorGrid','off');
xlabel('x [1/(2*pi)rad]','FontSize',labelfontsize(subidx,1));	ylabel('sin(2pi16x)','FontSize',labelfontsize(subidx,2));

subidx = subidx +1;
set(gcf,'CurrentAxes',h(subidx));
plot(x,sin(2*pi*32*x),'b-');
set(h(subidx),'XGrid','on','YGrid','on','Box','on','XMinorTick','on','YMinorTick','on','XMinorGrid','off','YMinorGrid','off');
xlabel('x [1/(2*pi)rad]','FontSize',labelfontsize(subidx,1));	ylabel('sin(2pi32x)','FontSize',labelfontsize(subidx,2));

subidx = subidx +1;
set(gcf,'CurrentAxes',h(subidx));
plot(x,sin(2*pi*64*x),'r-');
set(h(subidx),'XGrid','on','YGrid','on','Box','on','XMinorTick','on','YMinorTick','on','XMinorGrid','off','YMinorGrid','off');
xlabel('x [1/(2*pi)rad]','FontSize',labelfontsize(subidx,1));	ylabel('sin(2pi64x)','FontSize',labelfontsize(subidx,2));



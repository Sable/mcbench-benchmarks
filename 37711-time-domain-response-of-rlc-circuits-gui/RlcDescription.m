%ax1=axes('Position',[0.016  .53  .4  .3]);
warning('off','MATLAB:dispatcher:InexactMatch')
x1=[0.2  0.2  1.1  1.1];
y1=[0.6  1.0  1.0  .55];
x2=[0.2  0.2  1.1  1.1];
y2=[0.4  0    0    .45];
%h1=findobj('Tag','Axes1')
th=0:.005:2*pi;
x=0.2+0.1*cos(th);
y=0.5 +0.1*sin(th);
xr=[0.5 0.5  0.45  0.55 0.45  0.55 0.45 0.55 0.45 0.55  0.5  0.5];
yr=[0   .275 0.30  0.35 0.40  0.45 0.50 0.55 0.60 0.65  .675 1];
tho=-pi/2:.005:pi/2;
xo=0.8+0.05*cos(tho);
yo=.05*sin(tho);
xl=[xo     xo      xo       xo];
yl=[.35+yo 0.45+yo 0.55+yo  0.65+yo];
xl1=[0.8  .8]; yl1=[0 0.3];
xl2=[0.8  .8]; yl2=[0.7 1];
xc1=[1.05  1.15]; yc1=[0.45  0.45]; yc2=[0.55 0.55];
plot(x1, y1,'b', x2,y2,'b','erasemode','none')
axis([0 4 -3.5 1.5])
hold on
plot(x,y)
plot(xr,yr)
plot(xl,yl)
plot(xl1,yl1,'b', xl2,yl2,'b')
plot(xc1,yc1,'b', xc1, yc2,'b')
axis off
text(0.025, .5, 'I_s', 'FontSize',  9, 'color', [0 0 0.502] )
text(0.375, .5, 'R', 'FontSize',  9, 'color', [0 0 0.502])
text(0.75, .5, 'L', 'FontSize',  9, 'color', [0 0 0.502])
text(1.015, .36, 'C', 'FontSize',  9, 'color', [0 0 0.502])
text(.425, .825,'\downarrow', 'FontSize',  9, 'color', [0 0 0.502])
text(.725, .825,'\downarrow', 'FontSize',  9, 'color', [0 0 0.502])
text(1.025,.825,'\downarrow', 'FontSize',  9, 'color', [0 0 0.502])
text(0.175,.485,'\uparrow', 'FontSize',  9, 'color', [0 0 0.502])
text(0.725, 0.65,'\downarrow', 'color',[1 0 0])
text(.65,.65, 'I_0', 'FontSize',  9, 'color',[1 0 0])
text(.925, .5, 'V_0', 'FontSize',  9, 'color',[1 0 0])
text(.925, .725,'+', 'FontSize',  9, 'color',[1 0 0])
text(.925, .35,'-',  'FontSize',  9,  'color',[1 0 0])
text(1.2, .5, 'v', 'FontSize',  9, 'color', [0 0 0.502])
text(1.15, 0.9, '+', 'FontSize',  9, 'color', [0 0 0.502])
text(1.15, 0.1, '-', 'FontSize',  9, 'color', [0 0 0.502])
text(.35,.9,'i_R', 'FontSize',  9, 'color', [0 0 0.502])
text(.65,.9,'i_L', 'FontSize',  9, 'color', [0 0 0.502])
text(.95,.9,'i_C', 'FontSize',  9, 'color', [0 0 0.502])
%hold off

%%Series RLC circuit
x1=[0.2  0.2  .325   .35   .40  .45  .50  .55  .60  .625   .70];
y1=[0.6  1.0  1.0    1.05  .95  1.05  .95  1.05 .95  1       1 ];
x2=[0.2  0.2  1.1  1.1];
y2=[0.4  0    0    .45];
h1=findobj('Tag','Axes1');
th=0:.005:2*pi;
x=0.2+0.1*cos(th);
y=0.5 +0.1*sin(th);
%xr=[0.5 0.5  0.45  0.55 0.45  0.55 0.45 0.55 0.45 0.55  0.5  0.5];
%yr=[0   .275 0.30  0.35 0.40  0.45 0.50 0.55 0.60 0.65  .675 1];
tho=0:.005:pi;
xo=0.05*cos(tho);
yo= 1 +.05*sin(tho);
xla=0.75+xo;
xlb=0.85+xo;
xlc=0.95+xo;

xl1=[1  1.1  1.1]; yl1=[1   1   0.55];
xl2=[0.8  .8]; yl2=[0.7 1];
xc1=[1.05  1.15]; yc1=[0.45  0.45]; yc2=[0.55 0.55];
plot(2+x1, y1,'b', 2+x2,y2,'b','erasemode','none')
%hold on
plot(2+x,y)
%plot(xr,yr)
plot(2+xla,yo),plot(2+xlb, yo), plot(2+xlc, yo)
plot(2+xl1,yl1,'b')
plot(2+xc1,yc1,'b', 2+xc1, yc2,'b')
%axis off
text(2+0.0, .5, 'V_s', 'FontSize',  9, 'color', [0 0 0.502])
text(2+0.375, 1.15, 'R', 'FontSize',  9, 'color', [0 0 0.502])
text(2+0.75, 1.15, 'L', 'FontSize',  9, 'color', [0 0 0.502])
text(2+1.025, .35, 'C', 'FontSize',  9, 'color', [0 0 0.502])
%text(.425, .825,'\downarrow')
text(2+.6, 1.1,'\rightarrow', 'FontSize',  9, 'color', [0 0 0.502])
%text(1.025,.825,'\rightarrow', 'FontSize',  9, 'color', [0 0 0.502])
text(2+0.175,.5,'\pm', 'FontSize',  9, 'color', [0 0 0.502])
text(2+0.875, 1.125,'\rightarrow', 'color',[1 0 0])
text(2+.85,1.275, 'I_0', 'FontSize',  9,'color',[1 0 0])
text(2+.9, .5, 'V_0', 'FontSize',  9,'color',[1 0 0])
text(2+.95, .725,'+', 'FontSize',  9,'color',[1 0 0])
text(2+.95, .3,'-', 'FontSize',  9,'color',[1 0 0])
text(2+1.175, .5, 'v_C', 'FontSize',  9, 'color', [0 0 0.502])
text(2+1.15, 0.9, '+', 'FontSize',  9, 'color', [0 0 0.502])
text(2+1.15, 0.1, '-', 'FontSize',  9, 'color', [0 0 0.502])
text(2+.425,.85,'v_R', 'FontSize',  9, 'color', [0 0 0.502])
text(2+.3, 0.875, '+', 'FontSize',  9, 'color', [0 0 0.502])
text(2+.55, 0.875, '-', 'FontSize',  9, 'color', [0 0 0.502])
text(2+.625,1.2,'i', 'FontSize',  9, 'color', [0 0 0.502])
text(2+.825,.85,'v_L', 'FontSize',  9, 'color', [0 0 0.502])
text(2+.7, 0.875, '+', 'FontSize',  9, 'color', [0 0 0.502])
text(2+.95, 0.875, '-', 'FontSize',  9, 'color', [0 0 0.502])

hold off



str1(1) = {'\bfNatural and Step Response of RLC Circuits'};
str2(1) = {'{d^{ 2}i_L}/{dt^2} + 1/(RC) {di_L}/{dt} + 1/(LC) i_L = 1/(LC) I_s        {d^2v_C}/{dt^2} + R/L {dv_C}/{dt} + 1/(LC) v_C = 1/(LC)V_s'};
str3(1) = {'The application of KCL to the parallel RLC circuit and KVL to the series RLC circuit will result'};
str3(2) = {'in the following linear time-invariant second-order differential equations.'};
str4(1) = {'The {\bf characteristic equation} for both the parallel and series RLC circuits is given by'};
str5(1) = {'s^2 + 2 \alpha s + {\omega_0}^2 = 0, where \alpha is the damping factor and \omega_0 is the undamped natural frequency.'};
str6(1) = {'For a parallel circuit \alpha = 1/(2RC), for a series circuit \alpha = R/(2L) and for both cases \omega_0 = 1/(LC)^{1/2}.'};
str7(1) = {'The roots of the characteristic equations are:                       s_{1,2} = -\alpha \pm (\alpha^2 - {\omega_0}^2)^{1/2}'};
%str8(1) = {'                                         s_{1,2} = -\alpha \pm (\alpha^2 - {\omega_0}^2)^{\fontname{WP TypographicSymbols}2}'};
str9(1) = {'The form of response depends on the values of \alpha and \omega_0.'}; 
str9(2) = {'1.  \alpha > \omega_0 (real distinct roots), response is overdamped:      x(t) = x_f + A_1 e^{s_1t} + A_2 e^{s_2t} '}; 
str10(1)= {'2.  \alpha < \omega_0 (complex roots), underdamped:                            x(t) = x_f + e^{-\alpha t}(B_1 cos \omega_d t + B_2 sin \omega_d t) '}; 
str11(1)= {'3.  \alpha = \omega_0 (equal roots), critically damped:                            x(t) = x_f + e^{-\alpha t}(D_1 t + D_2)'}; 
str12(1) ={'The above constants are obtained from the initial conditions, x(0^+) and dx(0^+)/dt.'};

str13(1) = {'This program obtains the natural and step response of parallel and series RLC circuits. After selecting'};
str13(2) = {'one of the push buttons below, you can specify the step input, circuit parameters and initial values.'};
str13(3) = {'The Solve buttons are then pressed to obtain the analytical response and plots of currents or voltages.'};
 
text(0.5, 1.95, str1, 'FontSize', 14, 'color', [0 0 0.502]) 
text(0, -.25,  str2, 'FontSize',  9, 'color', [0 0 0.502]) 
text(0, 1.5,   str3, 'FontSize',  9,  'color', [0 0 0.502])
text(0, -.525,   str4,  'FontSize', 9, 'color', [0 0 0.502])
text(0, -.775,   str5,  'FontSize', 9, 'color', [0 0 0.502])
text(0, -1.0,   str6,   'FontSize', 9, 'color',[0 0 0.502])
text(0, -1.25,   str7,  'FontSize', 9, 'color',[0 0 0.502])

%text(0, -1.565,  str8,  'FontSize', 9, 'color', [0 0 0.502])
text(0, -1.65,   str9,  'FontSize', 9, 'color',[0 0 0.502])
text(0, -1.95,   str10, 'FontSize', 9, 'color',[0 0 0.502])
text(0, -2.175,    str11, 'FontSize', 9,  'color',[0 0 0.502])
text(0, -2.35,    str12, 'FontSize', 9,  'color',[0 0 0.502])
text(0, -2.95,    str13, 'fontname','Roman', 'FontSize', 11,  'color', [1 0 0.502])
%text(0.36, -3.55,'\bf\copyright', 'FontSize', 10, 'color',[1 0 0])
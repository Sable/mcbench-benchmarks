% Step Response of a series RLC circuit
% This program obtains the analytical step response of a series RLC 
% circuit. In addition, graphs of the current in the series circuit 
% and voltages across R, L, and C are obtained. Reference direction 
% is assumed in the direction of voltage drop across C. 

function SresponseI
warning('off','MATLAB:dispatcher:InexactMatch')
Rhandle=findobj('Tag','Rtext');
R=eval(get(Rhandle,'String'));
KOhandle=findobj('Tag','KOhm');
KO=get(KOhandle,'Value');
if KO==1 
   R=1000*R;
else, end
Lhandle=findobj('Tag','Ltext');
L=eval(get(Lhandle,'String'));
mHhandle=findobj('Tag','mHenry');
ml=get(mHhandle,'Value');
if ml==1 
   L=L/1000;
else, end
Chandle=findobj('Tag','Ctext');
C=eval(get(Chandle,'String'));
micFhandle=findobj('Tag','micFarad');
micF=get(micFhandle,'Value');
if micF==1 
   C=C/1000000;
else, end
Rhandle=findobj('Tag','VStext');
Vs=eval(get(Rhandle,'String'));
Rhandle=findobj('Tag','I0text');
I0=eval(get(Rhandle,'String'));
Rhandle=findobj('Tag','V0text');
V0=eval(get(Rhandle,'String'));
% Step Response of a series RLC circuit
if L==inf | C==inf | R ==inf 
   plot(0, 0)
   title('Open circuit', 'color', [ 1 0 0])
   text(-0.8, 0.80, 'Parameters must lie in the following ranges:', 'color', [0 0 0.6275])
   text(-0.8, 0.65, '0 \leq R < inf,   0 < L < inf,   &    0 < C < inf', 'color', [0 0 0.6275])
   text(-0.8, 0.5, 'Enter the correct value and press Solve', 'color', [0 0 0.6275])
   axis([-1  1  -1  1]);return,  else
end
if L==0 | C == 0
   plot(0, 0)
   text(-0.8, 0.80, 'Parameters must lie in the following ranges:', 'color', [0 0 0.6275])
   text(-0.8, 0.65, '0 \leq  R < inf,   0 < L < inf,   &    0 < C < inf', 'color', [0 0 0.6275])
   text(-0.8, 0.5, 'Enter the correct value and press Solve', 'color', [0 0 0.6275])
   axis([-1  1  -1  1]);return,  else
   alpha =R/(2*L);
end
w02 = 1/(L*C); w0 = sqrt(w02); 
if alpha~= 0
   err=(alpha-w0)/alpha;
   if abs(err) <1e-4
   w0=alpha; 
   else, end
else, end   
di = Vs/L-V0/L-I0*R/L;
dv = I0/C;
if alpha > w0
 % Overdamped response
    s(1) = -alpha + sqrt(alpha^2 - w02);
    s(2) = -alpha - sqrt(alpha^2 - w02);
    A1 = (di-s(2)*I0)/(s(1)-s(2));
    A2 = (di-s(1)*I0)/(s(2)-s(1));
    A1i =(dv-s(2)*(V0-Vs))/(s(1)-s(2));
    A2i =(dv-s(1)*(V0-Vs))/(s(2)-s(1));
    tf = 6*max(abs(1/s(1)), abs(1/s(2)));
    t=0:tf/100:tf;
    vC=Vs + A1i*exp(s(1)*t)+A2i*exp(s(2)*t); 
    i = A1*exp(s(1)*t)+A2*exp(s(2)*t); 
    vR = R*i;
    vL= Vs -vR-vC;
    vt=vR+vL+vC;
    plot(t,i,'erasemode','none','color',[0.9 0 0.8]), grid
    title(['i(t) = (', num2str(A1), ') e^{(', num2str(s(1)), 't)} + (', num2str(A2), ') e^{(', num2str(s(2)), 't)}'],'color',[0.9 0 0.8])
    xlabel(['\alpha = ',num2str(alpha), ',  \omega_0 = ',  num2str(w0), '  (O.D.)          t, sec'])
    ylabel('i, Amps')
    elseif alpha < w0   
     if alpha~=0
      % Underdamped response
      tf = 6/alpha;
      t=0:tf/200:tf;
      wd= sqrt(w02 - alpha^2); 
      s(1) = -alpha +j*wd;
      s(2) = -alpha -j*wd;
      B1 = I0; B2 = (di+alpha*B1)/wd;
      B1i = V0 - Vs; B2i = (dv+alpha*B1i)/wd;
      vC=Vs + exp(-alpha*t).*(B1i*cos(wd*t)+B2i*sin(wd*t));
      i = exp(-alpha*t).*(B1*cos(wd*t)+B2*sin(wd*t));
      vR = R*i;
      vL= Vs -vR-vC;
      vt=vR+vL+vC;
      plot(t,i,'erasemode','none','color',[.9 0 0.8]), grid
      title(['i(t) = e^{(-', num2str(alpha), 't)}[(', num2str(B1), ')cos',num2str(wd),'t + (' , num2str(B2), ')sin',num2str(wd),'t]'],'color',[0.9 0 0.8])
      xlabel(['\alpha = ',num2str(alpha), ',  \omega_0 = ',  num2str(w0), '  (U.D.)          t, sec'])
      ylabel('i, Amps')
      else 
      % Undamped Response   
      tf = 8*pi/w0;
      t=0:tf/200:tf;
      wd= w0; 
      B1 = I0; B2 = di/wd;
      B1i = V0 - Vs; B2i = dv/wd;
      vC=Vs + (B1i*cos(wd*t)+B2i*sin(wd*t));
      i = (B1*cos(wd*t)+B2*sin(wd*t));
      vR = R*i;
      vL= Vs -vR-vC;
      vt=vR+vL+vC;

      plot(t,i,'erasemode','none','color',[0.9 0 0.80]), grid
      title(['i(t) = (', num2str(B1), ')cos',num2str(wd),'t + (' , num2str(B2), ')sin',num2str(wd),'t'],'color',[0.9 0 0.8])
      xlabel(['\alpha = ',num2str(alpha), ',  \omega_0 = ',  num2str(w0), '  (Undamped)          t, sec'])
      ylabel('i, Amps')
      end
   elseif alpha ==w0   
    % Critically damped response
    s(1)=-alpha;  s(2) = s(1);
    D2 = I0; 
    D1 = di+alpha*D2;
    D2i = V0 - Vs; D1i = dv+alpha*D2i;   
    tf = 8/alpha;
    t=0:tf/100:tf;
    vC=Vs + exp(-alpha*t).*(D1i*t+D2i); 
    i = exp(-alpha*t).*(D1*t+D2);         
    vR = R*i;
    vL= Vs -vR-vC;
    vt=vR+vL+vC;
    plot(t,i,'erasemode','none','color',[0.9 0 0.8]), grid
    title(['i(t) = e^{(-', num2str(alpha), 't)}[(', num2str(D1), ')t + (' , num2str(D2), ')]'],'color',[0.9 0 0.8])
    xlabel(['\alpha = ',num2str(alpha), ',  \omega_0 = ',  num2str(w0), '  (C.D.)          t, sec'])
    ylabel('i, Amps')
    else, end
    
    
    
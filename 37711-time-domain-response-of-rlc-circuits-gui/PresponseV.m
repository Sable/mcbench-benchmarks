% This program obtains the analytical step response of a parallel RLC 
% circuit. In addition, graphs of the voltage across the parallel 
% combination and branch currents are obtained.  
% H. Saadat, Copyright 1999 

function PresponseV
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
Rhandle=findobj('Tag','IStext');
Is=eval(get(Rhandle,'String'));
Rhandle=findobj('Tag','I0text');
I0=eval(get(Rhandle,'String'));
Rhandle=findobj('Tag','V0text');
V0=eval(get(Rhandle,'String'));
% Step Response of a parallel RLC circuit
if L==inf | C==inf 
   plot(0, 0)
   text(-0.8, 0.80, 'Parameters must lie in the following ranges:', 'color', [0 0 0.6275])
   text(-0.8, 0.65, '0 < R \leq inf,   0 < L < inf,   &    0 < C < inf', 'color', [0 0 0.6275])
   text(-0.8, 0.5, 'Enter the correct value and press Solve', 'color', [0 0 0.6275])
   axis([-1  1  -1  1]);return,  else
end
if R==0 | L==0 | C == 0
   plot(0, 0)
   title('Short-circuit across the parallel circuit', 'color', [ 1 0 0])
   text(-0.8, 0.80, 'Parameters must lie in the following ranges:', 'color', [0 0 0.6275])
   text(-0.8, 0.65, '0 < R \leq inf,   0 < L < inf,   &    0 < C < inf', 'color', [0 0 0.6275])
   text(-0.8, 0.5, 'Enter the correct value and press Solve', 'color', [0 0 0.6275])
   axis([-1  1  -1  1]);return,  else
   alpha =1/(2*R*C);
end
w02 = 1/(L*C); w0 = sqrt(w02); 
if alpha~= 0
   err=(alpha-w0)/alpha;
   if abs(err) <1e-4
   w0=alpha; 
   else, end
else, end   
dv = Is/C-I0/C-V0/(R*C);
di = V0/L;
if alpha > w0
 % Overdamped response
    s(1) = -alpha + sqrt(alpha^2 - w02);
    s(2) = -alpha - sqrt(alpha^2 - w02);
    A1 = (dv-s(2)*V0)/(s(1)-s(2));
    A2 = (dv-s(1)*V0)/(s(2)-s(1));
    A1i =(di-s(2)*(I0-Is))/(s(1)-s(2));
    A2i =(di-s(1)*(I0-Is))/(s(2)-s(1));
    tf = 6*max(abs(1/s(1)), abs(1/s(2)));
    t=0:tf/100:tf;
    v = A1*exp(s(1)*t)+A2*exp(s(2)*t); 
    iL=Is + A1i*exp(s(1)*t)+A2i*exp(s(2)*t); 
    iR = v/R;
    iC= Is -iR-iL;
    it=iR+iL+iC;
    plot(t,v,'erasemode','none','color',[0.9 0 0.8]), grid
    title(['v(t) = (', num2str(A1), ') e^{(', num2str(s(1)), 't)} + (', num2str(A2), ') e^{(', num2str(s(2)), 't)}'],'color',[0.9 0 0.8])
    xlabel(['\alpha = ',num2str(alpha), ',  \omega_0 = ',  num2str(w0), '  (O.D.)          t, sec'])
    ylabel('v(t), Volts')
    elseif alpha < w0   
     if alpha~=0
      % Underdamped response
      tf = 6/alpha;
      t=0:tf/200:tf;
      wd= sqrt(w02 - alpha^2); 
      s(1) = -alpha +j*wd;
      s(2) = -alpha -j*wd;
      B1 = V0; B2 = (dv+alpha*B1)/wd;
      B1i = I0 - Is; B2i = (di+alpha*B1i)/wd;
      v = exp(-alpha*t).*(B1*cos(wd*t)+B2*sin(wd*t));
      iL = Is + exp(-alpha*t).*(B1i*cos(wd*t)+B2i*sin(wd*t));
      iR = v/R;
      iC= Is -iR-iL;
      it=iR+iL+iC;
      plot(t,v,'erasemode','none','color',[.9 0 0.8]), grid
      title(['v(t) = e^{(-', num2str(alpha), 't)}[(', num2str(B1), ')cos',num2str(wd),'t + (' , num2str(B2), ')sin',num2str(wd),'t]'],'color',[0.9 0 0.8])
      xlabel(['\alpha = ',num2str(alpha), ',  \omega_0 = ',  num2str(w0), '  (U.D.)          t, sec'])
      ylabel('v(t), Volts')
      else 
      % Undamped Response   
      tf = 8*pi/w0;
      t=0:tf/200:tf;
      wd= w0; 
      B1 = V0; B2 = (dv)/wd;
      B1i = I0 - Is; B2i = (di)/wd;
      iL = Is + B1i*cos(wd*t)+B2i*sin(wd*t);
      v = B1*cos(wd*t)+B2*sin(wd*t);
      iR = v/R;
      iC= Is -iR-iL;
      it=iR+iL+iC;
      plot(t,v,'erasemode','none','color',[0.9 0 0.80]), grid
      title(['v(t) = (', num2str(B1), ')cos',num2str(wd),'t + (' , num2str(B2), ')sin',num2str(wd),'t'],'color',[0.9 0 0.8])
      xlabel(['\alpha = ',num2str(alpha), ',  \omega_0 = ',  num2str(w0), '  (Undamped)          t, sec'])
      ylabel('v(t), Volts')
      end
   elseif alpha ==w0   
    % Critically damped response
    s(1)=-alpha;  s(2) = s(1);
    D2 = V0; 
    D1 = dv+alpha*D2;
    D2i = I0 - Is; D1i = di+alpha*D2i;   
    tf = 8/alpha;
    t=0:tf/100:tf;
    iL=Is + exp(-alpha*t).*(D1i*t+D2i); 
    v = exp(-alpha*t).*(D1*t+D2);         
    iR = v/R;
    iC= Is -iR-iL;
    it=iR+iL+iC;
    plot(t,v,'erasemode','none','color',[0.9 0 0.8]), grid
    title(['v(t) = e^{(-', num2str(alpha), 't)}[(', num2str(D1), ')t + (' , num2str(D2), ')]'],'color',[0.9 0 0.8])
    xlabel(['\alpha = ',num2str(alpha), ',  \omega_0 = ',  num2str(w0), '  (C.D.)          t, sec'])
    ylabel('v(t), Volts')
    else, end
  
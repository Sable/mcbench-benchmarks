%% Crystal Ladder filter made from 6.188 MHz xtals
% Copyright 2006-2013 The Mathworks, Inc.
% Dick Benson
clear all
clc

% xtal parameters are from actual measurements 
Rx       = 20;         %  nominal series R loss
Cseries  = 24.5e-15;   %  series C
Lseries  = 0.027;      %  series L
Cpar     = 5.3e-12;    %  parallel C, no holder
f_series = 6.188200e6; % nominal series resonant freq

f        = 6.185e6:20:6.1925e6;  % freq vector for analysis       

%  A simple loop to compare the freq response with ideal components
%  with the response using standard values 
for k=1:2
  if k==1
     % ideal values
     Ro  = 0; % no loss in the "perfect" xtal
     Zo  =   334.1;    % ideal impedance
     Cp1 =   65.5e-12;
     Cp2 =   80.8e-12;
     Cp3 =   83.8e-12;
     Cp4 =   84.4e-12;

     Cs1 =   80.8e-12;
     Cs2 =   300.3e-12;
     Cs3 =   259.4e-12;

elseif k==2
     % real world values
     Ro  =  Rx;    % from xtal measurments
     Zo  =  330;;  % 334.1;
     Cp1 =  68e-12; % 65.5e-12;
     Cp2 =  82e-12; % 80.8e-12;
     Cp3 =  91e-12; % 83.8e-12;
     Cp4 =  91e-12; % 84.4e-12;

     Cs1 =  82e-12; % 80.8e-12;
     Cs2 =  330e-12; % 300.3e-12;
     Cs3 =  250e-12; % 259.4e-12;
 
    
  end
  
  % model the xtal
    rlc_1  = rfckt.seriesrlc('R',Ro,'L',Lseries,'C',Cseries);
    c_1    = rfckt.seriesrlc('R',0,'L',0,'C',Cpar);
    Xtal   = rfckt.parallel('Ckts',{rlc_1,c_1});

  % create a series of subnetworks from caps and xtals
  Cs  =  rfckt.seriesrlc('C',Cs1);
  Cp  =  rfckt.shuntrlc('C',Cp1);
  N1  =  rfckt.cascade('CKTS',{Cs,Xtal,Cp});
   
  Cp  =  rfckt.shuntrlc('C',Cp2);
  N2  =  rfckt.cascade('CKTS',{Xtal,Cp});
   
  Cs  =  rfckt.seriesrlc('C',Cs2);
  Cp  =  rfckt.shuntrlc('C',Cp3);
  N3  =  rfckt.cascade('CKTS',{Cs,Xtal,Cp});
   
   
  Cs  =  rfckt.seriesrlc('C',Cs3);
  Cp  =  rfckt.shuntrlc('C',Cp4);
  N4  =  rfckt.cascade('CKTS',{Cs,Xtal,Cp});
   
   
  Cs  =  rfckt.seriesrlc('C',Cs3);
  Cp  =  rfckt.shuntrlc('C',Cp3);
  N5  =  rfckt.cascade('CKTS',{Cs,Xtal,Cp});
   
  Cs  =  rfckt.seriesrlc('C',Cs2);
  Cp  =  rfckt.shuntrlc('C',Cp2);
  N6  =  rfckt.cascade('CKTS',{Cs,Xtal,Cp});
   
  Cp  =  rfckt.shuntrlc('C',Cp1);
  N7  =  rfckt.cascade('CKTS',{Xtal,Cp});
   
  Cs  =  rfckt.seriesrlc('C',Cs1);
  N8  =  rfckt.cascade('CKTS',{Cs,Xtal});
   

  if k==1   
     Nideal   =  rfckt.cascade('CKTS',{N1,N2,N3,N4,N5,N6,N7,N8});  
     analyze(Nideal,f,Zo,Zo,Zo);
     h = plot(Nideal,'S21');
     set(h,'color',[0 0 0])
     hold on  
  elseif k==2
     Nreal   =  rfckt.cascade('CKTS',{N1,N2,N3,N4,N5,N6,N7,N8});   
     analyze(Nreal,f,Zo,Zo,Zo);
     h = plot(Nreal,'S21'); 
     title('Xtal Filter, black=ideal components red=realistic components');
     set(h,'color',[1 0 0])
     hold off
  end
  
  
  
  set(gca,'YLim',[-100,10])
  title('Xtal Filter, black=ideal components red=realistic components');
  drawnow
  
end
%% passband detail
set(gca,'Xlim',[6.1882,6.1913],'YLim',[-8,2])





    
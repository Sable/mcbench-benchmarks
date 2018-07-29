% 
% VIKINGASKEPP -- THE _ANIMATED_ REVENGE
%
%    Huvudprogram, nu med animerade åror, vimpel och vatten.
%
%    Överarbetning av laboration 3:10, Numeriska Metoder gkII.
%    Pontus Axelsson (d94-pax) & Fredrik Sandberg (d94-fsa).

clear,clf,format compact

global rpos botten nx ny wpos wneg % What can I say... they're all needed.

global oars         % En vektor med OBJECT HANDLES till de sex årorna.
global spunkter     % Vattnets skärningspunkter med skrovet.
global vimpel       % Ett OBJECT HANDLE till vimpeln.
noofframes=40;      % Totalt antal frames i hela animationen.

vikingplot;              % Plotta vikingaskepp utan åror.
water=watersurface;      % Beräkna vattenlinjen.
waterplot(0,water,'b');  % Plotta vattnet i ursprungsläge.
watervelvec=[];          % Initiera vattnets positionsvektor.
oarplot;                 % Plotta åror med konstanta x-värden. Sätt 'oars'.
newamplitude=0.5;        % Utgångsamplitud för vimpeln.
vimpelplot(newamplitude);% Plotta vimpeln med amplitud 0.5.

% Utgångspositioner för årorna.
for i=1.5:0.5:2.5
  rotate(oars(i/0.5-2),[0 0 1],-2*1/6*noofframes,[i 0.8 0.6-40*0.02])
  rotate(oars(i/0.5+1),[0 0 1],2*1/6*noofframes,[i -0.8 0.6-40*0.02])
end

disp('Frame no.:')

% Uppbyggnad av movie matrix M.
M=moviein(noofframes);
for i=1:noofframes
  title('Generating frames...')
  disp(i)

  delete(vimpel)
  newamplitude=newamplitude-sign(20-i-0.1)*1/20;
  vimpelplot(newamplitude);
  
  delete(wpos), delete(wneg)
%  watervelocity=(25-i)/24;
%  watervelvec=[watervelvec watervelocity*i/noofframes];

  if i<=5
    for j=1.5:0.5:2.5
      % Rotation kring x-axeln.
      rotate(oars(j/0.5-2),[1 0 0],-1,[j 0.8 0.6-40*0.02])
      rotate(oars(j/0.5+1),[1 0 0],1,[j -0.8 0.6-40*0.02])
      % Rotation kring y-axeln.
%      rotate(oars(j/0.5-2),[0 1 0],90/12.5,[j 0.8 0.6-40*0.02])
%      rotate(oars(j/0.5+1),[0 1 0],90/12.5,[j -0.8 0.6-40*0.02])
    end
    waterplot(i*2*pi/noofframes,water,'b');

  elseif i<=20
    for j=1.5:0.5:2.5
      % Rotation kring z-axeln.
      rotate(oars(j/0.5-2),[0 0 1],2,[j 0.8 0.6-40*0.02])
      rotate(oars(j/0.5+1),[0 0 1],-2,[j -0.8 0.6-40*0.02])
      % Rotation kring y-axeln.
%      rotate(oars(j/0.5-2),[0 1 0],sign(12.5-i)*90/12.5,[j 0.8 0.6-40*0.02])
%      rotate(oars(j/0.5+1),[0 1 0],sign(12.5-i)*90/12.5,[j -0.8 0.6-40*0.02])
    end
    waterplot(i*2*pi/noofframes,water,'b');

  elseif i<=25
    for j=1.5:0.5:2.5
      % Rotation kring x-axeln.
      rotate(oars(j/0.5-2),[1 0 0],1,[j 0.8 0.6-40*0.02])
      rotate(oars(j/0.5+1),[1 0 0],-1,[j -0.8 0.6-40*0.02])
      % Rotation kring y-axeln.
%      rotate(oars(j/0.5-2),[0 1 0],-90/12.5,[j 0.8 0.6-40*0.02])
%      rotate(oars(j/0.5+1),[0 1 0],-90/12.5,[j -0.8 0.6-40*0.02])
    end
    waterplot(i*2*pi/noofframes,water,'b');

  else
    for j=1.5:0.5:2.5
      % Rotation kring z-axeln.
      rotate(oars(j/0.5-2),[0 0 1],-2,[j 0.8 0.6-40*0.02])
      rotate(oars(j/0.5+1),[0 0 1],2,[j -0.8 0.6-40*0.02])
    end
    % waterplot((1-sum(watervelvec))/15*(i-25)*2*pi,water,'b');
    waterplot(i*2*pi/noofframes,water,'b');

  end

  M(:,i)=getframe;
end

% Uppspelning.
title('Roddbåt DeLuxe av d94-fsa och d94-pax')

timestoplay=20;
movie(M,timestoplay);

% Återinställningar.
format
return














function f=watersurface()

% Beräkning av vattenlinjen medelst sekantmetoden.

global spunkter rpos botten nx ny

vikt=.5; 		% Farkostens vikt angett i ton.
zguess1=0.3;		% Gissningar av vattenlinjens höjd
zguess2=0.4;		% för lösning med sekantmetoden.
spunkter=[];		% Skärningspunkter med vattnet,
                        % för att kunna plotta detsamma.
iter=0; zfel=1;
[spunkter v1]=volymunder(rpos,botten,nx,ny,zguess1);
v1=v1-vikt;             % Ger avvikelsen från den önskade volymen.
while abs(zfel)>1e-4 & iter<10
  [spunkter v2]=volymunder(rpos,botten,nx,ny,zguess2);
  v2=v2-vikt;
  zfel=(zguess2-zguess1)/(v2-v1)*v2;
  zguess1=zguess2;
  v1=v2;
  zguess2=zguess2-zfel;
  iter=iter+1;
end

f=zguess2;
Vattenlinje=f

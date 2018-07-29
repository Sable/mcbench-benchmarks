%
% VOLYMUNDER
%
% Beräknar volymen av båten under ett visst z-värde.
% Returnerar dessutom 'spunkter' som är en vektor av skärningspunkter
% med planet zguess. Volymen integreras i x-led över snittareorna i
% båten. Dessa räknas ut genom att hitta snittets bézierkurvas t-värde
% för där fz(t)=z (Löses med Newton-Raphson.). Sedan kan arean av snittet
% Räknas ut m.h.a. 'areaunder'.

function [spunkter, volym] = volymunder(rpos,botten,nx,ny,zguess)

volym=0; spunkter=[];
for i=1:nx
  Q=rpos(i,:); P=botten(i,:);
  b=Q+[0 0 -1]*0.4*norm(Q-P);
  c=P+[0 1 1]/sqrt(2)*0.6*norm(Q-P);
  
  if P(3)<zguess            % Existerar det någon area?
    err=1;
    tguess=0.5;
    while abs(err)>1e-5
      t=tguess-(fz(Q,b,c,P,tguess)-zguess)/dfz(Q,b,c,P,tguess);
      err=t-tguess;
      tguess=t;
    end
    spunkter=[spunkter;[rpos(i,1) fy(Q,b,c,P,tguess)]];
    arean=(fy(Q,b,c,P,tguess)*fz(Q,b,c,P,tguess)+areaunder(Q,b,c,P,tguess));
  else
    arean=0;	
  end
  
  if i>1
    volym=volym+2*(rpos(i,1)-oldx)*(oldarea+arean)/2;
  end
  oldarea=arean;
  oldx=rpos(i,1);
end



% ##############################################################################
% ##  pb_psk_ray.m : Bestimmung der BER bei PSK und Rayleigh Kanal, koh. Det. ##
% ##############################################################################
%
% function [Ps,Pb] = pb_psk_ray (EbN0db,M,L,map);
% benoetigt: bin_coef
% ------------------------------------------------------------------------------
% EINGABE:
%   EbN0db: Signal/Noise pro Infobit [db]
%           (Spalten- oder Zeilenvektor)
%        M: Stufigkeit der Modulation (default=2)
%           (Skalar)
%        L: Anzahl der Pfade (default=1)
%           (Skalar)
%      map: Art des Mappings
%           'gray' (default)
%             Gray-Codierung
%           'nat'
%             natuerliches Mapping
%           (string)
%
% AUSGABE:
%   Ps: Symbolfehlerwahrscheinlichkeit (Spaltenvektor)
%   Pb: Bitfehlerwahrscheinlichkeit (Spaltenvektor)
%
% ANMERKUNGEN:
%   - exakte Loesungen
%   - M>=8 nur bis L=2
%
% QUELLE:
%   2-PSK(BPSK) [Kam96, S.670,(16.3.26)] [Ben96, S.66,(4.120)]
%               [Pro95, S.781,(14-4-15)]
%   4-PSK(QPSK) [Pro95,S.786,(14-4-38)]
%   M-PSK       [Pro68]
%
% AUTOR: Juergen Rinas,  08.12.1998
% Erweitert um Symbolfehlerraten von Volker Kuehn, 04.01.01
% ------------------------------------------------------------------------------

function [Ps,Pb] = pb_psk_koh_ray (EbN0db,M,L,map);

if (nargin<2) M=2; end;        % default: M=2
if (nargin<3) L=1; end;        % default: L=1
if (nargin<4) map='gray'; end; % default: map='gray'
K=log2(M);
if (K~=fix(K))
  disp(['# Achtung(',mfilename,') M ist keine Potenz von 2.']);
end;

EbN0=10.^(EbN0db(:)./10);
Pb=zeros(length(EbN0),1);

if (M==2)
  % Pro95 S.781 (14-4-15) == Pro95 S.774 (14-3-7) fuer L=1
  gammac=EbN0/L;
  alpha=sqrt(gammac./(1+gammac));

  % Schleife notwendig, da laufender Index im Exponenten!
  Pb=zeros(length(EbN0),1);
  for mu=0:(L-1)
    Pb=Pb + bin_coef(L-1+mu,mu) * ((1+alpha)/2).^mu;
  end;

  Pb=Pb.*((1-alpha)/2).^L;
  Ps=Pb;
elseif ((M==4) & (upper(map(1))=='G'))
  gammac=K/L*EbN0;
  mu=sqrt(gammac./(1+gammac));

  Pb=zeros(length(EbN0),1);
  for k=0:(L-1)
    Pb=Pb + bin_coef(2*k,k) * ((1-mu.^2)./(4-2*mu.^2)).^k;
  end;

  Pb=.5 - .5*Pb.*mu./(sqrt(2-mu.^2));
elseif ((M==8) & (L==1) & (upper(map(1))=='G'))
  gammac=K/L*EbN0;
  mu=sqrt(gammac./(1+gammac));

  A=mu*sqrt(1-1/sqrt(2));
  A2=A.^2;

  B=mu*sqrt(1+1/sqrt(2));
  B2=B.^2;

  Pb=1/(3*pi)*...
    ( 3*pi/2 ...
     - A./sqrt(2-B2).*acotpi( -B./sqrt(2-B2))...
     - B./sqrt(2-A2).*acotpi( -A./sqrt(2-A2))...
     );
end

if M>2  % BPSK schon fertig
  % Hamming-Gewichte berechnen
  coeff=pskweight(K,map)/K;

  gammac=K/L*EbN0;
  mu=sqrt(gammac./(1+gammac)); % PSK

  % Loesungen der Teilintegrale gewichten und aufsummieren
  Ps=zeros(length(EbN0),1);
  for i=1:length(coeff)/2
    Theta1=pi/M+ 2*pi/M *(i-1);
    Theta2=pi/M+ 2*pi/M*(i);
    if Theta2>pi, Theta2=pi; end;

    if (L==1)
      Pint1= 1 / (2*pi).* ( mu*sin(Theta1)...
                           ./sqrt(1-(mu*cos(Theta1)).^2)...
                           .*acotpi( -mu*cos(Theta1)...
                                    ./sqrt(1-(mu*cos(Theta1)).^2)...
                                    )...
                           +Theta1...
                           );

      Pint2= 1 / (2*pi).* ( mu*sin(Theta2)...
                           ./sqrt(1-(mu*cos(Theta2)).^2)...
                           .*acotpi( -mu*cos(Theta2)...
                                    ./sqrt(1-(mu*cos(Theta2)).^2)...
                                    )...
                           +Theta2...
                           );
    elseif (L==2)
      Pint1= 1 / (2*pi).* ( mu*sin(Theta1)...
                           ./sqrt(1-(mu*cos(Theta1)).^2)...
                           .*acotpi( -mu*cos(Theta1)...
                                    ./sqrt(1-(mu*cos(Theta1)).^2)...
                                    )...
                           +Theta1...
                           )...
        + (1-mu.^2)/(4*pi).*(...
                             mu*sin(Theta1)...
                             ./(1-(mu*cos(Theta1)).^2).^(3/2)...
                             .*acotpi( -mu*cos(Theta1)...
                                      ./sqrt(1-(mu*cos(Theta1)).^2)...
                                      )...
                             + (mu.^2.*sin(Theta1).*cos(Theta1))...
                             ./(1-mu.^2.*cos(Theta1).^2)...
                             );
      Pint2= 1 / (2*pi).* ( mu*sin(Theta2)...
                           ./sqrt(1-(mu*cos(Theta2)).^2)...
                           .*acotpi( -mu*cos(Theta2)...
                                    ./sqrt(1-(mu*cos(Theta2)).^2)...
                                    )...
                           +Theta2...
                           )...
        + (1-mu.^2)/(4*pi).*(...
                             mu*sin(Theta2)...
                             ./(1-(mu*cos(Theta2)).^2).^(3/2)...
                             .*acotpi( -mu*cos(Theta2)...
                                      ./sqrt(1-(mu*cos(Theta2)).^2)...
                                      )...
                             + (mu.^2.*sin(Theta2).*cos(Theta2))...
                             ./(1-mu.^2.*cos(Theta2).^2)...
                             );
    end;

    Ps=Ps+(Pint2-Pint1);
    if (i<M/2)
      Ps=Ps+(Pint2-Pint1);
    end

    if ((M>8) | (upper(map(1))~='G') | (L>1))
      Pb=Pb+coeff(i+1)*(Pint2-Pint1);
      if (i<M/2)
        Pb=Pb+coeff(M-i+1)*(Pint2-Pint1);
      end
    end;
  end;
end;  % if M>2

% ### EOF ######################################################################

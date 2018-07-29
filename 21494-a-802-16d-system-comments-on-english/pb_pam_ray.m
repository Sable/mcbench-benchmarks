% function [Ps,Pb] = pb_pam_koh_ray (EbN0db,M,L,map);
% ------------------------------------------------------------------------------
% EINGABE:
%   EbN0db: Signal/Noise pro Infobit [db] 
%           (Skalar, Spalten- oder Zeilenvektor)
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
%   - benoetigt pb_psk_ray_co.m und graytable.m
%
% AUTOR: Juergen Rinas,  08.12.1998
% Erweitert um Symbolfehlerraten und Mapping von Volker Kuehn, 04.01.01
% ------------------------------------------------------------------------------

function [Ps,Pb] = pb_pam_koh_ray (EbN0db,M,L,map)

if (sscanf(version,'%d')<5) 
  disp(['# Achtung: ',mfilename,' wurde unter Matlab 5.1 entwickelt.']); 
end;
if (nargin<2) M=2; end;        % default: M=2
if (nargin<3) L=1; end;        % default: L=1
if (nargin<4) map='gray'; end; % default: map='gray'
K=log2(M);
if (K~=fix(K))
  disp(['# Achtung(',mfilename,') M ist keine Potenz von 2.']); 
end;

EbN0=10.^(EbN0db(:)./10);
EsN0=K*EbN0;

if (upper(map(1))=='N')
   codetable=nattable(K);
else
   codetable=graytable(K); 
end

% mittlere Leistung des PAM-Signals [Pro95,S.267,(5-2-40)]
P0=1/6*(M^2-1)*(0.5^2)*2;

% Berechnung der Gewichtung
P=zeros(M-1,1);
for APriori=1:M
  
  AP=codetable(APriori,:);
  
  for RXdiff=1:M-1
    
    for RX=[APriori-RXdiff APriori+RXdiff]
      
      Pidx=abs(APriori-RX);
      RX=max(RX,1);
      RX=min(RX,M);
      P(Pidx)=P(Pidx)+ sum(AP~=codetable(RX,:));
    end;
    
  end;
  
end;
P=P/M/K;

% Umsortieren der Gewichte, Zusammenfassen gleicher erfc-Terme
Pw=zeros(length(P),1);
for i=1:length(P)-1
  Pw(i)=Pw(i)+P(i);
  Pw(i+1)=Pw(i+1)-P(i);
end;
i=length(P);
Pw(i)=Pw(i)+P(i);

% Berechnung und Gewichtung der Wahrscheinlichkeiten
Pb=zeros(length(EsN0),1);
Ps=zeros(length(EsN0),1);
for i=1:length(Pw)
  [u,v]=pb_psk_ray(10*log10( (i-0.5)^2*EsN0/P0 ),2,L);
  Pb=Pb+Pw(i)*v;
  Ps=Ps+v;
end;

% EOF --------------------------------------------------------------------------

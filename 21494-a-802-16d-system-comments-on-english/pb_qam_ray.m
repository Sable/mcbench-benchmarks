% function [Ps,Pb] = pb_qam_koh_ray (EbN0db,M,L,map);
% ------------------------------------------------------------------------------
% EINGABE:
%   EbN0db: Signal/Noise pro Infobit [db] 
%           (Skalar, Spalten- oder Zeilenvektor)
%        M: Stufigkeit der Modulation (default=4)
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
%  - benoetigt pb_pam_ray_co.m
%
% AUTOR: Juergen Rinas,  08.12.1998
% Erweitert um Symbolfehlerraten und Mapping von Volker Kuehn, 04.01.01
% ------------------------------------------------------------------------------

function [Ps,Pb] = pb_qam_koh_ray (EbN0db,M,L,map)

if (sscanf(version,'%d')<5) 
  disp(['# Achtung: ',mfilename,' wurde unter Matlab 5.1 entwickelt.']); 
end;
if (nargin<2) M=4; end;        % default: M=4
if (nargin<3) L=1; end;        % default: L=1
if (nargin<4) map='gray'; end; % default: map='gray'
K=log2(M);
if (K~=fix(K))
  disp(['# Achtung(',mfilename,') M ist keine Potenz von 2.']); 
end;
sqrtM=sqrt(M);
if (sqrtM~=fix(sqrtM))
  disp(['# Achtung(',mfilename,') sqrt(M) ist keine ganze Zahl.']); 
end;

[tmp,Pb]=pb_pam_ray(EbN0db,sqrt(M),L,map);
Ps=2*tmp-tmp.^2;

% EOF --------------------------------------------------------------------------

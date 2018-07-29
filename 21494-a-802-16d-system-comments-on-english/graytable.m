% ##############################################################################
% ##  graytable.m : Tabelle mit Gray-Code erstellen                           ##
% ##############################################################################
%
% function [gt] = graytable(K)
% ------------------------------------------------------------------------------
% EINGABE:
%      K: Stellen in der Gray-Code-Tabelle
%         (Skalar)
%
% AUSGABE:
%   gt: Gray-Code-Tabelle
%       ( (2^K,K)-Matrix  )
%
% BEISPIEL:
%    » graytable(2)
%    ans =
%       0     0
%       0     1
%       1     1
%       1     0
%
% AUTOR: Juergen Rinas,  08.12.1998
% ------------------------------------------------------------------------------

function [gt] = graytable(K)

gt=[0;1];
for i=1:(K-1)
  gt=[zeros(length(gt),1) gt; ones(length(gt),1) flipud(gt)];
end;

% ### EOF ######################################################################

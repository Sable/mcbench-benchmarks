function [Psw,Pww,Pws,Pss]=sstrat(Gs,Qs,Gw,Qw)

% [Psw,Pww,Pws,Pss]=sstrat(Gs,Qs,Gw,Qw); service strategy
% given the numbers GW, probability of the weak 
% service being good, QW, probability of winning 
% the point if the weak service is good, 
% GS, probability of the strong service being good, 
% QS, probability of winning the point if the weak 
% service is good, then the probabilities of winning 
% the point using the strategies 1) strong service 
% followed by a weak one, 2) weak followed by weak, 
% 3) weak an then strong, 4) strong followed by strong. 
% are computed.

% Giampy Jan 04

Psw=Gs*Qs+(1-Gs)*Gw*Qw;
Pww=Gw*Qw+(1-Gw)*Gw*Qw;
Pws=Gw*Qw+(1-Gw)*Gs*Qs;
Pss=Gs*Qs+(1-Gs)*Gs*Qs;

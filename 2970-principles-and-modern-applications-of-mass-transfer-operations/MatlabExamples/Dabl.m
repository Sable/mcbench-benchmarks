function y=DABL(TbA,TcA,PcA,VA,TbB,TcB,PcB,VB,T,muB)
%DABL Calculates liquid-phase diffusivity from Hayduk-Minhas correlation 
%   for non-aqueous dilute solutions of solute A in solvent B, p. 24, text.
%   DABL(TbA,TcA,PcA,VA,TbB,TcB,PcB,VB,T,muB)
%   Tb = normal boiling point in K; Tc = critical temperature in K
%   Pc = critical pressure in bar; V = liquid molar volume, cm3/mole
%   T = absolute temperature in K; muB = solvent viscosity in cP
%   DABL = diffusivity in square cm/sec.
TbrA=TbA/TcA; TbrB=TbB/TcB;
alphacA=0.9076*(1+(TbrA*log(PcA/1.013))/(1-TbrA));
alphacB=0.9076*(1+(TbrB*log(PcB/1.013))/(1-TbrB));
sigmaA=PcA^(2/3)*TcA^(1/3)*(0.132*alphacA-0.278)*(1-TbrA)^(11/9);
sigmaB=PcB^(2/3)*TcB^(1/3)*(0.132*alphacB-0.278)*(1-TbrB)^(11/9);
y=1.55*10^(-8)*VB^0.27*T^1.29*sigmaB^0.125/(VA^0.42*muB^0.92*sigmaA^0.105)

% objective function when omega is fixed
% For a given omega, find the {a,b} in linear Ls sense
% Written by Dr Chen YangQuan <yqchen@ieee.org> 
function y=jomega(x,s0,t0,Ts) 
[Ahat,Theta,RMS]=sinefit2(s0,x,t0,Ts); 
y=RMS; 
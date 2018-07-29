function Show_EWT(ewt,f,rec)

% ====================================================================
% function Show_EWT(f,ewt)
%
% This function plots the successive filtered components (low scale 
% first and then wavelets scales). The original and
% reconstructed signals are plotted on a different graph.
% If f and rec are provided, it also plot the original and reconstructed
% signals on a separate figure
%
% Inputs:
%   -ewt: EWT components
%   -f: input signal  (OPTIONNAL)
%   -rec: reconstructed signal (OPTIONNAL)
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2012
% Version: 1.0
% =====================================================================

%These lines plot the EWT components
figure;
x=0:1/length(ewt{1}):(length(ewt{1})-1)/length(ewt{1});
l=1;
if length(ewt)>6
    lm=6;
else
    lm=length(ewt);
end

for k=1:length(ewt)
   hold on; subplot(lm,1,l); plot(x,ewt{k});
   if mod(k,6) == 0
        figure;
        l=1;
   else
    l=l+1;
   end
end

%These lines plot f and its reconstruction
if nargin>1
    figure;
    subplot(2,1,1);plot(x,f);
    subplot(2,1,2);plot(x,rec);
end
%Author: Alex Dytso
%Date:06/13/2012
%Project: Zero Forcing Equalizer
%Discription: Zero Forcing Equalizer is a type of linear equalizers used to
%combat ISI(inter symbol interference). This codes is a demostration of a
%simple implemenation of Zero Forcing Equalizer using MatLab tools.
% A typical channel is model in discrete domain as:

%%%%%%  y[n]=h[n]*x[n]+z[n]
% where y[n] is channel output, x[n] is channel input, h[n] is channal
% impulse response, z[n] is AWGN nosise

% We can convert channel to frequency domain as follows:
%  Y(f)=H(f)X(f)+Z(f)
% Zero-forcing equalizer multiplies  Y(f) by inv(H(f))
% inv(H(f))Y(f)=X(f)+inv(H(f))Z(f)
% thus we essancially get an ISI free channel.
% The drawback is that noise is enhance



function Xh = ZF(h,r)
%r --- signal at the receiver
% h--- impulse response of the channel 

 %Computing inverse impulse response
gD=tf(h,1); %taking impulse response and transforming it to S domain
f=1/gD; % taking inverse of a transfer function
[num,den]=tfdata(f,'v'); % extracting numerator and denominator coefficients  

%Zero forcing
Xh=filter(num,den,r); % filtering 

Xh=Xh(2:end); %this done for techniqal reasons 
end


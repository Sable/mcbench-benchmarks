% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
%  deconvolution 


%vectors y and x and the time step are defined in the m-file c422.m


hh=deconv(y,x)*(1/step);

plot(t,hh)
ylim([-.1 1.1]);
legend('impulse response h(t)')

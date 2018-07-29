function [out1,out3]=harmonic(LB,UB,N,option)


%[out1,out3]=harmonic(LB,UB,N) computes the Harmonic Wavelet with the lower
%Bound as 'LB' Upper Bound as 'UB' and N being the number of points in the
%wavelet.
% if Option > 0, a Plot of the harmonic wavelet created will be made.
%           <=0, No plot will be done.
%
%The function basically is for computing Harmoonic wavelet transform for 
%Condition Monitoring of rotating equipments by vibration based bearing 
%fault diagnosis.
%
%Out1 gives the real part of the wavelet
%out2 gives the imaginary part of the wavelet
%
%Example:
%       h_h=harmonic(0,1.25,16,1);
%
%Dont forget to rate or comment on the matlab central site
%http://www.mathworks.in/matlabcentral/fileexchange/authors/258518
%
%https://sites.google.com/site/santhanarajarunachalam/
%Author:Santhana Raj.A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


i=1;
out3=linspace(LB,UB,N);
t=out3;
w=(exp(1i*2*i*pi*t)-exp(1i*i*pi*t))./(1i*i*pi*t);
if LB==0
    w(1)=i*1.000+1i*0.00;
  %  w(2)=w(1);
end

out1=real(w);
out2=imag(w);
if(option>0)
    figure();plot(out1); axis tight;
end

end


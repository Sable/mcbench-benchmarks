function [b,a]=allpass(n,Fst,Fed,mag,Fs)
%Creates an allpass filter
%
%Syntax:
%		>>[b,a]=allpass(n,Fst,Fed,mag,Fs) or
%		>>allpass(n,Fst,Fed,mag,Fs)
%
%where
%		n = number of pole/zero pairs
%		Fst = Start frequency of pole/zero pairs in Hz
%		Fed = End frequency of pole/zero pairs in Hz
%		mag = Magnitude of pole (should be less than 1)
%		Fs = Sample frequency in Hz
%		b = coefficients of the allpass filter numerator
%		a = coefficients of the allpass filter denominator
%
%Many systems require phase compensation.  An allpass filter provides
%just that without affecting magnitude response.  This function creates 
%a filter with a magnitude response of unity and n number of pole/zero 
%complex-conjugate pairs spaced evenly starting at Fst and ending at Fed.
%The order of the allpass filter is 2n.  The coefficients of the filter,
%b and a, are passed as output arguments.  ALLPASS can run without the 
%output arguments.  This will display the Pole-Zero plot and the frequency
%response of the filter.
%
%Ref: Oppenheim and Schafer, Discrete-Time Signal Processing,
%	 1989, pg 234-240.

%Dean P. Andersen
%Ventritex
%A St. Jude Medical Company
%1/8/98

%****  Inputs  ***********************************************************
if nargin ~= 5
   fprintf('\nNot enough input arguments for ALLPASS\n');
   return
else
end
if Fed<Fst
     fprintf('\nEnd frequency must be greater than start frequency for ALLPASS\n');
     return
else
end

f(1)=Fst;
if n~=1
     fdiv=(Fed-Fst)/(n-1);
     for k=2:n
          f(k)=(k-1)*fdiv+Fst;
     end
else
end
r=mag;									%magnitude


%****  Computation of poles and zeros  ************************************
for k=1:length(f)
     p(k)=r.*exp(i*2*pi*(f(k)/Fs));
end
a=1;										%initializing den
b=1;										%initializing num
for k=1:length(f)
     if imag(p(k))< 1*10^(-10)				%if p(k) is purely real
          p(k)=real(p(k));					%create only one pole/zero
          a=conv(a,[1 -p(k)]);
          b=conv(b,[-p(k) 1]);
     else
     a=conv(conv([1 -p(k)],[1 -conj(p(k))]),a);
     b=conv(conv([-p(k) 1],[-conj(p(k)) 1]),b);
	end
end


%****  Display Z Plane and Freq. Response  ********************************
if nargout ~=2			
     zplane(b,a);
     title('Z Plane of Allpass Filter');
     figure
     freqz(b,a,256,Fs);
     title('Frequency Response of Allpass Filter');
else
end

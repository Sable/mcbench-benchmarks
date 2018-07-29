% Theory:
%
% Overlap Add Method:
% The overlap–add method is an efficient way to evaluate the discrete convolution of a very long signal with a finite impulse response 
% (FIR) filter where h[m] = 0 for m outside the region [1, M].The concept here is to divide the problem into multiple convolutions of h[n] 
% with short segments of x[n], where L is an arbitrary segment length. Because of this y[n] can be written as a sum of short convolutions.
% 
% Algorithm:
% 
% The signal is first partitioned into non-overlapping sequences, then the discrete Fourier transforms of the sequences are evaluated by 
% multiplying the FFT xk[n] of with the FFT of h[n]. After recovering of yk[n] by inverse FFT, the resulting output signal is reconstructed by 
% overlapping and adding the yk[n]. The overlap arises from the fact that a linear convolution is always longer than the original sequences. In 
% the early days of development of the fast Fourier transform, L was often chosen to be a power of 2 for efficiency, but further development has 
% revealed efficient transforms for larger prime factorizations of L, reducing computational sensitivity to this parameter. 
% A pseudo-code of the algorithm is the following:
% 
% Algorithm 1 (OA for linear convolution)
%  Evaluate the best value of N and L
%    H = FFT(h,N)       (zero-padded FFT)
%    i = 1
%    while i <= Nx
%        il = min(i+L-1,Nx)
%        yt = IFFT( FFT(x(i:il),N) * H, N)
%        k  = min(i+N-1,Nx)
%        y(i:k) = y(i:k) + yt    (add the overlapped output blocks)
%        i = i+L
%    end
% 
% Circular convolution with the overlap–add method
% 
% When sequence x[n] is periodic, and Nx is the period, then y[n] is also periodic, with the same period.  To compute one period of y[n], 
% Algorithm 1 can first be used to convolve h[n] with just one period of x[n].  In the region M ? n ? Nx, the resultant y[n] sequence is correct.  
% And if the next M ? 1 values are added to the first M ? 1 values, then the region 1 ? n ? Nx will represent the desired convolution. 
% The modified pseudo-code is:
% 
% Algorithm 2 (OA for circular convolution)
%   Evaluate Algorithm 1
%   y(1:M-1) = y(1:M-1) + y(Nx+1:Nx+M-1)
%   y = y(1:Nx)
%   end
%

clc;
clear all;
Xn=input('Enter 1st Sequence X(n)= ');
Hn=input('Enter 2nd Sequence H(n)= ');
L=input('Enter length of each block L = ');

% Code to plot X(n)
subplot (2,2,1);
stem(Xn);
xlabel ('n---->');
ylabel ('Amplitude ---->');
title(' X(n)');

%Code to plot H(n)
subplot (2,2,2);
stem(Hn,'red');
xlabel ('n---->');
ylabel ('Amplitude ---->');
title(' H(n)');

% Code to perform Convolution using Overlap Add Method
NXn=length(Xn);
M=length(Hn);
M1=M-1;
R=rem(NXn,L);
N=L+M1;
Xn=[Xn zeros(1,L-R)];
Hn=[Hn zeros(1,N-M)];
K=floor(NXn/L);
y=zeros(K+1,N);
z=zeros(1,M1);
for k=0:K
Xnp=Xn(L*k+1:L*k+L);
Xnk=[Xnp z];
y(k+1,:)=mycirconv(Xnk,Hn); %Call the mycirconv function.
end
p=L+M1;
for i=1:K
y(i+1,1:M-1)=y(i,p-M1+1:p)+y(i+1,1:M-1);
end
z1=y(:,1:L)';
y=(z1(:))'

%Code to plot the Convolved Signal
subplot (2,2,3:4);
stem(y,'black');
xlabel ('n---->');
ylabel ('Amplitude ---->');
title('Convolved Signal');

% Add title to the Overall Plot
ha = axes ('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text (0.5, 1,'\bf Convolution using Overlap Add Method ','HorizontalAlignment','center','VerticalAlignment', 'top')
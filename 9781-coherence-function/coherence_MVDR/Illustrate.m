clear all

%% This program calls the main program "coherence_MVDR",
%% which computes the coherence function with the MVDR method

%example on how the coherence function works with the MVDR method
%see papers for more explanations

n       = 1024;         %number of samples
nT      = [0:n-1]';     %time axis
Nf      = 5;            %number of frequencies of high coherence
f       = zeros(Nf,1);
f(1) = 0.05; f(2) = 0.06; f(3) = 0.07; f(4) = 0.08; f(5) = 0.09;
%
fw      = 2*pi*f;
x1      = randn(n,1); %first signal
x2      = randn(n,1); %second signal
for i = 1:Nf
    x1  = x1 + cos(fw(i)*nT);
    x2  = x2 + cos(fw(i)*nT + 2*pi*rand(1,1));
end

%coherence with MATLAB
WL      = 100; %window length
[cx1x2,w] = cohere(x1,x2,WL);
%
figure(1);
%
subplot(2,1,1)
plot(w/2,cx1x2)
%legend('');
grid on;
ylabel('MSC');
title('(a)')
axis([0 1/2 0 1]);

%Coherence with the MVDR method
K = 200; %to increase resolution
L = 100; %window length
[MSC]=coherence_MVDR(x1,x2,L,K);
%
K2 = K/2;
MSCf = MSC(1:K2);
wwf = [0:1/K2:1-1/K2]';
%
subplot(2,1,2)
plot(wwf/2,MSCf)
grid on;
ylabel('MSC');
xlabel('Frequency');
title('(b)')
axis([0 1/2 0 1]);
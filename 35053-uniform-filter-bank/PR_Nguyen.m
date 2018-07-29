
function [analysis_filters,synthesis_filters]=PR_Nguyen(M,m)

% 
% 
% Written By:   Iman Moazzen
%               Dept. of Electrical Engineering
%               University of Victoria
% 
% 
% This function can be used to design a uniform filter bank (with M
% analysis and M synthesis filters) so that the perfect reconstruction is
% almost achieved. The method is based on the optimization technique proposed in
% [1].
% 
% M= Number of subbands
% m= A positive integer 
%
% 
% [analysis_filters,synthesis_filters] are analysis and synthesis filters'
% coefficients of the designed filter bank (each row is devoted to one filter). The
% length of all filters is 2*(m*M). The amplitude response of the
% analysis filters will be shown at the end.
%
% Example:
% [analysis_filters,synthesis_filters]=PR_Nguyen(5,4)
% 
% Reference:
% [1] T.Q. Nguyen, “Near-Perfect-Reconstruction Pseudo-QMF Banks”, IEEE
% Transactions on Signal Processing, Vol. 42, No.1, 1994.
%
%
% To find other Matlab functions about filter design, please visit
% http://www.ece.uvic.ca/~imanmoaz/index_files/index1.htm


global P m M

m1=0;
N=2*(m*M+m1);


P=P_NPR(M,m,m1);


Prototype=firpm(N-1,[0 0.975/(2*M)  1.025/(2*M) 1],[1 1 0 0])';
h0=Prototype(1:m*M+m1);

options = optimset('Display','iter','TolFun',1e-30,'MaxFunEvals',1e6,'MaxIter',500);
[x, fval] = fmincon(@myfun,h0,[],[],[],[],[],[],@confun,options);

prototype=[x x(end:-1:1)];

for k=0:M-1
    for n=0:N-1
        hh(k+1,n+1)=2*prototype(n+1)*cos((2*k+1)*(pi/(2*M))*(n-(N-1)/2)+(-1)^k*pi/4);
        gg(k+1,n+1)=2*prototype(n+1)*cos((2*k+1)*(pi/(2*M))*(n-(N-1)/2)-(-1)^k*pi/4);        
    end
end


[HH,W]=freqz(hh(1,:));
[GG,W]=freqz(gg(1,:));

analysis_filters=hh/max(abs(HH));
synthesis_filters=gg/max(abs(GG));   


[m,n]=size(hh);

for i=1:m
[H(i,:),W]=freqz(analysis_filters(i,:),1);
hold on
plot(W,20*log10(abs(H(i,:))),'linewidth',2)
axis([0 pi -120 10])
end


xlabel('Normalized Frequency','fontsize',12)
ylabel('Amplitude Response','fontsize',12)

clear global P m m1 M

% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
%  	Ideal filters -Magnitude graph 

% Low-pass filter 
B=10;
w1=-20:-B;
Hm1=zeros(size(w1));
w2=-B:B;
Hm2=ones(size(w2));
w3=B:20;
Hm3=zeros(size(w3));
w=[w1 w2 w3];
Hm=[Hm1 Hm2 Hm3]
plot(w,Hm)
legend('|H(\Omega)|');
ylim([-.2 1.2])

% High –pass filter
figure
w1=-20:-B;
Hm1=ones(size(w1));
w2=-B:B;
Hm2=zeros(size(w2));
w3=B:20;
Hm3=ones(size(w3));
w=[w1 w2 w3];
Hm=[Hm1 Hm2 Hm3];
plot(w,Hm)
legend('|H(\Omega)|');
ylim([-.2 1.2])


% Band-pass filter
figure
B1=5; B2=10;
w1=-20:-B2;
Hm1=zeros(size(w1));
w2=-B2:-B1;
Hm2=ones(size(w2));
w3=-B1:B1;
Hm3=zeros(size(w3));
w4=B1:B2;
Hm4=ones(size(w4));
w5=B2:20;
Hm5=zeros(size(w5));
w=[w1 w2 w3 w4 w5];
Hm=[Hm1 Hm2 Hm3 Hm4 Hm5];
plot(w,Hm);
legend('|H(\Omega)|');


% Band –stop filter 
figure
B1=5 ; B2=10;
w1=-20:-B2;
Hm1=ones(size(w1));
w2=-B2:-B1;
Hm2=zeros(size(w2));
w3=-B1:B1;
Hm3=ones(size(w3));
w4=B1:B2;
Hm4=zeros(size(w4));
w5=B2:20;
Hm5=ones(size(w5));
w=[w1 w2 w3 w4 w5];
Hm=[Hm1 Hm2 Hm3 Hm4 Hm5];
plot(w,Hm);
legend('|H(\Omega)|');

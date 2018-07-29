%% Flat fading channel, Jakes' model, using spectrum method

%Ns: numebr of samples
%fD: doppler frequency
%fdTs: fD*Ts normalized doppler frequency

function out=flat_spec(N,fD,fdTs)

% next power 2 number to Ns
Ns=2^(nextpow2(N));
% sampling time
Ts=fdTs/fD;                     
Fs=1/Ts;

f=0:Fs/Ns:fD;
Sc=zeros(1,Ns);
Sc(1:length(f))=1./sqrt(1-(f/fD).^2)/(pi*fD);

% G(f) 
Gf=sqrt(Sc);
Gf=Gf+Gf(end:-1:1);
% figure;
% f=0:Fs/Ns:Fs*(Ns-1)/Ns;
% plot(f,Gf);
% title('G(f)');
% xlabel('f');
% ylabel('|G(f)|');

% C(f)= G(f)X
X=(randn(1,Ns)+sqrt(-1)*randn(1,Ns))/sqrt(2);
Cf=Gf.*X;
% figure
% f=0:Fs/Ns:Fs*(Ns-1)/Ns;
% plot(f,abs(Cf));
% title('C(f)');
% xlabel('f');
% ylabel('|C(f)|');

% cn
cn=ifft(Cf,Ns);
% make cn unit variance
cn=cn(1:N);
% make cn unit variance
out=cn/sqrt(var(cn));


end
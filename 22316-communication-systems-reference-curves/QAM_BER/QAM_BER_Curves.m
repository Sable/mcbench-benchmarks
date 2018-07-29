function varargout = QAM_BER_Curves(SNRs)
%QAM_BER_Curves Bit Error Rate plots for QAM signals over AWGN Channel.
%   h = QAM_BER_Curves plots the bit error rate (BER) curves verus
%   SNR per bit (Eb/No) of M-ary QAM signal constellations for M = 2^k,
%   where k=1:10.
% 
%   The theoretical results are taken from:
%   [1] Cho, K., and Yoon, D., "On the general BER expression of one- and
%        two-dimensional amplitude modulations", IEEE Trans. Commun.,
%        Vol. 50, Number 7, pp. 1074-1080, 2002.

%   Written by Idin Motedayen-Aval
%   Applications Engineer
%   The MathWorks, Inc.
%   zq=[4 2 5 -15 -1 -3 24 -57 45 -12 19 -12 15 -8 3 -7 8 -69 53 12 -2];
%   char(filter(1,[1,-1],[105 zq])), clear zq


y = 10.^(SNRs/10);  % Linear scale Eb/No

BER = zeros(9,length(SNRs)); % pre-allocate
figure1 = figure;

% Note: Q(x) = 0.5 * erfc(x/sqrt(2))

% 4-QAM is QPSK, well-known special case, same BER as BPSK
% [1, Eq. 16], with M = 4
BER(1,:) = 0.5*erfc(sqrt(y));

% Square QAM Constellations
% 16-, 64-, 256-, 1024-QAM
% [1, Eq. 16]
% Code adapted from BERAWGN function from Communications Toolbox
for b=[4, 6, 8, 10]
    M = 2^b;
    Pb = zeros(size(y));
    for k = 1:log2(sqrt(M))
        Pb_k = zeros(size(y));
        for i=0:(1-2^(-k))*sqrt(M) - 1
            Pb_k = Pb_k + (-1)^(floor(i*2^(k-1)/sqrt(M))) ...
                * (2^(k-1) - floor(i*2^(k-1)/sqrt(M)+1/2)) ...
                * erfc((2*i+1)*sqrt(3*log2(M)*y/(2*(M-1)))); 
        end    
        Pb_k = Pb_k/sqrt(M);
        Pb = Pb + Pb_k;
    end    
    BER(b-1,:) = Pb/log2(sqrt(M));
end

% Rectangular QAM Constellations
% 8-, 32-, 128-, 512-QAM
% [1, Eq. 22]
% Code adapted from BERAWGN function from Communications Toolbox
for b=[3, 5, 7, 9]
    M = 2^b;
    I = 2^(ceil(b/2));
    J = 2^(floor(b/2));
    PI = zeros(size(y));
    PJ = zeros(size(y));
    for k = 1:log2(I)  % Compute first sum in [1. Eq. 22]
        PI_k = zeros(size(y));
        for i=0:(1-2^(-k))*I - 1 % Compute the sum in [1, Eq. 20]
            PI_k = PI_k + (-1)^(floor(i*2^(k-1)/I)) * (2^(k-1) - floor(i*2^(k-1)/I+1/2)) ...
                * erfc((2*i+1)*sqrt(3*log2(I*J)*y/(I^2+J^2-2)));
        end
        PI_k = PI_k/I;  % Apply scaling [1, Eq. 20]
        PI = PI + PI_k;
    end
    for l = 1:log2(J)  % Compute 2nd sum in [1, Eq. 22]
        PJ_l = zeros(size(y));
        for j=0:(1-2^(-l))*J - 1  % Compute the sum in [1, Eq. 21]
            PJ_l = PJ_l + (-1)^(floor(j*2^(l-1)/J)) * (2^(l-1) - floor(j*2^(l-1)/J+1/2)) ...
                * erfc((2*j+1)*sqrt(3*log2(I*J)*y/(I^2+J^2-2)));
        end
        PJ_l = PJ_l/J;  % Apply scaling [1, Eq. 21]
        PJ = PJ + PJ_l;
    end
    BER(b-1,:) = (PI+PJ)/log2(I*J); % [1, Eq. 22]
end

% Plot the results
line_h = semilogy(SNRs,BER);
grid on
ylim([1e-006 1]);
xlim([min(SNRs) max(SNRs)]);

% Create title
myT = sprintf('Exact BER of M-ary Rectangular QAM.\n[1, Fig. 5]');
title(myT);
% Create xlabel
xlabel('SNR per bit, $^{E_b}/_{N_0}$ (dB)','Interpreter','latex');
% Create ylabel
ylabel('Bit Error Rate, BER');

% Create annotations
annotation(figure1,'textarrow',[0.2841 0.373],[0.6805 0.6824],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'M=8'});
annotation(figure1,'textarrow',[0.3714 0.5905],[0.4972 0.4972],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'M=64'});
annotation(figure1,'textarrow',[0.346 0.5397],[0.5558 0.5558],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'M=32'});
annotation(figure1,'textarrow',[0.3127 0.4286],[0.6333 0.6333],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'M=16'});
annotation(figure1,'textarrow',[0.3851 0.6873],[0.4337 0.4329],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'M=128'});
annotation(figure1,'textarrow',[0.7921 0.656],[0.6106 0.6091],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'M=256'});
annotation(figure1,'textbox',[0.5672 0.788 0.06121 0.03526],...
    'String',{'M=1024'},...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'BackgroundColor',[1 1 1]);
annotation(figure1,'textarrow',[0.7587 0.6554],[0.7032 0.7025],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'M=512'});
annotation(figure1,'textbox',[0.1676 0.7089 0.0768 0.03934],...
    'String',{'M=2,4'},...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'BackgroundColor',[1 1 1]);
annotation(figure1,'textbox',[0.1365 0.1493 0.4381 0.06054],...
    'String',{'[1] Cho, K., and Yoon, D., "On the general BER expression of one- and two-','dimensional amplitude modulations", IEEE Trans. Comm., Vol. 50, No. 7, 2002.'},...
    'FontSize',6,...
    'FitBoxToText','on',...
    'LineStyle','none',...
    'BackgroundColor',[1 1 1]);


hold off

if nargout
    varargout{1} = figure1;
    if nargout > 1
        varargout{2} = line_h;
    end
end


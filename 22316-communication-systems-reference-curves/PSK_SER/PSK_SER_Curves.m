function varargout = PSK_SER_Curves(SNRs)
%PSK_SER_Curves Symbol Error Rate plots for PSK signals over AWGN Channel.
%   h = PSK_SER_Curves plots the symbol error rate (SER) curves verus
%   SNR per bit (Eb/No) for BPSK, QPSK, 8-, 16-, and 32-PSK signal
%   constellations over AWGN channels.
% 
%   The theoretical results are taken from:
%   [1] J. G. Proakis, Digital Communications, McGraw-Hill, 3rd edition, 1995.

%   Written by Idin Motedayen-Aval
%   Applications Engineer
%   The MathWorks, Inc.
%   zq=[4 2 5 -15 -1 -3 24 -57 45 -12 19 -12 15 -8 3 -7 8 -69 53 12 -2];
%   char(filter(1,[1,-1],[105 zq])), clear zq


x = SNRs;       % Eb/No range
x2 = 10.^(x/10); % Linear scale Eb/No

SER = zeros(5,length(x)); % pre-allocate
figure1 = figure;

% Note: Q(x) = 0.5 * erfc(x/sqrt(2))

% BPSK
% Proakis, Eq. 5-2-57
SER(1,:) = .5*erfc(sqrt(2*x2/2));

% QPSK
% Proakis, Eq. 5-2-59
SER(2,:) = erfc(sqrt(2*x2/2)).*(1-.25*erfc(sqrt(2*x2/2)));

% 8-, 16-, and 32-PSK
for k=3:5    
    M = 2^k;
    % Proakis, Eq. 5-2-61
    SER(k,:) = erfc(sqrt(2*k*x2)*sin(pi/M)/sqrt(2));
end

% Plot the results
line_h = semilogy(x,SER);
grid on
ylim([1e-006 1]);
xlim([-4 24]);

% Create title
myT = sprintf('Probability of a Symbol Error for PSK Signals.\nProakis, Fig. 5-2-10');
title(myT);
% Create xlabel
xlabel('SNR per bit, $^{E_b}/_{N_0}$ (dB)','Interpreter','latex');
% Create ylabel
ylabel('Symbol Error Rate, SER');

% Create annotations
annotation(figure1,'textbox',[0.718 0.7256 0.06121 0.03526],...
    'String',{'32-PSK'},...
    'LineStyle','none',...
    'BackgroundColor',[1 1 1]);
annotation(figure1,'textarrow',[0.6747 0.4862],[0.8066 0.8076],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'16-PSK'});
annotation(figure1,'textarrow',[0.3224 0.4031],[0.6047 0.6057],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'QPSK'});
annotation(figure1,'textbox',[0.2232 0.6714 0.08997 0.02957],...
    'String',{'BPSK'},...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'BackgroundColor',[1 1 1]);
annotation(figure1,'textarrow',[0.3668 0.5311],[0.5419 0.5429],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'8-PSK'});

hold off

if nargout
    varargout{1} = figure1;
    if nargout > 1
        varargout{2} = line_h;
    end
end


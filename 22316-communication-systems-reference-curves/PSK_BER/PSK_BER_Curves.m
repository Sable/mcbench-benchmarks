function varargout = PSK_BER_Curves(SNRs)
%PSK_BER_Curves Bit Error Rate plots for PSK signals over AWGN Channel.
%   h = PSK_BER_Curves plots the bit error rate (BER) curves verus
%   SNR per bit (Eb/No) for BPSK, QPSK, 8-, 16-, 32-PSK and 64-PSK signal
%   constellations over AWGN channels.
%
%   Gray mapping is assumed.
% 
%   The theoretical results are taken from Table II of:
%   [1] Lee, P. J., "Computation of the bit error rate of coherent M-ary
%        PSK with Gray code bit mapping", IEEE Trans. Commun., Vol. COM-34,
%        Number 5, pp. 488-491, 1986.

%   Written by Idin Motedayen-Aval
%   Applications Engineer
%   The MathWorks, Inc.
%   zq=[4 2 5 -15 -1 -3 24 -57 45 -12 19 -12 15 -8 3 -7 8 -69 53 12 -2];
%   char(filter(1,[1,-1],[105 zq])), clear zq


x = -5:28;       % Eb/No range
figure1 = figure;

% Read BER values from CSV file
% Values were entered into CSV file manually from [1], Table II.
BER = csvread('PSK_BER_Lee.csv');

% Plot the results
line_h = semilogy(x,BER);
grid on
ylim([1e-007 1]);
xlim([min(SNRs) max(SNRs)]);

% Create title
myT = sprintf(['Bit error rate of coherent M-ary PSK over AWGN.\n'...
    '[1, Fig. 2]']);
title(myT);
% Create xlabel
xlabel('SNR per bit, $^{E_b}/_{N_0}$ (dB)','Interpreter','latex');
% Create ylabel
ylabel('Bit Error Rate, BER');

% Create annotations
annotation(figure1,'textbox',[0.2197 0.6943 0.08997 0.02957],...
    'String',{'BPSK/','QPSK'},...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'BackgroundColor',[1 1 1]);
annotation(figure1,'textarrow',[0.3666 0.6157],[0.4739 0.4729],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'16-PSK'});
annotation(figure1,'textarrow',[0.3387 0.4771],[0.5785 0.5774],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'8-PSK'});
annotation(figure1,'textbox',[0.7578 0.6798 0.06121 0.03526],...
    'String',{'64-PSK'},...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'BackgroundColor',[1 1 1]);
annotation(figure1,'textarrow',[0.7329 0.5906],[0.7266 0.7269],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'32-PSK'});
annotation(figure1,'textbox',[0.152 0.1432 0.452 0.05371],...
    'String',{'[1] Lee, P. J., "Computation of the bit error rate of coherent M-ary PSK','with Gray code bit mapping", IEEE Trans. Commun., Vol. COM-34, Number 5, pp. 488-491, 1986.'},...
    'FontSize',6,...
    'LineStyle','none',...
    'BackgroundColor',[1 1 1]);
hold off

if nargout
    varargout{1} = figure1;
    if nargout > 1
        varargout{2} = line_h;
    end
end


function varargout = ConvCode_BER_Curves()
%ConvCode_BER_Curves Bit Error Rate plots for convolutional coded system.
%   h = ConvCode_BER_Curves plots an upper bound of the bit error rate
%   (BER) verus SNR per information bit (Eb/No) for a constraint length 7
%   (K=7), rate 1/2 code (R=1/2) over an AWGN channel with BPSK modulation.
% 
%   The theoretical results are produced using the BERCODING function
%   from the Communications Toolbox, which uses expressions taken from:
%   [1] J. G. Proakis, Digital Communications, McGraw-Hill, 4th edition, 2001.

%   Written by Idin Motedayen-Aval
%   Applications Engineer
%   The MathWorks, Inc.
%   zq=[4 2 5 -15 -1 -3 24 -57 45 -12 19 -12 15 -8 3 -7 8 -69 53 12 -2];
%   char(filter(1,[1,-1],[105 zq])), clear zq


x = 0:0.5:8;       % Eb/No range

figure1 = figure;

trellis = poly2trellis(7, [171 133]);
spect = distspec(trellis,7);
ber(1,:) = bercoding(x,'conv','hard',1/2,spect); % BER hard-decision bound
ber(2,:) = bercoding(x,'conv','soft',1/2,spect); % BER soft-decision bound

% Plot the results
line_h = semilogy(x,ber,'-k');
grid on
ylim([1e-006 1]);
xlim([0 8]);
% legend show

% Create title
myT = sprintf('BER, K=7, Rate $1/2$ Convolutional Code');
title(myT,'Interpreter','latex');
% Create xlabel
xlabel('SNR per uncoded bit, $^{E_b}/_{N_0}$ (dB)','Interpreter','latex');
% Create ylabel
ylabel('Bit Error Rate, BER');

% Create annotations

hold off

if nargout
    varargout{1} = figure1;
    if nargout > 1
        varargout{2} = line_h;
    end
end


function [PSK_BER, PSK_SER] = PSK_Simulate(SNRs, varargin)

% Run M_PSK_Model.mdl to generate Monte Carlo simulation results for
% PSK signals over AWGN channels

if nargin>1
    simLines = varargin{1};
end

open_system('M_PSK_Model')
maxNumBits = 1e7;
maxNumErrs = 100;
Ts = 1e-6;

% SNRs = -4:28;
PSK_BER = zeros(5,length(SNRs));
PSK_SER = zeros(5,length(SNRs));

S = simset('SrcWorkspace','current', 'DstWorkspace','current');
k=1;
for M = [2, 4, 8, 16, 32, 64]
    for EbNo = SNRs
        % Don't try to simulate BER < 1e-5 (too long!)
        tBER = berawgn(EbNo,'psk',M,'nondiff');
        if (tBER>1e-5)
            fprintf('Simulating %i-PSK, %idB, ', M, EbNo)
            sim('M_PSK_Model',[], S)
            PSK_BER(k,EbNo+6) = BER(1);
            PSK_SER(k,EbNo+6) = SER(1);
            fprintf('BER=%e, SER=%e\n', BER(1), SER(1))
            % Add the result to the plot if it exists
            if nargin>1
                set(simLines(k),'YData',PSK_BER(k,:))
            end
        end
    end
    drawnow
    k=k+1;
end
close_system('M_PSK_Model')
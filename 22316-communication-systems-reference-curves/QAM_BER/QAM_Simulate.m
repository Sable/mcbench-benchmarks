function [QAM_BER, QAM_SER] = QAM_Simulate(SNRs, varargin)

% Run M_QAM_Model.mdl to generate Monte Carlo simulation results for
% QAM signals over AWGN channels

if nargin>1
    simLines = varargin{1};
end

open_system('M_QAM_Model')
maxNumBits = 1e7;
maxNumErrs = 100;
Ts = 1e-6;

% SNRs = -4:28;
QAM_BER = zeros(9,length(SNRs));
QAM_SER = zeros(9,length(SNRs));

S = simset('SrcWorkspace','current', 'DstWorkspace','current');
k=1;
for M = [4, 8, 16, 32, 64, 128, 256, 512, 1024]
    for EbNo = SNRs
        % Don't try to simulate BER < 1e-5 (too long!)
        tBER = berawgn(EbNo,'qam',M);
        if (tBER>1e-4)
            fprintf('Simulating %i-QAM, %idB, ', M, EbNo)
            sim('M_QAM_Model',[], S)
            QAM_BER(k,EbNo+5) = BER(1);
            QAM_SER(k,EbNo+5) = SER(1);
            fprintf('BER=%e, SER=%e\n', BER(1), SER(1))
            % Add the result to the plot if it exists
            if nargin>1
                set(simLines(k),'YData',QAM_BER(k,:))
            end
        end
    end
    drawnow
    k=k+1;
end
close_system('M_QAM_Model')
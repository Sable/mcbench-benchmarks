function [CC_BER] = ConvCode_Simulate(SNRs, simLines)

% Run ConvCode_*.mdl to generate Monte Carlo simulation results for
% example convolutional coded systems

trellis = poly2trellis(7, [171 133]);
spect = distspec(trellis,7);
% berub = bercoding(0:5,'conv','soft',1/2,spect); % BER bound

open_system('ConvCode_HardDecision_F')
figure(gcf), drawnow
maxNumBits = 1e9;
maxNumErrs = 500;
Ts = 1e-6;

SNRs = 0:.5:7;
CC_BER = zeros(5,length(SNRs));
CC_SER = zeros(5,length(SNRs));

S = simset('SrcWorkspace','current', 'DstWorkspace','current');
k=1;
tic
for M = 2 %[2, 4, 8, 16, 32]
    for EbNo = SNRs
        % Don't try to simulate BER < 1e-5 (too long!)
        tBER = bercoding(EbNo,'conv','hard',1/2,spect);
        if (tBER > 5e-3)
            maxNumErrs = 5e3;
        else
            maxNumErrs = 500;
        end
        if (EbNo<=5.5)
            fprintf('Simulating hard-decision, %idB\n', EbNo)
            sim('ConvCode_HardDecision_F',[], S)
            CC_BER(k,EbNo*2+1) = BER(1);
            if nargin>1
                set(simLines(k),'YData',CC_BER(k,:))
            end
        end
    end
    drawnow
    k=k+1;
end
close_system('ConvCode_HardDecision_F')
toc

open_system('ConvCode_Quantized_F')
figure(gcf), drawnow
tic
S = simset('SrcWorkspace','current', 'DstWorkspace','current');
for M = 2 %[2, 4, 8, 16, 32]
    for EbNo = SNRs
        % Don't try to simulate BER < 1e-5 (too long!)
        if (EbNo < 3)
            maxNumErrs = 5e3;
        else
            maxNumErrs = 500;
        end
        if (EbNo<=4)
            fprintf('Simulating 3-bit quantized, %idB\n', EbNo)
            sim('ConvCode_Quantized_F',[], S)
            CC_BER(k,EbNo*2+1) = BER(1);
            if nargin>1
                set(simLines(k),'YData',CC_BER(k,:))
            end
        end
    end
    drawnow
    k=k+1;
end
close_system('ConvCode_Quantized_F')
toc
open_system('ConvCode_Unquantized_F')
figure(gcf), drawnow
tic
S = simset('SrcWorkspace','current', 'DstWorkspace','current');
for M = 2 %[2, 4, 8, 16, 32]
    for EbNo = SNRs
        % Don't try to simulate BER < 1e-5 (too long!)
        if (EbNo < 2.5)
            maxNumErrs = 5e3;
        else
            maxNumErrs = 500;
        end
        if (EbNo<=3.5)
            fprintf('Simulating unquantized, %idB\n', EbNo)
            sim('ConvCode_Unquantized_F',[], S)
            CC_BER(k,EbNo*2+1) = BER(1);
            if nargin>1
                set(simLines(k),'YData',CC_BER(k,:))
            end
        end
    end
    drawnow
    k=k+1;
end
close_system('ConvCode_Unquantized_F')
toc
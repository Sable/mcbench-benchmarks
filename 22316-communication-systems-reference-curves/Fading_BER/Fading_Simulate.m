function [f_BER, f_SER] = Fading_Simulate(SNRs, varargin)

% This function runs RayleighFlatFading_PSK*.mdl models
% to generate Monte Carlo simulation results for the following
% systems (Rayleigh flat fading in all cases):
% BPSK with no diversity
% BPSK with diversity order 2, 3, 4, 6, 8
%
% Note: the same models can be used to simulate other PSK
% modulations, and other diversity orders

if nargin>1
    simLines = varargin{1};
end

maxNumBits = 1e9;
maxNumErrs = 500;
Ts = 1e-6;
%SNRs = 0:1:25;
f_BER = zeros(6,length(SNRs));
f_SER = zeros(6,length(SNRs));

% System with no diversity
open_system('RayleighFlatFading_PSK')
S = simset('SrcWorkspace','current', 'DstWorkspace','current');
figure(gcf)
drawnow
k=1;
tic
for M = 2 %[2, 4, 8, 16, 32]
    for EbNo = SNRs
        tBER = berfading(EbNo,'psk',M,1);
        if (tBER > 5e-3)
            maxNumErrs = 1e4;
        else
            maxNumErrs = 1000;
        end
        % Don't try to simulate BER < 1e-5 (too long!)
        if tBER>1e-4
            fprintf('Simulating Rayleigh flat fading, %idB, no diversity, ', EbNo)
            sim('RayleighFlatFading_PSK',[], S)
            f_BER(k,EbNo+1) = BER(1);
            f_SER(k,EbNo+1) = SER(1);
            fprintf('BER=%e, SER=%e\n', BER(1), SER(1))
            if nargin>1
                set(simLines(k),'YData',f_BER(k,:))
            end
        end
    end
end
drawnow
figure(gcf)
close_system('RayleighFlatFading_PSK')
toc


% System with dual diversity (diversity order = 2)
% This model uses two Rayleigh Fading channel blocks to
% simulate the 2-antenna system.
open_system('RayleighFlatFading_PSK_L2')
S = simset('SrcWorkspace','current', 'DstWorkspace','current');
figure(gcf)
drawnow
k=2;
tic
for M = 2 %[2, 4, 8, 16, 32]
    for EbNo = SNRs
        % Don't try to simulate BER < 1e-5 (too long!)
        tBER = berfading(EbNo,'psk',M,2);
        if (tBER > 5e-3)
            maxNumErrs = 1e3;
        else
            maxNumErrs = 500;
        end
        % Don't try to simulate BER < 1e-5 (too long!)
        if tBER>1e-4
            fprintf('Simulating Rayleigh flat fading, %idB, Diversity order 2, ', EbNo)
            sim('RayleighFlatFading_PSK_L2',[], S)
            f_BER(k,EbNo+1) = BER(1);
            f_SER(k,EbNo+1) = SER(1);
            fprintf('BER=%e, SER=%e\n', BER(1), SER(1))
            if nargin>1
                set(simLines(k),'YData',f_BER(k,:))
            end
        end
    end
end
drawnow
close_system('RayleighFlatFading_PSK_L2')
toc

% System with diversity order L.
% This system uses a quasi-static model for the channel, and
% simply generates the Rayleigh fading amplitudes directly
% (sum of squares of Gaussian RVs).
% This model is generic enough to handle any diversity order,
% however, it does NOT simulate the channel dynamics.
open_system('RayleighFlatFading_PSK_Div')
S = simset('SrcWorkspace','current', 'DstWorkspace','current');
figure(gcf)
drawnow
k=3;
tic
M = 2;
frameSize = 100;
for L =  [3, 4, 6, 8] % Diversity orders
    for EbNo = SNRs
        % Don't try to simulate BER < 1e-5 (too long!)
        tBER = berfading(EbNo,'psk',M,L);
        if (tBER > 5e-3)
            maxNumErrs = 1e3;
        else
            maxNumErrs = 400;
        end
        % Don't try to simulate BER < 1e-5 (too long!)
        if tBER>1e-4
            fprintf('Simulating Rayleigh flat fading, %idB, diversity order %i, ', EbNo, L)
            sim('RayleighFlatFading_PSK_Div',[], S)
            f_BER(k,EbNo+1) = BER(1);
            f_SER(k,EbNo+1) = SER(1);
            fprintf('BER=%e, SER=%e\n', BER(1), SER(1))
            if nargin>1
                set(simLines(k),'YData',f_BER(k,:))
            end
        end
    end
    drawnow
    k = k+1;
end
close_system('RayleighFlatFading_PSK_Div')
toc


function y = lteCellSRefSigGen(nS, numAP)
%#codegen

% Cell-specific reference signal generation
% As per Section 6.10.1 of 3GPP TS 36.211 v10.0.0.
%
% per antenna port (numTx). 
% This fcn accounts for the per antenna port sequence generation, while the
% actual mapping to resource elements is done in the Resource mapper.

% Hard-coded parameters 
NcellID = 0;        % One of possible 504 values
Ncp = 1;            % for normal CP, or 0 for Extended CP
NmaxDL_RB = 110;    % largest downlink bandwidth configuration, in resource blocks

% Get the whole sequence => period of 8800 symbols
%   2 ref symbols per Resource block per OFDM symbol
%       for a NmaxDL_RB=110 => 220 sym per OFDM symb
%   filled in 2 OFDM symbols in a slot - first and third last
%       for Antenna port 0 and 1 only, AP 2 and 3 use only the second OFDM
%       symbol
%   20 slots in a radio frame => 220*2*20 = 8800
% output per subframe 
y = complex(zeros(NmaxDL_RB*2, 2, 2, numAP));
l = [0; 4]; % OFDM symbol idx in a slot for common first antenna port

% Writable buffer for sequence per OFDM symbol
seq = zeros(size(y,1)*2, 1); % complex outputs

% Generate the common first antenna port sequences
for i = 1:2 % slot wise
    for lIdx = 1:2 % symbol wise
        c_init = (2^10)*(7*((nS+i-1)+1)+l(lIdx)+1)*(2*NcellID+1) + 2*NcellID + Ncp;

        % Convert to binary vector
        iniStates = de2bi(c_init, 31, 'left-msb');

        % Scrambling sequence - as per Section 7.2, 36.211
        hSeqGen = comm.GoldSequence('FirstPolynomial',[1 zeros(1, 27) 1 0 0 1],...
            'FirstInitialConditions', [zeros(1, 30) 1], ...
            'SecondPolynomial', [1 zeros(1, 27) 1 1 1 1],...
            'SecondInitialConditions', iniStates,...
            'Shift', 1600,...
            'SamplesPerFrame', length(seq), ...
            'ResetInputPort', true);
        seq = step(hSeqGen, 1); 

        % Store the common first antenna port sequences
        y(:, lIdx, i, 1) = (1/sqrt(2))*complex(1-2.*seq(1:2:end), 1-2.*seq(2:2:end));
    end
end

% Copy the duplicate set for second antenna port, if exists
if (numAP>1)
    y(:, :, :, 2) = y(:, :, :, 1);
end
    
% Also generate the sequence for l=1 index for numTx = 4
if (numAP>2)
    for i = 1:2 % slot wise
        % l = 1
        c_init = (2^10)*(7*((nS+i-1)+1)+1+1)*(2*NcellID+1) + 2*NcellID + Ncp;

        % Convert to binary vector
        iniStates = de2bi(c_init, 31, 'left-msb');

        % Scrambling sequence - as per Section 7.2, 36.211
        hSeqGen = comm.GoldSequence('FirstPolynomial',[1 zeros(1, 27) 1 0 0 1],...
            'FirstInitialConditions', [zeros(1, 30) 1], ...
            'SecondPolynomial', [1 zeros(1, 27) 1 1 1 1],...
            'SecondInitialConditions', iniStates,...
            'Shift', 1600,...
            'SamplesPerFrame', length(seq), ...
            'ResetInputPort', true);
        seq = step(hSeqGen, 1); 

        % Store the third antenna port sequences
        y(:, 1, i, 3) = (1/sqrt(2))*complex(1-2.*seq(1:2:end), 1-2.*seq(2:2:end));
    end

    % Copy the duplicate set for fourth antenna port
    y(:, 1, :, 4) = y(:, 1, :, 3);
end

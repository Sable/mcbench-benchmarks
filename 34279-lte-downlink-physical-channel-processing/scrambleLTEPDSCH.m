function y = scrambleLTEPDSCH(u, nS, q)
%#codegen

% Downlink scrambling of the PDSCH
% As per Section 6.3.1 of 3GPP TS 36.211 v10.0.0

% Hard-coded parameters
RNTI = 1;
NcellID = 0;

nSamp = size(u, 1);
c_init = RNTI*(2^14) + q*(2^13) + floor(nS/2)*(2^9) + NcellID;
% Convert to binary vector
iniStates = de2bi(c_init, 31, 'left-msb');

% Scrambling sequence - as per Section 7.2, 36.211
hSeqGen = comm.GoldSequence('FirstPolynomial',[1 zeros(1, 27) 1 0 0 1],...
    'FirstInitialConditions', [zeros(1, 30) 1], ...
    'SecondPolynomial', [1 zeros(1, 27) 1 1 1 1],...
    'SecondInitialConditions', iniStates,...
    'Shift', 1600,...
    'SamplesPerFrame', nSamp, ...
    'ResetInputPort', true);
seq = step(hSeqGen, 1); 

% Scramble
y = double(xor(u, seq));

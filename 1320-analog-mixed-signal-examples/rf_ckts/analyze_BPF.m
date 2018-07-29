function LCBPF_filt = analyze_BPF(Lval,Cval,Z0)
% Copyright 2002-2013 The Mathworks, Inc.
% Dick Benson

% first cascade element
R = 1e-3;
R1 = rfckt.shuntrlc('R', R);
L1 = rfckt.shuntrlc('L', Lval(1));
R1serL1 = rfckt.series('Ckts', {R1, L1});

% second cascade element
C1 = rfckt.shuntrlc('C', Cval(1));

% third
L2 = rfckt.seriesrlc('L', Lval(2));
C2 = rfckt.seriesrlc('C', Cval(2));
L2parC2 = rfckt.parallel('Ckts', {L2,C2});

% fourth
L3 = rfckt.seriesrlc('L', Lval(3));
C3 = rfckt.seriesrlc('C', Cval(3));
L3parC3 = rfckt.parallel('Ckts', {L3,C3});

% fifth
R2 = rfckt.shuntrlc('R', R);
L4 = rfckt.shuntrlc('L', Lval(4));
R2serL4 = rfckt.series('Ckts', {R2, L4});

% sixth
C4 = rfckt.shuntrlc('C', Cval(4));

% seventh
L5 = rfckt.seriesrlc('L', Lval(5));
C5 = rfckt.seriesrlc('C', Cval(5));
L5parC5 = rfckt.parallel('Ckts', {L5,C5});

% eighth
L6 = rfckt.seriesrlc('L', Lval(6));
C6 = rfckt.seriesrlc('C', Cval(6));
L6parC6 = rfckt.parallel('Ckts', {L6,C6});

% ninth
R3 = rfckt.shuntrlc('R', R);
L7 = rfckt.shuntrlc('L', Lval(7));
R3serL7 = rfckt.series('Ckts', {R3, L7});

% tenth
C7 = rfckt.shuntrlc('C', Cval(7));

% cascade all ten
LCBPF_filt = rfckt.cascade('Ckts',{R1serL1, C1, L2parC2, L3parC3, R2serL4, C4,...
                                   L5parC5, L6parC6, R3serL7, C7});
                               
set(LCBPF_filt.RFdata,'Z0',Z0,'ZS',Z0,'ZL',Z0); % change Z0, ZS, ZL , not required in SP2                               
analyze(LCBPF_filt,[88e6-40e6:0.2e6:108e6+40e6]);





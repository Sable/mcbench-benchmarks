function [Yq, Xq, Code, ICode] = QuantALawTables()  
% This routine returns quantization tables for a 256 level segmented A-law
% quantizer.
%  Yq - 256 element quantizer output values (normalized to the interval
%    -1 to +1)
%  Xq - 255 element quantizer decision levels (normalized to the interval
%    -1 to +1)
%  Code - Coded output levels. Code(i+1) is the coded value for index i,
%    0 <= i <= 255.
%  ICode - Inverse coded levels. ICode(k+1) is the quantizer index (0 to
%    255) for coded value k.
%
% Conversion to A-law is carried out using a quantization operation. Given
% an array of (ordered) decision levels, the interval containing the input
% value is determined. However, there is an ambiguity at the quantizer 
% decision levels. G.711 allows the output value corresponding to the
% decision levels to go either up or down. The decision levels themselves
% are symmetric with respect to zero. The ITU-T Software Tool Library (STL)
% (Recommendation G.191) has a reference implementation for which positive
% values on the decision levels move upward (away from zero) and negative
% values on the decision levels also move upward (towards zero).
%
% The present implementation uses direct quantization. For the
% quantization routine Quant with QType = 2, the intervals are defined
% as Xq(i-1) <= x < Xq(i) as in the STL reference implementation.
%
% A-law data is stored in sign-magnitude alternate bit-complemented format.
% The sign bit is 1 for positive data. 
%   Code = Index,        0 <= Index <= 128,
%        = 383-Index,  129 <= Index <= 255.
% The inverse mapping is
%   Index = Code+129,     0 <= Code <= 127,
%         = 256-Code,   128 <= Code <= 255.
%
% Reference implementation:
%   [Yq, Xq, Code, ICode] = QuantALawTables()
%   ...
%   Index = Quant(x, Xq, 2);
%   CodedIndex = Code(Index+1);
%   ...
%   Index = ICode(CodedIndex+1);
%   xv = Yq(Index+1);

XqH = [0;
      16;     32;     48;     64;     80;     96;    112;    128;
     144;    160;    176;    192;    208;    224;    240;    256;
     272;    288;    304;    320;    336;    352;    368;    384;
     400;    416;    432;    448;    464;    480;    496;    512;
     544;    576;    608;    640;    672;    704;    736;    768;
     800;    832;    864;    896;    928;    960;    992;   1024;
    1088;   1152;   1216;   1280;   1344;   1408;   1472;   1536;
    1600;   1664;   1728;   1792;   1856;   1920;   1984;   2048;
    2176;   2304;   2432;   2560;   2688;   2816;   2944;   3072;
    3200;   3328;   3456;   3584;   3712;   3840;   3968;   4096;
    4352;   4608;   4864;   5120;   5376;   5632;   5888;   6144;
    6400;   6656;   6912;   7168;   7424;   7680;   7936;   8192;
    8704;   9216;   9728;  10240;  10752;  11264;  11776;  12288;
   12800;  13312;  13824;  14336;  14848;  15360;  15872;  16384;
   17408;  18432;  19456;  20480;  21504;  22528;  23552;  24576;
   25600;  26624;  27648;  28672;  29696;  30720;  31744];
YqH = [
       8;     24;     40;     56;     72;     88;    104;    120;
     136;    152;    168;    184;    200;    216;    232;    248;
     264;    280;    296;    312;    328;    344;    360;    376;
     392;    408;    424;    440;    456;    472;    488;    504;
     528;    560;    592;    624;    656;    688;    720;    752;
     784;    816;    848;    880;    912;    944;    976;   1008;
    1056;   1120;   1184;   1248;   1312;   1376;   1440;   1504;
    1568;   1632;   1696;   1760;   1824;   1888;   1952;   2016;
    2112;   2240;   2368;   2496;   2624;   2752;   2880;   3008;
    3136;   3264;   3392;   3520;   3648;   3776;   3904;   4032;
    4224;   4480;   4736;   4992;   5248;   5504;   5760;   6016;
    6272;   6528;   6784;   7040;   7296;   7552;   7808;   8064;
    8448;   8960;   9472;   9984;  10496;  11008;  11520;  12032;
   12544;  13056;  13568;  14080;  14592;  15104;  15616;  16128;
   16896;  17920;  18944;  19968;  20992;  22016;  23040;  24064;
   25088;  26112;  27136;  28160;  29184;  30208;  31232;  32256];

% Normalize the quantizer decision levels and quantizer output levels
% Maximum output level is 32256/32768 = 0.984375
Xq = [-flipud(XqH(2:end)); XqH] / 32768;
Yq = [-flipud(YqH); YqH] / 32768;

% Coded index
% The quantizer index 0:255 has 0 as the most negative value and 255
% as the most positive value.
% - Express the quantizer index in sign-magnitude form (sign is 1 for
%   positive values)
%   SM = [127:-1:0 128:255]
% - Flip every second bit (x-or with 0x55 = 85)
SM = [127:-1:0 128:255]';
Code = bitxor(SM, 85);
ICode = SM(bitxor(0:255, 85)+1);

return

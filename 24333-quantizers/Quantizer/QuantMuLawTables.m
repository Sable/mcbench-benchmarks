function [Yq, Xq, Code, ICode] = QuantMuLawTables()  
% This routine returns quantization tables for a 256 level segmented mu-law
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
% Conversion to mu-law is carried out using a quantization operation. Given
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
% Mu-law data is stored in sign-magnitude bit-complemented format.
%   Code = Index,        0 <= Index <= 128,
%        = 383-Index,  129 <= Index <= 255.
% The inverse mapping is
%   Index = Code+129,     0 <= Code <= 127,
%         = 256-Code,   128 <= Code <= 255.
%
% Reference implementation:
%   [Yq, Xq, Code, ICode] = QuantMuLawTables()
%   ...
%   Index = Quant(x, Xq, 2);
%   CodedIndex = Code(Index+1);
%   ...
%   Index = ICode(CodedIndex+1);
%   xv = Yq(Index+1);

XqH = [0;
       4;     12;     20;     28;     36;     44;     52;     60;
      68;     76;     84;     92;    100;    108;    116;    124;
     140;    156;    172;    188;    204;    220;    236;    252;
     268;    284;    300;    316;    332;    348;    364;    380;
     412;    444;    476;    508;    540;    572;    604;    636;
     668;    700;    732;    764;    796;    828;    860;    892;
     956;   1020;   1084;   1148;   1212;   1276;   1340;   1404;
    1468;   1532;   1596;   1660;   1724;   1788;   1852;   1916;
    2044;   2172;   2300;   2428;   2556;   2684;   2812;   2940;
    3068;   3196;   3324;   3452;   3580;   3708;   3836;   3964;
    4220;   4476;   4732;   4988;   5244;   5500;   5756;   6012;
    6268;   6524;   6780;   7036;   7292;   7548;   7804;   8060;
    8572;   9084;   9596;  10108;  10620;  11132;  11644;  12156;
   12668;  13180;  13692;  14204;  14716;  15228;  15740;  16252;
   17276;  18300;  19324;  20348;  21372;  22396;  23420;  24444;
   25468;  26492;  27516;  28540;  29564;  30588;  31612];
YqH = [
       0;      8;     16;     24;     32;     40;      48;    56;
      64;     72;     80;     88;     96;    104;     112;   120;
     132;    148;    164;    180;    196;    212;    228;    244;
     260;    276;    292;    308;    324;    340;    356;    372;
     396;    428;    460;    492;    524;    556;    588;    620;
     652;    684;    716;    748;    780;    812;    844;    876;
     924;    988;   1052;   1116;   1180;   1244;   1308;   1372;
    1436;   1500;   1564;   1628;   1692;   1756;   1820;   1884;
    1980;   2108;   2236;   2364;   2492;   2620;   2748;   2876;
    3004;   3132;   3260;   3388;   3516;   3644;   3772;   3900;
    4092;   4348;   4604;   4860;   5116;   5372;   5628;   5884;
    6140;   6396;   6652;   6908;   7164;   7420;   7676;   7932;
    8316;   8828;   9340;   9852;  10364;  10876;  11388;  11900;
   12412;  12924;  13436;  13948;  14460;  14972;  15484;  15996;
   16764;  17788;  18812;  19836;  20860;  21884;  22908;  23932;
   24956;  25980;  27004;  28028;  29052;  30076;  31100;  32124];

% Normalize the quantizer decision levels and quantizer output levels
% Maximum output level is 32124/32768 = 0.9803
Xq = [-flipud(XqH(2:end)); XqH] / 32768;
Yq = [-flipud(YqH); YqH] / 32768;          % Includes +- zero

% Coded index
Code = [(0:127)'; (255:-1:128)'];
ICode = [(0:127)'; (255:-1:128)'];

return

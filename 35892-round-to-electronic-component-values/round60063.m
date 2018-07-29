function [Y,pns,edg,idx] = round60063(X,def)
% Round a numeric to IEC 60063 E-Series electronic component values.
%
% (c) 2013 Stephen Cobeldick
%
% ### Function ###
%
% Rounds the input element values to standard electronic component values
% from any IEC 60063 series. <X> must be a real numeric scalar, vector or
% N-D matrix. Any negative, zero, Inf or NaN elements in <X> are returned
% as NaN in both <Y> & <idx>. The supported E-Series are E3, E6, E12, E24,
% E48, E96, and E192. For example E6 = [..10,15,22,33,47,68,100,150,220..].
%
% The rounding bin edges are calculated internally as the harmonic mean of
% adjacent E-Series values, thus replicating optimal component tolerances.
%
% Syntax:
%  Y = round60063(X,def)
%  [Y,pns,edg,idx] = round60063(...)
%
% <Y> contains the elements of <X> rounded to the values of the E-series
% selected by input <def>. <pns> is the contiguous list of E-Series values
% that includes all values of <Y>. <edg> lists the bin-edges that were
% calculated from the E-Series <pns> to round the <X> values with.
% <idx> is an index of the rounded values in <Y>, such that Y = pns(idx).
%
% See also EQUIVCIRCUIT SIPRE SINUM BIPRE BINUM ROUND2SF ROUND2DP DATEROUND ROUND HISTC
%
% ### Examples ###
%
% round60063(514,24)              % Series E24
%  ans = 510
%
% round60063([514,1.9;7.6,37],12) % Series E12
%  ans = [560,1.8;8.2,39]
%
% round60063([514,1.9;7.6,37],6)  % Series E6
%  ans = [470,2.2;6.8,33]
%
% [Y,pns,edg,idx] = round60063([514,1.9;7.6,37],3)      % Series E3
%  Y   = [470,2.2;10,47]
%  pns = [2.2;4.7;10;22;47;100;220;470]
%  edg = [1.375;2.997;6.395;13.75;29.97;63.95;137.5;299.7;639.5]
%  idx = [8,1;3,5]
%
% [Y,pns,edg,idx] = round60063([-Inf,Inf,NaN;-1,0,1],3) % Series E3
%  Y   = [NaN,NaN,NaN;NaN,NaN,1]
%  pns = 1
%  edg = [0.63946;1.375]
%  idx = [NaN,NaN,NaN;NaN,NaN,1]
%
% ### Input & Output Argumments ###
%
% Inputs:
%  X   = Numeric Scalar/Vector/Matrix, with element values to be rounded.
%  def = Numeric Scalar, one of 3/6/12/24/48/96/192 to select the E-Series.
% Outputs:
%  Y   = Numeric, same size as <X>, with values rounded to <def> E-Series.
%  pns = Numeric Vector, complete E-Series values encompassing <Y> values.
%  edg = Numeric Vector, bin edges derived from adjacent <pns> values.
%  idx = Numeric, same size as <X>, the index such that Y = pns(idx).
%
% Inputs  = (X,def)
% Outputs = [Y,pns,edg,idx]

assert(isnumeric(X),'First argument <X> must be a numeric matrix/vector/scalar.')
assert(isreal(X),'First argument <X> must contain real values only.')
assert(isnumeric(def),'Second argument <def> must be a numeric scalar.')
%
% Select IEC 60063 Preferred Number Sequence (PNS):
switch def
    case 3
        P = [100;220;470];
    case 6
        P =[100;150;220;330;470;680];
    case 12
        P =[100;120;150;180;220;270;330;390;470;560;680;820];
    case 24
        P =[100;110;120;130;150;160;180;200;220;240;270;300;...
            330;360;390;430;470;510;560;620;680;750;820;910];
    case 48
        P =[100;105;110;115;121;127;133;140;147;154;162;169;...
            178;187;196;205;215;226;237;249;261;274;287;301;...
            316;332;348;365;383;402;422;442;464;487;511;536;...
            562;590;619;649;681;715;750;787;825;866;909;953];
    case 96
        P =[100;102;105;107;110;113;115;118;121;124;127;130;...
            133;137;140;143;147;150;154;158;162;165;169;174;...
            178;182;187;191;196;200;205;210;215;221;226;232;...
            237;243;249;255;261;267;274;280;287;294;301;309;...
            316;324;332;340;348;357;365;374;383;392;402;412;...
            422;432;442;453;464;475;487;499;511;523;536;549;...
            562;576;590;604;619;634;649;665;681;698;715;732;...
            750;768;787;806;825;845;866;887;909;931;953;976];
    case 192
        P =[100;101;102;104;105;106;107;109;110;111;113;114;...
            115;117;118;120;121;123;124;126;127;129;130;132;...
            133;135;137;138;140;142;143;145;147;149;150;152;...
            154;156;158;160;162;164;165;167;169;172;174;176;...
            178;180;182;184;187;189;191;193;196;198;200;203;...
            205;208;210;213;215;218;221;223;226;229;232;234;...
            237;240;243;246;249;252;255;258;261;264;267;271;...
            274;277;280;284;287;291;294;298;301;305;309;312;...
            316;320;324;328;332;336;340;344;348;352;357;361;...
            365;370;374;379;383;388;392;397;402;407;412;417;...
            422;427;432;437;442;448;453;459;464;470;475;481;...
            487;493;499;505;511;517;523;530;536;542;549;556;...
            562;569;576;583;590;597;604;612;619;626;634;642;...
            649;657;665;673;681;690;698;706;715;723;732;741;...
            750;759;768;777;787;796;806;816;825;835;845;856;...
            866;876;887;898;909;920;931;942;953;965;976;988];
    otherwise
        error('Second argument <def> value is not supported: %d',def)
end
%
% Preallocate output matrices:
Y = NaN(size(X));
pns = [];
edg = [];
idx = Y;
% Indices of input values to be rounded:
I = isfinite(X) & 0<X;
%
if any(I(:))
    % Finite positive values only:
    X = X(I);
    % Order of PNS magnitude required:
    omn = floor(log10(min(X)));
    omx = ceil(log10(max(X)));
    % Extrapolate PNS vector to cover input values:
    pns = P*10.^(omn:omx);
    pns = [P(end-1:end).*10^(omn-1);pns(:);P(1:2).*10^(omx+1)]/100;
    % Generate PNS bin edge values (harmonic mean = optimal tolerance):
    edg = 2*pns(1:end-1).*pns(2:end)./(pns(1:end-1)+pns(2:end));
    % Place values of X into PNS bins:
    [~,bin] = histc(X,edg);
    % Round input value to PNS values:
    Y(I) = pns(1+bin);
    % Remove superfluous PNS & edge values from vectors:
    pns = pns(1+min(bin):max(bin)+1);
    edg = edg(0+min(bin):max(bin)+1);
    idx(I) = 1 + bin - min(bin);
end
%
end
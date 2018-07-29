function tLogQuant (enc)
% Test Quant for A or mu-law quantizer tables

addpath(fileparts(pwd));        % Add parent directory

if (nargin < 1)
  enc = 'u';
end



if (strcmp(enc, 'u'))
  [Yq, Xq, Code, ICode] = QuantMuLawTables;
  disp('=== Testing u-law quantizer ===');
elseif (strcmp(enc, 'A'))
  [Yq, Xq, Code, ICode] = QuantALawTables;
  disp('=== Testing A-Law quantizer ===');
end

Xq = 32768 * Xq;
Yq = 32768 * Yq;

% ------------------------
% Consistency check, use quantizer levels as input
x = Yq;
IndexB = QuantXX(x, Xq, 'UL')';
IcB = Code(IndexB+1);
IndexBC = ICode(IcB+1);

yy = Yq(IndexBC+1);
if (any(IndexB ~= IndexBC))
  error('Coded Index table mismatch for QuantXX');
end
if (any(yy ~= x))
  error('Value mismatch for QuantXX with YQ as input');
end

% ------------------------
% Check all integer values
x = (-32768:32768);
N = length(x);

% Coder B (BLL ...)
tic;
IndexBLL = QuantXX(x, Xq, 'LL');     % Move up
IcBLL = Code(IndexBLL+1);
fprintf('Time Quant (Type = LL, %d values): %g, s\n', N, toc);

tic
IndexBUL = QuantXX(x, Xq, 'UL');     % Move towards zero
IcBUL = Code(IndexBUL+1);
fprintf('Time Quant (Type = UL, %d values): %g s\n', N, toc);

% Coder C
tic;
IndexC = quantiz(x, Xq);             % Equivalent to Type = 'LL'
fprintf('Time quantiz (%d values): %g s\n', N, toc);

% Coder D
tic
IcD = CodeXlaw(x, enc);
fprintf('Time CodeXlaw (%d values): %g s\n', N, toc);

if (any(IndexC ~= IndexBLL))
  error('Quantizer mismatch with quantiz');
end

if (any(IcBUL ~= IcD))
  error('Quantizer  mismatch with CodeXlaw');
end

% Decoder B
tic
xaBLL = Yq(ICode(IcBLL+1)+1);
fprintf('Time ICode (%d values): %g s\n', N, toc);

xaBUL = Yq(ICode(IcBUL+1)+1);

% Decoder C
xaC = Yq(IndexC+1);

% Decoder D
tic
xaD = DecodeXlaw(IcD, enc);
fprintf('Time DecodeXlaw (%d values): %g s\n', N, toc);

disp(' -----');
fprintf('Maximum difference quantiz: %d\n', max(abs(xaC-xaBLL)));
fprintf('Maximum difference CodeXlaw/DecodeXlaw: %d\n', max(abs(xaD-xaBUL)));

return

% ----- -----
function xc = QuantXX (x, Xq, Type)

% Type 'UL' means negative values move up, positive values move down

if (strcmp(Type, 'LL'))
  xc = Quant(x, Xq, 1);     % Upper interval edge included

elseif (strcmp(Type, 'UU'))
  xc = Quant(x, Xq, 2);
  
elseif (strcmp(Type, 'UL'))
  IP = find(x >= 0);
  IN = find(x < 0);
  xc(IP) = Quant(x(IP), Xq, 2);
  xc(IN) = Quant(x(IN), Xq, 1);

elseif (strcmp(Type, 'LU'))
  IP = find(x >= 0);
  IN = find(x < 0);
  xc(IP) = Quant(x(IP), Xq, 1);
  xc(IN) = Quant(x(IN), Xq, 2);
  
end

return

% ----- -----
function C = CodeXlaw (x, enc)

if (strcmp(enc, 'u'))
  C = lin2mu(x / 32768)';
elseif (strcmp(enc, 'A'))
  C = lin2pcma(x, 85, 1/8)'; % Normalized to +/- 32768
end

return

% ----- -----
function xv = DecodeXlaw (C, enc)

if (strcmp(enc, 'u'))
  xv = 32768 * mu2lin(C);
elseif (strcmp(enc, 'A'))
  xv = pcma2lin(C, 85, 1/8); % Normalized to +/- 32768
end

return

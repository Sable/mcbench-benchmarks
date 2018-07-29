% md5   Compute MD5 hash function for files
%
%   d = md5(FileName)
%
%   md5() computes the MD5 hash function of
%   the file specified in the string FileName
%   and returns it as a 64-character array d.


%   The MD5 message-digest algorithm is specified
%   in RFC 1321.

%  The code below is for instructional and illustrational
%  purposes only. It is very clear, but very slow.

% (C) Stefan Stoll, ETH Zurich, 2006

function Digest = md5(FileName)

% Guard against old Matlab versions
MatlabVersion = version;
if MatlabVersion(1)<'7'
  error('md5() requires Matlab 7.0 or later!');
end

% Run autotest if no parameters are given
if (nargin==0)
  md5autotest;
  return;
end

% Read in entire file into uint32 vector
[Message,nBits] = readmessagefromfile(FileName);

%--------------------------------------------------

% Append a bit-1 to the last bit read from file
BytesInLastInt = mod(nBits,32)/8;
if BytesInLastInt
  Message(end) = bitset(Message(end),BytesInLastInt*8+8);
else
  Message = [Message; uint32(128)];
end

% Append zeros
nZeros = 16 - mod(numel(Message)+2,16);
Message = [Message; zeros(nZeros,1,'uint32')];

% Append bit length of original message as uint64, lower significant uint32 first
Lower32 = uint32(nBits);
Upper32 = uint32(bitshift(uint64(nBits),-32));
Message = [Message; Lower32; Upper32];

%--------------------------------------------------

% 64-element transformation array
T = uint32(fix(4294967296*abs(sin(1:64))));

% 64-element array of number of bits for circular left shift
S = repmat([7 12 17 22; 5 9 14 20; 4 11 16 23; 6 10 15 21].',4,1);
S = S(:).';

% 64-element array of indices into X
idxX  = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ...
         1 6 11 0 5 10 15 4 9 14 3 8 13 2 7 12 ...
         5 8 11 14 1 4 7 10 13 0 3 6 9 12 15 2 ...
         0 7 14 5 12 3 10 1 8 15 6 13 4 11 2 9] + 1;

% Initial state of buffer (consisting of A, B, C and D)
A = uint32(hex2dec('67452301'));
B = uint32(hex2dec('efcdab89'));
C = uint32(hex2dec('98badcfe'));
D = uint32(hex2dec('10325476'));

%--------------------------------------------------

Message = reshape(Message,16,[]);

% Loop over message blocks each 16 uint32 long
for iBlock = 1:size(Message,2)
  
  % Extract next block
  X = Message(:,iBlock);
  
  % Store current buffer state
  AA = A;
  BB = B;
  CC = C;
  DD = D;

  % Transform buffer using message block X and the
  % parameters from S, T and idxX
  k = 0;
  for iRound = 1:4
    for q = 1:4
      A = Fun(iRound,A,B,C,D,X(idxX(k+1)),S(k+1),T(k+1));
      D = Fun(iRound,D,A,B,C,X(idxX(k+2)),S(k+2),T(k+2)); 
      C = Fun(iRound,C,D,A,B,X(idxX(k+3)),S(k+3),T(k+3)); 
      B = Fun(iRound,B,C,D,A,X(idxX(k+4)),S(k+4),T(k+4)); 
      k = k + 4;
    end
  end
  
  % Add old buffer state
  A = bitadd32(A,AA);
  B = bitadd32(B,BB);
  C = bitadd32(C,CC);
  D = bitadd32(D,DD);

end

%--------------------------------------------------

% Combine uint32 from buffer to form message digest
Str = lower(dec2hex([A;B;C;D]));
Str = Str(:,[7 8 5 6 3 4 1 2]).';
Digest = Str(:).';

%==================================================

function y = Fun(iRound,a,b,c,d,x,s,t)
switch iRound
case 1
  q = bitor(bitand(b,c),bitand(bitcmp(b),d));
case 2
  q = bitor(bitand(b,d),bitand(c,bitcmp(d)));
case 3
  q = bitxor(bitxor(b,c),d);
case 4
  q = bitxor(c,bitor(b,bitcmp(d)));
end
y = bitadd32(b,rotateleft32(bitadd32(a,q,x,t),s));

%--------------------------------------------

function y = rotateleft32(x,s)
y = bitor(bitshift(x,s),bitshift(x,s-32));

%--------------------------------------------

function sum = bitadd32(varargin)
sum = varargin{1};
for k = 2:nargin
  add = varargin{k};
  carry = bitand(sum,add);
  sum = bitxor(sum,add);
  for q = 1:32
    shift = bitshift(carry,1);
    carry = bitand(shift,sum);
    sum = bitxor(shift,sum);
  end
end

function [Message,nBits] = readmessagefromfile(FileName)
[hFile,ErrMsg] = fopen(FileName,'r');
error(ErrMsg);
%Message = fread(hFile,inf,'bit32=>uint32');
Message = fread(hFile,inf,'ubit32=>uint32');
fclose(hFile);
d = dir(FileName);
nBits = d.bytes*8;

%============================================

function md5autotest

disp('Running md5 autotest...');

Messages{1} = '';
Messages{2} = 'a';
Messages{3} = 'abc';
Messages{4} = 'message digest';
Messages{5} = 'abcdefghijklmnopqrstuvwxyz';
Messages{6} = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
Messages{7} = char(128:255);

CorrectDigests{1} = 'd41d8cd98f00b204e9800998ecf8427e';
CorrectDigests{2} = '0cc175b9c0f1b6a831c399e269772661';
CorrectDigests{3} = '900150983cd24fb0d6963f7d28e17f72';
CorrectDigests{4} = 'f96b697d7cb7938d525a2f31aaf161d0';
CorrectDigests{5} = 'c3fcd3d76192e4007dfb496cca67e13b';
CorrectDigests{6} = 'd174ab98d277d9f5a5611c2c9f419d9f';
CorrectDigests{7} = '16f404156c0500ac48efa2d3abc5fbcf';

TmpFile = tempname;
for k=1:numel(Messages)
  [h,ErrMsg] = fopen(TmpFile,'w');
  error(ErrMsg);
  fwrite(h,Messages{k},'char');
  fclose(h);
  Digest = md5(TmpFile);
  fprintf('%d: %s\n',k,Digest);
  if ~strcmp(Digest,CorrectDigests{k})
    error('md5 autotest failed on the following string: %s',Messages{k});
  end
end
delete(TmpFile);
disp('md5 autotest passed!');

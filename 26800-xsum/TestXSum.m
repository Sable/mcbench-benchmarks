function TestXSum(doSpeed)
% Automatic test: XSum
% This is a routine for automatic testing. It is not needed for processing and
% can be deleted or moved to a folder, where it does not bother.
%
% TestXSum(doSpeed)
% INPUT:
%   doSpeed: Optional logical flag to trigger time consuming speed tests.
%            Default: TRUE. If no speed test is defined, this is ignored.
% OUTPUT:
%   On failure the test stops with an error.
%
% Tested: Matlab 6.5, 7.7, 7.8, WinXP
% Author: Jan Simon, Heidelberg, (C) 2010 matlab.THISYEAR(a)nMINUSsimon.de

% $JRev: R0p V:015 Sum:yqlcwUee8BQZ Date:24-Feb-2010 23:50:29 $
% $License: BSD (see Docs\BSD_License.txt) $
% $File: Published\XSum\TestXSum.m $

% Initialize: ==================================================================
if nargin == 0
   doSpeed = true;
end
if doSpeed
   TestTime = 1;  % [sec]
else
   TestTime = 0.2;
end

% Hello:
ErrID = ['JSim:', mfilename];
whichXSum = which('XSum');

disp(['==== Test XSum:  ', datestr(now, 0), char(10), ...
      'Version: ', whichXSum, char(10)]);

disp('Ask XSum for compilation settings: ------');
Id = evalc('XSum');
fprintf(Id);
disp('-----------------------------------------');

% Methods in most likely (depends on compiler) increasing accuracy:
Method = {'Double', 'Long', 'Kahan', 'Knuth', 'KnuthLong', 'Knuth2', 'QFloat'};

% I've created a version with 384 bit QFloats also, but this needs the LCC v3.8
% compiler, which is not completely compatible with Matlab 2009a:
hasQFloat = any(findstr(lower(Id), 'qfloat: yes'));
if ~hasQFloat
   Method(strcmpi(Method, 'QFloat'))= [];
end

hasLongDouble = any(findstr(lower(Id), 'long double: yes'));
if ~hasLongDouble
   fprintf(['\n!!! The compiler does not support long doubles !!!\n', ...
         '  1. KnuthLong is forwarded to Knuth2.\n', ...
         '  2. XSum(A, [], ''LONG'') can be more precise than SUM(A), if ', ...
         'the compiler \n     accumulates the sum in a 80 bit register, ', ...
         'e.g. Open Watcom 1.8.\n']);
   Method(strcmpi(Method, 'KnuthLong'))= [];
end

nMethod = length(Method);

% Start tests: -----------------------------------------------------------------
% At first proove that some trivial summing work well:
disp([char(10), '== Test small input without rounding errors:']);
disp('  This would stop with an error on problems.');

for iMethod = 1:nMethod
   aMethod = Method{iMethod};
   disp(['-- ', aMethod, ':']);
   
   S = XSum([], [], aMethod);
   if isempty(S)
      disp('  ok: XSum([])');
   else
      error(ErrID, 'XSum([])');
   end
   
   S = XSum([], 1, aMethod);
   if isempty(S)
      disp('  ok: XSum([], 1)');
   else
      error(ErrID, 'XSum([], 1)');
   end

   S = XSum([], 2, aMethod);
   if isempty(S)
      disp('  ok: XSum([], 2)');
   else
      error(ErrID, 'XSum([], 2)');
   end

   S = XSum(1, [], aMethod);
   if isequal(S, 1)
      disp('  ok: XSum(1)');
   else
      error(ErrID, 'XSum(1)');
   end

   S = XSum(1, 1, aMethod);
   if isequal(S, 1)
      disp('  ok: XSum(1, 1)');
   else
      error(ErrID, 'XSum(1, 1)')
   end

   S = XSum(1, 2, aMethod);
   if isequal(S, 1)
      disp('  ok: XSum(1, 2)');
   else
      error(ErrID, 'XSum(1, 2)');
   end
   
   S = XSum([1, 1], [], aMethod);
   if isequal(S, 2)
      disp('  ok: XSum([1, 1], [])');
   else
      error(ErrID, 'XSum([1, 1], [])');
   end

   S = XSum([1, 1], 1, aMethod);
   if isequal(S, [1, 1])
      disp('  ok: XSum([1, 1], 1)');
   else
      error(ErrID, 'XSum([1, 1], 1)');
   end

   S = XSum([1, 1], 2, aMethod);
   if isequal(S, 2)
      disp('  ok: XSum([1, 1], 2)');
   else
      error(ErrID, 'XSum([1, 1], 2)');
   end
   
   S = XSum([1; 1], [], aMethod);
   if isequal(S, 2)
      disp('  ok: XSum([1; 1], [])');
   else
      error(ErrID, 'XSum([1; 1], [])');
   end

   S = XSum([1; 1], 1, aMethod);
   if isequal(S, 2)
      disp('  ok: XSum([1; 1], 1)');
   else
      error(ErrID, 'XSum([1; 1], 1)');
   end

   S = XSum([1; 1], 2, aMethod);
   if isequal(S, [1; 1])
      disp('  ok: XSum([1; 1], 2)');
   else
      error(ErrID, 'XSum([1; 1], 2)');
   end
   
   S = XSum([1, 1, 1], [], aMethod);
   if isequal(S, 3)
      disp('  ok: XSum([1, 1, 1], [])');
   else
      error(ErrID, 'XSum([1, 1, 1], [])');
   end

   S = XSum([1, 1, 1], 1, aMethod);
   if isequal(S, [1, 1, 1])
      disp('  ok: XSum([1, 1, 1], 1)');
   else
      error(ErrID, 'XSum([1, 1, 1], 1)');
   end
   
   S = XSum([1, 1, 1], 2, aMethod);
   if isequal(S, 3)
      disp('  ok: XSum([1, 1, 1], 2)');
   else
      error(ErrID, 'XSum([1, 1, 1], 2)');
   end
   
   S = XSum([1; 1; 1], [], aMethod);
   if isequal(S, 3)
      disp('  ok: XSum([1; 1; 1], [])');
   else
      error(ErrID, 'XSum([1; 1; 1], [])');
   end

   S = XSum([1; 1; 1], 1, aMethod);
   if isequal(S, 3)
      disp('  ok: XSum([1; 1; 1], 1)');
   else
      error(ErrID, 'XSum([1; 1; 1], 1)');
   end
   
   S = XSum([1; 1; 1], 2, aMethod);
   if isequal(S, [1; 1; 1])
      disp('  ok: XSum([1; 1; 1], 2)');
   else
      error(ErrID, 'XSum([1; 1; 1], 2)');
   end
   
   S = XSum([1, 2; 3, 4], [], aMethod);
   if isequal(S, [4, 6])
      disp('  ok: XSum([1,2;3,4], [])');
   else
      error(ErrID, 'XSum([1,2;3,4], [])');
   end

   S = XSum([1, 2; 3, 4], 1, aMethod);
   if isequal(S, [4, 6])
      disp('  ok: XSum([1,2;3,4], 1)');
   else
      error(ErrID, 'XSum([1,2;3,4], 1)');
   end
   
   S = XSum([1, 2; 3, 4], 2, aMethod);
   if isequal(S, [3; 7])
      disp('  ok: XSum([1,2;3,4], 2)');
   else
      error(ErrID, 'XSum([1,2;3,4], 2)');
   end
   
   X = reshape(1:2*3*5*7, [2, 3, 5, 7]);
   for iDim = 1:4
      Ssum = sum(X, iDim);
      S    = XSum(X, iDim, aMethod);
      if isequal(S, Ssum)
         fprintf('  ok: XSum([2 x 3 x 5 x 7], %d)\n', iDim);
      else
         error(ErrID, '  ok: XSum([2 x 3 x 5 x 7], %d)\n', iDim);
      end
   end
end

% Measure error compensation - this cannot be "tested", because it is not known,
% what is "correct" or "wrong".
disp([char(10), '== Test error compensation:']);
disp('  Standard truncation error ignores small numbers');
disp('-- [10^k, 1, 1, -10^k] = 2 ?');

Data = [15:21, 104:106];  % 15:120
fprintf('       k =');
fprintf(' %3d', Data);
fprintf('\n');
for iMethod = 0:nMethod
   switch iMethod
      case 0,    aMethod = 'Matlab';
      otherwise, aMethod = Method{iMethod};
   end
   fprintf('%-9s:  ', aMethod);
   for iN = Data;
      X = [10^iN, 1, 1, -10^iN];
      switch iMethod
         case 0,    S = sum(X, 2);
         otherwise, S = XSum(X, 2, aMethod);
      end
      fprintf('%2g  ', S);
   end
   fprintf('\n');
   drawnow;
end

fprintf('\n');
disp('-- [10^2k, 1, 10^k, 1, -10^k, 1, -10^2k] = 3 ?');
Data = [7:11, 15:21, 51:54];   % 4:120;
fprintf('       k =');
fprintf(' %3d', Data);
fprintf('\n');
for iMethod = 0:nMethod
   switch iMethod
      case 0,    aMethod = 'Matlab';
      otherwise, aMethod = Method{iMethod};
   end
   fprintf('%-9s:  ', aMethod);
   for iN = Data;
      X = [10^(2*iN), 1, 10^iN, 1, -10^iN, 1, -10^(2*iN)];
      switch iMethod
         case 0,    S = sum(X, 2);
         otherwise, S = XSum(X, 2, aMethod);
      end
      fprintf('%2g  ', S);
   end
   fprintf('\n');
   drawnow;
end

% ------------------------------------------------------------------------------
nLoop = 100;  % A small averaging
Len   = 1000;
fprintf('\n-- Test with random data:\n')
fprintf('  X = +-rand(1E3, 1) * 10 .^ rand(1E3, 1) * Exp,  exact sum = 0.0\n');
fprintf('  Average over absolute results of %d runs:\n', nLoop);
fprintf('  Smaller results are better!\n');

cVector = 6:32;
if hasQFloat
   cVector = [cVector, 99];
end
fprintf('     Exp = ');
fprintf('       1E%.2d', cVector);
fprintf('\n');

for iMethod = 0:nMethod
   switch iMethod
      case 0,    aMethod = 'Matlab';
      otherwise, aMethod = Method{iMethod};
   end
   fprintf('%-9s: ', aMethod);
   
   for c = cVector
      S = 0;
      for j = 1:nLoop
         X = RandTestData(Len, c);
         switch iMethod
            case 0,    S = S + abs(sum(X, 1)) / nLoop;
            otherwise, S = S + abs(XSum(X, 1, aMethod)) / nLoop;
         end
      end
      fprintf('%11.3G', S);
   end
   fprintf('\n');
   drawnow;
end

% ------------------------------------------------------------------------------
fprintf('\n-- Compare accuracy of results:\n')
nLoop = 100;  % A small averaging
if hasQFloat && 0
   c = 120;
else
   c = 48;   % > 16, e.g. with 48 all outputs have a similar format
end

fprintf('  X = +-rand(N, 1) * 10 .^ rand(N, 1) * Exp,  exact sum = 0.0\n');
fprintf('  Average over absolute results of %d runs:\n', nLoop);
fprintf('  Smaller results are better!\n');

for LenExp = 3:5
   fprintf('  N = 1E%d,  Exp = 1E%.2d\n', LenExp, c);
   Len = 10 ^ LenExp;
   
   TestM = zeros(Len, nLoop);
   for iLoop = 1:nLoop
      TestM(:, iLoop) = RandTestData(Len, c);
   end
   
   for iMethod = -1:nMethod
      switch iMethod
         case -1,    aMethod = 'SUM';
         case  0,    aMethod = 'SUM(SORT)';
         otherwise,  aMethod = Method{iMethod};
      end
      
      S = 0;
      for iLoop = 1:nLoop
         X = TestM(:, iLoop);
         switch iMethod
            case -1,   S = S + abs(sum(X, 1)) / nLoop;
            case  0,   S = S + abs(sum(sort(X), 1)) / nLoop;
            otherwise, S = S + abs(XSum(X, 1, aMethod)) / nLoop;
         end
      end
      fprintf('    %-9s: %.6G\n', aMethod, S);
      drawnow;
   end
end

% RANDN:
nLoop = 20;
fprintf(['\n  RANDN: Absolute results, sum estimated by Knuth2, ', ...
      'average over %d runs:\n'], nLoop);
fprintf('  Smaller results are better!\n');
fprintf('  0 must be replied for Knuth2, but even Knuth should be exact.\n');

for LenExp = 4:6
   fprintf('  X = RANDN(1, 1E%d):\n', LenExp);
   Len = 10 ^ LenExp;
   
   MethodSum = zeros(1, nMethod + 2);
   for iLoop = 1:20
      TestM    = randn(Len, 1);
      EstimSum = XSum(TestM, 1, 'Knuth2');
      
      for iMethod = -1:nMethod
         switch iMethod
            case -1
               S = abs(sum(TestM, 1) - EstimSum);
            case 0
               S = abs(sum(sort(TestM), 1) - EstimSum);
            otherwise
               aMethod = Method{iMethod};
               S = abs(XSum(TestM, 1, aMethod) - EstimSum);
         end
         MethodSum(iMethod + 2) = MethodSum(iMethod + 2) + S / nLoop;
      end   
   end
   
   for iMethod = -1:nMethod
      switch iMethod
         case -1,   aMethod = 'SUM';
         case 0,    aMethod = 'SUM(SORT)';
         otherwise, aMethod = Method{iMethod};
      end
      fprintf('    %-9s: %.8G\n', aMethod, MethodSum(iMethod + 2));
      drawnow;
   end
end

% Speed: -----------------------------------------------------------------------
fprintf('\n-- Compare times:\n');
LenList = [1E3, 1E4, 1E5, 1E6, 1E7];

fprintf('  SUM(RAND(N, 1)):\n');
fprintf('       N =');
fprintf('     1E%d', round(log10(LenList)));
fprintf('\n');
Time_SUM = zeros(1, length(LenList));
for iMethod = -1:nMethod
   switch iMethod
      case -1,   aMethod = 'SUM';
      case 0,    aMethod = 'SUM(SORT)';
      otherwise, aMethod = Method{iMethod};
   end
   fprintf('%-9s:', aMethod);
   
   Time_Method = zeros(1, length(LenList));
   
   for iLen = 1:length(LenList)
      Len = LenList(iLen);
      X   = rand(Len, 1);
      
      % Get number of loops:
      N     = 0;
      iTime = cputime;
      while cputime - iTime < 0.5
         S = sum(X);  clear('S');
         N = N + 1;
      end
      nLoop = N / (cputime - iTime);  % Loops per second
      nLoop = max(1, ceil(nLoop * TestTime));
      
      switch iMethod
         case -1
            tic;
            for iLoop = 1:nLoop
               S = sum(X);  clear('S');
            end
            nPerSec = nLoop / toc;
            Time_SUM(iLen) = nPerSec;
            
         case 0
            tic;
            mLoop = nLoop / 10;  % Reduce test time!
            for iLoop = 1:mLoop
               S = sum(sort(X));  clear('S');
            end
            nPerSec = mLoop / toc;
            
         otherwise
            if strcmpi(aMethod, 'qfloat')  % QFloat is very slow...
               mLoop = nLoop / 10;
            else
               mLoop = nLoop;
            end
            
            tic;
            for iLoop = 1:mLoop
               S = XSum(X, 1, aMethod);  clear('S');   %#ok<*NASGU>
            end
            nPerSec = mLoop / toc;
      end
      Time_Method(iLen) = nPerSec;
      
      PrintLoop(nPerSec);
   end
   fprintf('   loops/sec\n');
   
   if iMethod ~= -1
      fprintf('          ');
      fprintf('%8.1f', Time_SUM ./ Time_Method);
      fprintf('   time for SUM\n');
   end
end

% Goodbye:
fprintf('\nXSum seems to work fine.\n');

return;

% ******************************************************************************
function PrintLoop(N)
if N > 10
   fprintf('  %6.0f', N);
else
   fprintf('  %6.1f', N);
end

return;

% ******************************************************************************
function X = RandTestData(n, c)
% Test vector with exact sum is 0.
% INPUT:  n: Length of output vector, must be even.
%         c: The output has a maximum absolute value of 10^c.
% OUTPUT: X: Random [1 x n] double vector with exact sum 0.
%
% Simple approach: Create random numbers with random exponent and append a copy
% with opposite sign. Finally the vector is mixed.
% Data created with this method are definitely not valid to test the SUM over
% sorted absolute values

m = n / 2;
X = rand(m, 1) .* 10 .^ ceil(rand(m, 1) * c);
X = [X; -X];
X = randmix(X);

return;

% ******************************************************************************
function X = randmix(X)
% Faster RANDPERM, Knuth's shuffle
% Author: Jan Simon, Heidelberg, (C) 2010 matlab.THISYEAR(a)nMINUSsimon.de

for i = 1:numel(X)
   w    = ceil(rand * i);
   t    = X(w);
   X(w) = X(i);
   X(i) = t;
end
   
return;

function uTest_DGradient(doSpeed)
% Unit test: DGradient
% This is a routine for automatic testing. It is not needed for processing and
% can be deleted or moved to a folder, where it does not bother.
%
% uTest_DGradient(doSpeed)
% INPUT:
%   doSpeed: If ANY(doSpeed) is TRUE, the speed is measured.
% OUTPUT:
%   On failure the test stops with an error.
%
% Tested: Matlab 6.5, 7.7, 7.8, WinXP
% Author: Jan Simon, Heidelberg, (C) 2009-2011 matlab.THISYEAR(a)nMINUSsimon.de

% $JRev: R0k V:010 Sum:jVli3Fk6CFXC Date:02-Jan-2010 02:42:11 $
% $License: BSD $
% $File: Tools\UnitTests_\uTest_DGradient.m $

% Initialize: ==================================================================
% Global Interface: ------------------------------------------------------------
ErrID = ['JSimon:', mfilename];

hasDerivative   = ~isempty(which('derivative'));
hasCentral_Diff = ~isempty(which('central_diff'));
hasDiffXY       = ~isempty(which('diffxy'));

% Initial values: --------------------------------------------------------------
LF = char(10);

% Program Interface: -----------------------------------------------------------
if nargin == 0
   doSpeed = true;
end

randTestTime = 0.5;  % Time for random tests

% User Interface: --------------------------------------------------------------
% Do the work: =================================================================
disp(['==== Test DGradient  ', datestr(now, 0)]);
disp(['  Version: ', which('DGradient')]);
pause(0.01);  % Flush events

Y = DGradient([]);
Y = DGradient([], 1);
Y = DGradient([], 2);
Y = DGradient([], 3);
disp('  ok: DGradient([])');

Y0 = DGradient(1);
Y1 = DGradient(1, 1);
Y2 = DGradient(1, 2);
Y3 = DGradient(1, 3);
if Y0 == 0 && Y1 == 0 && Y2 == 0 && Y3 == 0
   disp('  ok: DGradient(1) is 0')
else
   error('*** DGradient(1) ~= 0');
end

x  = [1, 2; 3, 4];
Y1 = DGradient(x, 1.0, 1);
Y2 = DGradient(x, 1.0, 2);
if isequal(Y1, 2*ones(2)) && isequal(Y2, ones(2))
   disp('  ok: DGradient([1,2;3,4]) no interior points');
else
   error('*** Bad reply for DGradient([1,2;3,4])');
end

x  = [1, 2, 3; 4, 5, 6; 7, 8, 9];
Y1 = DGradient(x, 1.0, 1);
Y2 = DGradient(x, 1.0, 2);
if isequal(Y1, 3*ones(3)) && isequal(Y2, ones(3))
   disp('  ok: DGradient([1:3;4:6,7:9]) one interior point');
else
   error('*** Bad reply for DGradient([1:3;4:6,7:9])');
end

x  = [1, 4, 9; 16, 25, 36; 49, 64, 81];
Y1 = DGradient(x, 1.0, 1);
Y2 = DGradient(x, 1.0, 2);
if max(abs(Y1(:) - [15; 24; 33; 21; 30; 39; 27; 36; 45])) < 10*eps && ...
      max(abs(Y2(:) - [3; 9; 15; 4; 10; 16; 5; 11; 17])) < 10*eps
   disp('  ok: DGradient([1:3;4:6,7:9].^2) one interior point');
else
   error('*** Bad reply for DGradient([1:3;4:6,7:9].^2)');
end

x  = rand(1, 1000);
y  = DGradient(x);
y2 = gradient(x);
if max(abs(y2 - y)) < 10*eps
   disp('  ok: DGradient(rand(1, 1000)) equals GRADIENT');
else
   error('*** DGradient(rand(1, 1000)) differs from GRADIENT');
end

y = DGradient(x, 1.0, 1);
if isequal(y, zeros(size(x)))
   disp('  ok: DGradient(rand(1, 1000), 1.0, 1) equals ZEROS');
else
   error('*** DGradient(rand(1, 1000), 1.0, 1) differs from ZEROS');
end

y  = DGradient(x);
y2 = DGradient(x, 1.0);
if max(abs(y2 - y)) < 10*eps
   disp('  ok: DGradient(X, 1.0) equals DGradient(X)');
else
   error('*** DGradient(X, 1.0) differs DGradient(X)');
end

y1 = DGradient(x, 1.0, 2);
y2 = DGradient([x;x], 1.0, 2);
if max(abs(y2(1, :) - y1)) < 10*eps && max(abs(y2(2, :) - y1)) < 10*eps
   disp('  ok: DGradient([X; X]) equals [DGradient(X); DGradient(X)]');
else
   error('*** DGradient([X; X]) differs [DGradient(X); DGradient(X)]');
end

y2 = DGradient(x', 1.0, 1);
y3 = DGradient([x', x'], 1.0, 1);
if isequal(y1, y2') && ...
      max(abs(y3(:, 1)' - y1)) < 10*eps && max(abs(y3(:, 2)' - y1)) < 10*eps
   disp('  ok: DGradient([X'', X'']) equals [DGradient(X); DGradient(X)]''');
else
   error('*** DGradient([X'', X'']) differs [DGradient(X); DGradient(X)]''');
end

% Get both directions for a matrix - GRADIENT swaps the output!
X  = rand(4, 1000);
Y1 = DGradient(X, [], 1);
Y2 = DGradient(X, [], 2);
[G1, G2] = gradient(X);
if max(abs(Y1(:) - G2(:))) < 10*eps && max(abs(Y2(:) - G1(:))) < 10*eps
   disp('  ok: DGradient(rand(4, 1000)) equals GRADIENT');
else
   error('*** DGradient(rand(4, 1000)) differs from GRADIENT');
end

X  = rand(4, 5, 6);
Y1 = DGradient(X, [], 1);
Y2 = DGradient(X, [], 2);
Y3 = DGradient(X, [], 3);
[G1, G2, G3] = gradient(X);
if max(abs(Y1(:) - G2(:))) < 10*eps && max(abs(Y2(:) - G1(:))) < 10*eps ...
      && max(abs(Y3(:) - G3(:))) < 10*eps
   disp('  ok: DGradient(rand(4, 5, 6)) equals GRADIENT');
else
   error('*** DGradient(rand(4, 5, 6)) differs from GRADIENT');
end

% Unevenly spaced data: --------------------------------------------------------
% Lines or rows must be equal for a [2x2] matrix, because forward and backward
% differences are equal:
x  = [1, 7; 11, 19];
t  = [1, 3];
Y1 = DGradient(x, t, 1);
Y2 = DGradient(x, t, 2);
wantY1 = [5, 6; 5, 6];
wantY2 = [3, 3; 4, 4];
if max(abs(Y1(:) - wantY1(:))) < 10*eps && ...
      max(abs(Y2(:) - wantY2(:))) < 10*eps
   disp('  ok: DGradient([1,7;11,19], [1,3]) no interior point');
else
   error('*** Bad reply for DGradient([1,7;11,19], [1,3])');
end

x  = [1, 4, 9; 16, 25, 36; 49, 64, 81];
t  = [1, 5, 13];
Y1 = DGradient(x, t, 1);
Y2 = DGradient(x, t, 2);
wantY1 = [3.75; 4; 4.125; 5.25; 5; 4.875; 6.75; 6; 5.625];
wantY2 = [2.25; 6.75; 11.25; 2; 5; 8; 1.875; 4.125; 6.375] / 3;
if max(abs(Y1(:) - wantY1)) < 10*eps && ...
      max(abs(Y2(:) - wantY2)) < 10*eps
   disp('  ok: DGradient([1:3;4:6,7:9].^2, [1,5,13]) one interior point');
else
   error('*** Bad reply for DGradient([1:3;4:6,7:9].^2, [1,5,13])');
end

% The method for unevenly spaces input is applied if the Spacing is defined as
% vector, also if it is evenly spaced:
x  = rand(50, 50, 50);
t  = (1:50) / 2;
Y1 = DGradient(x, t, 1);
Y2 = DGradient(x, t, 2);
Y3 = DGradient(x, t, 3);
E1 = DGradient(x, 0.5, 1);
E2 = DGradient(x, 0.5, 2);
E3 = DGradient(x, 0.5, 3);
if max(abs(Y1(:) - E1(:))) < 10*eps && ...
      max(abs(Y2(:) - E2(:))) < 10*eps && ...
      max(abs(Y3(:) - E3(:))) < 10*eps
   disp('  ok: DGradient(X, ONES(1,N)) equals DGradient(X, 1.0)');
else
   error('*** DGradient(X, ONES(1,N)) differs from DGradient(X, 1.0)');
end

% Get mean difference between 1st and 2nd order method for: d/dx(sin(x))
t   = cumsum(rand(1, 100))+0.01;
t   = 2*pi * t ./ max(t);
x   = sin(t);
dx1 = DGradient(x, t, 2, '1stOrder');
dx2 = DGradient(x, t, 2, '2ndOrder');
dx  = cos(t);          % Analytic solution

% Plot the diagrams, if the test function was called without inputs:
if nargin == 0
   figure('NumberTitle', 'off', 'Name', [mfilename, ' 1'], 'ToolBar', 'none');
   h1 = plot(t, dx, t, dx1, 'or', t, dx2, 'og');
   axis('tight');
   title('cos(x) and DGradient(sin(x))');
   
   Fig2 = figure('NumberTitle', 'off', 'Name', [mfilename, ' 2'], ...
      'ToolBar', 'none');
   set(Fig2, 'Position', get(Fig2, 'Position') + [20, -20, 0, 0]);
   h2 = plot(t, dx - dx1, 'r', t, dx- dx2, 'g');
   axis('tight');
   title('cos(x) - DGradient(sin(x))');
   
   if sscanf(version, '%d', 1) >= 7
      Location = {'location', 'SouthEast'};
   else
      Location = {4};
   end
   legend(h1, {'analytic', '1st order', '2nd order'}, Location{:});
   legend(h2, {'1st order', '2nd order'}, Location{:});
   
   drawnow;
end

fprintf('\nCompare DGradient(sin(x)) and cos(x):\n');
fprintf('  1st order:  mean(abs)=%.8f  min=%.8f  max=%.8f\n', ...
   mean(abs(dx-dx1)), min(dx-dx1), max(dx-dx1));
fprintf('  2nd order:  mean(abs)=%.8f  min=%.8f  max=%.8f\n', ...
   mean(abs(dx-dx2)), min(dx-dx2), max(dx-dx2));
if mean(abs(dx-dx1)) / 10 > mean(abs(dx-dx2))
   disp('  ok: mean error(2nd order) < 10 * mean error(1st order)');
else  % A failure is very unlikely, but RAND values are dangerous ever...
   % This test fails if t is nearly evenly spaced.
   error(['*** Mean error of 2nd order method greater than expected!\n', ...
      '   Please run the test again.']);
end

% Speed comparisons: -----------------------------------------------------------
if doSpeed
   fprintf('\n== Speed comparison:\n');
   LenList = [10, 1000, 2000, 4000, 8000, 16000, 32000, 64000];
   unevenT = cumsum(rand(1, LenList(length(LenList)))) + 0.01;
   
   HeadFmt = '  %-13s ';
   fprintf('%-16s', '[1 x N], N =');
   fprintf('%8d', LenList);
   fprintf('\nEvenly spaced:\n');
   fprintf(HeadFmt, 'GRADIENT:');
   for Len = LenList
      x = rand(1, Len);
      
      nLoop = GetNLoop(@gradient, {x});
      tic;
      for i = 1:nLoop
         dx    = gradient(x);
         dx(1) = rand;         % More realistic timings
      end
      M_time = toc;
      fprintf('%8d', round(nLoop / M_time));
      drawnow;
   end
   fprintf(' loops/sec\n');
   
   if hasDerivative
      fprintf(HeadFmt, 'derivative:');
      for Len = LenList
         x = rand(1, Len);
         
         nLoop = GetNLoop(@derivative, {x});
         tic;
         for i = 1:nLoop
            dx    = derivative(x);
            dx(1) = rand;         % More realistic timings
         end
         M_time = toc;
         fprintf('%8d', round(nLoop / M_time));
         drawnow;
      end
      fprintf(' loops/sec\n');
   end
   
   fprintf(HeadFmt, 'DGradient:');
   for Len = LenList
      x = rand(1, Len);
      
      nLoop = GetNLoop(@DGradient, {x});
      tic;
      for i = 1:nLoop
         dx    = DGradient(x);
         dx(1) = rand;         % More realistic timings
      end
      M_time = toc;
      fprintf('%8d', round(nLoop / M_time));
      drawnow;
   end
   fprintf(' loops/sec\n');
   
   % Unevenly spaced: ----------------------------------------------------------
   fprintf('Unevenly spaced, 1st order:\n');
   fprintf(HeadFmt, 'GRADIENT:');
   for Len = LenList
      x = rand(1, Len);
      t = unevenT(1:Len);
      
      nLoop = GetNLoop(@gradient, {x, t});
      tic;
      for i = 1:nLoop
         dx    = gradient(x, t);
         dx(1) = rand;         % More realistic timings
      end
      M_time = toc;
      fprintf('%8d', round(nLoop / M_time));
      drawnow;
   end
   fprintf(' loops/sec\n');
   
   fprintf(HeadFmt, 'DGradient:');
   for Len = LenList
      x = rand(1, Len);
      t = unevenT(1:Len);
      
      nLoop = GetNLoop(@DGradient, {x, t});
      tic;
      for i = 1:nLoop
         dx    = DGradient(x, t);
         dx(1) = rand;         % More realistic timings
      end
      M_time = toc;
      fprintf('%8d', round(nLoop / M_time));
      drawnow;
   end
   fprintf(' loops/sec\n');
   
   % 2nd order unevenly spaced: ------------------------------------------------
   fprintf('Unevenly spaced, 2nd order:\n');
   if hasCentral_Diff
      fprintf(HeadFmt, 'central_diff:');
      for Len = LenList
         x = rand(1, Len);
         t = unevenT(1:Len);

         nLoop = GetNLoop(@central_diff, {x, t});
         tic;
         for i = 1:nLoop
            dx    = central_diff(x, t);
            dx(1) = rand;         % More realistic timings
         end
         M_time = toc;
         fprintf('%8d', round(nLoop / M_time));
         drawnow;
      end
      fprintf(' loops/sec\n');
   end
   
   if hasDiffXY
      fprintf(HeadFmt, 'diffxy:');
      for Len = LenList
         x = rand(1, Len);
         t = unevenT(1:Len);

         nLoop = GetNLoop(@diffxy, {x, t});
         tic;
         for i = 1:nLoop
            dx    = diffxy(x, t);
            dx(1) = rand;         % More realistic timings
         end
         M_time = toc;
         fprintf('%8d', round(nLoop / M_time));
         drawnow;
      end
      fprintf(' loops/sec\n');
   end
   
   fprintf(HeadFmt, 'DGradient:');
   for Len = LenList
      x = rand(1, Len);
      t = unevenT(1:Len);
      
      nLoop = GetNLoop(@DGradient, {x, t, 2, '2ndOrder'});
      tic;
      for i = 1:nLoop
         dx    = DGradient(x, t, 2, '2ndOrder');
         dx(1) = rand;         % More realistic timings
      end
      M_time = toc;
      fprintf('%8d', round(nLoop / M_time));
      drawnow;
   end
   fprintf(' loops/sec\n');
   
   % Matrices: -----------------------------------------------------------------
   fprintf('[10 x N]:\n');
   fprintf('Unevenly spaced, 1st order:\n');
   fprintf(HeadFmt, 'GRADIENT:');
   for Len = LenList
      x  = rand(10, Len);
      t1 = unevenT(1:10);
      t2 = unevenT(1:Len);
      
      nLoop = GetNLoop(@gradient, {x, t2, t1});
      tic;
      for i = 1:nLoop
         [dx2, dx1] = gradient(x, t2, t1);
         dx(1)      = rand;
         dx(2)      = rand;         % More realistic timings
      end
      M_time = toc;
      fprintf('%8d', round(nLoop / M_time));
      drawnow;
   end
   fprintf(' loops/sec\n');
   
   fprintf(HeadFmt, 'DGradient:');
   for Len = LenList
      x  = rand(10, Len);
      t1 = unevenT(1:10);
      t2 = unevenT(1:Len);
      
      nLoop = GetNLoop(@DGradient, {x, t2, 2});
      tic;
      for i = 1:nLoop
         dx1    = DGradient(x, t1, 1);
         dx2    = DGradient(x, t2, 2);
         dx1(1) = rand;         % More realistic timings
         dx2(1) = rand;
      end
      M_time = toc;
      fprintf('%8d', round(nLoop / M_time));
      drawnow;
   end
   fprintf(' loops/sec\n');
end

% Ready - successful if this is reached:
fprintf('\n== DGradient passed the tests.\n');

return;

% ******************************************************************************
function nLoops = GetNLoop(Fcn, Arg)
% Get number of iterations for valid speed measurement:

iLoop     = 0;
startTime = cputime;
while cputime - startTime < 0.5
   E     = feval(Fcn, Arg{:});  %#ok<*NASGU>
   clear('E');
   iLoop = iLoop + 1;
end
nPerSec = ceil(0.1 * iLoop / (cputime - startTime));

% Round loop numbers:
% nDigits = max(1, floor(log10(max(1, nPerSec))) - 1);
% nLoops  = max(4, round(nPerSec / 10 ^ nDigits) * 10 ^ nDigits);
nLoops  = max(4, nPerSec);

return;

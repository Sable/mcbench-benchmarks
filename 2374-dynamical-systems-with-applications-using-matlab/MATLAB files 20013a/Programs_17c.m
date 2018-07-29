% Chapter 17 - Neural Networks.
% Programs_17c - The Hopfield Network Used as an Associative Memory.
% Copyright Birkhauser 2013. Stephen Lynch.

function Programs_17c
clear all
% The 81-dimensional fundamental memories (Figure 17.12).
X = [-1 -1 -1 -1 -1 -1 -1 -1 -1  -1 -1 -1 1 1 1 -1 -1 -1  -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 1 -1 1 1 -1 -1  -1 -1 1 1 -1 1 1 -1 -1  -1 -1 1 1 -1 1 1 -1 -1  -1 -1 1 1 -1 1 1 -1 -1   -1 -1 -1 1 1 1 -1 -1 -1   -1 -1 -1 -1 -1 -1 -1 -1 -1;
    -1 -1 -1 1 1 1 -1 -1 -1 -1 -1 -1 1 1 1 -1 -1 -1 -1 -1 -1 1 1 1 -1 -1 -1 -1 -1 -1 1 1 1 -1 -1 -1 -1 -1 -1 1 1 1 -1 -1 -1 -1 -1 -1 1 1 1 -1 -1 -1 -1 -1 -1 1 1 1 -1 -1 -1 -1 -1 -1 1 1 1 -1 -1 -1 -1 -1 -1 1 1 1 -1 -1 -1;
    -1 -1 1 1 1 1 1	-1 -1	-1 1 -1	-1 -1 -1 -1	1 -1	-1 -1 -1 -1	-1 -1 -1 1 -1	-1 -1 -1 -1	-1 -1 1	-1 -1	-1 -1 -1 -1	-1 1 -1	-1 -1   -1 -1 -1 -1 1 -1 -1 -1	-1   -1 -1 -1 1 -1 -1 -1	-1 -1	  -1 -1	1 -1 -1	-1 -1 -1 -1	 -1 1 1 1 1 1 1 1 -1;
    -1 1 1 -1 -1 -1 1 1 -1  -1 1 1 -1 -1 -1 1 1 -1 -1 1 1 -1 -1 -1 1 1 -1 -1 1 1 -1 -1 -1 1 1 -1 -1  1 1 1 1 1 1 1 -1  -1 -1 -1 -1 -1 -1 1 1 -1 -1 -1 -1 -1 -1 -1 1 1 -1  -1 -1 -1 -1 -1 -1 1 1 -1  -1 -1 -1 -1 -1 -1 1 1 -1; 
    1 1 1 1 1 1 -1 -1 -1  1 1 -1 -1 -1 -1 -1 -1 -1   1 1 -1 -1 -1 -1 -1 -1 -1  1 1 1 1 1 1 -1 -1 -1   1 1 -1 -1 1 1 -1 -1 -1 1 1 -1 -1 1 1 -1 -1 -1  1 1 -1 -1 1 1 -1 -1 -1  1 1 -1 -1 1 1 -1 -1 -1  1 1 1 1 1 1 -1 -1 -1];

% Load data.
X = X([1 2 3 4 5],:);
numPatterns = size(X,1);
numInputs = size(X,2);
% Plot the fundamental memories. They will appear in Figure 1.
figure
plotHopfieldData(X)

% STEP 1. Calculate the weight matrix using Hebb's postulate.
W = (X'*X - numPatterns*eye(numInputs))/numInputs;

% STEP 2. Set a probe vector using a predefined noiselevel. The probe
% vector is a distortion of one of the fundamental memories.
noiseLevel = 1/3;
patInd = ceil(numPatterns*rand(1,1));
xold = (2*(rand(numInputs,1)> noiseLevel)-1).*X(patInd,:)';

% STEP 3. Asynchronous updates of the elements of the probe vector until it
% converges. To guarantee convergence, the algorithm performs at least
% numPatterns=81 iterations even though convergence generally occurs before
% this.
figure
converged = 0;
x=xold;
while converged==0,
    p=randperm(numInputs);
    for n=1:numInputs
        r = x(p(n));
        x(p(n)) = hsign(W(p(n),:)*x, r);
        plotHopfieldVector(x);
        pause(0.01);
    end	
% STEP 4. Check for convergence.
    if (all(x==xold))
        break;    
    end
    xold = x;
end

% Step 3. Update the elements asynchronously.
function y = hsign(a, r)
y(a>0) = 1;
y(a==0) = r;
y(a<0) = -1;

% Plot the fundamental memories.
function plotHopfieldData(X)
numPatterns = size(X,1);
numRows = ceil(sqrt(numPatterns));
numCols = ceil(numPatterns/numRows);
for i=1:numPatterns
   subplot(numRows, numCols, i);
   axis equal;
   plotHopfieldVector(X(i,:))
end

% Plot the sequence of iterations for the probe vector. The sequence is
% shown in Figure 2. Note that 81 iterations.  You can exit by pressing
% Ctrl-Shift-C, if you wish to interupt the program.
function plotHopfieldVector(x)
cla;
numInputs = length(x);
numRows = ceil(sqrt(numInputs));
numCols = ceil(numInputs/numRows);
for m=1:numRows
   for n=1:numCols
      xind = numRows*(m-1)+n;
      if xind > numInputs
         break;
      elseif x(xind)==1
         rectangle('Position', [n-1 numRows-m 1 1], 'FaceColor', 'k');
      elseif x(xind)==-1
         rectangle('Position', [n-1 numRows-m 1 1], 'FaceColor', 'w');         
      end
   end
end
set(gca, 'XLim', [0 numCols], 'XTick', []);
set(gca, 'YLim', [0 numRows], 'YTick', []);

% End of Programs_17c.
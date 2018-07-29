function [Y,Xpad] = snn(X,WINSZ,progress)
% [Y,Xpad] = SNN(X[,WINSZ][,progress])
% perform symmetric nearest-neighbor nonlinear edge-preserving filtering on 
% an intensity image
%
% * If no window size WINSZ is specified, the default is 5.
% * Setting progress to a nonzero value causes SSN to display
%   the current row it is processing.
%
% Description:
% The SNN filter works by looking at each pair of pixels opposite the
% output (center) pixel. From each pair, the one that is closest to
% the output pixel is used to compute the output (mean of all selected
% pixels).
% 
% Notes:
% Image is converted to double format for processing.
%
% Copyright Art Barnes, 2005 artbarnes<at>ieee<dot>org

if nargin >= 3
    verboseFlag = true;
else
    verboseFlag = false;
end

if nargin < 2
    WINSZ = 3;
end

if ~isa(X,'double')
    X = im2double(X);
end

PADDING = floor(WINSZ/2);

Xpad = padarray(X,[PADDING PADDING],'replicate');
[padRows,padCols] = size(Xpad);
Y = zeros(size(X));

nRowIters = length((PADDING+1):(padRows-PADDING));
count = 1;
for i = (PADDING+1):(padRows-PADDING)
    for j = (PADDING+1):(padCols-PADDING)
       
        % window 
        W = Xpad((i-PADDING):(i+PADDING),(j-PADDING):(j+PADDING));

        Wtop = W(1:PADDING,:)';
        Wtop = Wtop(:)';
        Wtop = [Wtop W(PADDING+1,1:PADDING)];
        Wbot = W((end-PADDING+1):end,:)';
        Wbot = Wbot(:)';
        Wbot = [W(PADDING+1,(end-PADDING+1):end) Wbot];     
        Wbot = fliplr(Wbot);

        NN = [Wtop; Wbot];
        NNdiff = abs(NN - W(PADDING+1,PADDING+1)); % or use X(i,j)
        [y,ids] = min(NNdiff);
        

        for k = 1:length(ids)
            NNnearest(k) = NN(ids(k),k);
        end
        
        Y(i,j) = mean([NNnearest X(i,j)]);
    end
    
    if verboseFlag & ~mod(count,10)
        fprintf('SNN: %d/%d\n',count,nRowIters);
    end
    
    count = count + 1;
end

function [tfVMVariates] = vmrand(fMu, fKappa, varargin)

% vmrand - FUNCTION Draw random variates from the Von Mises circular distribution
%
% Usage: [tfVMVariates] = vmrand(fMu, fKappa)
%        [tfVMVariates] = vmrand(..., M)
%        [tfVMVariates] = vmrand(..., M, N, P, ...)
%        [tfVMVariates] = vmrand(..., [M N P ...])
%
% This function uses an envelope-rejection method based on a wrapped Cauchy
% distribution to draw random variates from an arbitrary Von Mises
% distribution, first proposed in [1].
%
% 'fMu' and 'fKappa' are the mean and variance parameter of the Von Mises
% distribution over [-pi, pi).  'tVMVariates' will be a tensor containing
% random variates drawn from the defined distribution.  If 'fMu' and
% 'fKappa' are non-scalar, then they must be the same size.  In this case
% 'tVMVariates' will be the same size.  If 'fMu' and 'fKappa' are scalar,
% then the number of variates returned can be specified as extra arguments.
%
% If only single dimension 'M' is provided, then the return argument
% 'tfVMVariates' will be M x M.
%
% This implementation is vectorised, and requires O(7.5*N) space.
%
% References:
% [1] D. J. Best and N. I. Fisher, 1979. "Efficient Simulation of the von
% Mises Distribution", Journal of the Royal Statistical Society. Series C
% (Applied Statistics), Vol. 28, No. 2, pp. 152-157.

% Author: Dylan Muir <muir@hifo.uzh.ch>
% Created: 19th June, 2012

% -- Check arguments

if (nargin < 2)
   help vmrand;
   error('VMRAND:Usage', '*** vmrand: Incorrect usage');
end


% -- Check sizes

vbScalarArgs = [isscalar(fMu) isscalar(fKappa)];

if (nnz(vbScalarArgs) == 1)
   if vbScalarArgs(1)
      % - fMu is scalar
      fMu = repmat(fMu, size(fKappa));
   else
      % - fKappa is scalar
      fKappa = repmat(fKappa, size(fMu));
   end
   
   % - Set return sizes
   vnTensorSize = size(fMu);
   
elseif (nnz(vbScalarArgs == 0))
   % - Two non-scalar arguments
   if (~isequal(size(fMu), size(fKappa)))
      error('VMRAND:UnequalSizes', ...
         '*** vmrand: ''fMu'' and ''fKappa must be the same size.');
   else
      vnTensorSize = size(fMu);
   end
      
elseif (~isempty(varargin))
   % - Get argument sizes from varargin (be forgiving)
   varargin = cellfun(@(c)(reshape(c, 1, [])), varargin, 'UniformOutput', false);
   vnTensorSize = [varargin{:}];
   
   % - Take Matlab semantics to make square matrices
   if (isscalar(vnTensorSize))
      vnTensorSize = vnTensorSize([1 1]);
   end
   
   fKappa = repmat(fKappa, vnTensorSize);
   
else
   % - Return a scalar variate
   vnTensorSize = [1 1];
end


% -- Check values

if (any(fKappa < 0))
   error('VMRAND:InvalidArguments', ...
      '*** vmrand: ''fKappa'' must be >= 0');
end

if (any(vnTensorSize < 1))
   error('VMRAND:InvalidArguments', ...
      '*** vmrand: Tensor size dimensions must be positive');
end


% -- Preallocate data

tfVMVariates = nan(vnTensorSize);
tfZ = nan(vnTensorSize);
tfF = nan(vnTensorSize);
tfC = nan(vnTensorSize);


% -- Short-cut fKappa == 0

tbUniform = fKappa == 0;
tfVMVariates(tbUniform) = rand(nnz(tbUniform), 1) * 2*pi - pi;
tbDraw = ~tbUniform;
tbAccept = tbUniform;


% -- Pre-compute what we can

if (all(vbScalarArgs))
   tfTau = sqrt(4 .* fKappa(1).^2 + 1) + 1;
   tfRho = (tfTau - sqrt(2 .* tfTau)) ./ (2 .* fKappa(1));
   tfR = repmat((1 + tfRho.^2) ./ (2 .* tfRho), vnTensorSize);

else
   tfTau = sqrt(4 .* fKappa.^2 + 1) + 1;
   tfRho = (tfTau - sqrt(2 .* tfTau)) ./ (2 .* fKappa);
   tfR = (1 + tfRho.^2) ./ (2 .* tfRho);
   clear tfTau tfRho;   % - To save some space
end


% -- Draw random variates

while (nnz(tbDraw > 0))
   % - Draw partial variates and estimate wrapped Cauchy distribution envelope
   nNumToDraw = nnz(tbDraw);
   tfZ(tbDraw) = cos(pi .* rand(nNumToDraw, 1));
   tfF(tbDraw) = (1 + tfR(tbDraw) .* tfZ(tbDraw)) ./ (tfR(tbDraw) + tfZ(tbDraw));
   tfC(tbDraw) = fKappa(tbDraw) .* (tfR(tbDraw) - tfF(tbDraw));
   
   % - Filter variates
   vfRand2 = rand(nNumToDraw, 1);
   tbAccept(tbDraw) = (tfC(tbDraw) .* (2 - tfC(tbDraw)) - vfRand2) > 0;
   vbRecheck = ~tbAccept(tbDraw);
   if (any(vbRecheck))
      tbAccept(tbDraw & ~tbAccept) = (log(tfC(tbDraw & ~tbAccept) ./ vfRand2(vbRecheck)) + 1 - tfC(tbDraw & ~tbAccept)) >= 0;
   end
   
   % - Construct final variates
   nNumToAccept = nnz(tbDraw & tbAccept);
   tfVMVariates(tbDraw & tbAccept) = sign(rand(nNumToAccept, 1) - 0.5) .* acos(tfF(tbDraw & tbAccept));
   
   % - Mark as being accepted (don't need to try again)
   tbDraw(tbAccept) = false;
end


% -- Shift variates to mean

tfVMVariates = tfVMVariates + fMu;
tfVMVariates(tfVMVariates > pi) = -2*pi + tfVMVariates(tfVMVariates > pi);
tfVMVariates(tfVMVariates < -pi) = 2*pi + tfVMVariates(tfVMVariates < -pi);

% --- END of vmrand.m ---

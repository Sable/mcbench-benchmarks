%%
% Copyright (c) 2013, Mohammad Abouali (maboualiedu@gmail.com)
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.

%%
function P=ConstructProjector2D(xs,ys,xd,yd,nPoly,nInterp)
% Checking for errors.
if (any(size(xs)~=size(ys)))
  error('xs and ys must have the same size.');
end
if (any(size(xd)~=size(yd)))
  error('xd and yd must have the same size.');
end
if (nInterp<(nPoly+1)^2)
  error(['nInterp must be bigger than or equal to ' num2str((nPoly+1)^2) '.']);
end
if (nInterp>numel(xs))
  error('There must be at least nInterp points in the source grid');
end

% Getting the dimension of the projector/interpolator
Ns=numel(xs);
Nd=numel(xd);
nCoef=(nPoly+1)^2;

% Converting to a vector
xs=xs(:);
ys=ys(:);
xd=xd(:);
yd=yd(:);

% Initializing and reserving memory
SparseIndex_i=zeros(Nd*nInterp,1);
SparseIndex_j=zeros(Nd*nInterp,1);
P_nonZeroElem=zeros(Nd*nInterp,1);

i1=mod(floor((0:nCoef-1)/(nPoly+1)),nPoly+1);
i2=mod(0:nCoef-1,nPoly+1);
% Looping over each point on destination grid.
% this can be paralized with parfor. The calculation over each point on
% destination grid, i.e. xd(i),yd(i), is completely independent of
% eachother.
for i=1:Nd
  SparseIndex_i((i-1)*nInterp+1:i*nInterp,1)=i;
  
  % finding the nInterp closest points
  d=sqrt((xs-xd(i)).^2+(ys-yd(i)).^2);
  [~,idx]=sort(d,'ascend');
  SparseIndex_j((i-1)*nInterp+1:i*nInterp,1)=idx(1:nInterp);

  % Making a 2D plane of the order of nPoly out of the nInterp closest 
  tmp1=   repmat(xs(idx(1:nInterp)),1,nCoef).^repmat(i1,nInterp,1) ...
       .* ...
          repmat(ys(idx(1:nInterp)),1,nCoef).^repmat(i2,nInterp,1);

  % x^iy^j i,j \in 0:nPoly for the destination point
  tmp2= repmat(xd(i),1,nCoef).^i1 .* repmat(yd(i),1,nCoef).^i2;

  % Coefficients that interpolates/extrapolates to the destination grid.
  P_nonZeroElem((i-1)*nInterp+1:i*nInterp,1)= ...
                                transpose( tmp2* ((tmp1'*tmp1)\tmp1') );
end

P=sparse(SparseIndex_i,SparseIndex_j,P_nonZeroElem,Nd,Ns);

end

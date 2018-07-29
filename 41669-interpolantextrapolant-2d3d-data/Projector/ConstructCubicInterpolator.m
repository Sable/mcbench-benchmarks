function P=ConstructCubicInterpolator(xs,ys,xd,yd,nInterp)
% Checking for errors.
if (any(size(xs)~=size(ys)))
  error('xs and ys must have the same size.');
end
if (any(size(xd)~=size(yd)))
  error('xd and yd must have the same size.');
end
if (nInterp<16)
  error('nInterp must be bigger than or equal to 16.');
end

% Getting the dimension of the projector/interpolator
Ns=numel(xs);
Nd=numel(xd);

% Converting to a vector
xs=xs(:);
ys=ys(:);
xd=xd(:);
yd=yd(:);

% Initializing and reserving memory
SparseIndex_i=zeros(Nd*nInterp,1);
SparseIndex_j=zeros(Nd*nInterp,1);
P_nonZeroElem=zeros(Nd*nInterp,1);
tmp1=zeros(nInterp,16);
tmp2=zeros(1,16);

for i=1:Nd
  SparseIndex_i((i-1)*nInterp+1:i*nInterp,1)=i;
  
  % finding the 16 closest points
  d=sqrt((xs-xd(i)).^2+(ys-yd(i)).^2);
  [~,idx]=sort(d,'ascend');
  SparseIndex_j((i-1)*nInterp+1:i*nInterp,1)=idx(1:nInterp);

  % Making a cubic plane out of the nInterp closest points.
  for j=1:nInterp
    for i1=0:3
      for i2=0:3
        tmp1(j,i1*4+i2+1)=(xs(idx(j)).^i1)*(ys(idx(j)).^i2);
      end
    end
  end

  % x^iy^j i,j \in 0:3 for the destination point
  for i1=0:3
    for i2=0:3
      tmp2(1,i1*4+i2+1)=(xd(i).^i1)*(yd(i).^i2);
    end
  end

  % cubic coefficients that interpolates to the destination grid.
%   tmp3=tmp1'*tmp1;
%   a_Coef=tmp3\tmp1';
%   a_Coef=tmp2*a_Coef;
%   P_nonZeroElem((i-1)*nInterp+1:i*nInterp,1)=transpose(a_Coef);
  P_nonZeroElem((i-1)*nInterp+1:i*nInterp,1)=transpose( tmp2* ((tmp1'*tmp1)\tmp1') );
end

P=sparse(SparseIndex_i,SparseIndex_j,P_nonZeroElem,Nd,Ns);

end

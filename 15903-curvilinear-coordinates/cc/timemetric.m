function timemetric
tic; [x,n,bco,bcn,gco,gcn,cs1,cs2]=metr(@elipsod,1); toc

function [x,n,bco,bcn,gco,gcn,cs1,cs2]=metr(func,method)
% [x,n,bco,bcn,gco,gcn,cs1,cs2]=metr(func,method)

% This function computes base vectors, metric tensor
% components, and Christoffel symbols for a general
% curvilinear coordinate system
% func     - handle of a function which returns the
%            cartesian radius vector x as a function
%            of the curvilinear coordinate variables,
%            and a vector containing the names of the
%            coordinate variables used to define x. In
%            spherical coordinates, for example, names
%            might be 'r, theta, phi'.
% method   - Use 1 to compute the Christoffel symbols by
%            differentiating the metric tensor components.
%            Use 2 to compute the Christoffel symbols by 
%            by differentiating vector x. 
% x        - cartesian components of the radius vector
%            expressed in terms of the curvilinear 
%            coordinate variables
% n          a vector containing the names of the 
%            curvilinear coordinate variables
% bco, bcn - cartesian components of the covariant and
%            contravariant base vectors. The i'th column
%            of each array contains components of the 
%            i'th base vector.
% gco, gcn - covariant and contravariant components of
%            the metric tensor.
% cs1, cs2 - Christoffel symbols or the first and second
%            kinds. The symbol for index i,j,k is in
%            row i, column j, and layer k of each array.
       
if nargin<2, method=1; end
if nargin==0, func=@sphr; end
[x,n]=feval(func); x=simple(x(:));

% Differentiate the radius vector to get the
% contravariant base vectors.
% bco=[diff(x,n(1)),diff(x,n(2)),diff(x,n(3))]
bco=jacobian(x,n(:).');

% Use orthogonality to compute the contravariant 
% base vectors.
bcn=simple(inv(bco.'));

% Obtain the metric tensor components as dot products of
% the base vectors
gco=simple(bco.'*bco); gcn=simple(bcn.'*bcn);

% If Christoffel symbols are not required, then exit
if nargout<6, return, end

% Compute the Christoffel symbols.
cs1=sym(zeros(3,3,3)); cs2=cs1;
if method==1   
  % Obtain symbols of the first kind by differentiating
  % the covariant metric tensor components.    
  for k=1:3
    for i=1:3, for j=1:i
      cs1(i,j,k)=1/2*(diff(gco(j,k),n(i))+...
             diff(gco(i,k),n(j))-diff(gco(i,j),n(k))); 
      if j~=i, cs1(j,i,k)=cs1(i,j,k); end   
    end, end
  end
else % method==2  
  % Obtain symbols of the first kind using derivatives 
  % of vector x.  
  h=sym(zeros(3,3,3)); 
  for k=1:3, h(:,:,k)=simple(diff(bco(:,:),n(k))); end
  
  for k=1:3
    cs1(:,:,k)=squeeze(h(1,:,:)*bco(1,k)+h(2,:,:)*bco(2,k)+...
               h(3,:,:)*bco(3,k));
  end
%   for k=1:3, for i=1:3, for j=1:3
%     cs1(i,j,k)=h(1,i,j)*bco(1,k)+h(2,i,j)*bco(2,k)+...
%                h(3,i,j)*bco(3,k);
%   end,end,end
  cs1=simple(cs1);
end

% Obtain Christoffel symbols of the second kind by 
% using the contravariant metric tensor components to
% raise the third index.
for k=1:3
  cs2(:,:,k)=cs1(:,:,1)*gcn(1,k)+cs1(:,:,2)*gcn(2,k)+...
             cs1(:,:,3)*gcn(3,k);
end
x=simple(x); bco=simple(bco); bcn=simple(bcn);
gco=simple(gco); gcn=simple(gcn);
cs1=simple(cs1); cs2=simple(cs2);

function [X,names]=elipsod
% [X,names]=elipsod defines ellipsoidal
% coordinates with 0 < lm < b,
% b < t < c, and c < e <infinity
syms e t lm real 
names=[lm,t,e];
b=1; c=2*b; b2=b^2; c2=c^2; cb=c2-b2;
x=e*t*lm/(b*c); 
y=sqrt((e^2-b2)*(t^2-b2)*...
    (b2-lm^2)/(b2*cb));
z=sqrt((e^2-c2)*(c2-t^2)*...
     (c2-lm^2)/(c2*cb));
X=[x;y;z];
function p=polymake(name,x0,XR,varargin)

% p=polymake(name,x0,XR,P1,P2,...);
% polynomial interpolation coefficients for a given scalar field :
% 
% name is a string containing the name of the function,
% x0 is a reference point in the x-space, 
% XR is a matrix in which each row consists of :
%    1) an index i, indicating the variable x(i).
%    2) a row vector of values that x(i) assumes apart from x0(i).
% P1,P2,... are parameters to be passed to the function "name".
% 
% The output g is a structure containing the interpolating coefficients
% this structure has to be passed to the function polyeval.
% 
% Example:
% 
% p=polymake('norm',zeros(12,1),[1 -1 1; 5 -2 1]);
% computes the interpolating coefficients of the function 'norm',
% where the first element of x assumes the values -1, x0(1)=0, 1,
% and the fifth -2, x0(5)=0, 1. For all 3*3=9 points the interpolating
% polynomial coefficients are computed and are enclosed in p.
% 
% This following part uses the function polyeval to evaluate
% the polynomial approximation along a grid :
% [x,y]=meshgrid(-2:.2:2,-2:.2:2);
% for i=1:size(x,1), 
%     for j=1:size(x,2), 
%         z(i,j)=polyeval(p,[x(i,j) zeros(1,3) y(i,j) zeros(1,7)]); 
%     end, 
% end
% surf(x,y,z)
%
  
% G.Campa 25/04/99

if isempty(XR), p.idx=1;XG=x0(p.idx);
else p.idx=XR(:,1);XG=[x0(p.idx) XR(:,2:size(XR,2))];
end

% combination matrices
I0=1:size(XG,2);I=I0;
for i=1:size(XG,1)-1;I=polycomb(I,I0);end

% hypercube vertex trip
S=[];c=0;
for i=I;
      c=c+1;
      x0(p.idx)=diag(XG(:,i));
      y0=feval(name,x0,varargin{:});
      S(c)=y0;
end

% exponent vs. dimension combinations matrices
[p.Wx,p.Vx]=meshgrid([1:size(XG,2)]-1,1:size(XG,1));

% final polynomial data matrix
Pf=[];
x0=reshape(x0,size(x0,1)*size(x0,2),1);
for i=I,
      c=c+1;
      x0(p.idx)=diag(XG(:,i));
      Px=x0(p.idx(p.Vx)).^p.Wx;Pr=Px(1,:);
      for h=2:size(Px,1), Pr=prod(polycomb(Pr,Px(h,:))); end
      Pf=[Pf;Pr];
end

% polynomial coefficients
p.C=pinv(Pf)*S.';

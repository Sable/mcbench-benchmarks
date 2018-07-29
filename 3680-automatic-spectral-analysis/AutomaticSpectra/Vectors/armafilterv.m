function y = armafilterv(x,a,b,prev_y);

%ARMAFILTERV Digital ARMA filter for matrix-valued signals
%   X = ARMAFILTERV(E,AR,MA) filters the matrix-valued data in the 3-D
%   vector E with a filter described by an ARMA model with parameter
%   vectors AR and MA, to create the filtered data X. It implements the
%   difference equation
%
%   a0*x(n)+a1*x(n-1)+ ... +ap*x(n-p) = e(n)+b1*e(n-1)+ ... +bq*e(n-q).
%   
%   ARMAFILTER(E,AR,MA,X_INI) is used to provide the filter with 
%   initial values from past output X_INI = [x(n-p) , ... , x(n-1)]
%   When X_INI is omitted, zeros are used as previous observations.
%
%   See also: ARMAFILTER, FILTER, CONVV, PRODSUMV.

%S. de Waele, March 2003.

nobs = size(x,3);
sa = kingsize(a);
sb = kingsize(b);
sx = kingsize(x);

b_len = size(b,3);
a_len = size(a,3);

%MA-part
v = zeros([sb(1) sx(2:3)]);
for ma = 1:b_len
   for xc = 1:sx(2) %xc = x-column
	   vc = zeros(sb(1),sx(3));
      c = squeeze(x(:,xc,1:end-ma+1));
      if sx(1)==1, c = c'; end
      vc(:,ma:end) = b(:,:,ma)*c;
      if sb(1)==1 %was sx(1)==1,
	      v(:,xc,:)=(squeeze(v(:,xc,:)))'+vc;
		else         
	      v(:,xc,:)=squeeze(v(:,xc,:))+vc;
   	end      
   end %for xc = 1:sx(2)
end %for ma = 1:b_len

if a_len-1,
   %AR-part
   s = kingsize(v);
   s(3) = s(3)+a_len-1;
   y = zeros(s);
   if nargin == 4, y(:,:,1:a_len-1) = prev_y; end
   %addition of initial zeros in v for clarity of programming
	vz= zeros(s); vz(:,:,a_len:end)=v;
	v = vz;
   
   fa = a(:,:,1); %first coefficient a
   ifa= inv(fa);  %ifa = Inverse of First coefficient a
   for obs = (1:nobs)+a_len-1,
      y(:,:,obs) = ifa*(v(:,:,obs)-prodsumv(a(:,:,2:end),y(:,:,obs-1:-1:obs-a_len+1)));
   end
   y = y(:,:,a_len:end);
else
   y = v;
end %if a_len-1,

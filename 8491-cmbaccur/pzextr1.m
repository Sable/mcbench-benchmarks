function  [yz, dy] = pzextr1(iest, xest, yest)
% pzextr.m  uses extrapolation to evaluate nv functions at x=0 by fitting a
% polynomial to a sequence of estimates with progressively smaller values x= xest(1..np), and
% corresponding function vectors yest(1..nv,1..np). This call is number iest in the sequence
% of calls, see also bsstep1.m and pzextr.m
% 
% output : the extrapolated function values, yz(1..nv,1..np) and their estimated error, dy(1..nv,1..np).


% D Vangheluwe 8 mrt 2005

global x_bulirsch_stoer  d_bulirsch_stoer

[nv np] = size(yest);

if np > 1
  x_bulirsch_stoer(iest,:) = xest;
% save current independent variable
  yz = yest;
  dy = yz;

%  x_bulirsch_stoer
%  d_bulirsch_stoer

  if iest == 1
% store first estimate in first column
     d_bulirsch_stoer(:,:,1) = yest;
  else
     c = yest;
     for k1 = 1:iest-1
        delta = 1 ./ (x_bulirsch_stoer(iest-k1,:) - xest);
        f1 = xest .* delta;
        f2 = x_bulirsch_stoer(iest-k1,:) .* delta;      
        q = d_bulirsch_stoer(:,:,k1);
        d_bulirsch_stoer(:,:,k1) = dy;
        deltay = c - q;
        dy = repmat(f1, nv, 1) .* deltay;
        c = repmat(f2, nv, 1) .* deltay;
        yz = yz + dy;
     end
     d_bulirsch_stoer(:,:,iest) = dy;
  end

else  %np == 1

  x_bulirsch_stoer(iest) = xest';
% save current independent variable
  yz = yest;
  dy = yz;

%  x_bulirsch_stoer
%  d_bulirsch_stoer
  if iest == 1
% store first estimate in first column
     d_bulirsch_stoer(:,1) = yest;
  else
     c = yest;
     for k1 = 1:iest-1
        delta = 1 ./ (x_bulirsch_stoer(iest-k1) - xest);
        f1 = xest .* delta;
        f2 = x_bulirsch_stoer(iest-k1) .* delta;      
        q = d_bulirsch_stoer(:,k1);
        d_bulirsch_stoer(:,k1) = dy;
        deltay = c - q;
        dy = f1 .* deltay;
        c = f2 .* deltay;
        yz = yz + dy;
     end
     d_bulirsch_stoer(:,iest) = dy;
  end

end  %np > 1

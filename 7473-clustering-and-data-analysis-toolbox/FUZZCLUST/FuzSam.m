function result = FuzSam(proj,result,param)
%rand('seed',120)

%Adapt the data
P = proj.P;             %P projected data or dimension
d = result.data.d;      %d distances
f = result.data.f;      %f partition matrix
m = param.m;            %m fuzzy exponent
maxstep = param.max;
alpha = param.alpha;
% compute data dimensions
[np,nc]=size(d);        %number of data and number of clusters
orig_si = size(d); 
% noc = orig_si(1); 
% nc = orig_si(2); %

if prod(size(P))==1,    %output dimension given
  odim = P; 
  P = rand(np,odim)-0.5;
  %P = 2*rand(np,odim)-1; 
else                    %initial projection matrix given
  si = size(P);
  odim = si(end);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

np_x_1  = ones(np, 1); 
nc_x_1  = ones(nc, 1); 
odim_x_1 = ones(odim,1); 
% xu = zeros(np, odim);       %projected data matrix
% xd = zeros(np, odim);       %projected distance matrix
% dq = zeros(np, 1);
% dr = zeros(np, 1);
%alpha = 0.4;                %gradient method step size

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
fprintf(2, 'iterating                    \r');

% initializing   
x  = P ;
fm = f.^m;
sumf = sum(fm);
xv = (fm'*x)./(sumf'*ones(1,2));;   %projected cluster centers

c = sum(x) / np;% move the center of mass to the center
x = x - c(np_x_1, :);
xv = xv - c(nc_x_1, :); 

for i=1:maxstep;
  for j = 1:np,
    xd      = - xv + x(j*nc_x_1,:);
    xd2     = xd.^2;
    dpj     = sqrt(sum(xd2'))';
    dq      = d(j,:)' - dpj;
    dr      =  dpj;
    index     = find(dr ~= 0);
    term    = dq(index) ./ dr(index).* [ones(1,nc).*fm(j,:)]';
    e1      = sum(xd(index,:) .* term(:,odim_x_1));
    term2   = ((1.0 + dq(index) ./ dpj(index)) ./ dpj(index)) ./ dr(index).*[ones(1,nc).*fm(j,:)]';
    e2      = sum(term) - sum(xd2(index,:) .* term2(:,odim_x_1));
    xu(j,:) = x(j,:) + alpha * e1 ./ abs(e2);
  end
x=xu;
c = mean(x);
x = x - c(np_x_1, :);
xv = (fm'*x)./(sumf'*ones(1,2));
 
  if 1, 
    clf
    plot(x(:,1), x(:,2), 'o');
    hold on
    plot(xv(:,1), xv(:,2), 'r*');
    %projeval(x,xv,m,nc,fm);
    hold off
    title('Fuzzy Sammon mapping - training')
    drawnow
  end
  fprintf(2, '\r%d iterations', i);
end   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% reshape
orig_si(end) = odim; 
P = reshape(x, orig_si);

%results
result.proj.vp=xv;
result.proj.P=x;


function [x, c] = gendata(a,b,n_obs,g,gar)
%x = gendata(a,b,npseg)
%Generates a realization of the ARMA-process a,b.
%and standard deviation 1.
%
%This program can also be used to generate ns independent
%realisations with x = gendata(a,b,npseg*ones(1,nseg))
%
%[note: x = gendata(a,b,n_obs,g,gar) can speed up for high-order AR models]

%S. de Waele, August 2002.

%Take care of segments
npseg = n_obs(1);
ns = length(n_obs);

clim = 1e4;

aro = length(a)-1; mao = length(b)-1;
if nargin==3,
    [cor,g]=arma2cor(a,b);
    if b == 1,
        gar = g;
        cor2 = cor;
    else
        [cor2,gar]=arma2cor(a,1);
    end
end

if ~aro,
    v = randn(npseg+mao,ns)/sqrt(g);
    if nargout == 2, c = 1; end
else
    z = randn(aro,ns);
    vs = zeros(aro,ns);
    
    if nargout == 2, 
        R = toeplitz(cor2(1:aro-1),cor2(1:aro-1));
        c = cond(R);
        if c>clim, warning(['Initial conditions badly conditioned COND = ' int2str(c)]), end
    end
    
    [set_ar rc] = ar2arset(a,1:aro);

    if exist('c'),
        if c>clim, rc; end
    end   
    f = 1;
    vs(1,:) = f*z(1,:);
    al = [];
    for i = 2:aro,
        f = sqrt(1-rc(i-1)^2)*f;
        vs(i,:) = f*z(i,:)-set_ar{i-1}(2:end)*vs(i-1:-1:1,:);
    end %for i = 2:aro,
    vs = vs*sqrt(gar/g);
    vinit = -filter(a(aro+1:-1:2),1,flipud(vs)); vinit = flipud(vinit);
    v = filter(1,a,randn(npseg+mao,ns)/sqrt(g),vinit);
end %if ~aro,
x = filter(b,1,v); x = x(mao+1:mao+npseg,:);
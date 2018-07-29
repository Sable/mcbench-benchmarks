function [sigma,C] = calcBSImpVol(cp,P,S,K,T,r,q)
%
% [sigma,C] = calcBSImpVol(cp,P,S,K,T,r,q)
%
% Calculates Black-Scholes Implied Volatility Surface for an Option Price Matrix.
% Uses Li's Rational Function Approximator for the Initial Estimate, followed by
% 3rd-Order Householder's Root Finder (i.e. using vega,vomma & ultima) for greater 
% convergence rate and wider domain-of-convergence relative to Newton-Raphson. Both 
% Li's Approximator and the Root Finder are calculated matrix-wise (i.e.
% fully vectorized) for increased efficiency.
%
%
%   Input Parameters
%       cp      Call[+1],Put[-1]
%       P       Option Price Matrix [m x n]
%       S       Underlying Price [1 x 1]
%       K       Strike Price [m x n]
%       T       Time to Expiry [m x n]
%       r       Continuous Risk-Free Rate [1 x 1]
%       q       Continuos Div Yield [1 x 1]
%
%   Output Parameters
%       sigma   Implied Volatility  [m x n]
%       C       Convergence Flag  [m x n]
%
%
%
%   Example
%     S = 100; K = (40:25:160)'; T = (0.25:0.25:1)'; % Define Key Variables
%     r = 0.01; q = 0.03;
%     cp = 1; % i.e. call
%     P = ...
%         [[59.3526805861312,34.4154741312210,10.3406451776045,0.501199199160055,0.0101623685145268;];
%         [58.7107005379958,33.8563481863964,10.9917759513981,1.36915029885860,0.143324063090580;];
%         [58.0742593358310,33.3567195106962,11.5012247391034,2.12859686975881,0.400045353619436;];
%         [57.4444414750070,32.9126689586500,11.9027988146544,2.77274776123341,0.708059729236718;];];
%     [mK,mT] = meshgrid(K,T);
%     [sigma,C] = calcBSImpVol(cp,P,S,mK,mT,r,q);
%     mesh(mK,mT,sigma);
%
%
% References:
%   1)  Li, 2006, "You Don't Have to Bother Newton for Implied Volatility"
%       http://papers.ssrn.com/sol3/papers.cfm?abstract_id=952727
%   2)  http://en.wikipedia.org/wiki/Householder's_method
%   3)  http://en.wikipedia.org/wiki/Greeks_(finance)
%


%% APPLY LI's RATIONAL APPROXIMATOR

[g,h] = size(P);

p = [-0.969271876255; 0.097428338274; 1.750081126685];


m = ones(1,1,14);
m(:) = [...
    6.268456292246;
    -6.284840445036;
    30.068281276567;
    -11.780036995036;
    -2.310966989723;
    -11.473184324152;
    -230.101682610568;
    86.127219899668;
    3.730181294225;
    -13.954993561151;
    261.950288864225;
    20.090690444187;
    -50.117067019539;
    13.723711519422];
m = m(ones(g,1),ones(1,h),:); % Repmat to size [g,h]

n = ones(1,1,14);
n(:) = [...
    -0.068098378725;
    0.440639436211;
    -0.263473754689;
    -5.792537721792;
    -5.267481008429;
    4.714393825758;
    3.529944137559;
    -23.636495876611;
    -9.020361771283;
    14.749084301452;
    -32.570660102526;
    76.398155779133;
    41.855161781749;
    -12.150611865704];
n = n(ones(g,1),ones(1,h),:); % Repmat to size [g,h]

i = ones(1,1,14);
i(:) = [0,1,0,1,2,0,1,2,3,0,1,2,3,4];
i = i(ones(g,1),ones(1,h),:); % Repmat to size [g,h]
j = ones(1,1,14);
j(:) = [1,0,2,1,0,3,2,1,0,4,3,2,1,0];
j = j(ones(g,1),ones(1,h),:); % Repmat to size [g,h]


x = log(S.*exp((r-q).*(T))./K); % Moneyness
if cp==-1
    P = P + S.*exp(-q.*T) - K.*exp(-r.*T); % Convert Put to Call by Parity Relation
end
c = P./(S.*exp(-q.*(T))); % Normalized Call Price

x = x(:,:,ones(1,14)); % Repmat to 3d size 14
c = c(:,:,ones(1,14)); % Repmat to 3d size 14

% Rational Function -  Eqn(19) of Li 2006
fcnv = @(p,m,n,i,j,x,c)(p(1).*x(:,:,1) + p(2).*sqrt(c(:,:,1)) + p(3).*c(:,:,1) + (sum(n.*((x.^i).*(sqrt(c).^j)),3))./(1 + sum(m.*((x.^i).*(sqrt(c).^j)),3)));
v1 = fcnv(p,m,n,i,j,x,c); % D- Domain (x<=-1)
v2 = fcnv(p,m,n,i,j,-x,exp(x).*c + 1 -exp(x)); % Reflection for D+ Domain (x>1)
v = zeros(g,h); v(x(:,:,1)<=0)=v1(x(:,:,1)<=0); v(x(:,:,1)>0)=v2(x(:,:,1)>0);

% Domain-of-Approximation is x={-0.5,+0.5},v={0,1},x/v={-2,2}
domainFilter = x(:,:,1)>=-0.5 & x(:,:,1)<=0.5 & v > 0 & v <1 & (x(:,:,1)./v)<=2 & (x(:,:,1)./v)>=-2;
v(~domainFilter) = NaN;

sigma = v./sqrt(T); % v = sigma.*(sqrt(T));


%% BIVARIATE LINEAR REGRESSION FOR OUT-OF-DOMAIN VALUES

if any(~domainFilter(:) & ~isnan(P(:))) % any out-of-Li domain values
    M = S./K; % Moneyness

    % ITM Regression
    Y = sigma(:); X = [T(:),K(:)];
    X(isnan(Y) | M(:)<1,:) = []; Y(isnan(Y) | M(:)<1) = [];
    B = [ones(size(X,1),1),X]\Y;
    sigma_reg = [ones(size(T(:),1),1), T(:),K(:)]*B;
    sigma_reg = reshape(sigma_reg,g,h);
    sigma(~isnan(P) & M>=1 & ~domainFilter) = sigma_reg(~isnan(P) & M>=1 & ~domainFilter);

    % OTM Regression
    Y = sigma(:); X = [T(:),K(:)];
    X(isnan(Y) | M(:)>=1,:) = []; Y(isnan(Y) | M(:)>=1) = [];
    B = [ones(size(X,1),1),X]\Y;
    sigma_reg = [ones(size(T(:),1),1), T(:),K(:)]*B;
    sigma_reg = reshape(sigma_reg,g,h);
    sigma(~isnan(P) & M<1 & ~domainFilter) = sigma_reg(~isnan(P) & M<1 & ~domainFilter);

end

%% HOUSEHOLDER ROOT-FINDER FOR INCREASED CONVERGENCE 

d1fcn = @(sig,C)((log(S./K(C)) + (r-q+sig(C).^2*0.5).*(T(C)))./(sig(C).*sqrt(T(C))));
d2fcn = @(sig,C)((log(S./K(C)) + (r-q-sig(C).^2*0.5).*(T(C)))./(sig(C).*sqrt(T(C))));
callfcn = @(sig,C)( +exp(-q.*T(C)).*S.*fcnN(d1fcn(sig,C)) - exp(-r.*T(C)).*K(C).*fcnN(d2fcn(sig,C)) );

vegafcn = @(sig,C)(S.*exp(-q.*(T(C))).*fcnn(d1fcn(sig,C)).*(sqrt(T(C)))); 
vommafcn = @(sig,C)(S.*exp(-q.*(T(C))).*fcnn(d1fcn(sig,C)).*(sqrt(T(C))).*d1fcn(sig,C).*d2fcn(sig,C)./sig(C));
ultimafcn = @(sig,C)(-S.*exp(-q.*(T(C))).*fcnn(d1fcn(sig,C)).*(sqrt(T(C))).*(d1fcn(sig,C).*d2fcn(sig,C).*(1-d1fcn(sig,C).*d2fcn(sig,C))+d1fcn(sig,C).^2+d2fcn(sig,C).^2)./(sig(C).^2));

tolMat=1e-10;
k_max = 10; % 10 Householder Iterations
objfcn = @(sig,C)(P(C) - callfcn(sig,C));

C = true(size(P(:))); err = objfcn(sigma,C); % calculate initial error
C = abs(err)>tolMat; % Convergence Matrix

k = 1;
while any(C) && k<=k_max

    vega = vegafcn(sigma,C); %f'(x_n)
    vomma = vommafcn(sigma,C); %f''(x_n)
    ultima = ultimafcn(sigma,C); %f'''(x_n)

%     % Newton Raphson Method x_n+1 = x_n + f(x_n)/f'(x_n)
%     sigma = sigma  + (err(C)./vega) ;
%     % Halley Method x_n+1 = x_n - f(x_n)/( f'(x_n) - f(x_n)*f''(x_n)/2*f'(x_n))
%     sigma = sigma  - err(C)./(-vega-(-err(C).*vomma./(-2.*vega)));
    % Householder Method x_n+1 = x_n - f(x_n)/( f'(x_n) - f(x_n)*f''(x_n)/2*f'(x_n))
    sigma(C) = sigma(C) - (6.*err(C).*vega.^2 + 3.*err(C).^2.*vomma)./(-6.*vega.^3 - 6.*err(C).*vega.*vomma - err(C).^2.*ultima) ;
    err(C) = objfcn(sigma,C); %

    C = abs(err)>tolMat; % Convergence Matrix

    k = k + 1;
end

sigma(C) = NaN; % any remaining sigma are not worth calculating


end


%% SUBFUNCTION
function p=fcnN(x)
p=0.5*(1.+erf(x./sqrt(2)));
end
%
function p=fcnn(x)
p=exp(-0.5*x.^2)./sqrt(2*pi);
end
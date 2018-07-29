function [p,type,coefs] = pearspdf(X,mu,sigma,skew,kurt)
% pearspdf
%   [p,type,coefs] = pearspdf(X,mu,sigma,skew,kurt)
%
%   Returns the probability distribution denisty of the pearsons distribution
%   with mean `mu`, standard deviation `sigma`, skewness `skew` and
%   kurtosis `kurt`, evaluated at the values in X.
%
%   Some combinations of moments are not valid for any random variable, and in
%   particular, the kurtosis must be greater than the square of the skewness
%   plus 1.  The kurtosis of the normal distribution is defined to be 3.
%
%   The seven distribution types in the Pearson system correspond to the
%   following distributions:
%
%      Type 0: Normal distribution
%      Type 1: Four-parameter beta
%      Type 2: Symmetric four-parameter beta
%      Type 3: Three-parameter gamma
%      Type 4: Not related to any standard distribution.  Density proportional
%              to (1+((x-a)/b)^2)^(-c) * exp(-d*arctan((x-a)/b)).
%      Type 5: Inverse gamma location-scale
%      Type 6: F location-scale
%      Type 7: Student's t location-scale
%
%   Examples
%
%   See also
%       pearspdf pearsrnd mean std skewness kurtosis
%


%   References:
%      [1] Johnson, N.L., S. Kotz, and N. Balakrishnan (1994) Continuous
%          Univariate Distributions, Volume 1,  Wiley-Interscience.
%      [2] Devroye, L. (1986) Non-Uniform Random Variate Generation, 
%          Springer-Verlag.

%   Copyright 2005-2008 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2008/08/20 23:04:44 $

%% Author Information
% Pierce Brady
% Smart Systems Integration Group - SSIG
% Cork Institute of Technology, Ireland.
%

outClass = superiorfloat(mu,sigma,skew,kurt);
%%
X = (X-mu)./sigma;  % Z-score

beta1 = skew.^2;
beta2 = kurt;

% Return NaN for illegal parameter values.
if (sigma < 0) || (beta2 <= beta1 + 1)
    p = NaN(size(X),outClass);
    type = NaN;
    coefs = NaN(1,3,outClass);
    return
end

%% Classify the distribution and find the roots of c0 + c1*x + c2*x^2
c0 = (4*beta2 - 3*beta1); % ./ (10*beta2 - 12*beta1 - 18);
c1 = skew .* (beta2 + 3); % ./ (10*beta2 - 12*beta1 - 18);
c2 = (2*beta2 - 3*beta1 - 6); % ./ (10*beta2 - 12*beta1 - 18);
if c1 == 0 % symmetric dist'ns
    if beta2 == 3
        type = 0;
    else
        if beta2 < 3
            type = 2;
        elseif beta2 > 3
            type = 7;
        end
        a1 = -sqrt(abs(c0./c2));
        a2 = -a1; % symmetric roots
    end
elseif c2 == 0 % kurt = 3 + 1.5*skew^2 
    type = 3;
    a1 = -c0 ./ c1; % single root
else
    kappa = c1.^2 ./ (4*c0.*c2);
    if kappa < 0
        type = 1;
    elseif kappa < 1-eps
        type = 4;
    elseif kappa <= 1+eps
        type = 5;
    else
        type = 6;
    end
    % Solve the quadratic for general roots a1 and a2 and sort by their real parts
    tmp = -(c1 + sign(c1).*sqrt(c1.^2 - 4*c0.*c2)) ./ 2;
    a1 = tmp ./ c2;
    a2 = c0 ./ tmp;
    if (real(a1) > real(a2)), tmp = a1; a1 = a2; a2 = tmp; end
end

denom = (10*beta2 - 12*beta1 - 18);
if abs(denom) > sqrt(realmin)
    c0 = c0 ./ denom;
    c1 = c1 ./ denom;
    c2 = c2 ./ denom;
    coefs = [c0 c1 c2];
else
    type = 1; % this should have happened already anyway
    % beta2 = 1.8 + 1.2*beta1, and c0, c1, and c2 -> Inf.  But a1 and a2 are
    % still finite.
    coefs = Inf(1,3,outClass);
end

%% Generate standard (zero mean, unit variance) values
switch type
case 0
    % normal: standard support (-Inf,Inf)
%     m1 = zeros(outClass);
%     m2 = ones(outClass);
    m1 = 0;
    m2 = 1;
    p = normpdf(X,m1,m2)/sigma;
case 1
    % four-parameter beta: standard support (a1,a2)
    if abs(denom) > sqrt(realmin)
        m1 = (c1 + a1) ./ (c2 .* (a2 - a1));
        m2 = -(c1 + a2) ./ (c2 .* (a2 - a1));
    else
        % c1 and c2 -> Inf, but c1/c2 has finite limit
        m1 = c1 ./ (c2 .* (a2 - a1));
        m2 = -c1 ./ (c2 .* (a2 - a1));
    end
%     r = a1 + (a2 - a1) .* betarnd(m1+1,m2+1,sizeOut);
    X = (X-a1)./(a2-a1);        % Transform to 0-1 interval
%     lambda = -(a2-a1)*(m1+1)./(m1+m1+2)-a1;
%     X = (X - lambda - a1)./(a2-a1);
    p = betapdf(X,m1+1,m2+1)/sigma/(a2-a1);
%     X = X*(a2-a1) + a1;         % Undo interval tranformation
%     r = r + (0 - a1 - (a2-a1).*(m1+1)./(m1+m2+2));
case 2
    % symmetric four-parameter beta: standard support (-a1,a1)
    m = (c1+a1)./(c2.*2*abs(a1));
    X = (X-a1)./(2*abs(a1));
%     r = a1 + 2*abs(a1) .* betapdf(X,m+1,m+1);
    p = betapdf(X,m+1,m+1)/sigma/(2*abs(a1));
%     X = a1 + 2*abs(a1).*X;
case 3
    % three-parameter gamma: standard support (a1,Inf) or (-Inf,a1)
    m = (c0./c1 - c1) ./ c1;
    X = (X - a1)./c1;
%     r = c1 .* gampdf(X,m+1,1,sizeOut) + a1;
    p = gampdf(X,m+1,1)/sigma/c1;
%     X = c1 .* X + a1;
case 4
    % Pearson IV is not a transformation of a standard distribution: density
    % proportional to (1+((x-lambda)/a)^2)^(-m) * exp(-nu*arctan((x-lambda)/a)),
    % standard support (-Inf,Inf)
    m = 1 ./ (2*c2);
    nu = 2.*c1.*(1 - m) ./ sqrt((4.*c0.*c2 - c1.^2));
    b = 2*(m-1);
    a = sqrt(b.^2 .* (b-1) ./ (b.^2 + nu.^2));  % gives unit variance
    lambda = a.*nu ./ b;                        % gives zero mean
%     X = (X - lambda)./a;
    p = pearson4pdf(X,m,nu,a,lambda);           % pdf for pearson type 4
    p = p/sigma;
%     C = X.*a + lambda;
%     C = diff(C);
%     C= C(1);
%     p = p./(sum(p)*C);
case 5
    % inverse gamma location-scale: standard support (-C1,Inf) or (-Inf,-C1)
    C1 = c1 ./ (2*c2);
%     r = -((c1 - C1) ./ c2) ./ gampdf(X,1./c2 - 1,1) - C1;
    X = -((c1-C1)./c2)./(X + C1);
    p = gampdf(X,1./c2 - 1,1)/sigma;
    warning('not correctly normalized')
%     X = -((c1-C1)./c2)./X-C1;
case 6
    % F location-scale: standard support (a2,Inf) or (-Inf,a1)
    m1 = (a1 + c1) ./ (c2.*(a2 - a1));
    m2 = -(a2 + c1) ./ (c2.*(a2 - a1));
    % a1 and a2 have the same sign, and they've been sorted so a1 < a2
    if a2 < 0
        nu1 = 2*(m2 + 1);
        nu2 = -2*(m1 + m2 + 1);
        X = (X-a2)./(a2-a1).*(nu2./nu1);
%         r = a2 + (a2 - a1) .* (nu1./nu2) .* fpdf(X,nu1,nu2);
        p = fpdf(X,nu1,nu2)/sigma/(a2-a1)*(nu2./nu1);
%         X = a2 + (a2-a1).*(nu1./nu2).*X
    else % 0 < a1
        nu1 = 2*(m1 + 1);
        nu2 = -2*(m1 + m2 + 1);
        X = (X-a1)./(a1-a2).*(nu2./nu1);
%         r = a1 + (a1 - a2) .* (nu1./nu2) .* fpdf(X,nu1,nu2);
        p = fpdf(X,nu1,nu2)/sigma/(a1-a2)*(nu2./nu1);
%         X = a1 + (a1-a2).*(nu1./nu2).*X;
    end
case 7
    % t location-scale: standard support (-Inf,Inf)
    nu = 1./c2 - 1;
    X = X./sqrt(c0./(1-c2));
    p = tpdf(X,nu)/sigma/sqrt(c0./(1-c2));
%     p = sqrt(c0./(1-c2)).*tpdf(X,nu);
%     X = sqrt(c0./(1-c2)).*X;
end

% scale and shift
% X = X.*sigma + mu; % Undo z-score
end

function p = pearson4pdf(X,m,nu,a,lambda)
% pearson4pdf
%   p = pearson4pdf(X,m,nu,a,lambda)
%
%   Returns the pearson type IV probability density function with
%   parameters m, nu, a and lambda at the values of X.
%
%   Example
%
%   See also
%       pearson4pdf betapdf normpdf
%       pearspdf pearsrnd
%
X = (X - lambda)./a;
p1 = (abs(gammac(m+(nu/2)*1i)/gammac(m)).^2)./(a.*beta(m-.5,.5*ones(size(m))));
p2 = (1+X.^2).^-m.*exp(-nu.*atan(X));
p = p1.*p2;
end

function [f] = gammac(z)
% GAMMA  Gamma function valid in the entire complex plane.
%        Accuracy is 15 significant digits along the real axis
%        and 13 significant digits elsewhere.
%        This routine uses a superb Lanczos series
%        approximation for the complex Gamma function.
%
%        z may be complex and of any size.
%        Also  n! = prod(1:n) = gamma(n+1)
%
%usage: [f] = gamma(z)
%       
%tested on versions 6.0 and 5.3.1 under Sun Solaris 5.5.1
%
%References: C. Lanczos, SIAM JNA  1, 1964. pp. 86-96
%            Y. Luke, "The Special ... approximations", 1969 pp. 29-31
%            Y. Luke, "Algorithms ... functions", 1977
%            J. Spouge,  SIAM JNA 31, 1994. pp. 931-944
%            W. Press,  "Numerical Recipes"
%            S. Chang, "Computation of special functions", 1996
%            W. J. Cody "An Overview of Software Development for Special
%            Functions", 1975
%
%see also:   GAMMA GAMMALN GAMMAINC PSI
%see also:   mhelp GAMMA
%
%Paul Godfrey
%pgodfrey@intersil.com
%http://winnie.fit.edu/~gabdo/gamma.txt
%Sept 11, 2001

siz = size(z);
z=z(:);
zz=z;

f = 0.*z; % reserve space in advance

p=find(real(z)<0);
if ~isempty(p)
   z(p)=-z(p);
end

% 15 sig. digits for 0<=real(z)<=171
% coeffs should sum to about g*g/2+23/24

g=607/128; % best results when 4<=g<=5

c = [  0.99999999999999709182;
      57.156235665862923517;
     -59.597960355475491248;
      14.136097974741747174;
      -0.49191381609762019978;
        .33994649984811888699e-4;
        .46523628927048575665e-4;
       -.98374475304879564677e-4;
        .15808870322491248884e-3;
       -.21026444172410488319e-3;
        .21743961811521264320e-3;
       -.16431810653676389022e-3;
        .84418223983852743293e-4;
       -.26190838401581408670e-4;
        .36899182659531622704e-5];

%Num Recipes used g=5 with 7 terms
%for a less effective approximation

z=z-1;
zh =z+0.5;
zgh=zh+g;
%trick for avoiding FP overflow above z=141
zp=zgh.^(zh*0.5);

ss=0.0;
for pp=size(c,1)-1:-1:1
    ss=ss+c(pp+1)./(z+pp);
end

%sqrt(2Pi)
sq2pi=  2.5066282746310005024157652848110;
f=(sq2pi*(c(1)+ss)).*((zp.*exp(-zgh)).*zp);

f(z==0 | z==1) = 1.0;

%adjust for negative real parts
if ~isempty(p)
   f(p)=-pi./(zz(p).*f(p).*sin(pi*zz(p)));
end

%adjust for negative poles
p=find(round(zz)==zz & imag(zz)==0 & real(zz)<=0);
if ~isempty(p)
   f(p)=Inf;
end

f=reshape(f,siz);
end
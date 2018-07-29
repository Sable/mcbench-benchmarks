function [mu,gsd,left,right] = TSK(x,r,n,A,conf)
%TSK Trimmed Spearman-Karber method.
%   [mu,gsd,left,right] = TSK(x,r,n,A,conf) analyzes a dose-response curve
%   and calculates the median dose using the Trimmed Spearman-Karber 
%   method, taking the input parameters:
%    x    = Array of doses (must be in increasing order and positive: a
%           zero dose will be used as the control dose)
%    r    = Array of number of subjects that respond (must be in order 
%        corresponding to the doses)
%    n    = Scalar number of subjects per dose, or array of number of 
%        subjects at each dose
%    A    = Trim (0 gives the untrimmed Spearman-Karber method. Must be 
%        between 0 and .5. Uses 0 if no number is given.)
%    conf = Confidence of confidence interval in plot. (0.95 if not 
%        specified.) 
%
%   and returning:
%    mu    = Median dose.
%    gsd   = Geometric standard deviation of the median.
%    left  = Lower confidence limit
%    right = Upper confidence limit
%
%   This is an alternative to dose-response analysis methods such as probit 
%   and logit methods. It does not require glmfit or the stats toolbox.
%
%   All calculations in this code are based on the method from Hamilton, 
%   M.A.; Russo, R.C.; Thurston, R.V. Trimmed Spearman-Karber Method for 
%   Estimating Median Lethal Concentrations in Toxicity Bioassays. Enviro. 
%   Sci. Tech. 1977, 11 (7), 714-719. See also ibid, 1978, 12 (4), 417. 
%
%   This code was validated using the data given in Hamilton et al. (1977)
%   and the example given in the documentation for the EPA's DOS program to 
%   perform the Spearman-Karber method, available at http://www.epa.gov/
%   eerd/stat2.htm. (Note that the confidence intervals given in Hamilton 
%   et al (1977) are incorrect, as per Hamilton et al. (1978).) 
%   This code replicates the EPA program's results.

%Code written by Brenton R. Stone
%Last revised Aug 13 2010.

%---CHECK THAT THE INPUT IS VALID------------------------------------------
if nargin < 3
    error('MATLAB:TrimmedSpearmanKarber:Nargin',...
        'Too few arguments.');
elseif nargin < 5
    conf = 0.95;
elseif nargin < 4
    A = 0;
    conf = 0.95;
end

input = struct('x',x,'r',r,'n',n);

% Check if xr, r, and nr match
N = length(input.x);
if N ~= length(input.r)
    error('MATLAB:TrimmedSpearmanKarber',...
        'Different numbers of doses and responses were given.');
end

if length(input.n) == 1
    input.n = input.n*ones(1,N);
elseif length(input.n) ~= N
    error('MATLAB:TrimmedSpearmanKarber',...
        'Different numbers of doses and subject groups were given.');
end

% Check if x is in the right range and order
if any(input.x < 0)
    error('MATLAB:TrimmedSpearmanKarber',...
        ['All doses must be positive or zero.' ...
        'Please input concentrations, not logs of concentrations.']);
elseif ~issorted(input.x)
    error('MATLAB:TrimmedSpearmanKarber',...
        'Data is not in order of increasing dose.');
end

% Check if r is in the right range
if any(input.r < 0)
    error('MATLAB:TrimmedSpearmanKarber',...
        'Responses must be positive or zero');
end

% Check if n is nonnegative
if any(input.n<=0)
    error('MATLAB:TrimmedSpearmanKarber',...
        'Population sizes should be positive.');
end
% Check if A is in the right range
if A<0 || A>=0.5
    error('MATLAB:TrimmedSpearmanKarber',...
        'The trim A is not a valid value.');
end
% Check if conf is in the right range
if conf>=1 || conf<=0.5
    error('MATLAB:TrimmedSpearmanKarber',...
        'The confidence is not a valid value.');
end

%---MASSAGE THE DATA-------------------------------------------------------
% If first concentration is 0, scale everything else to account for that. 
% Also, transform to log scale.

if input.x(1) == 0
    data = struct('x',zeros([N-1 1]),'p',zeros([N-1 1]),'n',zeros([N-1 1]));
    data.x = log10(input.x(2:end));
    if input.r(1) == 0
        data.p = input.r(2:end) ./ input.n(2:end);
        data.n = input.n(2:end);
        titl = sprintf('Responses, trim of %d%%', A*100);
    else
        warning('MATLAB:TrimmedSpearmanKarber',...
            ['Control dose has a non-zero response. ' ...
            'Scaling everything else to correct for that...'])
        data.p = (input.r(2:end) - input.r(1)) ./ ...
            (input.n(2:end) - input.r(1));
        data.n = input.n(2:end) - input.r(1);
        titl = sprintf('Responses scaled for control, trim of %d%%', A*100);
    end
    N = length(data.n);
else
    data   = struct('x',zeros([N 1]),'p',zeros([N 1]),'n',zeros([N 1]));
    data.p = input.r ./ input.n;
    data.x = log10(input.x);%transform to log scale
    data.n = input.n;
end

% Smooth by fixing nondecreasingness, as per the first step in Hamilton.
% There's probably a more efficient way to do this but this is what's in
% Hamilton. It does not seem to add much to the execution time.
datasmooth = data;

if any(datasmooth.p(1:(N-1)) > datasmooth.p(2:N))
    warning('MATLAB:TrimmedSpearmanKarber', ...
        ['Responses are not monotonically increasing with dose. ' ...
        'Smoothing the data by averaging adjacent nonincreasing responses.'])
    while any(datasmooth.p(1:(N-1)) > datasmooth.p(2:N))
        for i = 1:(N-1)
            if datasmooth.p(i) > datasmooth.p(i+1)
                pave = (datasmooth.p(i) * datasmooth.n(i) + ...
                    datasmooth.p(i+1) * datasmooth.n(i+1)) ...
                    / (datasmooth.n(i)+datasmooth.n(i+1));
                datasmooth.p(i)   = pave;
                datasmooth.p(i+1) = pave;
            end
        end
    end
end

%---SCALE AND TRIM---------------------------------------------------------
% As per steps 2 and 3 in Hamilton
datascale = datasmooth;
if A ~= 0
    datascale.p = (datasmooth.p - A) / (1 - 2 * A);
end
if datascale.p(1) > 0 || datascale.p(end) < 1
    %Cannot do it with this trim. Determine smallest trim that analysis can
    %be done with.
    Amaybe = max(datasmooth.p(1), 1 - datasmooth.p(end));
    error('MATLAB:TrimmedSpearmanKarber',...
        ['Responses do not cover the space from A to 1-A. ' ...
        sprintf('Consider using a value of A that is %.2f or larger.'...
        ,Amaybe)]);
end

% Linearly interpolate points where the lines meet the trim.
% Check if any points lie inside the trim
keepers = (datascale.p > 0) & (datascale.p < 1);
if any(keepers)
    Uscale = find(keepers,1,'last');
    Lscale = find(keepers,1,'first');

    trimx = datascale.x(keepers);
    trimp = datascale.p(keepers);
    if datascale.p(Lscale-1) ~= 0
        i=Lscale;
        xhead = interp1q([datascale.p(i-1); datascale.p(i)],...
            [datascale.x(i-1); datascale.x(i)],0);
    else
        xhead = datascale.x(Lscale-1);
    end
    if datascale.p(Uscale+1) ~= 1
        i = Uscale;

        xtail = interp1q([datascale.p(i); datascale.p(i+1)],...
            [datascale.x(i); datascale.x(i+1)],1);
    else
        xtail = datascale.x(Uscale+1);
    end
    datatrim = struct('x',[xhead trimx xtail],'p',[0 trimp 1]);
else % When all datapoints lie outside the trim
    i = find(datascale.p > 0,1,'first')-1;
    xhead = interp1q([datascale.p(i); datascale.p(i+1)],...
        [datascale.x(i); datascale.x(i+1)],0);
    xtail = interp1q([datascale.p(i); datascale.p(i+1)],...
        [datascale.x(i); datascale.x(i+1)],1);
    datatrim = struct('x',[xhead xtail],'p',[0 1]);
end

%---FIND THE MEAN----------------------------------------------------------
% Step 4 in Hamilton
trimN = length(datatrim.x);
mids  = (datatrim.x(1:trimN-1) + datatrim.x(2:trimN)) / 2;
delp  = datatrim.p(2:trimN) - datatrim.p(1:trimN-1);
logmu = sum(mids .* delp);
mu    = 10^logmu;

%---FIND THE VARIANCE------------------------------------------------------
% Appendix in Hamilton
L = find(datasmooth.p <= A, 1, 'last');
U = find(datasmooth.p >= 1-A, 1, 'first');
s = U - L;
switch s
    case 0
        %If this case occurs it should have failed before now but just in
        %case...
        Var = NaN;
    case 1
        Var = (datasmooth.x(U) - datasmooth.x(L))^2 * ...
            ((0.5-datasmooth.p(U))^2 / (datasmooth.p(U)-datasmooth.p(L))^4 * ...
            datasmooth.p(L) * (1-datasmooth.p(L)) / datasmooth.n(L) ...
            + (0.5-datasmooth.p(L))^2 / (datasmooth.p(U)-datasmooth.p(L))^4 * ...
            datasmooth.p(U) * (1-datasmooth.p(U)) / datasmooth.n(U));
    case 2
        Var = (V1(datasmooth,A,L,U) + V5(datasmooth,A,L,U) + ...
            V6(datasmooth,A,L,U)) / (2 - 4*A)^2;
    case 3
        Var = (V1(datasmooth,A,L,U) + V2(datasmooth,A,L,U) + V4(datasmooth,A,L,U) + ...
            V5(datasmooth,A,L,U)) / (2 - 4*A)^2;
    otherwise
        Var = (V1(datasmooth,A,L,U) + V2(datasmooth,A,L,U) + V3(datasmooth,A,L,U) + ...
            V4(datasmooth,A,L,U) + V5(datasmooth,A,L,U)) / (2 - 4*A)^2;
end

gsd=10^(sqrt(Var));
%Calculate confidence interval
v     = sqrt(2) * erfinv(conf);
left  = mu * gsd^(-v);
right = mu * gsd^v;

%---PLOT DATA--------------------------------------------------------------
semilogx(10.^data.x, 100*data.p, 'x');
hold on
plot(10.^datatrim.x, 100*(datatrim.p * (1 - 2*A) + A), ':');
plot(mu, 50, 'o');
set(gca, 'YLim', [0 100]);
title (titl);
xlabel('Dose');
ylabel('Response, %');


%Error bars for the confidence interval on the mean. HERRORBAR doesn't do
%the ends right since we're only plotting one point, so we have to do this
%by hand. This is based on the code from herrorbar.m.
tee = 0.02; % make tee .02 x-distance for error bars
ptop = 0.5 + tee;
pbot = 0.5 - tee;

% build up nan-separated vector for bars
xb = zeros(9);
xb(1) = left;
xb(2) = left;
xb(3) = NaN;
xb(4) = left;
xb(5) = right;
xb(6) = NaN;
xb(7) = right;
xb(8) = right;
xb(9) = NaN;

yb = zeros(9);
yb(1) = ptop;
yb(2) = pbot;
yb(3) = NaN;
yb(4) = 0.5;
yb(5) = 0.5;
yb(6) = NaN;
yb(7) = ptop;
yb(8) = pbot;
yb(9) = NaN;

plot(xb,100 * yb,'-');
hold off
end

%Functions to calculate the variance, as per the appendix of Hamilton.
function V1 = V1(data,A,L,U)
V1 = ((data.x(L+1) - data.x(L)) * (data.p(L+1) - A)^2 / ...
    (data.p(L+1) - data.p(L))^2)^2 * data.p(L) * (1 - data.p(L)) / ...
    data.n(L);
end

function V2 = V2(data,A,L,U)
V2 = ((data.x(L) - data.x(L+2)) + (data.x(L+1) - data.x(L)) * ...
    (A - data.p(L))^2 / (data.p(L+1) - data.p(L))^2)^2 * data.p(L+1) * ...
    (1-data.p(L+1)) / data.n(L+1);
end

function V3 = V3(data,A,L,U)
v3 = (data.x((L+1):(U-3)) - data.x((L+3):(U-1))).^2 .* data.p((L+2):(U-2)) .* ...
    (1 - data.p((L+2):(U-2))) ./ data.n((L+2):(U-2));
V3 = sum(v3);
end

function V4 = V4(data,A,L,U)
V4 = ((data.x(U-2) - data.x(U)) + (data.x(U) - data.x(U-1)) * ...
    (data.p(U) - 1 + A)^2 / (data.p(U) - data.p(U-1))^2)^2 * ...
    data.p(U-1) * (1-data.p(U-1)) / data.n(U-1);
end

function V5 = V5(data,A,L,U)
V5 = ((data.x(U) - data.x(U-1)) * (1 - A - data.p(U-1))^2 / ...
    (data.p(U) - data.p(U-1))^2)^2 * data.p(U) * (1-data.p(U)) / data.n(U);
end

function V6 = V6(data,A,L,U)
V6 = ((data.x(U) - data.x(L+1)) * (1 - A - data.p(U))^2 / ...
    (data.p(U) - data.p(L+1))^2 - (data.x(L+1) - data.x(L)) * ...
    (A - data.p(L))^2 / (data.p(L+1) - data.p(L))^2 + ...
    (data.x(L) - data.x(U)))^2 * data.p(L+1) * (1 - data.p(L+1)) / ...
    data.n(L+1);
end
function [as,bs,vars] = sumARMA(varargin)

%SUMARMA Sum of ARMA-processes
%   [ar_s,ma_s,var_s] = sumARMA(ar1,ma1,var1,ar2,ma2,var2) yields
%   the sum of 2 ARMA-processes. The list of arguments can be 
%   extended with more ARMA-processes.

%S. de Waele, 2001.

%Technical note:
%If this method does not work, the following procedure can be followed:
%- Calculate the covariance functions and add them;
%- Transform this covariance function into an AR process.

if rem(nargin,3),
    error('Incorrect number of inputs.')
end
np = nargin/3;

%Initialisation
a  = cell(np,1);
b  = cell(np,1);
var= cell(np,1);
gain = cell(np,1);
nomc = cell(np,1);
for i = 1:np,
    a{i}    = varargin{1+3*(i-1)};
    b{i}    = varargin{2+3*(i-1)};
    var{i}  = varargin{3+3*(i-1)};
    gain{i} = pgain(b{i},a{i});
    nomc{i} = 1;   
end
den = 1;
vars = 0;
nom = 0;

%Calculation of the contributions of the processes to the nominator
for i = 1:np,
    for j = 1:np,
        if j~=i,
            nomc{j} = conv(nomc{j},a{i});
        else
            nomc{j} = conv(nomc{j},b{j});      
        end %if j~i,
    end %for j = 1:np,
    vars = vars+var{i};
    den = conv(den,a{i});
end %for i = 1:np,
m = length(nomc{1});
for i = 2:np, m = max( [m length(nomc{i})] ); end
nom = zeros(1,m);

for i = 1:np,
    l = length(nomc{i})-1;
    nomc{i} = conv(nomc{i},fliplr(nomc{i}));
    nomc{i} = nomc{i}(l+1:2*l+1);
    nom(1:l+1) = nom(1:l+1)+var{i}*nomc{i}/gain{i};
end

as = den;
bs = cor2ma(nom,200*length(nom));
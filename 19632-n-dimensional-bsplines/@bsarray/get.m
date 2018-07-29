function val = get(b, propName)
% bsarray/get: get specified properties from bsarray object
% usage: v = get(b,propName)
%
% arguments:
%   b - bsarray object
%   propName - string, one of:
%       'coeffs'
%       'degree'
%       'tensorOrder'
%

% author: Nathan D. Cahill
% email: ndcahill@gmail.com
% date: 18 April 2008

switch lower(propName)
    case 'coeffs'
        val = b.coeffs;
    case 'tensororder'
        val = b.tensorOrder;
    case 'datasize'
        val = b.dataSize;
    case 'coeffssize'
        val = b.coeffsSize;
    case 'degree'
        val = b.degree;
    case 'centred'
        val = b.centred;
    case 'elementspacing'
        val = b.elementSpacing;
    case 'lambda'
        val = b.lambda;
    otherwise
        error([mfilename,':InvalidProperty'],...
            [propName,' is not a valid bsarray property'])
end

function [outh,outd]=hexcalc(expr)
% Copyright Murphy O'Brien 2006. All rights unreserved.
%
% Evaluate the input character string as a hexadecimal expression 
% and return both hex and decimal outputs.
% Allowed operators in precedence order are:
% #(xor) &(and) |(or) ^(exponential)  /(divide) *(times) -(minus) +(plus)
% 
% [OUTH,OUTD]=HEXCALC(EXPR)
% evaluate the input expression and return both hex and decimal outputs.
% 
% HEXCALC(EXPR) with no output arguments prints both outputs
%
% example:
% hexcalc('F4*4-34*4/2-640*3+a#F2+3|A0')
% prints out:
% evaluates as FFFFF243 hex or -3517 decimal
if ~ischar(expr)
    error('Function ''hexcalc'' requires a hex input expression in the form a string')
end
if any(ismember(expr,'[{()}]'))
    error('brackets are not allowed')
end
if ~all(ismember(expr,'#&|^*/-+0123456789ABCDEFabcdef '))
    warning('HEXCALC:unknown','unknown characters ignored')
end
ops=regexp(expr,'[\#\&\|\^\*\/\-\+]');          % 
expr(ops(diff(ops)==1))='';                     % remove repeated operators to allow || and &&
ops=regexp(expr,'[\#\&\|\^\*\/\-\+]','match');  % extract operators
ops=[ops{:}];                                   % concatenate elements
hexs=regexpi(expr,'[\dABCDEF]+','match');       % extract hex strings
decs=zeros(size(hexs));
for ii=1:size(hexs,2);
    decs(ii)=hex2dec(hexs(ii));
end

% do for all operators in precedence order
for op='#&|^/*-+'
    [decs,ops]=applyop(decs,ops,op);
end
if nargout==0                                   % see if output expected 
    fprintf('evaluates as %s hex or %g decimal\n',dec2hexs(decs(1)),decs(1))
else
    outh=dec2hexs(decs(1));
    outd=decs(1);
end


%-------------------------------
% signed decimal to hex convert
function h=dec2hexs(dec,bits)
if nargin<2
    bits=32;
end
h=dec2hex(mod(round(dec)+2.^bits,2.^bits));
%-------------------------------

%-------------------------------
% apply an operation to a data vector
function [decs,ops]=applyop(decs,ops,op)
opsnow=find(ops==op);
bitops='#&|';
bitfuns={'bitxor','bitand','bitor'};
if any(op==bitops)
    op=bitfuns{find(op==bitops)};
end
fop=str2func(op);
for ii=opsnow;
    decs(ii+1)=fop(decs(ii),decs(ii+1));
end
decs(opsnow)=[];
ops(opsnow)='';

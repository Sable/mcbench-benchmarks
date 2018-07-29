function [f] = poch(z,n)
%Pochhammer function (z)n = z(z+1)(z+2)...(z+n-1)
%
%usage:  f = poch(z,n)
%
%tested on version 5.3.1
%
%        z and n may be complex but must be equal in size.
%
%see also: Gamma, Fact

%Paul Godfrey
%pgodfrey@conexant.com
%8-24-00

f = gamma(z+n)./gamma(z);

p=find(z==0 & n==0);
if ~isempty(p)
    f(p)=0;
end

return

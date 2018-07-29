function response = Unforgiving(n,p)

persistent coopflag

if n==1; coopflag=1; end
if p==1 || p==5; coopflag=0; end

if coopflag
    response = 'cooperate';
else
    response = 'defect';
end
    
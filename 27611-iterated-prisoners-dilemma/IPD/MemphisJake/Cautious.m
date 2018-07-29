function response = Cautious(n,p)

if n==1 || n==20
    response = 'defect';
elseif p==0 || p==3
    response = 'cooperate';
else
    response = 'defect';
end
    
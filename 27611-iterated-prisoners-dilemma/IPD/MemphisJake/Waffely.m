function response = Waffely(n,p)

persistent oscyflag
if n==1; oscyflag=1; end
if oscyflag
    response = 'cooperate';
    oscyflag=0;
else
    response = 'defect';
    oscyflag=1;
end
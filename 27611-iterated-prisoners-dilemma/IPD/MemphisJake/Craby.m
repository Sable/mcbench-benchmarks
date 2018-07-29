function response = Craby(n,prev)

if n>4 && n<9 || n==1 || n>18
    response = 'cooperate';
else
    response = 'defect';
end
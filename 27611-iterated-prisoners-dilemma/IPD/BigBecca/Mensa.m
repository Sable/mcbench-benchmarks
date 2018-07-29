function response = Mensa(n,prev)

if rem(n, 2) == 0 && prev == 3
    response = 'cooperate';
else
    response = 'defect';
end
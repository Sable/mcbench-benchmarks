function response = Observant(n,prev)

if prev == -1
    response = 'defect'; % Screw him before he screws you!
elseif (prev == 0) % He cooperated last time
    response = 'cooperate';
elseif (prev == 1) % He defected last time
    response = 'defect';
elseif  (prev == 3) % He 'cooperated' last time
    response = 'cooperate';
elseif (prev == 5) % He defected last time
    response = 'defect';
end
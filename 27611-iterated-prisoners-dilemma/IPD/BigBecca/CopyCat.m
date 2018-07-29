function response = CopyCat(n,prev)

if prev == -1
    response = 'cooperate'; % Give him the benefit of the doubt
elseif (prev == 5) % See what he's doing and adjust accordingly
    response = 'defect';
elseif (prev == 1)
    response = 'defect';
elseif  (prev == 3)
    response = 'cooperate';
elseif (prev == 0)
    response = 'cooperate';
end
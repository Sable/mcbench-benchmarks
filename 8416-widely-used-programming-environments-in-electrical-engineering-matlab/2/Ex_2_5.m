for k=0:5
    switch k
        case 1 
        a=1
        case 2 
        a=2
        case {3,4}
        a=3
        otherwise
        a=0
    end
end
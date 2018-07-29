function name = getUserName ()
    if isunix() 
        name = getenv('USER'); 
    else 
        name = getenv('username'); 
    end
end

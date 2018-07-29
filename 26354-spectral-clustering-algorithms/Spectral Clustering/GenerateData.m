function [data] = GenerateData(select)


% pseudo random sequence
rand('state',100);

if select == 1
    CL1 = 7;
    CL2 = 7;    
    
    for i=1:CL1
        % rand value for x and y axis
        data(i,1) = 1+rand;   data(i,2) = 1+rand;
    end % end of for

    for i = (CL1+1) : (CL2 + CL1)
        % rand value for x and y axis
        data(i,1) = 3 + rand;   data(i,2) = 3 + rand;
    end % end of for
    
elseif select == 2
    CL1 = 7;
    CL2 = 7;    
    CL3 = 7;
    
    for i=1:CL1
        % rand value for x and y axis
        data(i,1) = 1+rand;   data(i,2) = 1+rand;
    end % end of for

    for i = (CL1+1) : (CL2 + CL1)
        % rand value for x and y axis
        data(i,1) = 3 + rand;   data(i,2) = 1 + rand;
    end % end of for
        
    for i = (CL1+CL2+1) : (CL3 + CL2 + CL1)
        % rand value for x and y axis
        data(i,1) = 1.5 + rand;   data(i,2) = 3 + rand;
    end % end of for
        
end % end of if

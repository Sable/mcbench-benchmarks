function y=bin2sbin(x)

    y = ones(1,length(x));

    for index =1:length(x)
    
        if x(index)=='0'
            y(index)=-1;
        end
        
    end
    

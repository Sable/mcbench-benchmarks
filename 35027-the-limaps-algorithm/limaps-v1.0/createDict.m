function [D DINV true_alpha s] = createDict(n,m,k,l,field,dictType)

    if(nargin<3||nargin>6)
        error('Wrong parameters number');
    end
    if(nargin==3)
        l=1;
        field='Real';
        dictType='Gaussian';
    end 
    if(nargin==4)
        field='Real';
        dictType='Gaussian';
    end
    if(nargin==4)
        dictType='Gaussian';
    end 
    
    true_alpha = zeros(m,l);
    for i=1:l
        switch(field)
            case 'Real';
                ta = [randi(n,1,k)-n/2 zeros(1,m-k)]';
            case 'Complex';
                ta = complex([randi(n,1,k)-n/2 zeros(1,m-k)]',[randi(n,1,k)-n/2 zeros(1,m-k)]');
        end
        ta=ta(randperm(numel(ta)));
        true_alpha(:,i)=ta;
    end
    
    % create the random dictionary
    switch(dictType)
        case 'Gaussian'
            switch(field)
                case 'Real';
                    D = randn(n,m);
                case 'Complex';
                    D = complex(randn(n,m),randn(n,m));
            end
            
        case 'Bernoulli'
            switch(field)
                case 'Real';
                    D = (binornd(1,0.5,n,m)*2-1)/sqrt(m);
                case 'Complex';
                    D = complex((binornd(1,0.5,n,m)*2-1)/sqrt(m),(binornd(1,0.5,n,m)*2-1)/sqrt(m));
            end
            
        case 'Toepliz_Gaussian'
            switch(field)
                case 'Real';
                    c = randn(1,n);
                    r = randn(1,m);
                case 'Complex';
                    c = complex(randn(1,n),randn(1,n));
                    r = complex(randn(1,m),randn(1,m));
            end
            r(1)=c(1);
            D = toeplitz(c,r);
            
        case 'Toepliz_Bernoulli'
            switch(field)
                case 'Real';
                    c = (binornd(1,0.5,1,n)*2-1)/sqrt(m)
                    r = (binornd(1,0.5,1,m)*2-1)/sqrt(m);
                case 'Complex';
                    c = complex(binornd(1,0.5,1,n),binornd(1,0.5,1,n));
                    r = complex(binornd(1,0.5,1,m),binornd(1,0.5,1,m));
            end
            r(1)=c(1);
            D = toeplitz(c,r);
    end;
    
    for j=1:m
        D(:,j) = D(:,j) / norm(D(:,j));
    end
    DINV = pinv(D);

    % generate the signal
    s = D*true_alpha;
    
end
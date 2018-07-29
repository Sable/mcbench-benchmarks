function [ args ] = geadientDescent( data )
%GEADIENTDESCENT Summary of this function goes here
%   data are, in lines there are samples, in columns there are dimensions
    
    learningRate = 0.2;
    stopCriterion = 0.000001;
    normalize = true;
    
    
    
    stop = false;
    args=rand(1,size(data,2)+1);
    %args=zeros(1,size(data,2)+1);
    
    if normalize==true
        for i=1:size(data,2)
            data(:,i)=data(:,i)-min(data(:,i));
            data(:,i)=data(:,i)./max(data(:,i));
        end
    end
    
    
    
    extra = ones(size(data,1),1);
    
    
    verify=[extra,data];

    while stop == false
        data = verify;
        
        argsOld=args;
        
        for i=1:size(data,1)
            data(i,:)=args.*data(i,:);
            
        end
        
        sumed = sum(data(:,1:(size(data,2)-1))')';
        posun = sumed-verify(:,end);
        
        for i=1:(size(data,2)-1)
            args(i)=args(i)-(learningRate*(sum(verify(:,i).*posun)/size(data,1)));
        end
        
        if pdist([args;argsOld]) < stopCriterion
            stop=true;
        end
        
        
        %plotting for 2D Data
        clf
        scatter(verify(:,2),verify(:,3));
        hold on 
        ycoord=args(1)+(args(2)*(1));
        plot([0,1],[args(1),ycoord]);
        shg;
        
        pause(1);
        
        
    end

end


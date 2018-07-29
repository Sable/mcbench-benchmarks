function [p_best,p_best_fit]=renewp_best(D,fitness,p_best,N,k,position,p_best_fit,Min_Max_flag)
if Min_Max_flag == 1
    for n=1:N
        if k==1
            min_p=fitness(n,k);
            p_best(n,:)=position(n,:);
            p_best_fit(n,1)=min_p;
        elseif p_best_fit(n,1) > fitness(n,k)  
            p_best_fit(n,1)=fitness(n,k);
            p_best(n,:)=position(n,:);
        end
    end
else
    for n=1:N
        if k==1
            min_p=fitness(n,k);
            p_best(n,:)=position(n,:);
            p_best_fit(n,1)=min_p;
        elseif p_best_fit(n,1) < fitness(n,k)  
            p_best_fit(n,1)=fitness(n,k);
            p_best(n,:)=position(n,:);
        end
    end
end
return
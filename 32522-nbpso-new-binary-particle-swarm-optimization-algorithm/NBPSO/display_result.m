function display_result(best_fit,mean_fit,K,Min_Max_flag)
best_rate=mean(best_fit);
mean_rate=mean(mean_fit);
temp=best_rate;
if Min_Max_flag == 1   % minimization
    for i=2:K
        if best_rate(i) < temp(i-1)
            temp(i) = best_rate(i);
        else
            temp(i) = temp(i-1);
        end
    end
else      % maximization
    for i=2:K
        if best_rate(i) > temp(i-1)
            temp(i) = best_rate(i);
        else
            temp(i) = temp(i-1);
        end
    end
end
best_sofar=temp;
plot(mean_rate),grid,title(' Meaan of fitness')
figure,plot(best_sofar),grid,title(' Best fitness ever found')
return
[x,y,d,t,h,iter,alpha,beta,e,m,n,el]=ants_information;
for i=1:iter
    [app]=ants_primaryplacing(m,n);
    [at]=ants_cycle(app,m,n,h,t,alpha,beta);
    at=horzcat(at,at(:,1));
    [cost,f]=ants_cost(m,n,d,at,el);
    [t]=ants_traceupdating(m,n,t,at,f,e);
    costoa(i)=mean(cost);
    [mincost(i),number]=min(cost);besttour(i,:)=at(number,:);
    iteration(i)=i;
end
subplot(2,1,1);plot(iteration,costoa);
title('average of cost (distance) versus number of cycles');
xlabel('iteration');
ylabel('distance');
[k,l]=min(mincost);
for i=1:n+1
    X(i)=x(besttour(l,i));
    Y(i)=y(besttour(l,i));
end
subplot(2,1,2);plot(X,Y,'--rs','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',10)
xlabel('X');ylabel('y');axis('equal');
for i=1:n
    text(X(i)+.5,Y(i),['\leftarrow node ',num2str(besttour(l,i))]);
end
title(['optimum course by the length of ',num2str(k)]);
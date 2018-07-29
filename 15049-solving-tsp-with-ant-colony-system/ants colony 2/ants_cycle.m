function [at]=ants_cycle(app,m,n,h,t,alpha,beta);
for i=1:m
    mh=h;
    for j=1:n-1
        c=app(i,j);
        mh(:,c)=0;
        temp=(t(c,:).^beta).*(mh(c,:).^alpha);
        s=(sum(temp));
        p=(1/s).*temp;
        r=rand;
        s=0;
        for k=1:n
            s=s+p(k);
            if r<=s
                app(i,j+1)=k;
                break
            end
        end
    end
end
at=app;% generation of ants tour matrix during a cycle.

    function xsol = fzero_data(x,y,y0)
        N=length(x);
        vectsign=sign(y-y0);
        pos=zeros(1,N);
        for i=1:(N-1)
            if vectsign(i)~=vectsign(i+1)
                pos(i)=1;
                pos(i+1)=1;
            end
        end
        
        indices=find(pos);
        Nmax=2*(length(indices)-1);
        vectint=zeros(1,Nmax);
        vectint(1)=indices(1);
        vectint(Nmax)=indices(length(indices));       
        for j=2:2:(Nmax-2)
            vectint(j)=indices(j/2+1);
            vectint(j+1)=indices(j/2+1);
        end
        Nmaxsol=Nmax/2;
        indsol=zeros(1,2*Nmaxsol);
        for k=1:Nmaxsol
            if (y(vectint(2*k-1))-y0>=0 && y(vectint(2*k))-y0<=0)||(y(vectint(2*k-1))-y0<=0 && y(vectint(2*k))-y0>=0)
                indsol(2*k-1)=1;
                indsol(2*k)=1;
            else
                indsol(2*k-1)=0;
                indsol(2*k)=0;
            end
        end
        vectpos=vectint(find(indsol));
        Nsol=length(vectpos)/2;
        xsol=zeros(1,Nsol);
        for n=1:Nsol
            xsol(n)=interp1(y(vectpos(2*n-1:2*n))-y0,x(vectpos(2*n-1:2*n)),0);
        end
        
        clear vectsign pos indices Nmax vectint Nmaxsol indsol vectpos Nsol
        
    end


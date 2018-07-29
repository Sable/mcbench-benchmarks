
function [c,ceq]=confun(h)

global P m M

m1=0;

S=zeros(m*M+m1,m*M+m1,2*m*M+2*m1-1);

for n=0:2*m*M+2*m1-2
    
    for k=0:m*M+m1-1
        for l=0:m*M+m1-1
            
            if n==k+l;
                S(k+1,l+1,n+1)=1;
            else
                S(k+1,l+1,n+1)=0;
            end
        end
    end
    
end

J=flipud(eye(m*M+m1,m*M+m1));

for l=1:m-1
    
    n=2*M*(m-l)+2*m1-1;
    if l<=m-1 && l>=floor((m+1)/2)      
        ceq(:,l)=h'*S(:,:,n+1)*h;
    elseif l<=floor((m+1)/2)-1 && l>=1
        ceq(:,l)=h'*[S(:,:,n+1)+J*S(:,:,n-m*M+1)+S(:,:,n-m*M+1)*J]*h;
    end
end

ceq(:,m)=h'*[J*S(:,:,m*M+m1-1)+S(:,:,m*M+m1-1)*J]*h-(1/(2*M));
c=[];
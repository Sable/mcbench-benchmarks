function y1=K_q_Tsallis(P1,P2,q)
      


        [M,N]=size(P1);
        y=ones(1,N);
        
            for n=1:N
                y(1,n)=sum((P1(:,n).^q).*(P2(:,n).^(1-q)-P1(:,n).^(1-q)));
            end
                y1=y/(q-1);
                
    
    
    
    
    
function y2=K_q_escorTsallis(P1,P2,q)
  [M,N]=size(P1);
    y=ones(1,N);
    A1=ones(1,N);
    for n=1:N
    A1=sum(P1(:,n).^(1/q));
    A2=sum(P2(:,n).^(1/q));
       y(1,n)=sum( (P1(:,n)./((A1)^q)).*( ((P2(:,n).^(1/q))/A2).^(1-q) -((P1(:,n).^(1/q))/A1).^(1-q)) );
    end
    y2=y/(q-1);
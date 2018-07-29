function y2=K_q_renyi(P1,P2,q)
    [M,N]=size(P1);
    y=ones(1,N);
    for n=1:N
    y(1,n)=log(sum((P1(:,n).^q).*(P2(:,n).^(1-q))));
    end
    y2=y/(q-1);
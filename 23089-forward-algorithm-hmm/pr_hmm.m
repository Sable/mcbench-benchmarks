function p=pr_hmm(o,a,b,pi)
%INPUTS:
%O=Given observation sequence labellebd in numerics
%A(N,N)=transition probability matrix
%B(N,M)=Emission matrix
%pi=initial probability matrix
%Output
%P=probability of given sequence in the given model
n=length(a(1,:));
T=length(o);
%it uses forward algorith to compute the probability
for i=1:n        %it is initilization
    m(1,i)=b(i,o(1))*pi(i);
end
for t=1:(T-1)      %recurssion
    for j=1:n
        z=0;
        for i=1:n
            z=z+a(i,j)*m(t,i);
        end
        m(t+1,j)=z*b(j,o(t+1));
    end
end
p=0;
for i=1:n         %termination
    p=p+m(T,i);        
end

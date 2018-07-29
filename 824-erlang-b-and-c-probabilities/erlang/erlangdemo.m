%
%  This script demonstrates the Erlang B and Erlang C functions.
%
%
% First, a couple of easy ones.
%
disp('Consider a queueing system with lambda=10/minute, mu=4/minute,');
disp('5 servers, and no waiting line.  Find the probability that an');
disp('arriving customer will find all servers busy.');
disp('pbusy=erlangb(5,10/4)');
pbusy=erlangb(5,10/4)
disp('Next, suppose that we have an infinite waiting line. What is the');
disp('probability that an arriving customer will have to wait?');
disp('pwait=erlangc(5,10/4)');
pwait=erlangc(5,10/4)
%
% Now, a couple of hard ones.
%
disp('Consider a queueing system with lambda=900/minute, mu=1/minute,');
disp('1000 servers, and no waiting line.  Find the probability that an');
disp('arriving customer will find all servers busy.');
disp('pbusy=erlangb(1000,900)');
pbusy=erlangb(1000,900)
disp('Next, suppose that we have an infinite waiting line. What is the');
disp('probability that an arriving customer will have to wait?');
disp('pwait=erlangc(1000,900)');
pwait=erlangc(1000,900)
%
% Now, demonstrate the inverse functions.  
%
disp('Consider a queueing system with lambda=100/minute, mu=4/minute,');
disp('n servers, and no waiting line.  Find the smallest n such that');
disp('the probability of an arriving customer finding all servers busy');
disp('is less than 0.001');
disp('n=erlangbinv(0.001,100/4)');
n=erlangbinv(0.001,100/4)
disp('Next, suppose that we have an infinite waiting line. What is the');
disp('number of servers required to reduce the probability of having to');
disp('wait below 0.001 ');
disp('n=erlangcinv(0.001,100/4)');
n=erlangcinv(0.001,100/4)
%
% Demonstrate the findrho functions.
%
disp('Consider a queueing system with n=1000 servers and no waiting line.');  
disp('How much traffic can be handled while keeping the probability that');
disp('an arriving customer will be blocked below 1%?');
disp('rhob=findrhob(1000,0.01)');
rhob=findrhob(1000,0.01)
disp('Consider a queueing system with n=1000 servers and an infinite waiting');
disp('line.  How much traffic can be handled while keeping the probability');
disp('that an arriving customer will wait below 1%?');
disp('rhoc=findrhoc(1000,0.01)');
rhoc=findrhoc(1000,0.01)
%
% Finally demonstrate the engset function.
%
disp('Consider a queueing system with a population of m=200');
disp('customers, n=150 servers, and rho=0.5.  What is the');
disp('blocking probability?');
disp('E=engset(200,150,0.50)');
E=engset(200,150,0.50)


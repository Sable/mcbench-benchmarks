%MULINV(X,P) is a function that finds the multiplicative inverse of 
%vector X over finite (Galois) field of order P, i.e. if Y = MULINV(X,P)
%then (X*Y) mod P = 1 or Y = X^(-1) over field of order P.
%
%The input parameters are vector of integers X and a scalar P which 
%represents the field order. The output is a size(X) vector which 
%is the multiplicative inverses of X over P.
%
%The field order P must be a prime number and all elements of X
%should belong to the field i.e. X < P. Note: Over any field of numbers
%the multiplicative inverse of one is one and the multiplicative inverse of
%zero doesn't exist.
%
%Example:   X = [1 2 5], P = 7.
%           Y = MULINV(X,P) => Y = [1 4 3];
%
%The function doesn't check the format of input parameters.
%
%Reference:
%S. Bruce, Applied Cryptography: Protocols, Algorithms, and Source Code in
%C, 2nd edition, John Wiley and Sons, Inc., US-Canada, 1996.
%
%G. Levin, Oct. 2004
 

function y=mulinv(x,p)

if ~isprime(p)
    disp('The field order is not a prime number');
    return
elseif sum(x>=p)
    disp('All or some of the numbers do not belong to the field');
    return
elseif sum(~x)
    disp('0 does not have a multiplicative inverse');
    return
end

k=zeros(size(x));   %set the counter array
m=mod(k*p+1,x);     %find reminders
while sum(m)        %are all reminders zero?
    k=k+sign(m);    %update the counter array
    m=mod(k*p+1,x); %caculate new reminders 
end
y=(k*p+1)./x;       %find the multiplicative inverses of X
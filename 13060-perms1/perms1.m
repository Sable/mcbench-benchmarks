function p = perms1(n,b)

% PERMS1(n,b), where n is a positive integer, creates a vector with n
% columns containing one permutation of the numbers from 1 to n. Input b is
% a number between 1 and n! which is the index of the required permutation,
% such that the output of PERMS1(n,b) for b from 1 to n! is equivalent to 
% the output from perms(1:n). The order of the permutations is, however, 
% different (e.g.,PERMS1(n,5) does not give the fifth row of the PERMS(1:n) output).

% The algorithm is based on imagining that the permutations are obtained by
% using n nested loops. The counter in each inner loop skips the values of all
% outer loops to generate the required permutations. A counter (index) in the
% innermost loop would count n! permutations. Working backwards, given the value
% of an index between 1 and n! this algorithm figures out the state of the
% counter in each these imaginary loops, which are actually the required
% permutation indices.

%K. H. Hamed, 
%Sultan Qaboos University, Muscat, Oman
%khhamed@squ.edu.om
%21 November 2006

if nargin <2
    error('PERMS1:minrhs','Two Input Arguments are required.')
end;
if fix(n) ~= n || fix(b) ~= b ||n < 0 || b < 0 || ~isa(n,'double') || ~isa(b,'double') || ~isreal(n) || ~isreal(b)
  error('PERMS1:nnegint','Input Parameters n and b Must be Non-negative Integers');
end
a=factorial(n:-1:1);
if b>a;
    error('PERMS1:brange','Input Parameter b Should be between 1 and n!')
end;

p=zeros(1,n);                       %initialize output variable
idx=ones(1,n);                      %initialize loop counters
id=find(a<b,1);                     %locate the level at which the given index stands
for i=id-1:n-1                      %work down to figure out the counter states (idx) in each inner loop
    d=mod(b,a(i+1));                %how far down this loop?
    idx(i)=floor(b/a(i+1))+(d~=0);  %set counter, account for counter resetting
    b=d;
    if d==0;                        %adjust indices of inner loops if current loop is reset
        for j=i+1:n-1;
            idx(j)=n-j+1;
        end;
        break;
    end;
end;
m=1:n;                  %all possible indices
for i=1:n;
    p(i)=m(idx(i));     %set permutation index according to current counter index
    m=m(m~=p(i));       %current premutation index is no longer available
end;

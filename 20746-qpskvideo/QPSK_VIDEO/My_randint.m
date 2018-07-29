function  a = randint(m,n,a,b)
        %RANDINT  Randomly generated integral matrix.
        %         randint(m,n) returns an m-by-n such matrix with entries
        %         between 0 and 9.
        %         rand(m,n,a,b) return entries between integers  a  and  b .
        if nargin < 3, a = 0; b = 9; end
        a = floor((b-a+1)*rand(m,n)) + a;

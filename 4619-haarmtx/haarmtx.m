function H=haarmtx(n)

% HAARMTX Compute Haar orthogonal transform matrix.
%
%   H = HAARMTX(N) returns the N-by-N HAAR transform matrix.  H*A
%   is the HAAR transformation of the columns of A and H'*A is the inverse
%   transformation of the columns of A (when A is N-by-N).
%   If A is square, the two-dimensional Haar transformation of A can be computed
%   as H*A*H'. This computation is sometimes faster than using
%   DCT2, especially if you are computing large number of small
%   Haar transformation, because H needs to be determined only once.
%
%   Class Support
%   -------------
%   N is an integer scalar of class double. H is returned 
%   as a matrix of class double.
%   
%    
%   I/O Spec
%   N - input must be double
%   D - output DCT transform matrix is double
%
%   Author : Frederic Chanal (f.j.chanal@student.tue.nl) - 2004


a=1/sqrt(n);
for i=1:n
    H(1,i)=a;
end
for k=1:n-1
    p=fix(log2(k));
    q=k-2^p+1;
    t1=n/2^p;
    sup=fix(q*t1);
    mid=fix(sup-t1/2);
    inf=fix(sup-t1);
    t2=2^(p/2)*a;
    for j=1:inf
        H(k+1,j)=0;
    end
    for j=inf+1:mid
        H(k+1,j)=t2;
    end
    for j=mid+1:sup
        H(k+1,j)=-t2;
    end
    for j=sup+1:n
        H(k+1,j)=0;
    end
end

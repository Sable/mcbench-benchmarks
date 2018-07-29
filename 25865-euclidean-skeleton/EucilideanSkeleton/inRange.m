function flag=inRange(n_term, range)
%effect:    determine if the coordinate(2D) "n_term" is in the "range"
%Inputs:
%       n_term: 2*1 array representing the 2D coordinate
%       range: 2*1 array represents the range of each coordinate.
%Composed by Su Dongcai on 2009/11/13
flag=(n_term(1)>=1 & n_term(1)<=range(1) );
flag= (flag & (n_term(2)>=1 & n_term(2)<=range(2)) );
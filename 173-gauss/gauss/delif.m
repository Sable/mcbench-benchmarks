function xs=delif(x,t);
% DELIF 
% DELIF(x,t) deletes the rows of x for which t=1
% x: NxK matrix, t: Nx1 matrix of 0's and 1's
nt=repmat(1-t,1,rows(x'));
nx=x.*nt;
xs=nx(nx~=0);
col=rows(x');
xs=reshape(xs,rows(xs)/col,col);


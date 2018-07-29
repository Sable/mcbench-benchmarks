function [G1,Gd1,Wd,Wn,Juu,Jud]=randcase(ny,nu,nd)
% RANDCASE  A random case for self-optimizing control
%
%   [G,Gd,Wd,Wn,Juu,Jud] = randcase(ny,nu,nd) produces matrices of a random
%   case for self-optimizing control corresponding to the following
%   optimizing control problem:
%
%   min J(y,u,d)
%   s.t.  y = G*u + Gd*Wd*d + Wn*e
%
%   with Juu = \partial^2 J/\partial u \partial u
%        Jud = \partial^2 J/\partial u \partial d
%
%  These matrices can then be used to test the b3wc program.
%
%  See also b3wc, pb3wc, b3av, pb3av

%  By Yi Cao at Cranfield University, 9th January 2009; 23rd February 2010.
%

% Example.
%{
ny=30;
nu=15;
nd=5;
[G,Gd,Wd,Wn,Juu,Jud] = randcase(ny,nu,nd);
[B,sset,ops,ctime] = b3wc(G,Gd,Wd,Wn,Juu,Jud);
[B1,sset1,ops1,ctime1] = pb3wc(G,Gd,Wd,Wn,Juu,Jud,20);
%}
G1=randn(ny,nu);
Gd1=rand(ny,nd);
Wd=diag(rand(nd,1));
Wn=diag(rand(ny,1));
x=randn(nu,nu+2*ny+nd);
Juu=diag(sum(x.*x,2));
Jud=rand(nu,nd);

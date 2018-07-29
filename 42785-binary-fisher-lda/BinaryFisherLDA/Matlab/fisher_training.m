% Copyright (C) 2010 Quan Wang <wangq10@rpi.edu>
% Signal Analysis and Machine Perception Laboratory
% Department of Electrical, Computer, and Systems Engineering
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA

%% The training of binary Fisher's linear discriminant
%    f: n*m feature matrix, each row being a data point
%    l: n*1 binary label vector, each element being 0 or 1
%    w: projection weights
%    t: threshold, obtained by
%    fp: projected features
function [w,t,fp]=fisher_training(f,l)

%% check input
if size(l,2)~=1 || size(l,1)~=size(f,1) || sum(l~=0&l~=1)>0 || nargin~=2
    fprintf(['Incorrect input: f must be n*m, l must be n*1, '...
        'and l can only contain value 0 or 1.\n']);
    w=NaN;
    t=NaN;
    fp=NaN;
    return;
end

%% get projection weights
f0=f(l==0,:);
f1=f(l==1,:);

mu0=mean(f0);
mu1=mean(f1);
S0=cov(f0);
S1=cov(f1);

w=(S0+S1)\(mu1-mu0)';

fp=f*w;

%% get threshold
f0=fp(l==0,:);
f1=fp(l==1,:);

n0=size(f0,1);
n1=size(f1,1);

mu0=mean(f0);
mu1=mean(f1);
S0=cov(f0);
S1=cov(f1);

a=S1-S0;
b=-2*(mu0*S1-mu1*S0);
c=S1*mu0^2-S0*mu1^2-2*S0*S1*log(n0/n1);

if b^2-4*a*c<0
    fprintf('No threshold found. \n');
    t=NaN;
    return;
else
    d=sqrt(b^2-4*a*c);
    t1=(-b+d)/2/a;
    t2=(-b-d)/2/a;
    
    if (t1-mu0)^2<(t2-mu0)^2
        t=t1;
    else
        t=t2;
    end
end
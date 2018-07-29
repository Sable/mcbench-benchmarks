function lock=Knearest(y,Y,K,p)
%Syntax: lock=Knearest(y,Y,K,p)
%______________________________
%
% Locks the K nearest neighbors of a reference point that lie in a
% phase-space.
%
% lock returns the points located.
% y is the vector.
% Y is tha phase space.
% K is the number of the nearest neighbors.
% p is the norm indicator.
%
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% 45110 - Dourouti
% Ioannina
% Greece
%
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% June 15, 2001.

% Define the length of the phase space
T=size(Y,1);

for i=1:T
   dist(i)=norm(y-Y(i,:),p);
end

[dist,j]=sort(dist);
[j,f]=sort(j);
lock=f(1:K);

function lock=radnearest(y,Y,T,r,p)
%Syntax: lock=radnearest(y,Y,T,r,p)
%__________________________________
%
% Locks the nearest neighbors of a reference point that lie within a
% radius in a phase-space.
%
% lock returns the points located.
% y is the reference vector.
% Y is the phase space.
% T is the length of the phase space
% r is the radius.
% p defines the norm.
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


% Initialize j
j=0;

% For every phase-space point
for i=1:T
    % Calculate the distance from the reference point
    dist=norm(y-Y(i,:),p);
    % If it is less than r, count it
    if dist<=r
        j=j+1;
        lock(j)=i;
    end
end

if j==0
    lock=NaN;
end

function P=perimeter(r,N)
% find perimeter of the polygon

n=1:N-1;
r1=r(:,n); % current points
r2=r(:,n+1); % next points
dr=r1-r2; % difference
dr2=sum(dr.^2); % squared lenghts
drl=sqrt(dr2); % lenghts
P=sum(drl); % perimeter

% last and first:
r1=r(:,N); % current points
r2=r(:,1); % next points
dr=r1-r2; % difference
dr2=sum(dr.^2); % squared lenghts
drl=sqrt(dr2); % lenghts
P=P+drl; % perimeter
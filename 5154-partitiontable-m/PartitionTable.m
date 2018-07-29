
% PartitionTable.m by David Terr, Raytheon, 6-7-04

% Given nonnegative integer n, compute the unrestricted partition function p(k) for k<=n.
function pt = partitiontable(n)

if n==0 
    pt = 1;
    return;
end

pt = zeros( n+1, 2 );
pt( n+1, 1 ) = n;

% Precompute tables of (-1)^k and k*(3k +/- 1)/2.
s = sqrt( 24*n + 1 );
kp = floor( ( s - 1 ) / 6 );
km = floor( ( s + 1 ) / 6 );
tp = zeros( kp );
tm = zeros( km );

for k = 1:kp
    tp( k ) = k*(3*k+1)/2;
end

for k = 1:km
    tm( k ) = k*(3*k-1)/2;
end

% Compute p(m) for all m <= n.
pt( 1, 2 ) = 1;

for m=1:n
    pt(m,1) = m-1;
    s = sqrt( 24*m + 1 );
    kp = floor( ( s - 1 ) / 6 );
    km = floor( ( s + 1 ) / 6 );
    
    for k = 1:kp
        pt( m+1, 2 ) = pt( m+1, 2 ) + (-1)^(k+1) * pt( m + 1 - tp(k), 2 );
    end
    
    for k = 1:km
        pt( m+1, 2 ) = pt( m+1, 2 ) + (-1)^(k+1) * pt( m + 1 - tm(k), 2 );
    end
end
    
    

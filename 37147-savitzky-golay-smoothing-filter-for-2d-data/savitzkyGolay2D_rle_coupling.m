% function savitzkyGolay2D_rle is developed out of
% savitzkyGolay2D_rle_development.m
function vOUT = savitzkyGolay2D_rle_coupling(x,z,mIN,lengthX,lengthZ,order)
% input:
% x = int, number of pixels in the 1st direction
% z = int, number of pixels in the 2nd direction
% mIN      = numZ(row)*numX(column) matrix, 2D input matrix for smoothing 
%                    e.g. experimental data with noise
% lengthX = int, must be *odd*, the size of the window in the 1st direction
% lengthZ = int, must be *odd*, the size of the window in the 2nd direction
% order    = int, order of polynomial
% 
% output:
% vOUT     = x by z matrix, 2D smoothed data of mIN
% 
% Reference: 
% [1] Abraham Savitzky and Marcel J. E. Golay, 'Smoothing and
% differentiation of data by simplified least sqaure procedures',
% Analytical Chemistry, Vol. 36, No. 8, page 1627-1639, July 1964
%
% Author: Shao Ying HUANG (shaoying.h@gmail.com)
% Date: 9 April 2012
%% 
% z changes faster, number of z = m = row number
% x changes slowly, number of x = n = column number 
n = x;
m = z;
Nloc = lengthX*lengthZ;

% order
ord = order;
% moving window
x = -(lengthX-1)/2:1:(lengthX-1)/2;
z = -(lengthZ-1)/2:1:(lengthZ-1)/2;

coor = zeros(Nloc,2);
count = 1;
for p = 1:lengthX
    for q = 1:lengthZ
        coor(count,1) = x(p);
        coor(count,2) = z(q);
        count = count +1;
    end
end
%A = zeros(Nloc,(2*ord+1));
for nn = 1:Nloc
    count = 1;
    for nx = 0:ord
        for nz = 0:ord
            if nx+nz<=ord
                A(nn,count) = coor(nn,1)^nx*coor(nn,2)^nz;
                count = count+1;
            end
        end
    end
end

AT = A';
AT_A = AT*A;

F = eye(Nloc);    
c = zeros(Nloc,Nloc);
for nn = 1:Nloc %excitation
    CC = AT_A\(AT*F(:,nn));
    for ss = 1:Nloc % location
        c(ss,nn) = 0;
        count = 1;
        for nx = 0:ord
            for nz = 0:ord
                if nx+nz<=ord
                    c(ss,nn) = c(ss,nn) + CC(count)*coor(ss,1)^nx*coor(ss,2)^nz;
                    count = count+1;
                end
            end
        end
    end
end

hlengthX = (lengthX-1)/2;
hlengthZ = (lengthZ-1)/2;
vOUT = zeros(m,n);
% cal four corners (left-top, left-bottom, right-top, right-bottom)
% left-top
mIN_blk = mIN(1:lengthZ,1:lengthX);
count = 1;
for q = 1:lengthX
    for p = 1:lengthZ
        map = reshape(c(count,:),lengthZ,lengthX);
        weightedM= map.*mIN_blk;
        vOUT(p,q) = sum(sum(weightedM));
        count = count +1;
    end
end
% left-bottom
mIN_blk = mIN((m-lengthZ+1):m,1:lengthX);
count = 1;
for q = 1:lengthX
    for p = (m-lengthZ+1):m
        map = reshape(c(count,:),lengthZ,lengthX);
        weightedM= map.*mIN_blk;
        vOUT(p,q) = sum(sum(weightedM));
        count = count +1;
    end
end
% right-top
mIN_blk = mIN(1:lengthZ,(n-lengthX+1):n);
count = 1;
for q = (n-lengthX+1):n
    for p = 1:lengthZ
        map = reshape(c(count,:),lengthZ,lengthX);
        weightedM= map.*mIN_blk;
        vOUT(p,q) = sum(sum(weightedM));
        count = count +1;
    end
end
% right-bottom
mIN_blk = mIN((m-lengthZ+1):m,(n-lengthX+1):n);
count = 1;
for q = (n-lengthX+1):n
    for p = (m-lengthZ+1):m
        map = reshape(c(count,:),lengthZ,lengthX);
        weightedM= map.*mIN_blk;
        vOUT(p,q) = sum(sum(weightedM));
        count = count +1;
    end
end
%% cells at the edges
% left row
for pp = 2:(m-2*lengthZ+1)
    qq = 1;
    mIN_blk = mIN(pp:(pp+lengthZ-1),qq:qq+lengthX-1);
        
    for jj = 1:hlengthX
        map = reshape(c(lengthZ*jj,:),lengthZ,lengthX);
        weightedM= map.*mIN_blk;
        vOUT(pp+lengthZ-1,jj) = sum(sum(weightedM));
    end
end
% right row
for pp = 2:(m-2*lengthZ+1)
    qq = n-lengthX+1;
    mIN_blk = mIN(pp:(pp+lengthZ-1),qq:n);
        
    for jj = 1:hlengthX
        map = reshape(c((lengthZ*(hlengthX+1+jj)),:),lengthZ,lengthX);
        weightedM= map.*mIN_blk;
        vOUT(pp+lengthZ-1,n-hlengthX+jj) = sum(sum(weightedM));
    end
end
% top row
pp = 1;
for qq = 2:(n-2*lengthX+1);
    mIN_blk = mIN(pp:pp+lengthZ-1,qq:(qq+lengthX-1));
        
    for jj = 1:hlengthZ
        map = reshape(c(lengthZ*(lengthX-1)+jj,:),lengthZ,lengthX);
        weightedM= map.*mIN_blk;
        vOUT(jj,(qq+lengthX-1)) = sum(sum(weightedM));
    end
end
% bottom row
pp = m-lengthZ+1;
for qq = 2:(n-2*lengthX+1);
    mIN_blk = mIN(pp:pp+lengthZ-1,qq:qq+lengthX-1);
    
    jjc = hlengthZ -1;
    for jj = 1:hlengthZ 
        map = reshape(c(lengthZ*lengthX-jjc,:),lengthZ,lengthX);
        weightedM= map.*mIN_blk;
        vOUT((pp+lengthZ-1-jjc),qq+lengthX-1) = sum(sum(weightedM));
        jjc = jjc -1;
    end
end
% center block
center = lengthZ*(lengthX-1)/2+(lengthZ-1)/2+1;
mapCenter = reshape(c(center,:),lengthZ,lengthX);
for pp = 1:m-lengthZ+1
    for qq = 1:n-lengthX+1
        mIN_blk = mIN(pp:pp+lengthZ-1,qq:qq+lengthX-1);
        
        weightedM= mapCenter.*mIN_blk;
        vOUT(pp+hlengthZ,qq+hlengthX) = sum(sum(weightedM));
    end
end

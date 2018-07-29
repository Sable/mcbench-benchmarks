%Image Registration - 3D Rigid body Transformation 
%Jeny Rajan, Chandrashekar P.S
%This program is for rigid body transformation of 3D objects.
%Input variables 
%k1 - Input array (X*Y*Z)
%thx,thy,thz - rotation angle theta (in degrees) along x, y and z axis respectively.
%tx,ty,tz - translation along x, y and z.
function N=rigid3D(k1,thx,thy,thz,tx,ty,tz);
k1=double(k1);
[x y z]=size(k1);
xc=x/2;
yc=y/2;
zc=z/2;
thz=-(thz*3.14/180);
thx=-(thx*3.14/180);
thy=-(thy*3.14/180);
N=zeros(x,y,z);
Rz=[cos(thz) -sin(thz) 0 0;
   sin(thz) cos(thz) 0 0;
   0 0 1 0;
   0 0 0 1;];

Rx=[1 0 0 0;
    0 cos(thx) -sin(thx) 0;
    0 sin(thx) cos(thx) 0;
    0 0 0 1;];

Ry=[cos(thy) 0 sin(thy) 0;
    0 1 0 0;
    -sin(thy) 0 cos(thy) 0;
    0 0 0 1;];
R=Rx*Ry*Rz;
T=[tx,ty,tz];
for k=1:z
   for i=1:x
        for j=1:y
            ii=(R(1,1)*(i-xc))+(R(1,2)*(j-yc))+(R(1,3)*(k-zc))+xc-T(1);
            jj=(R(2,1)*(i-xc))+(R(2,2)*(j-yc))+(R(2,3)*(k-zc))+yc-T(2);
            kk=(R(3,1)*(i-xc))+(R(3,2)*(j-yc))+(R(3,3)*(k-zc))+zc-T(3);
            ii=round(ii);
            jj=round(jj);
            kk=round(kk);
            if ii>0 &jj>0 & kk>0 & ii<=x &jj<=y &kk<=z
                N(i,j,k)=k1(ii,jj,kk); 
            end
        end
    end
end
    

    
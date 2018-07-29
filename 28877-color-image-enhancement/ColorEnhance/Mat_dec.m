
%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/

function q5=mat_dec(data1,blkx)
[m,n]=size(data1);
r3=m/blkx;c3=n/blkx;q4=0;q1=0;
for i=1:r3
   for j=1:c3
      for s=1:blkx
         for k=1:blkx
            p3=s+q4;
            q2=k+q1;
            q5(s,k,i,j)=data1(p3,q2);
         end
      end   
      q1=q1+blkx;   
   end
   q4=q4+blkx;q1=0;
end


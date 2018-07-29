
%This program decomposes an image into blocks.

%Parameters
% inImg         -   Input Gray Image
% blkSize       -   Window size for block processing
% out           -   Output 4 dimensional matrix with blocks.
%
%Author : Athi Narayanan S
%Student, M.E, EST,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%s_athi1983@yahoo.co.in
%http://sites.google.com/site/athisnarayanan/

function out = MatDec(inImg, blkSize)

[m,n]=size(inImg);

r3=m/blkSize;
c3=n/blkSize;
q4=0;
q1=0;

for i=1:r3
    for j=1:c3
        for s=1:blkSize
            for k=1:blkSize
                p3=s+q4;
                q2=k+q1;
                out(s,k,i,j)=inImg(p3,q2);
            end
        end
        q1=q1+blkSize;
    end
    q4=q4+blkSize;q1=0;
end

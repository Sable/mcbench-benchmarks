function rechi=sskkrebook(omega,imchi,omega1,rechi1)
%The program inputs are the vector of the frequency
%(or energy) components, the vector of the imaginary
% part of the susceptibility
%under examination, anchor point, the value of the
%real part at the anchor point.
%The two vectors must have the same length 
%and the frequency vector omega must be equispaced. 
%If not, apply MATLAB functions such as interp.
%Note that the anchor point must be situated in one of the values
%of the vector omega.
%This function uses the function kkrebook2 
%The output is the estimate of the
%imaginary part as obtained by using SSKK relations.
%This software is distributed under the GNU licence agreement
%by Valerio Lucarini
%email: lucarini@alum.mit.edu
%University of Camerino
%Department of Mathematics and Computer Science
%Camerino, Italy

if size(omega,1)>size(omega,2);
omega=omega';
end; if size(imchi,1)>size(imchi,2);
imchi=imchi';
end;
%Here the program rearranges the two vectors so that,
%whichever their initial shape, they become row vectors.
g=size(omega,2);
%Size of the vectors.%
k=0; 
for j=1:g;
if omega(j)==omega1;
k=j;
end;
end;
%Determination of the anchor point.
rechi=kkrebook2(omega,imchi,0);
%Application of K-K relations
rechi=rechi+(rechi1-rechi(k));
%The subtracted relation upgrades the estimate obtained
%with K-K relations.
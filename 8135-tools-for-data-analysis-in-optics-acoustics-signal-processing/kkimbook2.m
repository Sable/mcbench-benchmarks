function imchi=kkimbook2(omega,rechi,alpha)
%The program inputs are the vector of the frequency (or energy)
%components, the vector of the real part of the susceptibility
%under examination, and the value of the moment considered.
%The two vectors must have the same length 
%and the frequency vector omega must be equispaced. 
%If not, apply MATLAB functions such as interp.
%If rechi is the real part of a linear susceptibility, 
%alpha must be 0. 
%If rechi is the real part of the nth 
%harmonic generation susceptibility, alpha=0,1,..2n. 
%If rechi is the real part of a pump and probe
%susceptibility, alpha=0 or 1.
%This files accompanies the book 
%"Kramers-Kronig Relations in Optical Materials Research"
%by Lucarini, V., Saarinen, J.J., Peiponen, K.-E., Vartiainen, E.M. 
%Springer, Heidelberg, 2005
%where the theory and applications are fully developed.
%The output is the estimate of the imaginary part as obtained
%with K-K relations.
%This software is distributed under the GNU licence agreement
%by Valerio Lucarini
%email: lucarini@alum.mit.edu
%University of Camerino
%Department of Mathematics and Computer Science
%Camerino, Italy

if size(omega,1)>size(omega,2);
omega=omega';
end; if size(rechi,1)>size(rechi,2);
rechi=rechi';
end;
%Here the program rearranges the two vectors so that,
%whichever their initial shape, they become row vectors.

g=size(omega,2);
%Size of the vectors.%

imchi=zeros(size(rechi));
%The output is initialized.

a=zeros(size(rechi));
b=zeros(size(rechi));
%Two vectors for intermediate calculations are initialized

deltaomega=omega(2)-omega(1);
%Here we compute the frequency (or energy) interval

j=1;
beta1=0;
for k=2:g;
b(1)=beta1+rechi(k)*omega(k)^(2*alpha)/(omega(k)^2-omega(1)^2);
beta1=b(1);
end;
imchi(1)=-2/pi*deltaomega*b(1)*omega(1)^(1-2*alpha);
%First element of the output: the principal part integration
%is computed by excluding the first element of the input

j=g;
alpha1=0;
for k=1:g-1;
a(g)=alpha1+rechi(k)*omega(k)^(2*alpha)/(omega(k)^2-omega(g)^2);
alpha1=a(g);
end;
imchi(g)=-2/pi*deltaomega*a(g)*omega(g)^(1-2*alpha);
%Last element of the output: the principal part integration
%is computed by excluding the last element of the input.

for j=2:g-1; ;
%Loop on the inner components of the output vector.
alpha1=0;
beta1=0;
for k=1:j-1;
a(j)=alpha1+rechi(k)*omega(k)^(2*alpha)/(omega(k)^2-omega(j)^2);
alpha1=a(j);
end;
for k=j+1:g;
b(j)=beta1+rechi(k)*omega(k)^(2*alpha)/(omega(k)^2-omega(j)^2);
beta1=b(j);
end;
imchi(j)=-2/pi*deltaomega*(a(j)+b(j))*omega(j)^(1-2*alpha);
%Last element of the output: the principal part integration
%is computed by excluding the last element of the input
end;
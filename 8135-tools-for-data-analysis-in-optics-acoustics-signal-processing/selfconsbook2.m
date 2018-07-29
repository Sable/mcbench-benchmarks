function [refin,imfin]=selfconscam(omega,rechi,imchi,iter,w)
%This program provide a self-consistent estimate of the real 
%and imaginary part of a general susceptibility
%when they are both experimentally observed.
%Self-consistency is checked with KK relations
%The program inputs are the vector of the frequency
%(or energy) components, the vector of the real and imaginary
%parts of the susceptibility under examination, the number of
%iterations and the weight given to the observed data. 
%The three vectors must have the same length 
%and the frequency vector omega must be equispaced. 
%If not, apply MATLAB functions such as interp.
%w must be between 0 and 1 and determines how relatively confident 
%you feel with your experimental data. In general, 0.5 is a good choice 
%This files accompanies the book 
%"Kramers-Kronig Relations in Optical Materials Research"
%by Lucarini, V., Saarinen, J.J., Peiponen, K.-E., Vartiainen, E.M. 
%Springer, Heidelberg, 2005
%where the theory and applications are fully developed.
%The output is the self-consistent estimate of the real and imaginary 
%part as obtained with K-K relations.
%This program uses the functions kkrebook2 and kkimbook2.
%This software is distributed under the GNU licence agreement
%by Valerio Lucarini
%email: lucarini@alum.mit.edu
%University of Camerino
%Department of Mathematics and Computer Science
%Camerino, Italy


if size(omega,1)>size(omega,2);
    omega=omega';
end;
if size(rechi,1)>size(rechi,2);
    rechi=rechi';
end;
if size(imchi,1)>size(imchi,2);
    imchi=imchi';
end;

comodo1=rechi;
comodo2=imchi;

for j=1:iter;
    comodo1=kkrebook2(omega,comodo2,0);
    comodo1=w*rechi+(1-w)*comodo1;
    comodo2=kkimbook2(omega,comodo1,0);
    comodo2=w*imchi+(1-w)*comodo2;
end;

refin=comodo1;
imfin=comodo2;

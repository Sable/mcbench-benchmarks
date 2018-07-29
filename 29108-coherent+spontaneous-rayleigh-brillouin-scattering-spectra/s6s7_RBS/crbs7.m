function [cohsig,sptsig,c] = crbs7(y,rlx_int,eukenf,c_int,c_tr,xi)
% Written by John Smith
% October 21st, 2010
% University of Colorado at Boulder, CIRES
% John.A.Smith@Colorado.EDU
% MATLAB version 7.10.0.59 (R2010a) 64-bit
% Adapted from "Coherent Rayleigh-Brillouin Scattering"
% by Xingguo Pan

% Computes the coherent and spontaneous
% RBS spectrum given the parameters
% in crbs_molecular using the s7 model
% by X. Pan, 2002

% Called by: crbs_molecular.m

n_xi=numel(xi);

n=7;
a=zeros(n,n);
b=zeros(n,2);

cohsig=zeros(1,n_xi);
sptsig=zeros(1,n_xi);

cpxunit=sqrt(-1);

y7=1.5*y;
gamma_int=c_int/(c_tr+c_int);
j020=-y;
j030=1.5*j020;
j100=-gamma_int*y/rlx_int;
j001=j100*c_tr/c_int;
j100001=j100*sqrt(c_tr/c_int);
j110=j100*5/6+j020*2/3;
j011110=j100*sqrt(5/(8*c_int));
j_nu=0.4*(1.5+c_int)+(3+c_int)/(2*rlx_int)+9*eukenf/(16*rlx_int^2);
j_de=-1+(4/15)*eukenf*(1.5+c_int)+(c_int/3)*eukenf/rlx_int;
j_co=-y*(2*gamma_int/3);
j011=j_co*j_nu/j_de;

for i=1:n_xi
    z=xi(i)+y7*cpxunit;
	w0=w0_func(z);
	w1=-sqrt(pi)+z*w0;
	w2=z*w1;
	w3=-0.5*sqrt(pi)+z*w2;
	w4=z*w3;
	w5=-3*sqrt(pi)/4+z*w4;
	w6=z*w5;
    
    i0000=w0/(sqrt(pi));
	i0100=w1*sqrt(2/pi);
	i0001=i0100;
	i0010=(2*w2-w0)/(sqrt(6*pi));
	i1000=i0010;
	i0011=(2*w3-3*w1)/(sqrt(5*pi));
	i1100=i0011;
	i0101=2*w2/sqrt(pi);
	i0110=(-w1+2*w3)/sqrt(3*pi);
	i1001=i0110;
	i0111=(-3*w2+2*w4)*sqrt(2/(5*pi));
	i1101=i0111;
	i1111=(13*w2-12*w4+4*w6)/(5*sqrt(pi));
	i0002=(-w0+2*w2)/sqrt(3*pi);
	i0200=i0002;
	i0211=(-w1+8*w3-4*w5)/sqrt(15*pi);
	i1102=i0211;
	i0202=2*(w0-2*w2+2*w4)/(3*sqrt(pi));
	i0210=(w0+4*w2-4*w4)/(3*sqrt(2*pi));
	i1002=i0210;
	i0102=(-w1+2*w3)*sqrt(2/(3*pi));
	i0201=i0102;
	i1010=(5*w0-4*w2+4*w4)/(6*sqrt(pi));
	i1110=(7*w1-8*w3+4*w5)/sqrt(30*pi);
	i1011=i1110;
    
    a(:,1)=-j030*[i0000 i0001 i0011 i0002 i0010 0 0]+[cpxunit 0 0 0 0 0 0];
    a(:,2)=-j030*[i0100 i0101 i0111 i0102 i0110 0 0]+[0 cpxunit 0 0 0 0 0];
    a(:,3)=(j030-j110)*[i1100 i1101 i1111 i1102 i1110 0 0]+j011110*[0 0 0 0 0 -i0100 -i0101]+[0 0 -cpxunit 0 0 0 0];
    a(:,4)=(j020-j030)*[i0200 i0201 i0211 i0202 i0210 0 0]+[0 0 0 3/2*cpxunit 0 0 0];
    a(:,5)=(j030-j100)*[i1000 i1001 i1011 i1002 i1010 0 0]+j100001*[0 0 0 0 0 -i0000 -i0001]+[0 0 0 0 -cpxunit 0 0];
    a(:,6)=j100001*[i1000 i1001 i1011 i1002 i1010 0 0]+(j001-j030)*[0 0 0 0 0 i0000 i0001]+[0 0 0 0 0 cpxunit 0];
    a(:,7)=j011110*[i1100 i1101 i1111 i1102 i1110 0 0]+(j011-j030)*[0 0 0 0 0 i0100 i0101]+[0 0 0 0 0 0 cpxunit];
    
    b(:,1)=-[i0100 i0101 i0111 i0102 i0110 0 0];
    b(:,2)=-[i0000 i0001 i0011 i0002 i0010 0 0];
    
    c=linsolve(a,b);
    
    cohsig(i)=c(1,1)*conj(c(1,1));
    sptsig(i)=2*real(c(1,2));
end
end
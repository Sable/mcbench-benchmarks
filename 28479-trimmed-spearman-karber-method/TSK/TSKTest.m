%TSKTest
%Test cases for the Trimmed Spearman-Karber method, as per Hamilton and EPA.
%Written by Brenton R. Stone, last revised May 18 2010
function TSKTest()
%Hamilton's test cases.
%Table I
x1=[15.54,20.47,27.92,35.98,55.52];
n1=[20,20,20,19,20];
p1a=[0,0,0,5.26,100]/100.*n1;
p1b=[0,5,0,5.26,100]/100.*n1;
p1c=[0,5,0,15.79,100]/100.*n1;
p1d=[0,5,5,94.74,100]/100.*n1;
p1e=[0,5,5,100,100]/100.*n1;

%Table V
x4=[7.8,13,22,36,60,100];
n4=10;
p4a=[0,0,10,100,100,100]/100.*n4;
p4b=[0,0,70,100,100,100]/100.*n4;
p4c=[0,0,10,40,100,100]/100.*n4;
p4d=[0,0,20,70,100,100]/100.*n4;
p4e=[0,0,20,30,100,100]/100.*n4;


fprintf('Spearman-Karber, pct\n')
fprintf('\t\t0 \t5 \t10 \t20\n')
fprintf('1A\t')
Trims(x1,p1a,n1)
fprintf('\n1B\t')
Trims(x1,p1b,n1)
fprintf('\n1C\t')
Trims(x1,p1c,n1)
fprintf('\n1D\t')
Trims(x1,p1d,n1)
fprintf('\n1E\t')
Trims(x1,p1e,n1)

fprintf('\n4A\t')
Trims(x4,p4a,n4)
fprintf('\n4B\t')
Trims(x4,p4b,n4)
fprintf('\n4C\t')
Trims(x4,p4c,n4)
fprintf('\n4D\t')
Trims(x4,p4d,n4)
fprintf('\n4E\t')
Trims(x4,p4e,n4)

%From the documentation to the EPA's program for doing the TSK Method. See
%http://www.epa.gov/eerd/stat2.htm
fprintf('\nEPA:\t mu\t down\t up\n')
[mu,gsd,left,right]=TSK([0,6.25,12.5,25,50,100],[0,0,1,0,0,16],20,0.2,erf(2/sqrt(2)));
fprintf('\t%4.2f\t%4.2f\t%4.2f\n',mu,left,right);
end

function Trims(x,p,n)
  conf=erf(2/sqrt(2));

[mu0,gsd,low0,up0]=TSK(x,p,n,0,conf);
[mu5,gsd,low5,up5]=TSK(x,p,n,0.05,conf);
[mu1,gsd,low1,up1]=TSK(x,p,n,0.1,conf);
[mu2,gsd,low2,up2]=TSK(x,p,n,0.2,conf);

fprintf('mid:\t%4.2f \t%4.2f \t%4.2f \t%4.2f\n',mu0,mu5,mu1,mu2)
fprintf('\tlow:\t%4.2f \t%4.2f \t%4.2f \t%4.2f\n',low0,low5,low1,low2)
fprintf('\thigh:\t%4.2f \t%4.2f \t%4.2f \t%4.2f\n',up0,up5,up1,up2)
end
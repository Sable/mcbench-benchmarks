function delta_coeff = mfcc2delta(CepCoeff,d)
% delta_coeff = mfcc2delta(CepCoeff,d);
% Input:->  CepCoeff: Cepstral Coefficient (Row Represents a feature vector
%                                          for a frame)
%           d       : Lag size for delta feature computation 
% Output:-> delta_coeff: Output delta coefficient 
%Main Code->
[NoOfFrame NoOfCoeff]=size(CepCoeff); %Note the size of input data
%The next portion is same as voicebox code for delta computatation.
%Reference of Original Source:
%http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
%melcept.m
vf=(d:-1:-d);
vf=vf/sum(vf.^2);
ww=ones(d,1);
cx=[CepCoeff(ww,:); CepCoeff; CepCoeff(NoOfFrame*ww,:)];
vx=reshape(filter(vf,1,cx(:)),NoOfFrame+2*d,NoOfCoeff);
vx(1:2*d,:)=[];
delta_coeff=vx;
%--------------------END OF CODE-------------------------------------------
function y =fbtrim(NoisyData,Param)

%   Author(s): Farhad Bayat, 
%   Email: fbayat@ee.iust.ac.ir
%   Copyright 2000-2008 

% Note:
%   In some applications it is necessary to differentiate a signal such as 
%   position to obtain velocity signal. But always derivation makes noise 
%   in output signal and using common filters yeld delay in output signal. 
%   The "fbtrim.m" provides a heuristic soulotion for this problem. It
%   contains several tunning parameters you can adjust to get suitable response.
%   NoisyData: is the Data to be trim.

%   fbtrim(NoisyData,Param) or  fbtrim(NoisyData)
%   Param:  contain the trimming preferences described in the folowing:
%   Param= [NPF,CF,MSV,LCF,Nd]; 
%   Leave param for default values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%   Filter Parameters:
% 
% NPF=0.5;        % Noise Power Factor
% CF=0.6;         % Correction Factor
% MSV=0.01;       % minnimum data value
% LCF=5;          % Level Change factor
% DF=5 ;          % Delay Factor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Filter parameters' default values: 
NPF=0.5;        % Noise Power Factor
CF=0.6;         % Correction Factor
MSV=0.01;       % minnimum data value
LCF=5;          % Level Change factor
DF=5 ;          % Delay Factor

if nargin==2
    NPF=Param(1);
    CF=Param(2);
    MSV==Param(3);
    LCF==Param(4);
    DF==Param(5);
end

flag=0;
dv=5*MSV;

Trimed(1)=NoisyData(1);
Dyn_1=0;

for i=2:length(NoisyData)
    Dyn=(NoisyData(i)-Trimed(i-1));
    if abs(Dyn)>DF*abs(Dyn_1)
       flag=(flag+sign(Dyn))*(1+sign(Dyn*Dyn_1))/2;
    end
    if abs(Dyn)>(1+NPF)*abs(Dyn_1)
        if flag>=LCF || flag<=-LCF
            flag=0;
            Trimed(i)=NoisyData(i);
        elseif abs(Dyn_1)<MSV
            Trimed(i)=Trimed(i-1)+sign(Dyn)*dv;
        else
            Trimed(i)=Trimed(i-1)+CF*sign(Dyn)*abs(Dyn_1);
        end
    else
        Trimed(i)= NoisyData(i);
    end
    Dyn_1=(Trimed(i)-Trimed(i-1));
end

y=Trimed;
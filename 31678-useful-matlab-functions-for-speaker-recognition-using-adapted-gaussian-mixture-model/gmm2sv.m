function SV=gmm2sv(mix)
%--------------------------------------------------------------------------
%Usage: SuperVECTOR=gmm2sv(mix);
%       input : mix: GMM structure of Netlab
%       output: SuperVECTOR: GMM Supervector
% 
% This program concatenates means of GMM to form SuperVector.
% Written by Md. Sahidullah (Graduate Student, IIT Kharagpur)
% Use this code works with Netlab toolbox
% http://www1.aston.ac.uk/eas/research/groups/ncrg/resources/netlab/
% If you have any query or suggestion please mail me sahidullahmd@gmail.com
temp=mix.centres';
SV=temp(:);
%--------------END OF CODE-------------------------------------------------
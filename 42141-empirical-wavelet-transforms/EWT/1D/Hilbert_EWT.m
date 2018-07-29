function Hilbert_EWT(ewt,t,f,sub,color)

%==================================================================
% function Hilbert_EWT(ewt,t,f,sub,color)
%
% This function display the time-frequency plane by applying
% the Hilbert transform on each EWT component.
%
% TO RUN THIS FUNCTION, YOU MUST HAVE FLANDRIN'S EMD TOOLBOX
%
% Inputs:
%   - ewt: output of the EWT transform
%   - t: the time vector corresponding to your input signal
%   - f: the input signal
%   - sub: permits to restrict the time-frequency plane to 
%          frequencies from [0;pi/sub]. This value must be 
%          >=1 (1 meaning the function display the entire TF-plane
%   - color: display the TF plane in grayscale if this parameter is
%            set to 0, otherwise the display is in color (useful to
%            generate figures for your papers!)
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%==================================================================

M=length(ewt);
ewtM=zeros(M,length(ewt{1}));
for i=1:M
   b=ewt{i};
   ewtM(i,:)=b';
end

if sub<1
    sub=1;
end

[Ae,fe,tte]=hhspectrum(ewtM);
[ime,tte,ffe]=toimage(Ae,fe);

disp_hhs2(ime,t,[],0,sub,color);
if color == 0
    subplot(6,1,1);plot(t,f,'black');
else
    subplot(6,1,1);plot(t,f);
end
axis tight
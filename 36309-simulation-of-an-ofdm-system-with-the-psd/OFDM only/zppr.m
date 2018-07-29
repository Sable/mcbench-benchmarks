%% Remove Zero Padding Function
% Input data is the sequence s, Number of zeros z
% output:
% signal :signal without zero padding 
% signal = zppr(s, z)
% 22/04/2011
function signal=zppr(s, z)
L=length(s)-z;
sgl=zeros(L,1);
sgl(1:L/2)=s(1:L/2);
sgl(end-L/2+1:end)=s(end-L/2+1:end);
signal=sgl;




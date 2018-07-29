function [ signal ] = msk_mod( bit_stream,frequency,Tb,Eb )
% %UNTITLED Summary of this function goes here
% %   Detailed explanation goes here

% clc;
% clear all;
% close all;
% 
% % bitstream to be tx
% bit_stream=[1 0 0 1 0 0 1 1];
% 
f=frequency;
% 
% % carrier frequency
% f=30;
% 
% % bit energy
% 
% Eb=1;
% % 
% % bit period
% Tb=0.001;


%time
t=0.001 : .001 : 1;

% time for p(t)

% t2=0.01:.01:(2*Tb);

nn=length(bit_stream);


amp=sqrt(2*Eb);




% make the data stream length even
if (mod(nn,2)~=0)
    bit_stream(1,nn+1)=0;
    nn=nn+1;
end

% length of bit stream
N=length(bit_stream);

m_i=zeros(1,N/2);% Even bit stream 
m_q=zeros(1,N/2);% Odd bit stream




a=1;
% Generate the odd and even stream from the input bit stream
% in bipolar nrz form
for i=1:1:N/2
    if (bit_stream(1,a)==0)
        m_i(1,i)=-1;
    else
        m_i(1,i)=1;
    end
    a=a+1;
      if (bit_stream(1,a)==0)
        m_q(1,i)=-1;
    else
        m_q(1,i)=1;
    end
    a=a+1;
end

Smsk=zeros(N/2,1000);

% for loop=1:N/2
%     if (m_i(1,loop)==1)
%         fi_k=0;
%     else
%         fi_k=pi;
%     end
%     
%     Smsk(loop,:)=amp*cos(2*pi*f*t-(m_i(1,loop)*m_q(1,loop)*pi*(t/(2*Tb)))+fi_k);
% end
% 
% signal=column_to_row(Smsk);

% 
for loop =1:N/2
    Smsk(loop,:)=(amp*(m_i(1,loop)*sin(2*pi*t/(4*Tb))).*cos(2*pi*f*t)) + (amp*(m_q(1,loop)*cos(2*pi*(t/(4*Tb)))).*sin(2*pi*f*t));
end
signal=column_to_row(Smsk);

end









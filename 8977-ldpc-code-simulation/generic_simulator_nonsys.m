% general script for non-systematic LDPC simulation

% Things to Remember - Steps to follow ALWAYS !!!!!!!!
% 0. This file is good for non-systematic H only (errors calculated for all n) 
% 1. Load H
% 2. Define SNR Range
% 3. Set Maximum number of iterations
% 4. Set Maximum number of codeword-errors for which to run simulation
% 5. Select decoder - Matlab or C-based



clear all
close all
clc
tic

%get H from somewhere , change R accordingly !!
load 128x256regular.mat H
% load 128x256regular_v6.mat  %for users of Matlab 6.5



ind=find(H==1);
[r,c]=ind2sub(size(H),ind);
[rows,cols]=size(H);
h=sparse(H);                         % for use with Matlab-based LDPC Decoder
n=cols;
k=n-rows;


% Find 
% 1: maximum check degree
% 2: column indeces in each row which contain '1'
% 3: maximum variable degree
% 4: find column indeces in each row which contain '1'
[max_check_degree,check_node_ones,BIGVALUE_COLS,max_variable_degree,variable_node_ones,BIGVALUE_ROWS]=one_finder(H);



rand('seed',584);
randn('seed',843);

dB=[0:3];                           % range of SNR values in dB
SNRpbit=10.^(dB/10);                % Eb/No conversion from dB to decimal
No_uncoded=1./SNRpbit;              % since Eb=1
R=k/n;                              % code rate 
No=No_uncoded./R;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_iter=10;                   %maximum number of decoder iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maximum_blockerror=30;          % maximum blockerrors per SNR point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

blockerrors=0;
biterrors=0;
block=0;
FER=zeros(1,length(dB));        % array for Frame Error Rate
BER=zeros(1,length(dB));        % array for Channel Error Rate
block_array=zeros(1,length(dB));

for z=1:length(SNRpbit), % loop for testing over range of SNR values

    biterrors=0;
    blockerrors=0;
    block=0;

    while(blockerrors<maximum_blockerror)  %while loop

        %%%%%%%%%%%%%%% u is the codeword to be transmitted %%%%%%%%%%%%%%%%%%%
        u=zeros(1,cols);  %%all zero codeword
        tx_waveform=bpsk(u);

        sigma=sqrt(No(z)/2);
        rx_waveform=tx_waveform + sigma*randn(1,length(tx_waveform));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%% Use C - based LDPC Decoder %%%%%%%%%%%%%%
        %%% Fastest C-based LDPC Decoder  %%%%
       
        
        gamma_n=(4/No(z))*rx_waveform;
        vhat=decode_ldpc_new(max_iter,gamma_n,check_node_ones,max_check_degree,BIGVALUE_COLS-1,variable_node_ones,max_variable_degree,BIGVALUE_ROWS-1,rows,cols);
        uhat=vhat;


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Slightly slower C-based LDPC Decoder  %%%%
        
%         gamma_n=(4/No(z))*rx_waveform;
%         sg=zeros(rows,cols);
%         sg(ind)=gamma_n(c);
%            
%         [vhat,iteration]=decode_ldpc(No(z),H,max_iter,sg,gamma_n);
%         uhat=vhat;
%         
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%% Use Matlab-based LDPC Decoder %%%%%%%%%%%%%%
%         
%         [vhat,iteration]=decode_ldpc_matlab(rx_waveform,No(z),h,rows,cols,ind,r,c,max_iter);
%         uhat=vhat;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        Errors=zeros(1,length(vhat));
        Errors(find(u~=vhat))=1;
      
        if sum(Errors)~=0
            blockerrors=blockerrors+1;
            
            if rem(blockerrors,5)==0; %save statistics after every 5 blockerrors
                
                ber=biterrors/(block*n);
                fer=blockerrors/block;
                
                s=sprintf('%dx%d_regular_results.txt',n-k,n);
                fid = fopen(s,'a');
                fprintf(fid,'\n');
                fprintf(fid,'%s %2.1EdB\n','SNR =',dB(z));
                fprintf(fid,'%s %6.3E\n','BER =',ber);
                fprintf(fid,'%s %6.3E\n','FER =',fer);
                fprintf(fid,'%s %d\n','blocks =',block);
                fprintf(fid,'%s %d\n','blockerrors =',blockerrors);
                fprintf(fid,'%s %d\n','biterrors =',biterrors);
                fclose(fid);
            end
            
            
        end
        
        biterrors=biterrors+sum(Errors);
        block=block+1;

    end     %while loop

    block_array(z)=block; %counting blocks per SNR point
    BER(z)=biterrors/(block*n);
    FER(z)=blockerrors/block;
    fprintf(1,'\n\n Simulation finished for SNR: %d \n',dB(z))
    
%     save results.mat dB BER FER block_array
    
end      % loop for testing over range of SNR values



semilogy(dB,BER,'b-o')
title('Bit Error Rate')
ylabel('BER')
xlabel('Eb/No (dB)')
grid
figure
semilogy(dB,FER,'b-o')
title('Frame Error Rate')
ylabel('FER')
xlabel('Eb/No (dB)')
grid



toc


%   Copyright (c) 2005 by Shaikh Faisal Zaheer, faisal.zaheer@gmail.com
%   $Revision: 3.0 $  $Date: 26/12/2005 $


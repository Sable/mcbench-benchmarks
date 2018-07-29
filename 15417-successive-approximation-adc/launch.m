%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Launch code for static input (sample)               %
%      code by Fabrizio Conso, university of pavia, student        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                launch code example                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                                                       %
 format short;
 f_s=1;            % normalized sampling frequency
 f_bw=5;                    % DAC's bandwidth
 sr=2;                      % DAC's slew-rate
 nbit=12;                   % converter bits
 input=0.7;                 % sample value
 
 [counter,tresholds]  =Approx(input,nbit,f_bw,sr,f_s)
 [counter2,tresholds2]=Approx_2(input,nbit,f_bw,sr,f_s)
 bitstream=dec2bin(counter)
 bitstream2=dec2bin(counter2)
%                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
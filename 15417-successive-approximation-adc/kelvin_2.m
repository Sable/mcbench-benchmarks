%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               successive approximation converter                 %
%            with finite DAC's slew-rate and bandwidth.            %
%           Case of binary weighted resistive array DAC            %
%       code by Fabrizio Conso, university of pavia, student       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function counter=kelvin_2(input,nbit,f_bw,sr,f_s,v)
% input = input sample
% nbit  = bits of the converter
% f_bw  = DAC bandwidth [f_s]
% sr    = DAC slew-rate [V_fs/T_s]
% f_s   = normalized sampling frequency
% v     = thresholds array

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                global variables                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                 %
 threshold_id=v(12);   %initializing ideal threshold to 0.5
 counter=0;
 in=input;
 threshold(1)=0.5;
 tau=1/(2*pi*f_bw);
 Tmax=1/(f_s*nbit);
%                                                 % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k=1:nbit
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            skip of last subtraction             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                 %    
    if k==12
       if (in-threshold_id) > 0
           bit=1;
       else
           bit=0;
       end
%                                                 %        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  finite  bandwidth & slew-rate                   %   
%                       error calculation                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
   else
   deltaV=abs(threshold_id-threshold(k));
   slope=deltaV/tau;
   if slope > sr
        tslew=(deltaV/sr) - tau;
            if tslew >= Tmax              % only slewing
                error = deltaV - sr*Tmax;
            else
                texp = Tmax - tslew;
                error = (deltaV-sr*tslew)*exp(-texp/tau);
            end
    
   else			                % only exponential settling
	    texp = Tmax;
	    error = deltaV*exp(-texp/tau);
   end        
   threshold(k+1)=threshold_id-sign(threshold_id-threshold(k))*error;
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      successive approximation       %
%        conversion algorythm         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                     %
      if (in-threshold(k+1)) > 0
          threshold_id=threshold_id+v(12-k);
          bit=1;
      else
          threshold_id=threshold_id-v(12-k);
          bit=0;
      end
    end
 counter=(counter+bit*2^(nbit-k+1));
 end
%                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Output             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                %
 counter=counter;
%                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
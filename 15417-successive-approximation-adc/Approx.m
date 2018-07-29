%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               successive approximation converter                 %
%            with finite DAC's slew-rate and bandwidth             %
%       code by Fabrizio Conso, university of pavia, student       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [counter,thresholds]=Approx(input,nbit,f_bw,sr,f_s)
% input= input sample
% nbit=  number of converter bits
% f_bw=  DAC bandwidth [f_s]
% sr=    DAC slew-rate [V_fs/T_s]
% f_s=   sampling frequency
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                global variables                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                 %
 threshold(1,nbit+1)=0;  % threshold array
 counter=0;              % converter decimal output
 threshold(1)=0.5;       % 0 threshold
 threshold(2)=0.5;       % first threshold
 threshold_id=0.5;       % next ideal threshold
 tau=1/(2*pi*f_bw);      % DAC output pole
 in=input;
 Tmax=1/(f_s*nbit);      % clock period
%                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 for i=2:(nbit+1)       % conversion cycle
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  finite  bandwidth & slew-rate                   %   
%                       error calculation                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
   deltaV=abs(threshold_id-threshold(i-1));
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
    
   threshold(i) = threshold_id - sign(threshold_id-threshold(i-1))*error;
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      successive approximation       %
%        conversion algorythm         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                     %
    if (in-threshold(i)) > 0
        threshold_id=threshold_id+1/2^i;
        bit=1;
    else 
        threshold_id=threshold_id-1/2^i;
        bit=0;
    end
 counter=(counter+bit*2^(nbit-i+1));
 thresholds(i-1)=threshold(i);
 end
%                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Output             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                %
 counter=counter;
 if nargout > 1
	thresholds=thresholds;
 end
%                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
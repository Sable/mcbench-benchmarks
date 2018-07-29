function [tap_variances,L,Dop]=CIRpowers(N_SUI,T)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                        %
%%     Name: CIRpowers.m                                                  %
%%                                                                        %
%%     Description: Originally this function gave back the variances of   %
%%      the different paths or "taps" of the channel multipaths; as well  %
%%      as the length of the channel.                                     %
%%     There are additions that give back the frequency of the doppler    %
%%      effect, since in SUI channels it comes defined.The team of Muquet %
%%      calculated it form the speed and that is why they did not need it.%
%%                                                                        %
%%     Parameters:                                                        %
%%      N_SUI : Channel to smiulate.    T = Time between carriers         %
%%                                                                        %
%%     Authors: Bertrand Muquet, Sebastien Simoens, Shengli Zhou          %
%%      October 2000                                                      %
%%     Modificación : Carlos Batlles - April 2007                         %
%%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


  [powers,K,delays,Dop,ant_corr,Fnorm] = parameters_SUI(N_SUI);
  Dop = max (Dop);
  
  %% The delays are normalized
  sz=size(delays);
  if (and(sz(1) ~= 1,sz(2) == 1)) delays=delays.';
  elseif (and(sz(1) ~= 1,sz(2) ~= 1)) 'Error: The delay must be a vector';
  end
  
  % Now the delays express themselves in number of samples.
  delays=delays/T; 
  
  nbtaps=length(powers);
  len_cir=1+round(max(delays));
  tap_variances=zeros(1,len_cir);
  
  %% Calculate the amplitude of each path.
  sz=size(powers);
  if (and(sz(1) ~= 1,sz(2) == 1)) powers=powers.';
  elseif (and(sz(1) ~= 1,sz(2) ~= 1)) 'Error: The powers must be a vector';
  end

  %% The powers are in dB -> With this order the variance is calculated to recombine the power of every path
  
  variances=10.^(powers/10);
  
  %% Normalize the powers
  variances=variances/sum(variances);

  %% Finally, the discreet CIR is calculated bringing every path to the following sample
  for i=1:nbtaps
    tap_variances(1+round(delays(i)))=tap_variances(1+round(delays(i)))+ variances(i);
  end

  L=length(tap_variances)-1;
  
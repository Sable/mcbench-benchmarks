function fadingcoeff=genh(I,v,Dop,tb)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                        %
%%     Name: genh.m                                                       %
%%                                                                        %
%%     Description: We generate a unique coefficient of fading with "sum  %
%%      of sinusoides" of the Jakes model.                                %
%%                                                                        %
%%     Parameters:                                                        %
%%          I = Length of the plot                                        %
%%          v = Speed of the terminal (m/s)                               %
%%          Dop = Maximum frequency of the Doppler effect                 %
%%          tb = Symbol Duration                                          %
%%                                                                        %
%%     Authors: Bertrand Muquet, Sebastien Simoens, Shengli Zhou          %
%%      October 2000                                                      %
%%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  fc = 2.3e9; 			% Carrier Frequency in Hertz (2.5GHz 3.2GHz)
  fdmax = Dop;        
  
  N = 100;                      % Number of incident waves
  t = tb:tb:tb*I;               % The variable "time"

  len = length(t);
  theta = rand(1,N)*2*pi;              % Generating the uniform phases
  fd = cos(2*pi*((1:N)/N))*fdmax;      % Generate eqaul-spaced frequencies from  "-fdmax" to "+fdmax"
  
 
  E = exp(j.*(2*pi*fd(:)*t(:)'+repmat(theta(:),1,len)));
  E = E/sqrt(N);
  fadingcoeff = sum(E);
  %plot(t,abs(fadingcoeff))
  %xlabel('time (second)');ylabel('Envelope of the fading coefficient');
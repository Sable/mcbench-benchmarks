%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  thresholds calculation from ideal and mismatched    %
%         (both random and linear gradient)            %
%               resistive binary string                %  
% code by Fabrizio Conso, university of pavia, student %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                                                      %
  function [v,v_err]=trs(nbit,vref)
  vref_err=vref*0.1*randn(1);
  for i=1:nbit      %calculation of resistance values
      R(1)=1;
      R1(1)=1+0.1*0.5*randn(1)+0.01*(i); % ideal DAC
      R(i+1) =2^(i-1);
      R1(i+1)=2^(i-1)+0.1*0.5*randn(1)+0.01*(i); % mismatched DAC       
  end
 
  for j=1:nbit        %calculation of tension values
      v(j)    =vref*sum(R(1:j))/sum(R);
      v_err(j)=vref_err*sum(R1(1:j))/sum(R1);
  end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Output             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                %
 v=v;
 if nargout > 1
	v_err=v_err;
 end
%                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
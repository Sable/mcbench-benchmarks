function [vhat,iteration]=decode_ldpc_matlab(rx_waveform,No,h,rows,cols,ind,r,c,max_iter)

% bit to check
% check to bit
% update APP LLR
% hard decision
% if valid codework, then exit

vhat(1,1:cols)=0;   %length of decoded word = number of colums of H

s=struct('a',sparse(rows,cols,0),'b',sparse(rows,cols,0),'g',sparse(rows,cols,0));
% a:check to bit messages of previous iteration, b: current check to bit messages,
% g:updated codebit APP LLR

gamma_n=(4/No)*rx_waveform;

s.g(ind)=gamma_n(c);

bitmessage=sparse(rows,cols,0);
bitmessage_2=sparse(rows,cols,0);
    
for iteration=1:max_iter       %iteration loop

    bitmessage(ind)=tanh( ( -(s.g(ind))+ s.a(ind))  /2);    %bit to check messages
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %loop for computing check-to-bit messages
    for i=1:rows
        cc=c(find(r==i));   %
        rowtemp=bitmessage(i,:);    %ith row of bitmessage
        
        rowtemp_int=zeros(1,length(cc));
        rowtemp_int=rowtemp(cc);    %interesting elements corresponding to 1's in H
        ze=find(rowtemp_int==0);    %number of zeros in interesting elements
        
        if length(ze)>=2    %if #of zeros >=2, all interesting elements are zero
            bitmessage_2(i,cc)=0;

        elseif isempty(ze)==1
            rowtemp_int1=zeros(1,length(cc));
            rowtemp_int1(1:length(cc))=prod(rowtemp_int);
            bitmessage_2(i,cc)=rowtemp_int1./rowtemp_int;

        else  %one zero in interesting elements
            zuss=find(rowtemp_int==0);
            rowtemp_int2=rowtemp_int;
            rowtemp_int2(zuss)=1;
            rowtemp_int3=zeros(1,length(cc));
            rowtemp_int3(zuss)=prod(rowtemp_int2);
            bitmessage_2(i,cc)=rowtemp_int3;
        end
            
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    s.b(ind)=-2*atanh(bitmessage_2(ind));   %check to bit messages
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    s.b(find(s.b==inf))=1000;    % limiting the checknode to bitnode LLR values to +-50
    s.b(find(s.b==-inf))=-1000;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
    
    
    s.a(ind)=s.b(ind);                      %current check to bit messages for use in next iteration

    sum_of_b=sum(s.b,1);

    tempsum=sum_of_b+gamma_n;               % updating APP LLR
    s.g(ind)=tempsum(c);
    
    vhat(find(tempsum>=0))=1;
    vhat(find(tempsum<0))=0;

    if mod(vhat*h',2)==0
        break
    end

end      %iteration loop -end



%   Copyright (c) 2005 by Shaikh Faisal Zaheer, faisal.zaheer@gmail.com
%   $Revision: 1.0 $  $Date: 10/11/2005 $



function [gamma_cof w_cof]=gamma_generator(Type,edges,w_dictonary)


cut_off=sort(edges);

index=1;

switch lower(Type)
       case {'lowpass'}
           if length(cut_off)~=2
               disp('Lowpass filter needs exactly two edges')
               gamma_cof=[];
               return
           end
           
           for w=w_dictonary
               if w<=cut_off(1)
                   temp_gamma(index)=1;
                   w_cof(index)=w;
                   index=index+1;
               elseif cut_off(2)<=w
                   temp_gamma(index)=0;
                   w_cof(index)=w;
                   index=index+1;
               end
           end
                   
           
       case {'highpass'}
           if length(cut_off)~=2
               disp('Highpass filter needs exactly two edges')
               gamma_cof=[];
               return
           end    
           
           for w=w_dictonary
               if w<=cut_off(1)
                   temp_gamma(index)=0;
                   w_cof(index)=w;
                   index=index+1;
               elseif cut_off(2)<=w
                   temp_gamma(index)=1;
                   w_cof(index)=w;
                   index=index+1;
               end
           end
           
           
       case {'bandpass'}
           if length(cut_off)~=4
               disp('Bandpass filter needs exactly four edges')
               gamma_cof=[];
               return
           end    
           
           for w=w_dictonary
               if w<=cut_off(1) | w>=cut_off(4)
                   temp_gamma(index)=0;
                   w_cof(index)=w;
                   index=index+1;
               elseif cut_off(2)<=w & w<=cut_off(3)
                   temp_gamma(index)=1;
                   w_cof(index)=w;
                   index=index+1;
               end
           end
           

      otherwise
           disp('Unknown Type')
end




gamma_cof=temp_gamma;

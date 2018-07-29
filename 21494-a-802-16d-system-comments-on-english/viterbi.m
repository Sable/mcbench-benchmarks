function [coded] = viterbi(msg,template,Tx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%     Name: viterbi.m                                                   %
%%                                                                       %
%%     Description: The convolutionals code is realized with an initial  %
%%      rate of 1/2, later the process of puncturing with the template   %
%%      that has been defined is realized, following the global rate     %
%%      that is to be obtained.                                          %
%%     If we are receiving, the function is in charge to decode the      %
%%      sequence received through the viterbi algorithm.                 %
%%                                                                       %
%%     Parameters:                                                       %
%%       Sequence of bits to encode with the algorithm.                  %
%%                                                                       %
%%     Result: It gives back the chain of bits encoded according to      %
%%      the need (following the modulatin and the rate).                 %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t=poly2trellis(7, [171 133]);

block = length (template);               % Length of the template
code_final=[];
    
if Tx==1                                   % Transmitting --> encode.
    code = convenc(msg,t);
    code_punctured = code;
    repeat = length(code)/block;         % When the template needs to be applied.
   
    
    % Depending on the mapping, more or less bits will remain.
    % Puncturing is realized.
    for i=0:repeat-1
        sample = code_punctured (i*block+1:(i+1)*block);
        for j=1:block
            if template(j)==1
                code_final = [code_final sample(j)];
            end
        end
    end
    
    coded = code_final;
    
elseif Tx==0        % For receiving, the process must be undone.
    
    repeat= length(msg)/sum(template);  % Times the process needs to be repeated.
    lengtht = sum(template);
    
    % Transmitting +1 and -1 to know what bits ahve been cleared.
    code = -2*msg +1; 
    
    % Must fill up the zeros and realize the inverse of puncturing.
    for i=0:repeat-1
        sample = code (i*lengtht+1:(i+1)*lengtht);
        k=1;
        for j=1:block            
            if template(j)==1
                code_final = [code_final sample(k)]; 
                k = k+1;
            elseif template(j)==0
                code_final = [code_final 0];
            end
        end
    end
    
    tb = 105;
    if length(code_final) == 192         % for BPSK
        coded = vitdec (code_final,t,96,'trunc','unquant');
    elseif length(code_final) ~= 192
        coded = vitdec (code_final,t,tb,'trunc','unquant'); 
    end


end


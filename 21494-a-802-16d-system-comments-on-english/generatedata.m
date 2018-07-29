function [output,amount,codeRS,template,n_symbols,rate] = generatedata(n_mod_type,rate,n_symbols,encode)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%      Name: generatedata.m                                             %
%%                                                                       %
%%      Descrition: In this function, the data is generated that,        %
%%       after the encoding, carrying the pilot and guards, will         %
%%       form an OFDM symbol.                                            %
%%                                                                       %
%%      Parameters: The amount of information generated will be          %
%%       depending on the FFT/IFFT and on the type of modulation.        %
%%                                                                       %
%%      Result: It gives back the generated bits.                        %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% In the first place I must know how many bits I must generate.
% The values are taken from table 215 of the standard, considering the byte that is due  
% subsequent to introduce the randomization of the data.

switch n_mod_type
    case 1
        amount = 11;
        amount_coded = 192;
        template = [1];
        codeRS=[12 12];
    case 2
        if rate == (1/2)
            amount = 23;
            template = [1 0 1 1];          % These templates are those that are used in the  
            codeRS=[32 24];                % Convolutional encoding and later in the Virerbi algorithm. 
        elseif rate == (3/4)                
            amount = 35;                   
            template = [1 0 1 0 1];        
            codeRS=[40 36];
        end
        amount_coded = 384;
    case 4
        if rate == (1/2)
            amount = 47;
            template = [1 0 1 1];
            codeRS=[64 48];                % The variable codeRS indicates the form in which 
        elseif rate == (3/4)               % data must be encoded in the Reed-Solomon encoding.
            amount = 71;                  
            template = [1 0 1 0 1];        
            codeRS=[80 72];
        end
        amount_coded = 768;
    case 6
        if rate == (2/3)
            amount = 95;                   % Logically, "amount" marks how many bytes i must generate in each case.
            template = [1 1 0];             
            codeRS=[108 96];              
        elseif rate == (3/4)                
            amount = 107;                
            template = [1 0 1 0 1];
            codeRS=[120 108];
        end
        amount_coded = 1152;
end

% Once the bytes needed to generate are found, they are generated for each case
 output = randint (1,amount*8*n_symbols);
 n_symbols = n_symbols;
 
 rate = amount_coded/(amount*8);

if encode==0
    
    % If encoding is not employed, the necessary bits are generated.
    n_symbols = floor(length(output)/amount_coded);
    amount = amount_coded/8;
    
    % Again, once the bytes needed to generate are found, they are generated.
    output = randint (1,amount*8*n_symbols);     
 
end



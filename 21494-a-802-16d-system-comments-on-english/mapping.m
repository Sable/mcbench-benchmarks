function data_mapping = mapping( data_interleaving, n_mod_type,Tx)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%       Name: mapping.m                                                 %
%%                                                                       %
%%       Description: It receives the number of bits to modulate and     %
%%        the type of modulation (1=BPSK,2=QPSK,4=16QAM,6=64QAM).        %
%%                                                                       %
%%       Result: A matrix with the symbol mappings according to the      %
%%        used constellation, that depends on the type of modulation     %
%%        required.                                                      %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Now depending on the modulation, a constellation is defined.
% These constellations are defined in the standard.
    
[M,M1,M2,type_mapping,c] = parameters_constellation(n_mod_type);
alphabet = bit_symbol(M,type_mapping,M1,M2);

if n_mod_type~=1
    constellation_gray = alphabet(:,3) + j*alphabet(:,2);
else
    constellation_gray = [0 1]';
end

l = length(data_interleaving);


if Tx==1
    % In case of wanting to map the received bits, i need to have the
    % vector entered in the form of a matrix with as many columns as a
    % symbol has bits.
 
    matrix_data = reshape (data_interleaving,n_mod_type,l/n_mod_type);
    m_data_decimal = bi2de (matrix_data','left-msb');
 
    % Now I am taking each value from each row of the matrix and the
    % mapping with the constellation that I have defined previously.

    for i=1:(l/n_mod_type)
        v_data_decimal = m_data_decimal (i);

        % I encode of the form dn=an+j*bn, according to my gray constellation.
        v_encode = genqammod(v_data_decimal,constellation_gray);

        % I place them in the matrix where I am going to have all the symbols by columns.
        output(:,i) = v_encode;
    end

    % I multiply the result by the factor 'c' defined in the standard.
    data_mapping = c.*output;
    
elseif Tx==0
    % So that all the values are coherent, I must begin to divide the
    % initial vector by the factor 'c' defined in the norm.
    data_normalized = data_interleaving ./ c;
   
    % Now the inverse of the mapping must be realized.
    
    for i=1:l
        v_data_mapping = data_normalized (i);

        % I decode them and it transforms them of dn=an j*bn to binary
        % numbers, according to my Gray constellation.
        v_decode = genqamdemod(v_data_mapping,constellation_gray);

        % I place them in the matrix where I am going to have all the symbols by columns
        data_decimal(:,i) = v_decode;
        data_mapping = de2bi(data_decimal,n_mod_type,'left-msb')';
        data_mapping = data_mapping(:)';
    end
end
    

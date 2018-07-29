function [alphabet] = bit_symbol(M,type,M1,M2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                        %
%%     Name: bit_symbol.m                                                 %
%%                                                                        %
%%     Description: Depending the type of modulation with which we are    %
%%      wroking, this function gives back each one of the values of the   %
%%      constellation, which is done by Gray coding.                      %
%%                                                                        %
%%                                                                        %
%%     Parameters:                                                        %
%%          M = The number of total symbols. It will be equal to 2^k,     %
%%      where k is the number of bits that are grouped to form a symbol,  %
%%      except for the case of QAM, in which it can come by the product   %
%%      of the arguments M1 and M2.                                       %
%%          type = type of modulation: PAM, MPSK, QAM(rectangular).       %
%%      In this case, it will be supposed that M is the product of M1     %
%%      and M2.                                                           %
%%          M1 and M2 = Number of symbols in each of the axes. Thus we    %
%%      can work with rectangular constellations or of different forms.   %
%%                                                                        %
%%                                                                        %
%%                                                                        %
%%     Note: This is based on the function realized by Fco. Javier Payan  %
%%     Somet in which, besides giving back the constellation, it gives    %
%%     back the sequence (bis) already encoded.                           %
%%                                                                        %
%%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Block of initialization
%
if strcmp(type,'QAM')
    k1 = ceil(log2(M1));
    k2 = ceil(log2(M2));
    M1 = 2^k1;
    M2 = 2^k2;
    M = M1*M2;
    
    % Everything is initialized
     % Aicd will be the values different from the coefficients in phase and
     % Aisd the values different from the coefficients in quadrature
    Aicd = zeros(1,k1);            
    Aisd = zeros(1,k2);             
    table1 = zeros(M1,2);
    table2 = zeros(M2,2);
    alphabet = zeros(M,3);

    % In 'table1' and 'table2', every row contains the decimal value of
    % the bits [b1 b2... Bk1] and the indices of the table Aicd and Aisd that encode them
    
    d1 = 0:1:M1-1;
    d1 = d1';
    d2 = 0:1:M2-1;
    d2 = d2';
	ind1 = bi2de(fliplr(gray2bi(fliplr(de2bi(d1)))));
	table1 = [d1,ind1+1];                  
	ind2 = bi2de(fliplr(gray2bi(fliplr(de2bi(d2)))));
	table2 = [d2,ind2+1];                  
    
else
    
	k = ceil(log2(M));
	M = 2^k;

    % We initialize
	Aicd = zeros(1,k);           % The values different from the coefficients in phase
	Aisd = zeros(1,k);           % The values different from the coefficients in quadrature
	table = zeros(M,2);          % A table with indices
	alphabet = zeros(M,3);       % Alphabet
	
    % In this case, every row of the table 'table' contains the decimal
    % value of the bits [b1 b2 ... bk] and the index of the table Aicd and Aisd that encodes it
	d = 0:1:M-1;
	d = d';
	ind=bi2de(fliplr(gray2bi(fliplr(de2bi(d)))));
	table = [d,ind+1];
    
end

% Block of computation
%
if strcmp(type,'PAM')
    Aicd = -(M-1):2:M-1;                   
    Aisd = [];
    
    % We create alphabet
    for i=1:M
        index = find_index(i-1,table);
        alphabet(i,:) = [i-1,Aicd(index),0];
    end
    
elseif strcmp(type,'MPSK')
    angle = 0:2*pi/M:2*pi*(M-1)/M;
    Aicd = cos(angle);
    Aisd = sin(angle);
    
    % We create alphabet
    for i=1:M
        index = find_index(i-1,table);
        alphabet(i,:) = [i-1,Aicd(index),Aisd(index)];
    end

    
elseif strcmp(type,'QAM')
    Aicd = -(M1-1):2:M1-1;       
    Aisd = (M2-1):-2:-(M2-1);
    
    % We create alphabet
    for i=1:M1
        for j=1:M2
            index1 = find_index(i-1,table1);           
            index2 = find_index(j-1,table2);
            l = i+M1*(j-1);
            alphabet(l,:) = [l-1,Aicd(index1),Aisd(index2)];
        end
    end
    
end

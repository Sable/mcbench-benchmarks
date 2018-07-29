function [M,M1,M2,type_map,c] = parameters_constellation(n_mod_type);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%       Name: parameters_constellation.m                                %
%%                                                                       %
%%       Description: It receives the type of modulation that we are     %
%%        working with(1=BPSK,2=QPSK,4=16QAM,6=64QAM)                    %
%%                                                                       %
%%       Output: The parameters necessary to call another function and   %
%%        that calculates the constellation to implement using Gray      %
%%        codes.                                                         %
%%                                                                       %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


switch n_mod_type
    case 1                          % for BPSK
        type_map = 'MPSK';          
        M = 2;
        M1 = 0;
        M2 = 0;
        c = 1;
    case 2                          % for QPSK(or 4-QAM)
        type_map = 'QAM';
        c = 1/sqrt(2);
    case 4                          % for 16-QAM
        type_map = 'QAM';
        c = 1/sqrt(10);
    case 6                          % for 64-QAM
        type_map = 'QAM';
        c = 1/sqrt(42);
end

if n_mod_type~=1
    M = 0;
    M1 = sqrt(2^n_mod_type);
    M2 = sqrt(2^n_mod_type);
end





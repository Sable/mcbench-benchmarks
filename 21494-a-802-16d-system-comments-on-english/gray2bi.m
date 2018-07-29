function b = gray2bi( g )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                %
%%   GRAY2BI converts Gray encoded sequence into the binary       %
%%   sequence. It is assumed that the most significant bit is     %
%%   the left hand side bit.                                      %
%%                                                                %
%%   Comments and suggestions to: batlles@gmail.com               %
%%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % copy the msb:
    b(:,1) = g(:,1);
    
    for i = 2:size(g,2),
        b(:,i) = xor( b(:,i-1), g(:,i) ); 
    end

return;
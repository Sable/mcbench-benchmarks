function [out] = random(msg,BSID,DIUC,Frame);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%     Name: random.m                                                    %
%%                                                                       %
%%     Description: This function is realisez uniquely by the way        %
%%      defined in the standard. It is one more stage in the encoding.   %
%%                                                                       %
%%                                                                       %
%%     Parameters:                                                       %
%%       msg  --> Sequence of bits to encode with the algorithm BSID,    %
%%       DIUC, Frame--> Identifiers of the connection that is carried    %
%%       out.(Base Station, Downlink and the number of frames)           %
%%                                                                       %
%%                                                                       %
%%     Result: It gives back the chain of bits encoded accordin to       %
%%      the need (following DIUC, BSID and Frame). The encoding and      %
%%      decoding are an identical process.                               %
%%                                                                       %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

seed = zeros (1,15);
seed=[de2bi(BSID,4,'left-msb') 1 1 de2bi(DIUC,4,'left-msb') 1 de2bi(Frame,4,'left-msb')];

out=zeros(1,length(msg));

for i=1:length(msg)
    next = xor(seed(14),seed(15));
    out(i) = xor( msg(i),next);
    seed = [next seed(1,1:14)];
end

return;

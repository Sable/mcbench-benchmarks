function Rcv = Refresh(Received)    %This function is used to clean the corrupted pulses & regenerate fresh pulses
    
    sz=length(Received);         %determines the length of bit stream of received symbols
    y=[];
    for i=1:sz,
        if Received(i)>=0
            y(i) = 1;    %if value of an element is >=0, then +ve pulse is generated
        else
            y(i)= -1;    %if value of an element is <0, then -ve pulse is generated
        end
    end
    
    Rcv=y;
end
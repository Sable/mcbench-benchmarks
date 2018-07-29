function Stats = Decode_and_compare(RECEIVED_MFSK,CODEWORD,n,k,t,h,g,field)

%Determine number and positions of erasures
num_erasures = 0;
erasures = [];
        
for j = 1:n
    if RECEIVED_MFSK(j) == -2
        num_erasures = num_erasures + 1;
        erasures = [erasures j];
    end
end

RECEIVED_RS_SYMB = ConvertMFSK2RS(RECEIVED_MFSK);  %Convert the symbols to RS symbols
                                                   % Symbols are in range [-1 M-1]
                                                  
if num_erasures <= h
    
    DECODED = RS_E_E_DEC(RECEIVED_RS_SYMB, erasures,n,k,t,h,g,field);
    
else
    
    DECODED = RECEIVED_RS_SYMB;  %Erasures exceed maximum correcting capability 
    
end

%Calculate the Stats
Stats = Compare(DECODED, CODEWORD,n,field);

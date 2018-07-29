%Function for finding next state and corresponding parity bit using the
%TRELLIS Diagram. State 0,1,2,3 represents state 00,01,10 and 11
%respectively
function [next_state,parity_bit]=parity_bit(current_state,input)
switch current_state
    case 0
        switch input
            case 0
                next_state=0;parity_bit=0;
            otherwise
                next_state=2;parity_bit=1;
        end
        
    case 1
        switch input
            case 0
                next_state=2;parity_bit=0;
            otherwise
                next_state=0;parity_bit=1;
        end
        
    case 2
        switch input
            case 0
                next_state=1;parity_bit=1;
            otherwise
                next_state=3;parity_bit=0;
        end
        
    otherwise
        switch input
            case 0
                next_state=3;parity_bit=1;
            otherwise
                next_state=1;parity_bit=0;
        end        
end
end
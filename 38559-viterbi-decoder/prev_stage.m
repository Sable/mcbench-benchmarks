%Starts from the current decoded state, takes input as minimum distance to
%reach that state and previous state And returns previous state and decoded
%information bit corresponding to that state.

function [prev_state,decoded_bit]=prev_stage(curr_state,distance_prev,metric)
    if(curr_state==1)
        if(distance_prev(1)+metric(1) <= distance_prev(3)+metric(5))
            prev_state=1;decoded_bit=0;
        else
            prev_state=3;decoded_bit=0;
        end
    end
    
    if(curr_state==2)
        if(distance_prev(1)+metric(2) <= distance_prev(3)+metric(6))
            prev_state=1;decoded_bit=1;
        else
            prev_state=3;decoded_bit=1;
        end
    end
    
    if(curr_state==3)
        if(distance_prev(2)+metric(3) <= distance_prev(4)+metric(7))
            prev_state=2;decoded_bit=0;
        else
            prev_state=4;decoded_bit=0;
        end
    end
    
    if(curr_state==4)
        if(distance_prev(2)+metric(4) <= distance_prev(4)+metric(8))
            prev_state=2;decoded_bit=1;
        else
            prev_state=4;decoded_bit=1;
        end
    end
    
end
%#codegen
function [ i_out , q_out ] = output_tone()
%Output a tone at 1MHz

    persistent i_hold q_hold phi

    if (isempty(phi))
        phi=1;
    end

    %ROMs *not* declared persistent
    lSin = SIN;
    lCos = COS;

    q_hold = lCos(phi);
    i_hold = lSin(phi);

    phi = phi + 1;
    if phi > 20
        phi = 1;
    end

    i_out = (2^11)*i_hold;
    q_out = (2^11)*q_hold;

end
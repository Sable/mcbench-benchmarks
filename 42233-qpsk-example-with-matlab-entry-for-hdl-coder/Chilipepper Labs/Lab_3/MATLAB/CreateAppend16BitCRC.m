function msg_out = CreateAppend16BitCRC(msg_no_zeros)

    valueCRC = 65535;
    genPoly = 4129;

    msg_in = [msg_no_zeros 0 0];
    for i1 = 1:length(msg_in)
        for i2 = 1:8
            b = mod(floor(msg_in(i1)/(2^(8-i2))),2);
            valueCRCsh1 = bitsll(valueCRC,1);
            valueCRCadd1 = bitor(valueCRCsh1,b);
            if floor(valueCRCadd1/2^16) == 1
                valueCRC = bitxor(valueCRCadd1,genPoly);
            else
                valueCRC = valueCRCadd1;
            end
            valueCRC = mod(valueCRC,2^16);
            2;
        end
    end

    msg_out = [msg_no_zeros mod(floor(valueCRC/2^8),2^8) mod(valueCRC,2^8)];
end

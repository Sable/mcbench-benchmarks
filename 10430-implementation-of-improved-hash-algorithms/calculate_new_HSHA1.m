function output = calculate_new_HSHA1(H,a,b,c,d,e)
%  Print results to screen
%

        a1= num2str(a')';
        b1= num2str(b')';
        c1= num2str(c')';
        d1= num2str(d')';
        e1= num2str(e')';


output(1,:) = dec2hex(mod(bin2dec(a1) + hex2dec(H(1,:)),2^32),8 );
output(2,:) = dec2hex(mod(bin2dec(b1) + hex2dec(H(2,:)),2^32),8 );
output(3,:) = dec2hex(mod(bin2dec(c1) + hex2dec(H(3,:)),2^32),8 );
output(4,:) = dec2hex(mod(bin2dec(d1) + hex2dec(H(4,:)),2^32),8 );
output(5,:) = dec2hex(mod(bin2dec(e1) + hex2dec(H(5,:)),2^32),8 );

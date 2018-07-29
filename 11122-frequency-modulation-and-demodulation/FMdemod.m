function x = FMdemod(y,beta)

[r, c] = size(y);
if r*c == 0
    y = [];
    return;
end;
if (r == 1)
    y = y(:);
    len = c;
else
    len = r;
end;

Fc = 40000;
Fs = 8000*20;
pi2 = 2*pi;

    [num, den] = butter(5, Fc * 2 / Fs);
    
    sen = 2*pi*beta*100;
    
    %pre-process the filter.
    if abs(den(1)) < eps
        error('First denominator filter coefficient must be non-zero.');
    else
        num = num/den(1);
        if (length(den) > 1)
            den = - den(2:length(den)) / den(1);
        else
            den = 0;
        end;
        num = num(:)';
        den = den(:)';
    end;
    len_den = length(den);
    len_num = length(num);

    x = y;
    y = 2 * y;

    ini_phase = pi/2;
    for ii = 1 : size(y, 2)
        z1 = zeros(length(den), 1);
        s1 = zeros(len_num, 1);
        intgl = 0;

        memo = 0;
        for i = 1:size(y, 1)
            %start with the zero-initial condition integer.
            vco_out = cos(pi2 * intgl+ini_phase);
            if len_num > 1
                s1 = [y(i, ii) * vco_out; s1(1:len_num-1)];
            else
                s1 = y(i, ii);
            end
            tmp = num * s1 + den * z1;
            if len_den > 1
                z1 = [tmp; z1(1:len_den-1)];
            else
                z1 = tmp;
            end;
            intgl = rem(((tmp*sen + Fc)/ Fs + intgl), 1);
            x(i, ii) = tmp;
        end;
    end;
    x = x;
x = decimate(x,20);
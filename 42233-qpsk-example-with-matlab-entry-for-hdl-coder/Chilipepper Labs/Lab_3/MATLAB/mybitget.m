function b = mybitget(by, p)

    switch p
        case 1
            u = floor(by/2^0);
        case 2
            u = floor(by/2^1);
        case 3
            u = floor(by/2^2);
        case 4
            u = floor(by/2^3);
        case 5
            u = floor(by/2^4);
        case 6
            u = floor(by/2^5);
        case 7
            u = floor(by/2^6);
        case 8
            u = floor(by/2^7);
        otherwise
            u = 0;
    end
    b = mod(u,2);
end
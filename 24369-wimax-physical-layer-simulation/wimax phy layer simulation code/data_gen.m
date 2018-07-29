function data_get=data_gen(rate_id)

switch (rate_id)
    case 0
       data_get=randint(11*8,1);     % No. of bit generated
    case 1
       data_get=randint(23*8,1);     % here we generate one less byte than the uncoded block size 
    case 2                           % (example 23 byte for rate_id 1)  
       data_get=randint(35*8,1);     % because we need to add one byte of 'zeros' after randmization
    case 3                                 
       data_get=randint(47*8,1); 
    case 4
        data_get=randint(71*8,1); 
    case 5
        data_get=randint(95*8,1); 
    case 6
        data_get=randint(107*8,1); 
    otherwise
       display('error in data getneration give proper rate_id')
end


my_fir=hm.stage(1).numerator;

number_luts     =   length(my_fir)/8;

lut_matrix      =   zeros(number_luts,256);



%% generate LUTs for response to signbit input
% each LUT has response for 8 taps for input (0-255)
% for Example lut_matrix(2,:) response of taps 8-15 of FIR filter to input
% the LUT approach naturally downsamples by 8 as 8 signbits produce one
% output

for index =0:255
    
    %convert uint8 to binary string of 1's and 0's then convert to 1's and
    %-1's
    xsig    =   bin2sbin(dec2bin(index,8));
    
    %initialize to first segment/8 taps of filter
    segment =   1:8;
    
    for lut_number=1:number_luts
        
        %take current 8 taps of filter
        hlut    =   my_fir(segment);
        
        %compute output due to this byte/ 8 bits of 1's and -1's worth of
        %input
        %put this value into LUT matrix
        lut_matrix(lut_number,index+1)  =   sum(hlut.*(xsig)  );
        
        %increment to next segment/ 8 taps of filter
        segment =   segment+8;
    end
    
    
    
end

q=quantizer;



























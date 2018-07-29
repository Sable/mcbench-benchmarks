%#eml
function R = radix4FFT3_FixPtEML(s)
    % This is a radix-4 FFT, using decimation in frequency
    % The input signal can be floating point or fixed point
    % Works with real or complex input
    % Modified for Embedded MATLAB support

    % Initialize variables and signals
    % NOTE: The length of the input signal should be a power of 4: 4, 16, 64, 256, etc.
    N = length(s);
    M = log2(N)/2;
 
    % Initialize variables for floating or fixed point sim
    if isfi(s)
        NT = numerictype(s);
        FM = fimath(s);
        wl = NT.WordLength;
        W=fi(exp(-1*2j*pi*(0:N-1)/N), 1, wl, wl - 2, FM);
        S = fi(complex(zeros(size(s))), NT, FM);
        R = fi(complex(zeros(size(s))), 1, wl, wl  - 1 - 2*M, FM);
        sTemp = fi(complex(zeros(size(s))), NT, FM);
        x = fi(complex(zeros(1,4)), NT, FM);
    else
        W=exp(-1*2j*pi*(0:N-1)/N);
        S = complex(zeros(size(s)));
        R = complex(zeros(size(s)));
        sTemp = complex(zeros(size(s)));
        x = complex(zeros(1,4));
    end

    % FFT algorithm
    % Calculate butterflies for first M-1 stages
    sTemp = s;
    for stage = 0:M-2
        for n=1:N/4
            for m=1:4
                x(m) = sTemp(n + (m-1)*N/4);
            end
            S((1:4)+(n-1)*4) = radix4bfly(x, floor((n-1)/(4^stage)) *(4^stage), 1, W);
        end
        sTemp = S;
    end
    
    % Calculate butterflies for last stage
    for n=1:N/4
        for m=1:4
            x(m) = sTemp(n + (m-1)*N/4);
        end
        S((1:4)+(n-1)*4) = radix4bfly(x, floor((n-1)/(4^stage)) * (4^stage), 0, W);
    end
    
    % Rescale the final output
    R(:) = S*N;
   
end

function Z = radix4bfly(x,segment,stageFlag,W)
    % For the last stage of a radix-4 FFT all the ABCD multiplers are 1.
    % Use the stageFlag variable to indicate the last stage
    % stageFlag = 0 indicates last FFT stage, set to 1 otherwise

    % Initialize variables and scale by 1/4
    if isfi(x)
        a=bitshift(x(1),-2);b=bitshift(x(2),-2);c=bitshift(x(3),-2);d=bitshift(x(4),-2);        
    else
        a=x(1)*.25;b=x(2)*.25;c=x(3)*.25;d=x(4)*.25;
    end

    % Radix-4 Algorithm
    A=a+b+c+d;
    B=(a-b+c-d)*W(2*segment*stageFlag + 1);
    C=(a-complex(-imag(b),real(b))-c+complex(-imag(d),real(d)))*W(segment*stageFlag + 1);
    D=(a+complex(-imag(b),real(b))-c-complex(-imag(d),real(d)))*W(3*segment*stageFlag + 1);
    
    Z = [A B C D];

end



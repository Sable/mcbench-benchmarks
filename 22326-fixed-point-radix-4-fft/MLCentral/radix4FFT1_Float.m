function S = radix4FFT1_Float(s)
    % This is a radix-4 FFT, using decimation in frequency
    % The input signal must be floating point 
    % Works with real or complex input

    % Initialize variables and signals
    % NOTE: The length of the input signal should be a power of 4: 4, 16, 64, 256, etc.
    N = length(s);
    M = log2(N)/2;
 
    % Initialize variables for floating point sim
    W=exp(-j*2*pi*(0:N-1)/N);
    S = complex(zeros(1,N));
    sTemp = complex(zeros(1,N));

    % FFT algorithm
    % Calculate butterflies for first M-1 stages
    sTemp = s;
    for stage = 0:M-2
        for n=1:N/4
            S((1:4)+(n-1)*4) = radix4bfly(sTemp(n:N/4:end), floor((n-1)/(4^stage)) *(4^stage), 1, W);
        end
        sTemp = S;
    end
    
    % Calculate butterflies for last stage
    for n=1:N/4
        S((1:4)+(n-1)*4) = radix4bfly(sTemp(n:N/4:end), floor((n-1)/(4^stage)) * (4^stage), 0, W);
    end
    sTemp = S;
    
    % Rescale the final output
    S = S*N;
   
end

function Z = radix4bfly(x,segment,stageFlag,W)
    % For the last stage of a radix-4 FFT all the ABCD multiplers are 1.
    % Use the stageFlag variable to indicate the last stage
    % stageFlag = 0 indicates last FFT stage, set to 1 otherwise

    % Initialize variables and scale to 1/4
    a=x(1)*.25;b=x(2)*.25;c=x(3)*.25;d=x(4)*.25;

    % Radix-4 Algorithm
    A=a+b+c+d;
    B=(a-b+c-d)*W(2*segment*stageFlag + 1);
    C=(a-b*j-c+d*j)*W(segment*stageFlag + 1);
    D=(a+b*j-c-d*j)*W(3*segment*stageFlag + 1);
    
    Z = [A B C D];

end



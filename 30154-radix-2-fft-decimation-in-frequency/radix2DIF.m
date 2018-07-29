% Radix 2 Decimation in Frequency 
% Input : Normal Order, An array of Length N
% Output: Normal Order (Output Bits reversed) X[k]
% For any length N (RADIX 2 DIF)
% Done by Nevin Alex Jacob
% Instructions : Input an array of numbers time domain (real or complex) to the function and
% ex : radix2DIF([1 2 3 4 5 ])
% If any mistakes/clarifications, do contact me
% Email : nevinalex1234@gmail.com

function radix2(x);
xcheck=x;
p=nextpow2(length(x));
x=[x zeros(1,(2^p)-length(x))];
N=length(x);
M=N/2;                                        % Index Helping for Controlling range of indices of the Butterfly at Each Stage (Shrinking)
for stage=1:log2(N);                          % No of times decimation has to occur 
         for index=0:(N/(2^(stage-1))):(N-1); % Adjusting the index variations of the butterfly in each stage
             for n=0:M-1;                     % Within a stage, for a given index (single) as reference, develop a local Butterfly Index
                      a=x(n+index+1)+ x(n+index+M+1);
                      b=(x(n+index+1)- x(n+index+M+1)).*exp((-j*(2*pi)/N)*(2^(stage-1))*(n));
                      x(n+1+index)=a;
                      x(n+M+1+index)=b;        % In place Computation
             end;
         end;
M=M/2;                                        % Used for creating Butterfly Pairs (INDEXing the wings) (Shrinkage)
end;
X=bitrevorder(x)                    % Bit reversing X[k] to obtain X[k] 0<k<N-1
Ycheck=fft(xcheck,N)                % Cross Check the answer using inbuilt FFT
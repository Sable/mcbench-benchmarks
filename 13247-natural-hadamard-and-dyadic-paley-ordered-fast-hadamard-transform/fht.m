function x=fhtnat(data)
% The function implement the 1D natural(Hadamard) ordered fast Hadamard transform,
% wchich can be used in signal processing, pattern recongnition and Genetic alogorithms.
% This algorithm uses a Cooley-Tukey type signal flow graph and is implemented in N log2 N
% additions and subtractions. Data sequence length must be an integer power of 2.
% 
% The inverse transform is the same as the forward transform except for the multiplication factor N.
% 
% Example:
% x=[1 2 1 1];
% W=fhtnat(x);
% 
% Author: Gylson Thomas
% e-mail: gylson_thomas@yahoo.com
% Asst. Professor, Electrical and Electronics Engineering Dept.
% MES College of Engineering Kuttippuram,
% Kerala, India, December 2006.
% copyright 2006.
% Reference: N.Ahmed, K.R. Rao, "Orthogonal Transformations for 
% Digital Signal Processing" Spring Verlag, New York 1975. page-111.
N = length(data);
x=data;
L=log2(N);
k1=N; k2=1; k3=N/2;
for i1=1:L  %In-place iterations begins here
    L1=1;
    for i2=1:k2
        for i3=1:k3
            i=i3+L1-1; j=i+k3;
            temp1= x(i); temp2 = x(j); 
            x(i) = temp1 + temp2;
            x(j) = temp1 - temp2;
        end
            L1=L1+k1;
    end
        k1 = k1/2;  k2 = k2*2;  k3 = k3/2;
end
x=inv(N)*x; %Delete this line for inverse transform


function x=fhtdya(data)
% The function implement the 1D dyadic (Paley) ordered fast Hadamard transform,
% wchich can be used in signal processing, pattern recongnition and Genetic alogorithms.
% This algorithm uses a Cooley-Tukey type signal flow graph and is implemented in N log2 N
% additions and subtractions. Data sequence length must be an integer power of 2.
% 
% The inverse transform is the same as the forward transform except for the multiplication factor N.
% 
% Example:
% x=[1 2 1 1];
% W=fhtdya(x);
% 
% Author: Gylson Thomas
% e-mail: gylson_thomas@yahoo.com
% Asst. Professor, Electrical and Electronics Engineering Dept.
% MES College of Engineering Kuttippuram,
% Kerala, India, December 2006.
% copyright 2006.
% Reference: N.Ahmed, K.R. Rao, "Orthogonal Transformations for 
% Digital Signal Processing" Spring Verlag, New York 1975. page-111.

N = length(data);
x=bitrevorder(data);
L=log2(N);
k1=N; k2=1; k3=N/2;
for i1=1:L  %In-place iteration begins here
    L1=1;
    for i2=1:k2
        for i3=1:k3
            i=i3+L1-1; j=i+k3;
            temp1= x(i); temp2 = x(j); 
            x(i) = temp1 + temp2;
            x(j) = temp1 - temp2;
        end
            L1=L1+k1;
    end
        k1 = k1/2;  k2 = k2*2;  k3 = k3/2;
end
x=inv(N)*x; %Delete this line for inverse transform

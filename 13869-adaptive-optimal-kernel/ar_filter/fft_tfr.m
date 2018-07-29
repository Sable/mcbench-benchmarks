function [x,y] = fft_tfr(n,m,x,y)

%***************************************************************/
%		fft.c
%		Douglas L. Jones
%		University of Illinois at Urbana-Champaign
%		January 19, 1992
%
%   fft: in-place radix-2 DIT DFT of a complex input
%
%   input:
%	n:	length of FFT: must be a power of two
%	m:	n = 2**m
%   input/output
%	x:	double array of length n with real part of data
%	y:	double array of length n with imag part of data
%
%   Permission to copy and use this program is granted
%   as long as this header is included.
%***************************************************************/

j = 0;				% bit-reverse
n2 = n/2;
for i=1:(n - 2),
    n1 = n2;
    while (j >= n1)
        j = j - n1;
        n1 = n1/2;
    end
    j = j + n1;

    if (i < j)
        t1 = x(i+1);
        x(i+1) = x(j+1);
        x(j+1) = t1;
        t1 = y(i+1);
        y(i+1) = y(j+1);
        y(j+1) = t1;
    end
end
   
n1 = 0;
n2 = 1;
for i=0:(m-1),
    n1 = n2;
    n2 = n2 + n2;
    e = -2*pi/n2;
    a = 0;

    for j=0:(n1-1),
        c = cos(a);
        s = sin(a);
        a = a + e;

        for k=j:n2:(n-1),
            t1 = c*x(k+n1+1) - s*y(k+n1+1);
            t2 = s*x(k+n1+1) + c*y(k+n1+1);
            x(k+n1+1) = x(k+1) - t1;
            y(k+n1+1) = y(k+1) - t2;
            x(k+1) = x(k+1) + t1;
            y(k+1) = y(k+1) + t2;
        end
    end
end
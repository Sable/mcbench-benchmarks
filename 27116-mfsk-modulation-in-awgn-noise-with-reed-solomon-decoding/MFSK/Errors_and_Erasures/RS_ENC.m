function CODEWORD = RS_ENC(INFO,n,k,g,field)

%CODEWORD = RS_ENC(INFO,n,k,g,field)
%
% m  is the number of bits of each symbol
% n = 2^m-1 => the number of symbols transmitted
% k = the number of code symbols that is going to be codes to a n symbol message
% t = the number of errors that can be found + corrected

%Tripple-error-correcting Reed-Solomon code with symbols from GF(2^4)
% Lin & Costello p.175 and article: Reed_Solomon Codes by Joel Sylvester

%generator polynomial

%field = gftuple([-1:2^m-2]', m, 2);

%p = 2; m = 4;
%primpoly = [0 0 -Inf -Inf 0];
%field = gftuple([-1:p^m-2]',primpoly,p);


%Lin + Costello, p.171


%Encoder (Article)
%shift codeword by X^(n-k)
for ii = 1:n-k
    shiftpol(ii) = -Inf;
end
%shiftpol(n-k+1) = 0;
shiftcode = [shiftpol INFO];


%divide shifted codeword by g(x)
[Q, R] = GFDECONV(shiftcode, g, field);

while length(R) < n-k
    R = [R -inf];
end

CODEWORD = [R INFO];

%CODWORD = gfconv(CODEWORD,0,field);

for i =1:n
    if CODEWORD(i) == -1
        CODEWORD(i) = -Inf;
    end
end
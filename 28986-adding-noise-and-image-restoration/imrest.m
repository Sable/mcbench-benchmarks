function f = imrest(g,type,m,n,parameter)
% this function performs the linear and non-linear spatial filtering for
% image restoration
% F = IMREST(G,TYPE,M,N,PARAMETER) performs spatial filtering of image G
% image using a TYPE filter of M by N. Valid calls to IMREST are as
% follows:
%
% F = IMREST(G,'amean',M,N)         Arithmatic mean filtering.
% F = IMREST(G,'gmean',M,N)         Geometric mean filtering.
% F = IMREST(G,'hmean',M,N)         Harmonic mean filtering.
% F = IMREST(G,'chmean',M,N,Q)      Contraharmonic mean filtering of order
%                                   Q. The default is Q = 1.5.
% F = IMREST(G,'median',M,N)        Median filtering.
% F = IMREST(G,'max',M,N)           Max filering.
% F = IMREST(G,'min',M,N)           Min filtering.
% F = IMREST(G,'midpoint',M,N)      Midpoint filtering.
% F = IMREST(G,'atrimmed',M,N)      Alpha-trimmed mean filtering. Parameter
%                                   D must be a non-negative even integer;
%                                   its default value is D = 2.
%
% The default values when only G and TYPE are input are M=N=3,
% Q = 1.5,and D = 2.
% Process inputs.
if nargin == 2
    m = 3; n = 3; Q = 1.5; d = 2;
elseif nargin == 5
    Q = parameter; d = parameter;
elseif nargin == 4
     Q = 1.5; d = 2;
else
    error('Wrong number of Inputs.')
end
% do the filtering.
switch type
    case 'amean'
        w = fspecial('average',[m n]);
        f = imfilter(g,w,'replicate');
    case 'gmean'
        f = gmean(g,m,n);
    case 'hmean'
        f = harmean(g,m,n);
    case 'chmean'
        f = charmean(g,m,n,Q);
    case 'median'
        f = medfilt2(g,[m n],'symmetric');
    case 'max'
        f = ordfilt2(g,m*n,ones(m,n),'symmetric');
    case 'min'
        f = ordfilt2(g,1,ones(m,n),'symmetric');
    case 'midpoint'
        f1 = ordfilt2(g,1,ones(m,n),'symmetric');
        f2 = ordfilt2(g,m*n,ones(m,n),'symmetric');
        f = imlincomb(0.5,f1,0.5,f2);
    case 'atrimmed'
        if (d < 0)|(d/2 ~= round(d/2))
            error('d must b a non-negatice. Even integer.')
        end
        f = alphatrim(g,m,n,d);
    otherwise
        error('Unknown filter type.')
end
      
        
        

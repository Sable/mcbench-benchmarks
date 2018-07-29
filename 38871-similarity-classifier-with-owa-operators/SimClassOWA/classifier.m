function [class, Simil] = classifier(data, ideals, y)
%   INPUT:
%
%   data    =    datamatrix
%   ideals  =    idealvectors
%   y(1)    =    p-value in similarity measure
%   y(2)    =    alpha value for OWA weights
%   y(3)    =    used owa aggregator
%
%
%   OUTPUT:
%
%   class   =    column vector of the classes in which the samples are classified
%   Simil   =    similarity values for each class

[nc, v_dim] = size(ideals);  
d_dim = size(data,1);  
Simil = zeros(d_dim, nc); 

if nargin==2   
    y = [1, 1, 1];   
end

for j = 1 : nc  

    Ideal = repmat(ideals(j,:),d_dim,1);

    if y(3) == 1 %Using OWA with Linguistic quantifier 1
        w=owaw1(v_dim,y(2));
        tmpmatrix=(1-abs(data.^y(1)-Ideal.^y(1))).^(1/y(1));
        Simil(:,j)=owamatrix(tmpmatrix,w);
    elseif    y(3) == 2 %Using OWA with Linguistic quantifier 2
        w=owaw2(v_dim,y(2));
        tmpmatrix=(1-abs(data.^y(1)-Ideal.^y(1))).^(1/y(1));
        Simil(:,j)=owamatrix(tmpmatrix,w);
    elseif    y(3) == 3 %Using OWA with Linguistic quantifier 3
        w=owaw3(v_dim,y(2));
        tmpmatrix=(1-abs(data.^y(1)-Ideal.^y(1))).^(1/y(1));
        Simil(:,j)=owamatrix(tmpmatrix,w);
    elseif    y(3) == 4 %Using OWA with Linguistic quantifier 4
        w=owaw4(v_dim,y(2));
        tmpmatrix=(1-abs(data.^y(1)-Ideal.^y(1))).^(1/y(1));
        Simil(:,j)=owamatrix(tmpmatrix,w);
    elseif  y(3) == 5   %O'Hagan's method
        tmpmatrix=(1-abs(data.^y(1)-Ideal.^y(1))).^(1/y(1));
        weights=Ohaganw(v_dim,y(2));
        index= 1;
        w=weights(index,:);
        Simil(:,j)=owamatrix(tmpmatrix,w);
    end
    
end

[simil_val, class] = max(Simil');
class=class';
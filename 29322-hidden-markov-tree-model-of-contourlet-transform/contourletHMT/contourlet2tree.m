% contourlet2tree.m
% written by: Duncan Po
% Date: August 24, 2002
% convert the contourlet coefficients from subband structure to tree structure
% Usage: [tree, scaling] = contourlet2tree(coef, dir)
% Inputs:   coef        - contourlet coefficients
%           dir         - the directional coefficients to be processed
% Output:   tree        - the resulting tree structure
%           scaling     - the scaling function of the coefficients

function [tree, scaling] = contourlet2tree(coef, dir) 

M = length(coef{2});
nlevel = length(coef)-1;

for l = 2:nlevel+1
    levndir(l-1) = log2(length(coef{l}));
end;

scaling = coef{1};

for r = 1:(length(levndir)-1)
    if levndir(r+1)==levndir(r)
        split(r) = 0;
    elseif levndir(r+1)-levndir(r)==1
        split(r) = 1;
    else
        return;
    end;
end;
    
for l=2:nlevel+1 
    if dir> M/2  
      for i=1+2^(levndir(l-1)-levndir(1))*(dir-1):2^(levndir(l-1)-levndir(1))*dir
          coef{l}{i} = coef{l}{i}.';
      end;
    end;
end;
    
for l=2:nlevel+1 
    if (l>2) & (levndir(l-1)~=levndir(1))
        j=1;
        if split(l-2)==1
            for i=1+2^(levndir(l-1)-levndir(1))*(dir-1):2:2^(levndir(l-1)-levndir(1))*dir
                coef{l}{j} = type3transform(coef{l}{i},coef{l}{i+1}); 
                j = j + 1;
            end;
        else
            for i=1+2^(levndir(l-1)-levndir(1))*(dir-1):2:2^(levndir(l-1)-levndir(1))*dir
                coef{l}{j} = type4transform(coef{l}{i},coef{l}{i+1});
                j = j + 1;
            end;
        end;
        
        i=length(coef{l})/length(coef{2})/2;
        while i>1
            j=1;
            for k=1:2:i
                coef{l}{j} = type4transform(coef{l}{k}, coef{l}{k+1});
                j = j+1;
            end;
            i = i/2;
        end;
        interimstructure{l-1} = coef{l}{1};        
    else;
        interimstructure{l-1} = coef{l}{dir};
    end;
end;

tree{1} = interimstructure{1}(:);
for l = 2:nlevel
    tree{l} = [];
    for col = 1:2:size(interimstructure{l}, 2)
        temp = interimstructure{l}(:,col:col+1);
        temp = temp.';
        tree{l} = [tree{l}; temp(:)];
    end;
end;

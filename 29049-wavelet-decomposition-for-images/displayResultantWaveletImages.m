function displayResultantWaveletImages(A, H, V, D, levelOfDecomposition, mode)
%DISPLAYRESULTANTIMAGES 
 
level = levelOfDecomposition;

if strcmp(mode,'tree')
    aff = 0;
    
    for k = 1:level
        subplot(level,4,aff+1); image(A{k});
        title(['Approximation A',num2str(k)]);
        subplot(level,4,aff+2); image(H{k});
        title(['Horizontal Detail ',num2str(k)]);
        subplot(level,4,aff+3); image(V{k});
        title(['Vertical Detail ',num2str(k)]);
        subplot(level,4,aff+4); image(D{k});
        title(['Diagonal Detail ',num2str(k)]);
        aff = aff + 4;
    end
    
elseif strcmp(mode,'square')
    dec = cell(1,level);
    dec{level} = [A{level} H{level} ; V{level} D{level}];
    
    for k = level-1:-1:1
        dec{k} = [imresize(dec{k+1},size(H{k})) H{k} ; V{k} D{k}];
    end
    
    image(dec{1});
    % imshow(dec{1}, []);    
end

end


function plotwavelet2(C,S,level,wavelet,rv,mode)

%   Plot wavelet image (2D) decomposition.
%   A short and simple function for displaying wavelet image decomposition
%   coefficients in 'tree' or 'square' mode
%
%   Required : MATLAB, Image Processing Toolbox, Wavelet Toolbox
%
%   plotwavelet2(C,S,level,wavelet,rv,mode)
%
%   Input:  C : wavelet coefficients (see wavedec2)
%           S : corresponding bookkeeping matrix (see wavedec2)
%           level : level decomposition 
%           wavelet : name of the wavelet
%           rv : rescale value, typically the length of the colormap
%                (see "Wavelets: Working with Images" documentation)
%           mode : 'tree' or 'square'
%
%   Output:  none
%
%   Example:
%
%     % Load image
%     load wbarb;
%     % Define wavelet of your choice
%     wavelet = 'haar';
%     % Define wavelet decomposition level
%     level = 2;
%     % Compute multilevel 2D wavelet decomposition
%     [C S] = wavedec2(X,level,wavelet);
%     % Define colormap and set rescale value
%     colormap(map); rv = length(map);
%     % Plot wavelet decomposition using square mode
%     plotwavelet2(C,S,level,wavelet,rv,'square');
%     title(['Decomposition at level ',num2str(level)]);
%
%
%   Benjamin Tremoulheac, benjamin.tremoulheac@univ-tlse3.fr, Apr 2010

A = cell(1,level); H = A; V = A; D = A;

for k = 1:level
    A{k} = appcoef2(C,S,wavelet,k); % approx
    [H{k} V{k} D{k}] = detcoef2('a',C,S,k); % details  
    
    A{k} = wcodemat(A{k},rv);
    H{k} = wcodemat(H{k},rv);
    V{k} = wcodemat(V{k},rv);
    D{k} = wcodemat(D{k},rv);
end

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
    
end

end
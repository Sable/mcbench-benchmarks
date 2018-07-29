function searchImageHist(imageName, modelName, nResults)

% function searchImageHist(imageName, modelName, nResults)
% Image retrieval m-file
%
% 
%
% (c) 2008 Theodoros Giannakopoulos
% tyiannak@di.uoa.gr
% http://www.di.uoa.gr/~tyiannak
%

% load train model:
load(modelName);

% compute 3-D image histograms (HSV color space):
fprintf('Computing 3-D (HSV) histogram for query image...\n');
[Hist, RGBQ] = getImageHists(imageName);

% number of training samples:
Nfiles = length(Hists);

% decision thresholds:
t = 0.010;
t2 = 0.8;

fprintf('Searching...\n');

range = 0.0:0.1:1.0;
rangeNew = 0.0:0.05:1.0;
[x,y,z]    = meshgrid(range);
[x2,y2,z2] = meshgrid(rangeNew);

Hist = INTERP3(x,y,z,Hist,x2,y2,z2);

Similarity = zeros(Nfiles, 1);

for (i=1:Nfiles) % for each file in database:
    
    % compute (normalized) eucledean distance for all hist bins:
    HistT = INTERP3(x,y,z,Hists{i},x2,y2,z2);
    DIFF = abs(Hist-HistT) ./ Hist;
    
    % keep distance values for which the corresponding query image's values
    % are larger than the predefined threshold:    
    DIFF = DIFF(Hist>t);
    
    % keep error values which are smaller than 1:
    DIFF2 = DIFF(DIFF<t2);
    L2 = length(DIFF2);
    
    % compute the similarity meaasure:
    Similarity(i) = length(DIFF) * mean(DIFF2) / (L2^2);
    
    % (interface): plot images with small similarity measures:
    plotThres = 0.5 * 10 / length(DIFF);
    if (Similarity(i) < plotThres)
%        fprintf('%70s %5.2f %5d %5d\n', files{i}, median(DIFF2),
%        length(DIFF), L2);
        subplot(2,2,1);imshow(RGBQ);
        title('Query image');        
        RGB = imread(files{i});
        subplot(2,2,2);imshow(RGB);
        title('A similar image ... Still Searching ...');        
        subplot(2,2,3);
        plot(DIFF)

        if (length(DIFF2)>1)
            subplot(2,2,4); plot(DIFF2);
            axis([1 length(DIFF2) 0.2 1])
        end
        drawnow
    end
end

% find the nResult "closest" images:
[Sorted, ISorted] = sort(Similarity);

NRows = ceil((nResults+1) / 3);

% plot query image:
subplot(NRows,3,1); imshow(RGBQ); title('Query Image');

% ... plot similar images:
for (i=1:nResults)
    RGB = imread(files{ISorted(i)});
	str = sprintf('Im %d: %.3f',i,100*Sorted(i));
    subplot(NRows,3,i+1); imshow(RGB);  title(str);
end

fprintf('Done\n');
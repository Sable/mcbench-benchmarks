function [ Is ] = emmpm(I, regions, varargin)
% EMMPM Segments an image using the EM/MPM method.
%
%    Is = emmpm(I) returns an uint8 matrix Is representing the segmented image. 
%    Each entry of Is is an integer between 1 and 'regions'. 'regions'
%    defines in how many regions the image I will be segmented.
%
%    EMMPM defines optional arguments:
%
%      EMMPM(I, regions, steps, mpmSteps, coolMax, coolInc)
%
%    steps: Defines the number of iterations in the segmentation process
%    (default = 5);
%    mpmSteps: Defines the number of repetitions of the MPM algorithm at
%    each iteration of the segmentation process (default = 1);
%    coolMax: Defines the maximum cooling rate (default = 1.2);
%    coolInc: Defines how much the cooling rate is incremented at each
%    iteration (default = 0.025).
%
%    The EM/MPM method is iterative that stabilizes after a number of
%    iterations. Usually, a higher number of iterations yelds better
%    segmentation but increases segmentation time.
%
%    coolMax and coolInc control the segmentation cooling rate. Higher
%    cooling rates stabilize the segmentation process. In early stages of
%    segmentation, it is desired to have a low cooling rate.
%
%    Author
%    ------
%    Alceu Ferraz Costa 
%    email: alceufc [at] icmc [dot] usp [dot] br

    % If necessary, convert I to a grayscale image with bit-depth of 8.
    I = im2uint8(I);
    if size(I,3) ~= 1
        I = rgb2gray(I);
    end;
    
    % Check optional arguments.
    if nargin >= 3
        steps = varargin{1};
    else
        steps = 3; % Default value;
    end;
    
    if nargin >= 4
        mpmSteps = varargin{2};
    else
        mpmSteps = 3; % Default value;
    end;
    
    if nargin >= 5
        coolMax = varargin{3};
    else
        coolMax = 1.2; % Default value;
    end;
    
    if nargin >= 6
        steps = varargin{4};
    else
        coolInc = 0.025; % Default value;
    end;
    
    % Initial cooling rate (difPenalty):
    difPenalty = 0.5;
    
    % We initialize with a pre-segmentation using a recursive Otsu
    % algorithm.
    Is = uint8(zeros(size(I)));
    maxGrayValue = double(intmax('uint8'));
    T = [0; otsurec(I, regions - 1); 1];
    for t = 1 : size(T, 1) - 1
        tA = T(t) * maxGrayValue;
        tB = T(t + 1) * maxGrayValue;
        Is((I >= tA) & (I <= tB)) = t;
    end;
    
    % The parameter vector is used to store the mean graylevel and graylevel
    % variance for each region in the segmented image.
    [meanVector, varianceVector] = initializeParameters(I, Is, regions);
    
    % Pad the segmented image in order to make comparison of different
    % neighbor labels more efficient.
    isPad = [1,1];
    Is = padarray(Is, isPad);
    
    % Stores the number of different neighbors in Is.
    difsAt = zeros(size(Is,1), size(Is,2), regions);
    
    % pdfMatrix stores the estimated PDF.
    % chanceMatrix(i, j, k)
    %     i: label
    %     j: gray level
    %     k: number of different neighbors
    
    pdfMatrix = zeros(regions, maxGrayValue + 1, 9);

    % labelAssignedVector: stores how many times a pixel received a label
    % 'k' during a call to the mpm function.
    % labelAssignedVector(i, j, k):
    %     i: image row
    %     j: image column
    %     k: label
    labelAssignedVector = zeros([size(I) regions]);
    
    for i = 1: steps
        if difPenalty < coolMax
            difPenalty = difPenalty + coolInc;
        end;
        
        mpm();
        em();
        labelAssignedVector = labelAssignedVector .* 0.0;
    end;
    
    % Note: nested functions are used to avoid reallocation of memory at
    % every iteration. Memory allocation *is* a major bottleneck in this
    % algorithm.
    
    % -- Nested function. -- %
    function [] =  mpm()
        M_1_PI = 1 / pi;
        % Update the pdfMatrix.
        for label = 1 : regions
            for grayLvl = 1 : maxGrayValue
                for difNeigh = 0 : 8
                    mean = meanVector(label);
                    variance = varianceVector(label);

                    if variance == 0.0
                        pdfMatrix(label, grayLvl + 1, difNeigh + 1) = 0.0;
                    else
                        dif = grayLvl - mean;
                        pdfMatrix(label, grayLvl + 1, difNeigh + 1) = sqrt(M_1_PI / variance / 2) * exp( - dif * dif / (2 * variance) - difPenalty * difNeigh);
                    end;
                end;
            end;
        end;
        
        for mpmStep = 1 : mpmSteps
            difNeighbors();
            
            % Vector to store random number. It is more efficient to 
            % generate a vector of random numbers thatn computing a random 
            % number at a time.
            randomVector = rand(size(I));
            for row = 1 : size(I, 1)
                for col = 1 : size(I, 2)
                    labelChance = zeros(regions, 1);
                    
                    for label = 1 : regions
                        difNeighs = difsAt(row, col, label);
                        labelChance(label) = pdfMatrix(label, I(row, col) + 1, difNeighs + 1);
                    end;
                    
                    newLabel = generateLabelSample(row, col, randomVector, labelChance, regions);
                    labelAssignedVector(row, col, newLabel) = labelAssignedVector(row, col, newLabel) + 1;
                    Is(row + isPad(1, 1), col + isPad(1, 2)) = newLabel;
                end;
            end;
        end;
    end % End of mpm().

    % -- Nested function. -- %
    function [ ] = em()
        for label = 1 : regions
            aux1 = 0.0;
            aux2 = 0.0;
            
            for row = 1 : size(I, 1)
                for col = 1 : size(I, 2)
                    aux1 = aux1 + labelAssignedVector(row, col, label);
                    aux2 = aux2 + labelAssignedVector(row, col, label) * double(I(row, col));
                end;
            end;
           
            if aux1 ~= 0.0
                meanVector(label) = aux2 / aux1;
            end;
            
            aux2 = 0.0;
            for row = 1 : size(I, 1)
                for col = 1 : size(I, 2)
                    dif = double(I(row, col)) - meanVector(label);
                    aux2 = aux2 + dif * dif * labelAssignedVector(row, col, label);
                end;
            end;
            
            if aux1 ~= 0.0
                varianceVector(label) = aux2 / aux1;
            end;
        end;
    end % End of em().

    % -- Nested function. -- %
    function [ newLabel ] = generateLabelSample(row, col, randomVector, labelChance, regions)
        newLabel = 1;
        apf = labelChance(newLabel);
        
        apfMax = 0.0;
        for label = 1 : regions
            apfMax = apfMax + labelChance(label);
        end;

        % Compute a uniform random number in the interaval [0.0, apfMax] from
        % randomVector(randomPos).
        randomSample = apfMax * randomVector(row, col);
        
        while apf < randomSample
            newLabel = newLabel + 1;
            apf = apf + labelChance(newLabel);
        end;
    end

    % -- Nested function. -- %
    function [ ] = difNeighbors()
        difsAt = difsAt .* 0;
        
        % Start by counting how many neighbors we have with a given label.
        for row = 2 : size(difsAt, 1) - 1
            for col = 2 : size(difsAt, 2) - 1
                label = Is(row, col);
                difsAt(row - 1, col - 1, label) = ...
                difsAt(row - 1, col - 1, label) + 1;
                
                difsAt(row - 1, col, label) = ...
                difsAt(row - 1, col, label) + 1;
            
                difsAt(row - 1, col + 1, label) = ...
                difsAt(row - 1, col + 1, label) + 1;
            
                difsAt(row, col + 1, label) = ...
                difsAt(row, col + 1, label) + 1;
            
                difsAt(row + 1, col + 1, label) = ...
                difsAt(row + 1, col + 1, label) + 1;
                
                difsAt(row + 1, col, label) = ...
                difsAt(row + 1, col, label) + 1;
                
                difsAt(row + 1, col - 1, label) = ...
                difsAt(row + 1, col - 1, label) + 1;
                
                difsAt(row, col - 1, label) = ...
                difsAt(row, col - 1, label) + 1;
            end;
        end;

        % Now we compute the number of different neighbors with a given value 
        % at each position.
        for row = 2 : size(difsAt, 1) - 1
            for col = 2 : size(difsAt, 2) - 1
                for label = 1 : regions
                    difsAt(row, col, label) = 8 - difsAt(row, col, label);
                end;
            end;
        end;
    end

    % Remove Is padding.
    Is = Is(2 : size(Is,1) - 1, 2 : size(Is,2) - 1);
    
    % Apply median filtering to smooth segmentation.
    Is = medfilt2(Is);
    % Remove the borders of the median filter output.
    Is = Is(2 : size(Is,1) - 1, 2 : size(Is,2) - 1);
end % End of emmpm()

function [meanVector, varianceVector] = initializeParameters(I, Is, regions)
    meanVector = zeros(regions, 1);
    varianceVector = zeros(regions, 1);
    
    for label = 1 : regions
        meanVector(label) = mean(I(Is == label));
        varianceVector(label) = var(double(I(Is == label)));
    end;
end
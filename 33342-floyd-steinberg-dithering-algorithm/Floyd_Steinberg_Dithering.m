function D = Floyd_Steinberg_Dithering(G)
% ================================================================
% FUNCTION Floyd_Steinberg Dithering Algorithm
%
% Input: G = a 8-bit grayscale / color image
% Output: D = dithered image of G's format with only values 0 and 255 of the same 
% ----------------------------------------------------------------
% Demo:
%        G = imread('peppers.png');
%        D = Floyd_Steinberg_Dithering(G);
%        figure('position',[50,50,600,900]),subplot(211),imshow(G),title('Original Image');
%        subplot(212),imshow(D),title('Dithered Image');
% ----------------------------------------------------------------
% For more details about Floyd Steinberg Dithering Algorithm
% Please check
% http://en.wikipedia.org/wiki/Floyd%E2%80%93Steinberg_dithering
% ----------------------------------------------------------------
% Oct. 18th 2011
% By Yue Wu,
% Department of Electrical and Computer Engineering
% Tufts University,
% Medford, MA 02155
% ================================================================

switch size(G,3)
    case 1
    G = double(G); % convert the original image from unit8 to double
    D = zeros(size(G)); % initialize dithered image D
    [M,N] = size(G); % extract size information of the original image
    for r = 1:M
        % applying '2'-like scanning order 
        % ->>>>>>>>>>>>>>>>>>>>>>>-
        %                        |
        % -<<<<<<<<<<<<<<<<<<<<<<<-
        % |
        % ->>>>>>>>>>>>>>>>>>>>>>>-
        if mod(r,2) == 0 % scan pixel from left to right
            cOrder = 1:N; 
            direction = 'l2r';
        else % scan pixel from right to left
            cOrder = N:-1:1; 
            direction = 'r2l';
        end  
        for c = cOrder
            tP = G(r,c); % current pixel intensity
            % pick nearest intensity scale two options 0 or 255
            if tP>=128 % close to 255
                D(r,c) = 255; % pick 255
            else % close to 0
                D(r,c) = 0; % pick 0
            end
            eP = tP-D(r,c); % difference before and after selection
            % diffuse difference eP to neighbor pixels
            if r~=M % deal with none bottom rows
                switch direction
                    case 'l2r'
                        if c == 1 % left-most pixel case
                            G(r,c+1) = G(r,c+1)+eP*7/13;
                            G(r+1,c) = G(r+1,c)+eP*5/13;
                            G(r+1,c+1) = G(r+1,c+1)+eP*1/13; 
                        elseif c == N % deal with the right-most pixel case
                            G(r+1,c) = G(r+1,c)+eP*5/8;
                            G(r+1,c-1) = G(r+1,c-1)+eP*3/8;
                        else % the normal case
                            G(r,c+1) = G(r,c+1)+eP*7/16;
                            G(r+1,c) = G(r+1,c)+eP*5/16;
                            G(r+1,c+1) = G(r+1,c+1)+eP*1/16;
                            G(r+1,c-1) = G(r+1,c-1)+eP*3/16;
                        end
                    case 'r2l'
                        if c == N % right-most pixel case
                            G(r,c-1) = G(r,c-1)+eP/2;
                            G(r+1,c) = G(r+1,c)+eP*3/8;
                            G(r+1,c-1) = G(r+1,c-1)+eP*1/8; 
                        elseif c == 1 % left-most pixel case
                            G(r+1,c) = G(r+1,c)+eP*5/8;
                            G(r+1,c+1) = G(r+1,c+1)+eP*3/8;
                        else % normal case
                            G(r,c-1) = G(r,c-1)+eP*7/16;
                            G(r+1,c) = G(r+1,c)+eP*5/16;
                            G(r+1,c-1) = G(r+1,c-1)+eP*1/16;
                            G(r+1,c+1) = G(r+1,c+1)+eP*3/16;
                        end
                end
            else % deal with the bottom row
                switch direction
                    case 'l2r'
                        if c ~=N % normal case
                            G(r,c+1) = G(r,c+1)+eP;
                        end
                    case 'r2l'
                        if c ~= 1 % normal case
                            G(r,c-1) = G(r,c-1)+eP;
                        end
                end
            end
        end
    end
    otherwise % if the input image is not one-layer gray-scale image, then apply algorithm with respect to each layer
        for i = 1:size(G,3)
            tD = Floyd_Steinberg_Dithering(G(:,:,i));
            D(:,:,i) = tD;
        end
end

D = uint8(D); % convert double D to uint8
            
% Author : FUAT COGUN
% Date   : 16.07.2009
%
%
% Find the Covariance Matrix of given region.
% 
%
% Inputs  : -I                                                  (uint8 Matrix)
% ======    -x position                                         (Integer)
%           -y position                                         (Integer)
%           -size                                               (Integer)
%
% Outputs : -Covariance Matrix                                  (7x7 Matrix)
% =======   

function CR = findCovarianceMatrix(I, positionX, positionY, size) 

    % First and second derivatives
    d = [-1 0 1];
    dd = [-1 2 -1];
    dI = double(I);

    % Ix, Iy, Ixx, Iyy
    Ix = conv2(d, dI);
    Iy = conv2(d,1,dI);
    Ixx = conv2(dd, dI);
    Iyy = conv2(dd,1,dI);

    for j = 1:size
        for i = 1:size

            f(i+(j-1)*size,:) = [positionX+i-1 positionY+j-1 dI(positionY+j-1, positionX+i-1) ...
                         Ix(positionY+j-1, positionX+i-1) Iy(positionY+j-1, positionX+i-1) ...
                        Ixx(positionY+j-1, positionX+i-1) Iyy(positionY+j-1,positionX+i-1)];

        end
    end

    % vector of means of features in region R
    uR = mean(f);

    T = zeros(7);
    for k = 1:size^2
        temp = (f(k,:)-uR)'*(f(k,:)-uR);
        T = T + temp;
    end

    CR = (1/size^2)*T;
function loser = updategrid(x, minHoleTime, minHoleSize, maxHoleTime, maxHoleSize)
global F
global alive
global snakeSize
global holeCountDown
global lastPos


res = size(F);
loser = 0;
for i = alive
    pixels = getpixels(x(i,:), snakeSize);
    index1 = size(F,1) * lastPos(:,i*2) + lastPos(:,i*2-1);   
    index2 = size(F,1) * pixels(:,2) + pixels(:,1);    
    F(index1) = 0;
    
    if any(pixels(:) < 1) || any(pixels(:,1) >= res(1)) || any(pixels(:,2) >= res(2))
        loser = i;
        alive(alive == i) = [];
        F(index1) = i;
        return
    end
    if sum(full(F(index2))) > 1
        alive(alive == i) = [];
        F(index1) = i;
        return
    end
    
    F(index2) = i;
    if holeCountDown(i,1) ~= 0
        F(index1) = i;
    else
        F(index1) = 0;
        holeCountDown(i,1) = 1;
        holeCountDown(i,2) = holeCountDown(i,2) - 1;
    end
    if holeCountDown(i,2) == 0
        F(index2) = i;
        holeCountDown(i,1) = round(rand() * (maxHoleTime - minHoleTime)) + minHoleTime;
        holeCountDown(i,2) = round(rand() * (maxHoleSize - minHoleSize)) + minHoleSize;
    end
    lastPos(:,i*2-1:i*2) = pixels;
end
function [mse, rmse] = RMSE2(signal1, signal2)

originalRowSize = size(signal1,1);
originalColSize = size(signal1,2);

signal1 = signal1(:);
signal2 = signal2(:);

mse = sum((signal1 - signal2).^2)./(originalRowSize*originalColSize);
rmse = sqrt(mse);

end


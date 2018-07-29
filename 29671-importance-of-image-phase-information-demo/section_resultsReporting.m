[targetFileName1, numberOfTokens] = stringTokenizer( targetFile1, '\\ /');
[targetFileName2, numberOfTokens] = stringTokenizer( targetFile2, '\\ /');

fprintf('Image 1 : %s\n', char(targetFileName1(end)));
fprintf('Image 2 : %s\n', char(targetFileName2(end)));


fprintf('\n\nReconstruction of Image 1:\n');
%% PSNR
psnr_Value = PSNR(uint8(image1InGray), uint8(imageInGray_InSpatialDomain));
fprintf('PSNR = +%5.5f dB \n', psnr_Value);
      
%% RMSE
[mse, rmse] = RMSE2(double(image1InGray), double(imageInGray_InSpatialDomain));
fprintf('MSE = %5.5f \n', mse);
fprintf('RMSE = %5.5f \n', rmse);
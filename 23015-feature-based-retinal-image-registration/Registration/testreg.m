% Li Chen and Xiaolong Zhang
% School of Computer Science and Technology
% Wuhan University of Science and Technology
% P. R. China, 430081
% Email: chenli77@wust.edu.cn


startup;

readfile1 = '.\images\1ridge_connected.tif'; %obtain blood vessel at first
imfile1 = '.\images\1.png';
readfile2 = '.\images\2ridge_connected.tif';
imfile2 = '.\images\2.png';

bw1 = 1-im2double(imread(readfile1));
bw2 = 1-im2double(imread(readfile2));
regim1 = im2double(imread(imfile1));
regim2 = im2double(imread(imfile2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find the matched points                                               %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
radius = 3;
NumMin = 20;
[linktable1, featuremat1, bw1] = points_feature(bw1, radius);
[linktable2, featuremat2, bw2] = points_feature(bw2, radius);
[P1, P2, P2idx] = featurematch(featuremat1, featuremat2, NumMin);
%-------------------
P1 = P1(find(P2idx==1));P2 = P2(find(P2idx==1));P2idx = P2idx(find(P2idx==1));
%-------------------
[outP1, outP2, mytform] = verifymatch(linktable1, linktable2, P1, P2, P2idx, bw1, bw2, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Show results                                                          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
outim1 = regim1;
outim2 = imtransform(regim2, mytform, 'XData', [1 size(outim1,2)], 'YData', [1 size(outim1,1)]);;
outmosaic = (outim1 + outim2); outmosaic(outmosaic>1) = 1;
imwrite(regim1,'.\results\mosaic_base1.jpg' );
imwrite(regim2,'.\results\mosaic_base2.jpg' );
imwrite(outmosaic,'.\results\mosaic.jpg');

bwtmp1 = points_show(bw1, linktable1(:,1), radius);
bwtmporg1 = points_showsome(bw1, linktable1(P1,:), radius);
imwrite(1-cat(3, bw1+bwtmp1, bw1+bwtmporg1 , bw1), '.\results\bw_org1.tif');
bwtmpsome1 = points_showsome(bw1, linktable1(outP1,:), radius);
imwrite(1-cat(3, bw1, bw1+bwtmpsome1 , bw1), '.\results\bw_base1.tif');

bwtmp2 = points_show(bw2, linktable2(:,1), radius);
bwtmporg2 = points_showsome(bw2, linktable2(P2,:), radius);
imwrite(1-cat(3, bw2+bwtmp2, bw2+bwtmporg2 , bw2), '.\results\bw_org2.tif');
bwtmpsome2 = bw2+points_showsome(bw2, linktable2(outP2,:), radius);
imwrite(1-cat(3, bw2, bw2+bwtmpsome2 , bw2), '.\results\bw_base2.tif');

outbw1 = bw1;
outbw2 = imtransform(bw2, mytform, 'XData', [1 size(outim1,2)], 'YData', [1 size(outim1,1)]);
outmosaicbw = 1-cat(3, outbw1, outbw2, outbw2);
imwrite(outmosaicbw, '.\results\bw_mosaic.tif');
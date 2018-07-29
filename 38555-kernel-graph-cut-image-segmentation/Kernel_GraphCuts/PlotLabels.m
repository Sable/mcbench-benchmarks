function ih = PlotLabels(L)

L = single(L);

bL = imdilate( abs( imfilter(L, fspecial('log'), 'symmetric') ) > 0.8, strel('disk', 1)); %0.1
LL = zeros(size(L),class(L));
LL(bL) = L(bL);
Am = zeros(size(L));
Am(bL) = .8;
ih = imagesc(LL); 
set(ih, 'AlphaData', Am);
colormap 'jet';
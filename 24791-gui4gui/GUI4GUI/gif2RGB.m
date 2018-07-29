function I = gif2RGB(gifFile)
[x, map] = imread(gifFile);
I = ind2rgb(x, map);
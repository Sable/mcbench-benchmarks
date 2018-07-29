function gabor_bank_test()

[gb orient]=gabor_bank(4,10,10,.05);

dip=abs(min(gb{1}(:)));

figure

subplot(2,2,1);
imshow(gb{1}+dip);
title(orient(1));

subplot(2,2,2);
imshow(gb{2}+dip);
title(orient(2));

subplot(2,2,3);
imshow(gb{3}+dip);
title(orient(3));

subplot(2,2,4);
imshow(gb{4}+dip);
title(orient(4));

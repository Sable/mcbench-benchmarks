%% 2D
load('test2D.mat');
figure('Name', 'test 2D');
% one object
subplot(3,2,1);
imshow(I);
title('I');
J = selectCc(I,[],220,648);
subplot(3,2,2);
imshow(J);
title('selectCc(I,[],220,648)');
% two objects (subscript indices)
subplot(3,2,3);
imshow(I);
title('I');
J = selectCc(I,[],[220 479],[648 157]);
subplot(3,2,4);
imshow(J);
title('selectCc(I,[],[220 479],[648 157])');
% two objects (linear indices)
subplot(3,2,5);
imshow(I);
title('I');
J = selectCc(I,[],sub2ind(size(I),[220 479],[648 157]));
subplot(3,2,6);
imshow(J);
title('selectCc(I,[],sub2ind(size(I),[220 479],[648 157])');

%% 3D
load('test3D.mat');
disp('test 3D');
rp = regionprops(I, 'Area', 'PixelIdxList', 'PixelList'); % 13623 objects
[~,i] = sort([rp.Area], 'descend');
rp = rp(i);
% subscripts indices
[i1,i2,i3] = deal(rp(5).PixelList(1,2), rp(5).PixelList(1,1), rp(5).PixelList(1,3));
J = selectCc(I,[],i1,i2,i3);
cc = bwconncomp(J);
if isequal(cc.PixelIdxList{1}, rp(5).PixelIdxList), disp('pass'); else disp('fail'); end
% Linear index
J = selectCc(I,[],rp(5).PixelIdxList(10));
cc = bwconncomp(J);
if isequal(cc.PixelIdxList{1}, rp(5).PixelIdxList), disp('pass'); else disp('fail'); end

%% 4D
load('test4D.mat');
disp('test 4D');
rp = regionprops(I, 'Area', 'PixelIdxList', 'PixelList'); % 47463 objects
[~,i] = sort([rp.Area], 'descend');
rp = rp(i);
% subscripts indices
[i1,i2,i3,i4] = deal(rp(4).PixelList(1,2), rp(4).PixelList(1,1), rp(4).PixelList(1,3), rp(4).PixelList(1,4));
J = selectCc(I,[],i1,i2,i3,i4);
cc = bwconncomp(J);
if isequal(cc.PixelIdxList{1}, rp(4).PixelIdxList), disp('pass'); else disp('fail'); end
% Linear index
J = selectCc(I,[],rp(4).PixelIdxList(10));
cc = bwconncomp(J);
if isequal(cc.PixelIdxList{1}, rp(4).PixelIdxList), disp('pass'); else disp('fail'); end
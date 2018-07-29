% The script supports warpitfun.m to demonstrate simple warping
% routine usage. On the images that you see specify pairs of 
% corresponding points to define the warping by left button click.

clear all;
close all;

% spicify your own directory here

cd('c:\Work\GET\MathworksWarping');


NPs = input('how many points do you want to use?');


getdatafile  = 'testget.bmp';
pinkdatafile = 'testpink.bmp';

pink =(imread(pinkdatafile));
get = (imread(getdatafile));

load split_cmap;
figure
Hp=subplot(1,2,1);
image(pink);
hold on;
Hg=subplot(1,2,2);
imagesc(get);
hold on;
colormap(split);
colors='rgbmy';
fprintf('Please Graphically Enter %d points',NPs);
Xp=[];
Xg=[];
Yg=[];
Yp=[];
for i = 1:NPs
    axis(Hp);
    [Yp(i),Xp(i)]=ginput(1);
    scatter(Yp(i),Xp(i),25,colors(mod(i,5)+1),'filled');
    text(Yp(i),Xp(i),num2str(i));
    axis(Hg);
    [Yg(i),Xg(i)]=ginput(1);
    scatter(Yg(i),Xg(i),25,colors(mod(i,5)+1),'filled');
    text(Yg(i),Xg(i),num2str(i));
    text(Yg(i),Xg(i),[num2str(i) '"']);
end;
pinkw  = warpitfun(pink,get,[Xp' Yp'],[Xg' Yg']);

[dx dy] = meshgrid(-3:3,-3:3);
kern = exp(-(dx.^2+dy.^2)*0.1);
pinkw = conv2(pinkw,kern,'same');

figure
imagesc(pinkw);
colormap(split);




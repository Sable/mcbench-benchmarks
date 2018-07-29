clear
clc
% im = imtest('c2');
% im = double(im);
n_it = 10;
D = 25;
im = rand(D);
SumO = sum(im(:));
cSumO = repmat(sum(im,1),D,1); %surf(cSumO);
rSumO = repmat(sum(im,2),1,D); %surf(rSumO);
var_it1 = zeros(1,n_it);
var_it2 = zeros(1,n_it);
imG1 = SumO/D^2*ones(D);
imG2 = (cSumO+rSumO)/(2*D);
for kk = 1:n_it
    cSumG1 = repmat(sum(imG1,1),D,1); %surf(cSumG1);
    rSumG1 = repmat(sum(imG1,2),1,D); %surf(rSumG1);
    cSumG2 = repmat(sum(imG2,1),D,1); %surf(cSumG2);
    rSumG2 = repmat(sum(imG2,2),1,D); %surf(rSumG2);
    imG1 = imG1+(cSumO-cSumG1)/(2*D)+(rSumO-rSumG1)/(2*D); %surf(imG1);
    imG2 = imG2+(cSumO-cSumG2)/(2*D)+(rSumO-rSumG2)/(2*D); %surf(imG2);
    % surf(imG1);
    % disp(imG1);
    x1 = (cSumO(1,:)-sum(imG1,1)) ;
    y1 = (rSumO(:,1)-sum(imG1,2))';
    x2 = (cSumO(1,:)-sum(imG2,1)) ;
    y2 = (rSumO(:,1)-sum(imG2,2))';
    var_it1(kk) = sum((x1.^2+y1.^2))/D;
    var_it2(kk) = sum((x2.^2+y2.^2))/D;
end
%imshow(uint8(imscale(imG1)));
figure
plot(var_it1,'k');
hold on
plot(var_it2,'r');

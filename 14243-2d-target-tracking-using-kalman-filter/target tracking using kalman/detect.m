%detect
clear,clc
% compute the background image
Imzero = zeros(240,320,3);
for i = 1:5
Im{i} = double(imread(['DATA/',int2str(i),'.jpg']));
Imzero = Im{i}+Imzero;
end
Imback = Imzero/5;
[MR,MC,Dim] = size(Imback);

% loop over all images
for i = 1 : 60
  % load image
  Im = (imread(['DATA/',int2str(i), '.jpg'])); 
  imshow(Im)
  Imwork = double(Im);

  %extract ball
  [cc(i),cr(i),radius,flag] = extractball(Imwork,Imback,i);%,fig1,fig2,fig3,fig15,i);
  if flag==0
    continue
  end
    hold on
    for c = -0.9*radius: radius/20 : 0.9*radius
      r = sqrt(radius^2-c^2);
      plot(cc(i)+c,cr(i)+r,'g.')
      plot(cc(i)+c,cr(i)-r,'g.')
    end
 %Slow motion!
      pause(0.02)
end

figure

  plot(cr,'g*')
  hold on
  plot(cc,'r*')
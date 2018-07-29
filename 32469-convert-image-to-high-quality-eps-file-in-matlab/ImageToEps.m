function ImageToEps(filename)
% Purpose: convert an image of type supported by Matlab to a high-quality
%          .eps file with same filename but new file extension.
% Implemented by Allan P. Engsig-Karup (apek@imm.dtu.dk), Aug 8, 2011.
imshow(filename,'border','tight','InitialMagnification',100);
idx = strfind(filename,'.');
filename = [filename(1:idx) 'eps'];
print(gcf,'-depsc',filename)
close
return

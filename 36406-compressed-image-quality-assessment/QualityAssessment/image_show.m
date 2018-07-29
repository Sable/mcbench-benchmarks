function X=image_show(img,grlvls,scale,title)
%Displays image, with additional parameters
%X = image_show(img,grlvls,scale,title)
%
%Input:
% img - image array; if the values fall outside [0,255] they will be
%       scaled
% grlvls - if it is a single value it represents the number of gray levels
%          to be displayed;
%          if grlvls is an array then it represents the colormap
% scale - scale for displaying the image
% title - name of the image figure, if it starts with 'save_' the image will be
%         saved instead. Don't forget the image format(e.g. 'save_test.png')!!
%
%Output:
% X - contains the image (useful if the image values have been scaled to
%     fit in the [0, 255] range
%
%Note:
% Works also for truecolor non-indexed images.
% If the range between the maximum and the minimum value in the image is larger
% than 2^16 then the image values will be rescaled logarithmically.
%
%Example:
% X = image_show(A,256,2,'A'); %zoom 2x

%for wavelet coefficients:
%Z2= 128+32*log2(abs(Y)+1); //high pass
%Z2(1:36,1:44) = Y(1:36,1:44)/8; //LL

LogTreshold = 10;

if isstr(img)
    img=imread(img);
end;
if numel(grlvls)>1
    mapa=grlvls;
else
    mapa=gray(grlvls);
end;
% maximg=max(img(:));
% minimg=min(img(:));
% if (maximg ~= minimg)
%     if maximg>255 | minimg<0
%         if log2(maximg-minimg)>LogTreshold
%             logimg=log2(abs(img)+1);
%             img=255*logimg/max(max(logimg));
%         else
%             img=round(255*(img-minimg)./(maximg-minimg));
%         end;
%     end;
%     if nargin<4
%         title=''
%         if nargin <3
%             scale=1;
%         end;
%     end;
% end;

set(0,'Units','pixels');
rd=get(0,'ScreenSize');
[rws,cls,ndms]=size(img);
rws=scale*rws;
cls=scale*cls;
fwd=round(cls+cls*0.1);
fhg=round(rws+rws*0.1);
if ~isempty(strmatch('save_',title))
    if ndims(img)==3
        imwrite(img,title);
    else
        imwrite(img,mapa,title);
    end;
else
    figure('Name',title,'Menubar','none','Units','pixels','Position',[(rd(3)-fwd)/2 (rd(4)-fhg)/2 fwd fhg]);
    image(img);
    if ndims(img)<3
        colormap(mapa);
    end;
    fh=gca;
    set(gca,'DataAspectRatio',[1 1 1],'TickLength',[0 0],'XTick',[],'YTick',[],'Units','pixels','Position',[cls*0.05 rws*0.05 cls rws]);
end;
X=img;
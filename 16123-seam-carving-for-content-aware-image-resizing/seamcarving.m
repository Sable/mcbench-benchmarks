function im=seamcarving(im,k)
%% illustrative example of Seam carving for content aware image resizing
%
%
% usage: carvedimg=seamcarving(im,k)
%
% k is how many vertical seams to remove.
% im is the image.
%
% example:
%   img=imread('peppers.png')
%   carvedimg=seamcarving(img,50)
%   image([carvedimg img]);
%   axis equal;
%
% Author: Aslak Grinsted 2007...
% Based on ideas from Avidan & Shamir:
% http://video.google.com/videoplay?docid=-6221880321193117495
% Note i havent read their paper and they have probably lots of smart tricks
% for optimizations.
%

demo=nargout==0;
if nargin==0
    fex={'peppers.png' 'liftingbody.png' 'pears.png' 'trees.tif' 'football.jpg' 'onion.png'};
    fex=fex{ceil(rand*length(fex))};
    try
        [im,map]=imread(fex);
    catch
        [im,map]=imread('street1.jpg');
    end
    k=50;
end
im=im2double(im);





if demo
    close(findobj(0,'type','figure','tag','seam carving demo'));
    figure; set(gcf,'tag','seam carving demo','name','Seam Carving','NumberTitle','off')
    axes('position', [0 0 1 1]);
    if size(im,3)==1
        im=im/max(im(:));
        him=imagesc(im);
        colormap gray
    else
        him=image(im);
    end
    origim=im;
    axis equal
    axis off
end


for jj=1:k
    G=costfunction(im);
    %find shortest path in G
    Pot=G;
    for ii=2:size(Pot,1)
        pp=Pot(ii-1,:);
        ix=pp(1:end-1)<pp(2:end);
        pp([false ix])=pp(ix);
        ix=pp(2:end)<pp(1:end-1);
        pp(ix)=pp([false ix]);
        Pot(ii,:)=Pot(ii,:)+pp;
    end

    %Walk down hill
    pix=zeros(size(G,1),1);
    [mn,pix(end)]=min(Pot(end,:));
    pp=find(Pot(end,:)==mn);
    pix(end)=pp(ceil(rand*length(pp)));
    
    im(end,pix(end),:)=nan;
    for ii=size(G,1)-1:-1:1
        %[mn,gg]=min(Pot(ii,pix+(-1:1)));
        [mn,gg]=min(Pot(ii,max(pix(ii+1)-1,1):min(pix(ii+1)+1,end)));
        pix(ii)=gg+pix(ii+1)-1-(pix(ii+1)>1);
        im(ii,pix(ii),:)=bitand(ii,1);
%        G(ii,pix(ii))=1;
    end

    if demo
        set(him,'CDATA',im);
        %set(him,'CDATA',G,'CDataMapping','scaled');
        drawnow;
    end

    %remove seam from im & G:
    for ii=1:size(im,1)
%        G(ii,pix(ii):end-1)=G(ii,pix(ii)+1:end);
        im(ii,pix(ii):end-1,:)=im(ii,pix(ii)+1:end,:);
    end
    im(:,end,:)=[];
%    G(:,end)=[];

end

if demo
    set(him,'CDATA',[im origim])
    axis tight
end
if nargout==0
    clear im
end


    function G=costfunction(im) %%(xi,yi)
            G=zeros(size(im,1),size(im,2));
            for ii=1:size(im,3)
                %G=G+abs(filter2([1 0 -1],im(:,:,ii)))+abs(filter2([1;0;-1],im(:,:,ii))); 
                G=G+(filter2([.5 1 .5; 1 -6 1; .5 1 .5],im(:,:,ii))).^2; %faster and reasonably good.
            end
    end
end

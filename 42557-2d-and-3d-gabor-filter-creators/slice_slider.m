function slice_slider(invol)
% SLICE_SLIDER(3d_volume) plots a 3d volume 1 slice at a time 
%   on the current figure. 
% A slider bar allows you to slice through the volume. 
% Assumes that you want to look at the third dimension using 
%   imagesc and the default colormap.
% Fix it/make it better if you want to.
%
%
% Frederick Bryan, 2013

invol = invol(:,:,:,1,1,1,1,1,1);

mid = ceil(size(invol,3)/2);
top = size(invol,3);
step = [1, 1] / (top - 1);

h=gcf; 

clf(h,'reset'); 

if length(unique(invol(:)))>500
    invol = img_normalize(invol);
    limits = [0 1];
    ccc = 'gray';
else
    limits = [min(invol(:)) max(invol(:))];
    ccc = 'jet';
end
if limits(2) <= limits(1); limits = [0 1]; end % fix limits (0 case)

figure(h);  
    
uicontrol('Style','slider','Min',1,'Max',top,'Value',mid,...
    'SliderStep', step, 'Position',[10 10 150 25],...
    'Callback',{@changeslice,invol,limits,ccc});
changeslice(get(h,'Children'),[],invol,limits,ccc) % find image in middle
                                               % and pass args to funct
end

function changeslice(src,~,invol,limits,ccc)
% update slice by reploting figure
    newsl = get(src,'Value');
%     disp(newsl)
    imagesc(invol(:,:,round(newsl)),limits);  
        colormap(ccc);
        title(sprintf('%3.0i',round(newsl)));axis off; 
end

function L=LUT2label(im,LUT)
% Create a label image using LUT obtained from a clustering operation of 
% grayscale data.  

% Intensity range
Imin=min(im(:));
Imax=max(im(:));
I=Imin:Imax;

% Create label image
L=zeros(size(im),'uint8');
for k=1:max(LUT)
    
    % Intensity range for k-th class
    i=find(LUT==k);
    i1=i(1);
    if numel(i)>1
        i2=i(end);
    else
        i2=i1;
    end
    
    % Map the intensities in the range [I(i1),I(i2)] to class k 
    bw=im>=I(i1) & im<=I(i2);
    L(bw)=k;
    
end


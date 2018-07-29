function im = image_read(filename)
fid = fopen(filename,'r');

im = zeros(256,256);
for i=1:256
    for j=1:256
         im(i,j) = fread(fid,1,'uint8');
    end
end

im = (uint8(im));
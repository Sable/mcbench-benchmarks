function i_rect = im_project(im,ps,rr,dim)

rr_min   = min(rr(1,:));
rr_max   = max(rr(2,:));
rr_width = uint32(rr_max-rr_min);
nr_lines = size(rr,2);

i_rect = zeros(dim',class(im));

skipped=0;
for line = 1:nr_lines
    for jj = 1:size(ps{line},2)
        x = ps{line}(1,jj);
        y = ps{line}(2,jj);
        [val,flag] = get_pixel(im,[x;y]);
        if flag == 1
            if dim(3) == 1
                i_rect(line,uint32(rr(1,line)-rr_min)+jj) = val;
            else
                i_rect(line,uint32(rr(1,line)-rr_min)+jj,:) = val;
            end
            skipped = skipped + 1;
        end
    end
end

fprintf('skipped %d of total pixels\n',skipped/(rr_width*nr_lines));
fprintf('original image: %g by %g = %d pixls\n',dim(1),dim(2),prod(dim));
fprintf('new image: %d by %d = %d pixels\n',rr_width,nr_lines,rr_width*nr_lines);
fprintf('orig_size/new_size = %f\n',double(prod(dim))/double((rr_width*nr_lines)));
function [filter_bank ang_s]=gabor_bank(bank_size,sigma_x,sigma_y,freq)

ang_s=fix(linspace(0,180,bank_size));
angs=deg2rad(ang_s);

filter_bank=cell(length(angs),1);
for i=1:length(angs),
    filter_bank{i}=gabor_fn(sigma_x,sigma_y,angs(i),freq);
end


function [sh,prob,score]=subpixel_register(hr_image,lr_image,ds,sr,sigma)

if ~exist('sigma','var')
    sigma=40;
end
if sigma < 0
    sigma=40;
end
sid=1;
sranges={};
sigma2=sigma*sigma;
for id=sr(1):sr(2) % search range
    for jd=sr(3):sr(4)
        sranges{sid}=[id jd];
        t=gen_shift_downsample_image(hr_image,ds,[id jd]);
        score(sid)=prod(prod(exp(-(t-lr_image).^2/(2*sigma*sigma))));
        
        sid=sid+1;
    end
end

[dummy,mid]=max(score);
prob=dummy/sum(score);
sh=sranges{mid};
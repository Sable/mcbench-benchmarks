function image=sr_bw(t2,handle_wb,offset_wb,scale_wb,ds,max_shift,th_prob1,th_prob2,no_iter)

if ~exist('ds','var')
    ds=4; % four time super resolution
end
if ~exist('max_shift','var')
    max_shift=8;
end
if ~exist('th_prob1','var')
    th_prob1=0.9;
end
if ~exist('th_prob2','var')
    th_prob2=0.85;
end
if ~exist('no_iter','var')
    no_iter=2;
end

fprintf('start SR\n...');
search_range=[-max_shift max_shift -max_shift max_shift];   
image=kron(t2{1},ones(ds));

sigma=-1; % use the default sigma to estimate prob (see also subpixel_register.m)
fprintf('start super-resolution 1st phase...\n');
tic
[image,probs,shs,scores]=sr_one_step_wb(image,t2,'average',ds,search_range,sigma,th_prob1,handle_wb,offset_wb,scale_wb/2); %,...
toc

fprintf('start super-resolution 2nd phase...\n');
for iter=1:no_iter
    tic
    [image,probs,shs,scores]=sr_one_step_wb(image,t2,'sort_pocs',ds,search_range,sigma,th_prob2,handle_wb,offset_wb+(iter-1)*scale_wb/2/no_iter+scale_wb/2,scale_wb/2/no_iter);
    toc
    iter
    if length(find(probs>th_prob2))==length(probs)
          break;
    end
end


function out = vad_test(snoi,model,coeff)

ls = length(snoi);

%%
Fs = 8000;
winLS = 1*32e-3; % [Sec] Sliding window duration
winL = winLS*Fs; % [Samples] Sliding window length
winOLS = 10e-3; % [Sec] Sliding window overlap duration
winOlL = winOLS*Fs; % [Samples] Sliding window overlap length
%%
xwin = buffer(snoi,winL,winOlL,'nodelay');
[m n]=size(xwin);  
%% feature extraction
for f=1:n
    sfr = xwin(:,f);
    [wpt,N,coef] = pwpdsub(sfr);  
    t=1;
    [Pxx,w] = pwelch(sfr);
    [xmax,imax,xmin,imin] = extrema(Pxx);
    fe(f,t) =  sum(xmax);
    t = t+1;
    fe(f,t) = entropy(abs(sfr));
    t = t+1;
    fe(f,t)= sum(abs(xcorr(sfr,'biased')));
    t = t+1;
    for i=1:length(N)
        fe(f,t) = mean(coef{i});
        t = t+1;
    end
end
%% adding delta
fv =fe;
for f=1:n
    if f==1
        del = (fe(f+1,:)+fe(f+2,:))/2;
        
    elseif f==n
        del = (fe(f-2,:)+fe(f-1,:))/2;
        
    else
        del = (fe(f+1,:)+fe(f-1,:))/2;
    end
    fv(f,21:40)=del;
end

%% adding noise information
fn = (fe(1,:)+fe(2,:)+fe(3,:)+fe(4,:))/4;
for i=1:n
    fv(i,41:60)=fn;
end



%%  svm classification

fv2 = fv*coeff;

fv2=fv2(:,1:33);
[out] = svmpredict(ones(size(fv,1),1), fv2, model, '-b 0');


%% overlap add

for i=1:n
    c =  double(out(i));
    va = c*ones(1,winL);
    yh(:,i) = va;  %...
end

y1 = yh(1:winL-winOlL,:);
[m n] = size(y1);
y2 = reshape(y1,[m*n 1]);
y2 ((m*n)+1:ls) = yh(m+1:m+(ls-m*n),n);

out=y2(1:length(snoi));
%%
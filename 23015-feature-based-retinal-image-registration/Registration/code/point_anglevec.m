function anglevec = point_anglevec(bw, seed, R) 

% This function generate the anglevector that surrounds the seed

[M, N]= size(bw);

% image(i,j) <==>(j-1)*M + i
idy = mod(seed, M);
if (idy==0) idy=M; end
idx = 1 + (seed - idy)/M;

if ( idy>R ) & ( idx>R ) & ( (idy+R)<=M ) & ( (idx+R)<=N )
    region = bw(idy-R:idy+R, idx-R:idx+R);
    [labelmap, numlabel] = bwlabel(region,8);
    mask = (labelmap == labelmap(1+R,1+R));
    region = region.*mask;
    % counterclock starts from 3'oclock
    anglevec = [region(R+1:-1:1,end)', region(1, end-1:-1:2), region(1:end,1)', region(end,2:end-1), region(end:-1:R+2,end)'];
else
    Len = 8 * R;
    anglevec = zeros(1, Len);
end
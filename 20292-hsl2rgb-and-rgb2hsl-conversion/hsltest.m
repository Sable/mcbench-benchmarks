% A few crude tests for rgb2hsl.m and hsl2rgb.m
% If you find a bug in the conversion add a test here that exposes it.
%
% (C) Vladimir Bychkovsky June 2008
%

% ideas for improvement:
% - factor out the testing code
% - rewrite using some sort of Matlab unit testing frame work

function hsltest()
% --------- Test rgb2hsl conversions ------------
rgb=[0,0,0];
test_hsl=[0,0,0];
hsl=rgb2hsl(rgb);
if min(hsl==test_hsl)==0
    fprintf('E');
    rgb
    test_hsl
    hsl
    return;
else
    fprintf('.');
end

rgb=[0.5,0,0];
test_hsl=[0,1,0.25];
hsl=rgb2hsl(rgb);
if min(hsl==test_hsl)==0
    fprintf('E');
    rgb
    test_hsl
    hsl
    return;
else
    fprintf('.');
end


rgb=[0.5,0.3,0];
test_hsl=[36.0/360,1,0.25];
hsl=rgb2hsl(rgb);
if min(hsl==test_hsl)==0
    fprintf('E');
    rgb
    test_hsl
    hsl
    return;
else
    fprintf('.');
end

rgb=[0.5,0.5,0.5];
test_hsl=[0,0,0.5];
hsl=rgb2hsl(rgb);
if min(hsl==test_hsl)==0
    fprintf('E');
    rgb
    test_hsl
    hsl
    return;
else
    fprintf('.');
end

% 2d test
rgb=[0.5,0.5,0.5;...
     0.5,0.3,0];
test_hsl=[0,0,0.5;
     36.0/360,1,0.25];
hsl=rgb2hsl(rgb);
if min(min(hsl==test_hsl))==0
    fprintf('E');
    rgb
    test_hsl
    hsl
    return;
else
    fprintf('.');
end

% 3d test
rgb_in=rand(4,4,3);
rgb_r=reshape(rgb_in, [],3);
hsl_r=rgb2hsl(rgb_r);
test_hsl=reshape(hsl_r, size(rgb_in));

hsl=rgb2hsl(rgb_in);
if min(reshape(hsl==test_hsl, [],1))==0
    fprintf('E');
    rgb
    test_hsl
    hsl
    return;
else
    fprintf('.');
end

%----------- Test HSL to RGB ----------
test_rgb=[0,0,0];
test_hsl=rgb2hsl(test_rgb);
rgb=hsl2rgb(test_hsl);
if min(reshape(rgb==test_rgb, [],1))==0
    fprintf('E');
    test_hsl
    rgb
    test_rgb
    return;
else
    fprintf('.');
end

test_rgb=[1,0,0];
test_hsl=rgb2hsl(test_rgb);
rgb=hsl2rgb(test_hsl);
if min(reshape(rgb==test_rgb, [],1))==0
    fprintf('E');
    test_hsl
    rgb
    test_rgb
    return;
else
    fprintf('.');
end

test_rgb=[0.0,1.0,0.0];
test_hsl=rgb2hsl(test_rgb);
rgb=hsl2rgb(test_hsl);
if min(reshape(rgb==test_rgb, [],1))==0
    fprintf('E');
    test_hsl
    rgb
    test_rgb
    return;
else
    fprintf('.');
end


% 2d test
test_rgb=floor(rand(5,5,3).*100)./100;
test_hsl=rgb2hsl(test_rgb);
rgb=hsl2rgb(test_hsl);
if min(reshape(rgb==test_rgb, [],1))==0
    fprintf('E');
    test_hsl
    rgb
    test_rgb
    return;
else
    fprintf('.');
end



fprintf('\nDone.\n');


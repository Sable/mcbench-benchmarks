function im = imtest(type,m,n)
%IMTEST   Generate test image
%
%   Phymhan
%   08-Aug-2013 19:18:05

switch nargin
    case 0
        type = 'phan';
        m = 256;
        n = 256;
    case 1
        if ~ischar(type)
            switch type
                case 0
                    type = 'c';
                case 1
                    type = 'c1';
                case 2
                    type = 'c2';
                case 3
                    type = 'c3';
                case 4
                    type = 's';
                case 5
                    type = 's2';
                case 6
                    type = 's4';
                case 7
                    type = 'sq';
                case 8
                    type = 'phan';
                case 9
                    type = 'lena';
                case 10
                    type = 'cat';
                otherwise
                    type = 'non';
            end
        end
        m = 256;
        n = 256;
    case 2
        if length(m) ~= 2
            n = m;
        else
            n = m(2);
            m = m(1);
        end
end
M = 256;
N = 256;
[x,y] = meshgrid(1:M,1:N);
x = x';%imshow(uint8(x));
y = y';%imshow(uint8(y));
if strcmpi(type,'c')
    im = zeros(M,N);
    im((x-N/2).^2+(y-M/2).^2 <= 32^2) = 255;
elseif strcmpi(type,'c1')
    im = zeros(M,N);
    im((x-N/4).^2+(y-M/4).^2 <= 32^2) = 255;
elseif strcmpi(type,'c2')
    im = zeros(M,N);
    im((x-  N/4).^2+(y-M/2).^2 <= 48^2) = 255;
    im((x-3*N/4).^2+(y-M/2).^2 <= 16^2) = 255;
elseif strcmpi(type,'c3')
    im = zeros(M,N);
    im((x-  N/2).^2+(y-3*M/4).^2 <= 16^2) = 255;
    im((x-3*N/4).^2+(y-  M/4).^2 <= 16^2) = 255;
    im((x-  N/4).^2+(y-  M/4).^2 <= 16^2) = 255;
elseif strcmpi(type,'s')
    im = zeros(M,N);
    l = 32;
    for k1 = 0:M/l-1
        im(k1*l+1:k1*l+l/2,:) = 255;
    end
elseif strcmpi(type,'s2')
    im = zeros(M,N);
    l = 32;
    for k1 = 0:M/l-1
        im(k1*l+1:k1*l+l/2,1:N/2) = 255;
    end
    for k2 = 0:(N/2)/l-1
        im(:,N/2+(k2*l+1:k2*l+l/2)) = 255;
    end
elseif strcmpi(type,'s4')
    im = zeros(M,N);
    l = 32;
    for k1 = 0:(M/2)/l-1
        im((k1*l+1:k1*l+l/2),1:N/2) = 255;
    end
    for k2 = 0:(N/2)/l-1
        im(M/2+1:M,(k2*l+1:k2*l+l/2)) = 255;
    end
    for k1 = 0:(M/2)/l-1
        im(M/2+(k1*l+1:k1*l+l/2),N/2+1:N) = 255;
    end
    for k2 = 0:(N/2)/l-1
        im(1:M/2,N/2+(k2*l+1:k2*l+l/2)) = 255;
    end
elseif strcmpi(type,'sq')
    im = zeros(M,N);
    l = 64;
    im((x-(M/2-l/2)).*(x-(M/2+l/2))<=0 & ...
        (y-(N/2-sqrt(3)*l/2)).*(y-(N/2+sqrt(3)*l/2))<=0) = 255;
elseif strcmpi(type,'phan')
    im = phantom(256);
    im = im*255;
elseif strcmpi(type,'lena')
    S = load('lena.mat');
    im = S.im;
    im = imresize(im,[M,N]);
elseif strcmpi(type,'cat')
    S = load('cat.mat');
    im = S.im;
    im = imresize(im,[M,N]);
else
    im = zeros(M,N);
end
if m~=M || n~=N
    im = imresize(im,[m,n]);
end
im = uint8(im);
end

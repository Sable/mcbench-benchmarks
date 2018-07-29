function res = homomorph(im,lowg,highg)

% inputs
% im is the result of applying 2D fft on the input image
%lowg is the gammaLow value for homomorphic filtering
%highg is the gammaHigh value for homomorphic filtering

%outputs
% res is the homomorphic filtered image

dif=(highg-lowg); %(gammahigh-gammalow)

sig=15; %sigma of gaussian
[r,c]=size(im);

for i=1:r
    for j=1:c
   
    p=-(((i-(r/2))^2+(j-(c/2))^2)/(2*(sig^2)));
    k=(1/2*3.14*(sig^2));
    % term=(1-k*exp()) since this is a high pass gaussian filter
    % term=(k*exp()) for low pass gaussian filter
    term(i,j)=(1-k*exp(p) ); 
        
    end
end



for i=1:r
    for j=1:c
    h(i,j)=(dif*term(i,j))+lowg;

    end
end

for i=1:r
    for j=1:c
    res(i,j)=im(i,j)*h(i,j);

    end
end





% Juan Manuel Perez Rua

% I =input image
% algorithm =name of the algorithm
% varargin, threshold list, if needed. AN error message error appears
% if incorrect inputs are used.

%Example of usage: J = colorConstancy(I, 'modified white patch', 200);
function [OUT] = colorConstancy(I, algorithm, varargin)

    [m,n,~]=size(I);
    switch (algorithm)
        case 'grey world'
            Rmean      = sum(sum(I(:,:,1)))/(m*n);
            Gmean      = sum(sum(I(:,:,2)))/(m*n);
            Bmean      = sum(sum(I(:,:,3)))/(m*n);
            Avg        = mean([Rmean Gmean Bmean]);
            Kr         = Avg/Rmean;
            Kg         = Avg/Gmean;
            Kb         = Avg/Bmean;
            OUT(:,:,1) = Kr*double(I(:,:,1));
            OUT(:,:,2) = Kg*double(I(:,:,2));
            OUT(:,:,3) = Kb*double(I(:,:,3));
            OUT = uint8(OUT);
        case 'white patch'
            Kr = 255/max(max(double(I(:,:,1))));
            Kg = 255/max(max(double(I(:,:,2))));
            Kb = 255/max(max(double(I(:,:,3))));
            OUT(:,:,1) = Kr*double(I(:,:,1));
            OUT(:,:,2) = Kg*double(I(:,:,2));
            OUT(:,:,3) = Kb*double(I(:,:,3));
            OUT = uint8(OUT);
        case 'modified white patch'
            if (~isempty(varargin))
                th = varargin{1};
                R=I(:,:,1); Kr = 255/mean(R(R>th));
                G=I(:,:,2); Kg = 255/mean(G(G>th));
                B=I(:,:,3); Kb = 255/mean(B(B>th));
                OUT(:,:,1) = Kr*double(I(:,:,1));
                OUT(:,:,2) = Kg*double(I(:,:,2));
                OUT(:,:,3) = Kb*double(I(:,:,3));
                OUT = uint8(OUT);
            else
                OUT=I; disp('Modified white patch algorithm must have another parameter.');    
            end
        case 'progressive'
            if (length(varargin)>1)
                h1 = varargin{1};
                h2 = varargin{2};
                imap = (double(I(:,:,1))+double(I(:,:,2))+double(I(:,:,3)))/3;
                R=I(:,:,1); G=I(:,:,2); B=I(:,:,3);
                
                Kr = zeros(size(imap));
                Kg = zeros(size(imap));
                Kb = zeros(size(imap));
                
                Kr( imap>=h1 )=255/mean(R(R>=h1));
                Kg( imap>=h1 )=255/mean(G(G>=h1));
                Kb( imap>=h1 )=255/mean(B(B>=h1));

                [m,n,~]=size(I);
                Rmean = sum(sum(R))/(m*n);
                Gmean = sum(sum(G))/(m*n);
                Bmean = sum(sum(B))/(m*n);
                Avg = mean([Rmean Gmean Bmean]);

                Kr( imap<=h2 ) = Avg/Rmean;
                Kg( imap<=h2 ) = Avg/Gmean;
                Kb( imap<=h2 ) = Avg/Bmean;
            
                deltha = imap/(h1-h2)-h2/(h1-h2);
                Kr( imap>=h2 & imap<=h1 ) = (1-deltha(imap>=h2 & imap<=h1))*...
                    255/mean(R(R>=h1)) + deltha(imap>=h2 & imap<=h1)*255/mean(R(R>=h1));
                Kg( imap>=h2 & imap<=h1 ) = (1-deltha(imap>=h2 & imap<=h1))*...
                    255/mean(G(G>=h1)) + deltha(imap>=h2 & imap<=h1)*255/mean(G(G>=h1));
                Kb( imap>=h2 & imap<=h1 ) = (1-deltha(imap>=h2 & imap<=h1))*...
                    255/mean(B(B>=h1)) + deltha(imap>=h2 & imap<=h1)*255/mean(B(B>=h1));
                OUT(:,:,1) = Kr.*double(I(:,:,1));
                OUT(:,:,2) = Kg.*double(I(:,:,2));
                OUT(:,:,3) = Kb.*double(I(:,:,3));
                OUT = uint8(OUT);              
            else
                OUT=I; disp('Modified white patch algorithm must have another parameter.');    
            end
        case 'single scale retinex'
            if (~isempty(varargin))
                c=varargin{1};
                [Y,X]=meshgrid(1:n,1:m);
               
                Fnok = exp(-((X.^2)+(Y.^2))./(c.^2));
                K = 1/(sum(sum(Fnok)));
                F = K.*Fnok; 
                
                IR = double(I(:,:,1));
                IG = double(I(:,:,2));
                IB = double(I(:,:,3));
                FF  = fftshift(fft2(F));
                IFR = fftshift(fft2(IR)); IFR=FF.*IFR; IFR=real(ifft2(ifftshift(IFR)));
                IFG = fftshift(fft2(IG)); IFG=FF.*IFG; IFG=real(ifft2(ifftshift(IFG))); 
                IFB = fftshift(fft2(IB)); IFB=FF.*IFB; IFB=real(ifft2(ifftshift(IFB))); 
                
                RR = log10(double(IR))-log10(IFR);
                RG = log10(double(IG))-log10(IFG);
                RB = log10(double(IB))-log10(IFB);
                
                OUT(:,:,1)=uint8(255*RR/(max(max([RR RG RB]))));
                OUT(:,:,2)=uint8(255*RG/(max(max([RR RG RB]))));
                OUT(:,:,3)=uint8(255*RB/(max(max([RR RG RB]))));
            else
                OUT=I; disp('Single scale algorithm must have another parameter (c).');                  
            end
        case 'multi scale retinex'
            R1=colorConstancy(I,'single scale retinex',25);
            R2=colorConstancy(I,'single scale retinex',100);
            R3=colorConstancy(I,'single scale retinex',240);
            OUT=(1/3)*R1+(1/3)*R2+(1/3)*R3;
        case 'MSRCR'
            if (length(varargin)>1)
              alpha=varargin{1};
              betha=varargin{2};
              gain=varargin{3};
              Rmsr=colorConstancy(I, 'multi scale retinex');
              T(:,:,1)=I(:,:,1)+I(:,:,2)+I(:,:,3);
              T(:,:,2)=I(:,:,1)+I(:,:,2)+I(:,:,3);
              T(:,:,3)=I(:,:,1)+I(:,:,2)+I(:,:,3);
              C = log10(alpha*double(I))-log10(double(T));
              OUT = uint8(gain*(C.*double(Rmsr)+betha));
            else    
                OUT=I; disp('MSRCR must have another parameter alpha, b and G.');                  
            end
        case 'ace'
            MR = zeros(m,n);
            MG = zeros(m,n);
            MB = zeros(m,n);
            RC = zeros(m,n,3);
            [Y,X]=meshgrid(1:n,1:m);
            cont=0;
            W=20;
            %STEP 1
            for i=1:m
               for j=1:n
                   
                   cont=cont+1;
                   if (mod(cont,1000)==0) disp(['Ciclos: ' num2str(cont)]); end  
                   
                   MD = sqrt(((X-X(i,j)).^2)+((Y-Y(i,j)).^2));

                   MR(MD<=W & MD~=0)=sign(double(I(i,j,1))-double(I(MD<=W & MD~=0)));
                   MG(MD<=W & MD~=0)=sign(double(I(i,j,2))-double(I(MD<=W & MD~=0)));
                   MB(MD<=W & MD~=0)=sign(double(I(i,j,3))-double(I(MD<=W & MD~=0)));
                   
                   T = zeros(size(m,n));
                   T(MD<=W & MD~=0)= MR(MD<=W & MD~=0)./MD(MD<=W & MD~=0);
                   RC(i,j,1)=sum(sum(T));
                   
                   T = zeros(size(m,n));
                   T(MD<=W & MD~=0)= MG(MD<=W & MD~=0)./MD(MD<=W & MD~=0);
                   RC(i,j,2)=sum(sum(T));
                   
                   T = zeros(size(m,n));
                   T(MD<=W & MD~=0)= MB(MD<=W & MD~=0)./MD(MD<=W & MD~=0);
                   RC(i,j,3)=sum(sum(T));                   
               end
            end
            %STEP 2
            mc = min(min(min(RC)));
            Mc = max(max(max(RC)));
            s = (255-Mc)/(-mc);
            OUT = uint8(round(127.5+s*RC));
        otherwise
            OUT=I; disp('Unknown alogrithm, please check name.');
    end
end

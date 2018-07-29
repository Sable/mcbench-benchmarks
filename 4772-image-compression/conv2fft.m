function [out] = conv2fft(z1,z2,shape,shape2)
%CONV2FFT FFT-based two dimensional convolution.
%    C = CONV2FFT(A, B) performs the 2-D convolution of matrices
%    A and B.   If [ma,na] = size(A) and [mb,nb] = size(B), then
%    size(C) = [ma+mb-1,na+nb-1].
%    C = CONV2FFT(H1, H2, A) convolves A first with the vector H1 
%    along the rows and then with the vector H2 along the columns.
% 
%    C = CONV2FFT( ... ,'shape') returns a subsection of the 2-D
%    convolution with size specified by 'shape':
%      'full'  - (default) returns the full 2-D convolution,
%      'same'  - returns the central part of the convolution
%                that is the same size as A.
%      'valid' - returns only those parts of the convolution
%                that are computed without the zero-padded
%                edges. size(C) = [ma-mb+1,na-nb+1] when
%                all(size(A) >= size(B)), otherwise C is empty.
%
%
% Please contribute if you find this software useful.
% Report bugs to luigi.rosa@tiscali.it
%
%*****************************************************************
% Luigi Rosa
% Via Centrale 27
% 67042 Civita di Bagno
% L'Aquila --- ITALY 
% email  luigi.rosa@tiscali.it
% mobile +39 340 3463208 
% http://utenti.lycos.it/matlab
%*****************************************************************
%



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% 3 input arguments: matrix 1, matrix 2, shape
if ((nargin==3)&&(isa(shape,'char'))) 
    if strcmp(shape,'same')
        z1x=size(z1,1);
        z1y=size(z1,2);
        z2x=size(z2,1);
        z2y=size(z2,2);
        
        if any(any(imag(z1)))||any(any(imag(z2)))
            out=(ifft2(fft2(z1,z1x+z2x-1,z1y+z2y-1).*fft2(z2,z1x+z2x-1,z1y+z2y-1)));
        else
            out=real(ifft2(fft2(z1,z1x+z2x-1,z1y+z2y-1).*fft2(z2,z1x+z2x-1,z1y+z2y-1)));
        end
        
        
        px=((z2x-1)+mod((z2x-1),2))/2;
        py=((z2y-1)+mod((z2y-1),2))/2;
        
        out=out(px+1:px+z1x,py+1:py+z1y);
        return;
    end
    
    if strcmp(shape,'full')
        z1x=size(z1,1);
        z1y=size(z1,2);
        z2x=size(z2,1);
        z2y=size(z2,2);
        
        if any(any(imag(z1)))||any(any(imag(z2)))
            out=(ifft2(fft2(z1,z1x+z2x-1,z1y+z2y-1).*fft2(z2,z1x+z2x-1,z1y+z2y-1)));
        else
            out=real(ifft2(fft2(z1,z1x+z2x-1,z1y+z2y-1).*fft2(z2,z1x+z2x-1,z1y+z2y-1)));
        end
        
        return;
    end
    
    if strcmp(shape,'valid')
        z1x=size(z1,1);
        z1y=size(z1,2);
        z2x=size(z2,1);
        z2y=size(z2,2);
        if ((z1x<z2x)||(z1y<z2y))
            out=[];
            return;
        else
        end
        if any(any(imag(z1)))||any(any(imag(z2)))
            out=(ifft2(fft2(z1,z1x+z2x-1,z1y+z2y-1).*fft2(z2,z1x+z2x-1,z1y+z2y-1)));
        else
            out=real(ifft2(fft2(z1,z1x+z2x-1,z1y+z2y-1).*fft2(z2,z1x+z2x-1,z1y+z2y-1)));
        end
        
        px=z2x;
        py=z2y;
        
        out=out(px:px+z1x-z2x,py:py+z1y-z2y);
        return;
    end
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% 2 input argiments: matrix 1, matrix 2, by default shape is 'full'
if (nargin==2)    
    z1x=size(z1,1);
    z1y=size(z1,2);
    z2x=size(z2,1);
    z2y=size(z2,2);
    
    if any(any(imag(z1)))||any(any(imag(z2)))
        out=(ifft2(fft2(z1,z1x+z2x-1,z1y+z2y-1).*fft2(z2,z1x+z2x-1,z1y+z2y-1)));
    else
        out=real(ifft2(fft2(z1,z1x+z2x-1,z1y+z2y-1).*fft2(z2,z1x+z2x-1,z1y+z2y-1)));
    end
    
    return;
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% conv2(c,r,a) where c and r are arrays, a is a matrix
if (isa(shape,'double'))
    %--------------------------
    % by default shape is 'full'
    if (nargin==3)
        a=shape;
        c=z1;
        r=z2;
        
        [ax,ay]=size(a);
        [rx,ry]=size(r);
        [cx,cy]=size(c);
        
        if size(convfft(a(1,:),r),1)==1
            for ii=1:ax
                y2(ii,:)=convfft(a(ii,:),r);
            end
        else
            for ii=1:ax
                y2(ii,:)=convfft(a(ii,:),r)';
            end
        end
        
        [y2x,y2y]=size(y2);       
        if size(convfft(y2(:,1),c),1)==1
            for ii=1:y2y
                y3(:,ii)=convfft(y2(:,ii),c)';
            end
        else
            for ii=1:y2y
                y3(:,ii)=convfft(y2(:,ii),c);
            end
        end
        
        
        out=y3;
        return;
    end
    %-------------------------
    if (nargin==4)
        a=shape;
        c=z1;
        r=z2;
        
        [ax,ay]=size(a);
        [rx,ry]=size(r);
        [cx,cy]=size(c);
        
        if cx==1
            dimx=cy;
        else
            dimx=cx;
        end
        if rx==1
            dimy=ry;
        else
            dimy=rx;
        end       
        
        
        
        if size(convfft(a(1,:),r),1)==1
            for ii=1:ax
                y2(ii,:)=convfft(a(ii,:),r);
            end
        else
            for ii=1:ax
                y2(ii,:)=convfft(a(ii,:),r)';
            end
        end
        
        [y2x,y2y]=size(y2);
        
        if size(convfft(y2(:,1),c),1)==1
            for ii=1:y2y
                y3(:,ii)=convfft(y2(:,ii),c)';
            end
        else
            for ii=1:y2y
                y3(:,ii)=convfft(y2(:,ii),c);
            end
        end       
        
        out=y3;
        
        [outx,outy]=size(out);
        %---------------------------------------------
        if strcmp(shape2,'full')
            return;
        end
        %---------------------------------------------      
        if strcmp(shape2,'valid')
            lx=ax-dimx+1;
            ly=ay-dimy+1;
            if (dimx>outx)||(dimy>outy)||(dimx+lx-1>outx)||(dimy+ly-1>outy)
                out=[];
                return;
            else                
                out=out(dimx:dimx+lx-1,dimy:dimy+ly-1);
                return;
            end           
        end
        %---------------------------------------------        
        if strcmp(shape2,'same')
            lx=ax;
            ly=ay;
            px=((dimx-1)+mod((dimx-1),2))/2;
            py=((dimy-1)+mod((dimy-1),2))/2;
            
            out=out(px+1:px+ax,py+1:py+ay);            
            return;
        end
        %---------------------------------------------          
        
    end
    %-------------------------
end
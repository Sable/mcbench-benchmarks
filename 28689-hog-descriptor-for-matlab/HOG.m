%Image descriptor based on Histogram of Orientated Gradients for gray-level images. This code 
%was developed for the work: O. Ludwig, D. Delgado, V. Goncalves, and U. Nunes, 'Trainable 
%Classifier-Fusion Schemes: An Application To Pedestrian Detection,' In: 12th International IEEE 
%Conference On Intelligent Transportation Systems, 2009, St. Louis, 2009. V. 1. P. 432-437. In 
%case of publication with this code, please cite the paper above.

function H=HOG(Im)
nwin_x=3;%set here the number of HOG windows per bound box
nwin_y=3;
B=9;%set here the number of histogram bins
[L,C]=size(Im); % L num of lines ; C num of columns
H=zeros(nwin_x*nwin_y*B,1); % column vector with zeros
m=sqrt(L/2);
if C==1 % if num of columns==1
    Im=im_recover(Im,m,2*m);%verify the size of image, e.g. 25x50
    L=2*m;
    C=m;
end
Im=double(Im);
step_x=floor(C/(nwin_x+1));
step_y=floor(L/(nwin_y+1));
cont=0;
hx = [-1,0,1];
hy = -hx';
grad_xr = imfilter(double(Im),hx);
grad_yu = imfilter(double(Im),hy);
angles=atan2(grad_yu,grad_xr);
magnit=((grad_yu.^2)+(grad_xr.^2)).^.5;
for n=0:nwin_y-1
    for m=0:nwin_x-1
        cont=cont+1;
        angles2=angles(n*step_y+1:(n+2)*step_y,m*step_x+1:(m+2)*step_x); 
        magnit2=magnit(n*step_y+1:(n+2)*step_y,m*step_x+1:(m+2)*step_x);
        v_angles=angles2(:);    
        v_magnit=magnit2(:);
        K=max(size(v_angles));
        %assembling the histogram with 9 bins (range of 20 degrees per bin)
        bin=0;
        H2=zeros(B,1);
        for ang_lim=-pi+2*pi/B:2*pi/B:pi
            bin=bin+1;
            for k=1:K
                if v_angles(k)<ang_lim
                    v_angles(k)=100;
                    H2(bin)=H2(bin)+v_magnit(k);
                end
            end
        end
                
        H2=H2/(norm(H2)+0.01);        
        H((cont-1)*B+1:cont*B,1)=H2;
    end
end

%Tristan Ursell
%Frechet Distance between two curves
%May 2013
%
% f = frechet(X1,Y1,X2,Y2)
% f = frechet(X1,Y1,X2,Y2,res)
%
% (X1,Y1) are the x and y coordinates of the first curve (column vector).
% (X2,Y2) are the x and y coordinates of the second curve (column vector).
%
% The lengths of the two curves do not have to be the same.
%
% 'res' is an optional parameter to set the resolution of 'f', the time to
% compute scales linearly with 'res'. 'res' must be positive, and if 'res'
% is larger than the largest distance between any two points on the curve
% the function will throw a warning. If 'res' is unspecified, the function
% will select a reasonable value, given the inputs.
%
% This function estimates the Frechet Distance, which is a measure of the
% dissimilarity between two curves in space (in this case in 2D).  It is a
% scalar value that is symmetric with respect to the two curves (i.e. 
% switching X1->X2 and Y1->Y2 does not change the value).  Roughly 
% speaking, this distance metric is the minimum length of a line that
% connects a point on each curve, and allows one to traverse both curves
% from start to finish.  (wiki:  Frechet Distance)
%
% The function requires column input vectors, and the function 'bwlabel' 
% from the image processing toolbox.
%
%
%EXAMPLE: compare three curves to find out which two are most similar
%
% %curve 1
%t1=0:1:50;
%X1=(2*cos(t1/5)+3-t1.^2/200)/2;
%Y1=2*sin(t1/5)+3;
%
% %curve 2
%X2=(2*cos(t1/4)+2-t1.^2/200)/2;
%Y2=2*sin(t1/5)+3;
%
% %curve 3
%X3=(2*cos(t1/4)+2-t1.^2/200)/2;
%Y3=2*sin(t1/4+2)+3;
%
%f12=frechet(X1',Y1',X2',Y2');
%f13=frechet(X1',Y1',X3',Y3');
%f23=frechet(X2',Y2',X3',Y3');
%f11=frechet(X1',Y1',X1',Y1');
%f22=frechet(X2',Y2',X2',Y2');
%f33=frechet(X3',Y3',X3',Y3');
%
%figure;
%subplot(2,1,1)
%hold on
%plot(X1,Y1,'r','linewidth',2)
%plot(X2,Y2,'g','linewidth',2)
%plot(X3,Y3,'b','linewidth',2)
%legend('curve 1','curve 2','curve 3','location','eastoutside')
%xlabel('X')
%ylabel('Y')
%axis equal tight
%box on
%title(['three space curves to compare'])
%legend
%
%subplot(2,1,2)
%imagesc([[f11,f12,f13];[f12,f22,f23];[f13,f23,f33]])
%xlabel('curve')
%ylabel('curve')
%cb1=colorbar('peer',gca);
%set(get(cb1,'Ylabel'),'String','Frechet Distance')
%axis equal tight
%

function f = frechet(X1,Y1,X2,Y2,varargin)

%get path point length
L1=length(X1);
L2=length(X2);

%check vector lengths
if or(L1~=length(Y1),L2~=length(Y2))
    error('Paired input vectors (Xi,Yi) must be the same length.')
end

%check for column inputs
if or(or(size(X1,1)<=1,size(Y1,1)<=1),or(size(X2,1)<=1,size(Y2,1)<=1))
    error('Input vectors must be column vectors.')
end

%create maxtrix forms
X1_mat=ones(L2,1)*X1';
Y1_mat=ones(L2,1)*Y1';
X2_mat=X2*ones(1,L1);
Y2_mat=Y2*ones(1,L1);

%calculate frechet distance matrix
frechet1=sqrt((X1_mat-X2_mat).^2+(Y1_mat-Y2_mat).^2);
fmin=min(frechet1(:));
fmax=max(frechet1(:));

%handle resolution
if ~isempty(varargin)
    res=varargin{1};
    if res<=0
        error('The resolution parameter must be greater than zero.')
    elseif ((fmax-fmin)/res)>10000
        warning('Given these two curves, and that resolution, this might take a while.')
    elseif res>=(fmax-fmin)
        warning('The resolution is too low given these curves to compute anything meaningful.')
        f=fmax;
        return
    end
else
    res=(fmax-fmin)/1000;
end

%compute frechet distance
for q3=fmin:res:fmax
    im1=bwlabel(frechet1<=q3);
    
    %get region number of beginning and end points
    if and(im1(1,1)~=0,im1(1,1)==im1(end,end))
        f=q3;
        break
    end
end
   







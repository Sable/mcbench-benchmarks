function [CX,CY,C_sum,C,xi,yi]=improfile_integrated(I,d,xi,yi);
%
%  function [CX,CY,C_sum,C,xi,yi]=improfile_integrated(I,d,xi,yi);
%
%   
%  'improfile_integrated' computes intensity values along a line or
%  multiline in a greyscale images. Parameter d gives the opportunity to
%  integrate along thicker lines with width d. 
%
%  Please note the 'known problems' section!
%
%
% input:
%    I      : image (only grayscale)
%    d      : thickness of line for integration
%    xi, yi : x-/y- coordinates of line profile
%
%
% output:
%    CX, CY : (center) coordinates of intensity values
%    C      : intensity along path, single line scan (from improfile)
%    C_sum  : integrated intensity profile of line with thickness d
%
%
% example:
%
%  I=zeros(100,100);
%  I(50:100,1:100)=.5;     
%  figure, imshow(I,[]);
%  % image with step in the middle, the noise free image
%  
%  Irand=rand(100,100)*.5; 
%  I=I+Irand;
%  figure, imshow(I,[]);   
%  % image is noisy but step is clearly visible
%
%  thickness=10;
%  [CX,CY,C_sum,C,xi,yi]=improfile_integrated(I,thickness);   
%  % do a ten pixel averaging
%  plot(1:length(C),C,'.',1:length(C_sum),C_sum/(thickness+1),'-');
%  grid on, axis tight
%  xlabel('lateral distance [px]');
%  ylabel('intensity [a.u.]');
%  title('comparision of single linescan and integrated line scan');
%
%
% known problems:
%
% sometimes the routine fails because of the numerical method of finding
% the rotated data points. An error is printed. The try it again with a
% slightly different line scan. 
% 
%
% conclusion:
% 
% is still not reliable, but up to my knowledge the first routine wich
% extracts integrated intensity profiles under Matlab. This is a standard
% tool in image analysis.
%
% Feel free to improve it!
%
% Hei 06/06
%



if nargin<4
    figure; imshow(I,[]);
    %     imcontrast;
    % uncomment, if needed

    [CX,CY,C,xi,yi]=improfile;

    close(gcf);
end

% set thickness of line to 1 if value is not given
if nargin<2
    d=1;
end


m=1;
while m<length(xi)
    if (xi(m)==xi(m+1))&(yi(m)==yi(m+1))
        xi((m+1):(end-1))=xi((m+2):end);
        yi((m+1):(end-1))=yi((m+2):end);
        xi(end)=[];
        yi(end)=[];
        warning('double values have been deleted!');
    end
    m=m+1;
end

linescan=[];
for m=2:length(xi)
    dy=yi(m)-yi(m-1);
    dx=xi(m)-xi(m-1);
    if abs(dx)<1e-3
        if dy>0
            rotation_angle=-90;
        elseif dy<0
            rotation_angle=90;
        end
    else
        rotation_angle=atan(dy/dx)*180/pi;
    end
    
    im_log=~(zeros(size(I),'uint8')<1);
    im_log(uint32(yi(m)),uint32(xi(m)))=true;
    im_log(uint32(yi(m-1)),uint32(xi(m-1)))=true;
    
    im_log=imrotate(im_log,rotation_angle);
    [yidx,xidx]=find(im_log);
    
    im_pi2=imrotate(I,rotation_angle);
    
    if length(xidx)<2
        error('Try again! Bad numerics #1!');
    end

    %     figure, imshow(im_pi2,[]);
    % for debugging purposes
    
    if length(xidx)>1
        xmin=xidx(1);
        ymin=yidx(1)-round(d/2);
        height=d;
        width=xidx(2)-xidx(1);
        ROIrect=[xmin ymin width height];

        %     imrect(gca,ROIrect);
        % for debugging

        im_pi3=imcrop(im_pi2,ROIrect);

        linescan=[linescan sum(im_pi3)];
    end
    
end

[CX,CY,C]=improfile(I,xi,yi);
C_sum=linescan;

if length(C_sum)>1
    indx=linspace(1,length(C),length(C_sum));
    C_sum=interp1(indx,C_sum,1:length(C));
else
    error('Try again! Bad numerics #2!');
end

if nargout<1
    figure;
    plot3(CX,CY,C,'b.',CX,CY,C_sum/(d+1),'r-');
    grid on
end
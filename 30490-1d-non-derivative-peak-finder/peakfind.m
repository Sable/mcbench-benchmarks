function varargout =peakfind(x_data,y_data,varargin)
%
%PEAKFIND general 1D peak finding algorithm
%Tristan Ursell, 2013.
%
%peakfind(x_data,y_data)
%peakfind(x_data,y_data,upsam)
%peakfind(x_data,y_data,upsam,gsize,gstd)
%peakfind(x_data,y_data,upsam,htcut,'cuttype')
%peakfind(x_data,y_data,upsam,gsize,gstd,htcut,'cuttype')
%
%[xpeaks]=peakfind()
%[xout,yout,peakspos]=peakfind()
%
%This function finds peaks without taking first or second derivatives,
%rather it uses local slope features in a given data set.  The function has
%four basic modes.
%
%   Mode 1: peakfind(x_data,y_data) simply finds all peaks in the data
%   given by 'xdata' and 'ydata'.
%
%   Mode 2: peakfind(x_data,y_data,upsam) finds peaks after up-sampling
%   the data by the integer factor 'upsam' -- this allows for higher
%   resolution peak finding.  The interpolation uses a cubic spline that
%   does not introduce fictitious peaks.
%
%   Mode 3: peakfind(x_data,y_data,upsam,gsize,gstd) up-samples and then
%   convolves the data with a Gaussian point spread vector of length
%   gsize (>=3) and standard deviation gstd (>0).
%
%   Mode 4: peakfind(x_data,y_data,upsam,htcut,'cuttype') up-samples the
%   data (upsam=1 analyzes the data unmodified).  The string 'cuttype' can
%   either be 'abs' (absolute) or 'rel' (relative), which specifies a peak 
%   height cutoff which is either:
%
%       'abs' - finds peaks that lie an absolute amount 'htcut' above the
%       lowest value in the data set.
%
%            for (htcut > 0) peaks are found if
%
%            peakheights > min(yout) + htcut
%       
%       'rel' - finds peaks that are an amount 'htcut' above the lowest
%       value in the data set, relative to the full change in y-input
%       values.
%
%           for (0 < htcut < 1) peaks are found if
%
%           (peakheights-min(yout))/(max(yout)-min(yout)) > htcut
%
%Upsampling and convolution allows one to find significant peaks in noisy
%data with sub-pixel resolution.  The algorithm also finds peaks in data 
%where the peak is surrounded by zero first derivatives, i.e. the peak is 
%actually a large plateau.  
%
%The function outputs the x-position of the peaks in 'xpeaks' or the
%processed input data in 'xout' and 'yout' with 'peakspos' as the indices
%of the peaks, i.e. xpeaks = xout(peakspos).  
%
%If you want the algorithm to find the position of minima, simply input 
%'-y_data'.  Peaks within half the convolution box size of the boundary 
%will be ignored (to avoid this, pad the data before processing).
%
% Example 1:
%
% x_data = -50:50;
% y_data =(sin(x_data)+0.000001)./(x_data+0.000001)+1+0.025*(2*rand(1,length(x_data))-1);
%
% [xout,yout,peakspos]=peakfind(x_data,y_data);
%
% plot(x_data,y_data,'r','linewidth',2)
% hold on
% plot(xout,yout,'b','linewidth',2)
% plot(xout(peakspos),yout(peakspos),'g.','Markersize',30)
% xlabel('x')
% ylabel('y')
% title(['Found ' num2str(length(peakspos)) ' peaks.'])
% box on
%
% Example 2:
%
% x_data = -50:50;
% y_data =(sin(x_data)+0.000001)./(x_data+0.000001)+1+0.025*(2*rand(1,length(x_data))-1);
%
% [xout,yout,peakspos]=peakfind(x_data,y_data,4,6,2,0.2,'rel');
%
% plot(x_data,y_data,'r','linewidth',2)
% hold on
% plot(xout,yout,'b','linewidth',2)
% plot(xout(peakspos),yout(peakspos),'g.','Markersize',30)
% xlabel('x')
% ylabel('y')
% title(['Found ' num2str(length(peakspos)) ' peaks.'])
% box on


%check if input data are same length
if length(x_data)~=length(y_data)
    error('Input data vectors must be the same length.')
end

%check to make sure data is all real
if or(sum(isreal(x_data)==0)>0,sum(isreal(y_data)==0)>0)
    error('All input data must be real valued.')
end

%check if input data is flat (no peaks)
if sum(diff(y_data)==0)==(length(y_data)-1)
    %disp('Warning: Input data is completely flat.')
    if nargout==1
        varargout(1)={[]};
    elseif nargout==3
        varargout(3)={[]};
        varargout(2)={y_data};
        varargout(1)={x_data};
    else
        error('Incorrect number of output arguments.')
    end   
    return
end

%check if input data is monotonic (no peaks)
if or(sum(diff(y_data)<=0)==(length(y_data)-1),sum(diff(y_data)>=0)==(length(y_data)-1))
    %disp('Warning: Input data is monotonic.')
    if nargout==1
        varargout(1)={[]};
    elseif nargout==3
        varargout(3)={[]};
        varargout(2)={y_data};
        varargout(1)={x_data};
    else
        error('Incorrect number of output arguments.')
    end   
    return
end

%parse varargin input
nargs=size(varargin,2);
if nargs==1
    upsam=varargin{1};
elseif nargs==3
    upsam=varargin{1};
    if ischar(varargin{3})
        htcut=varargin{2};
        cuttype=varargin{3};
    else
        gsize=varargin{2};
        gstd=varargin{3};
    end
elseif nargs==5
    upsam=varargin{1};
    gsize=varargin{2};
    gstd=varargin{3};
    htcut=varargin{4};
    cuttype=varargin{5};
elseif nargs~=0
    error('Incorrect number of input arguments.  See "help peakfind".')
end

%check value of upsam
if nargs>0
    if upsam<1
        error('Upsampling factor must be an integer greater than or equal to 1.')
    else
        if and(nargs>2,ischar(varargin{3}))
            upsam=round(upsam);
        end
    end
end

%upsample data
if nargs>0
    xup_data=linspace(x_data(1),x_data(end),upsam*length(x_data));
    yup_data=interp1(x_data,y_data,xup_data,'cubic');
else
    xup_data=x_data;
    yup_data=y_data;
end

if nargs>2
    %check string entries
    if or(and(nargs==3,ischar(varargin{3})),nargs==5)
        if ~or(strcmp('rel',cuttype),strcmp('abs',cuttype))
            error('Invalid string entry in function call.')
        end
    end
    
    %check value of gsize and gstd
    if or(nargs==5,and(nargs==3,~ischar(varargin{3})))
        if gsize<3
            error('Gaussian window must have at least 3 points.')
        end
        if gstd<=0
            error('Gaussian STD must be greater than zero.')
        end
    end
    
    if ischar(varargin{3})
        ycv_data=yup_data;
        xcv_data=xup_data;
        stpt=1;
    else
        %define convolution filter
        filt1 = exp(-linspace(-gsize/2,gsize/2,gsize).^2/(2*gstd^2));
        conv1 = filt1/sum(filt1);
        %convolve peak data with small STD gaussian
        ycv_data_unnorm=conv(yup_data,conv1,'same');
        ycv_data_ones=conv(ones(size(yup_data)),conv1,'same');
        ycv_data=ycv_data_unnorm./ycv_data_ones;
        xcv_data=xup_data;
        %xcv_data=xup_data+1/2*(xup_data(2)-xup_data(1));
        stpt=ceil(gsize/2);
        
        ycv_data(1:stpt)=yup_data(1:stpt);
        ycv_data(end-stpt+1:end)=yup_data(end-stpt+1:end);
    end
else
    ycv_data=yup_data;
    xcv_data=xup_data;
    stpt=1;
end

%number of upsampled data points
tipn=length(ycv_data);

%construct peak finding vectors
lpts=ycv_data(stpt:end-stpt-2);
mpts=ycv_data(stpt+1:end-stpt-1);
rpts=ycv_data(stpt+2:end-stpt);
%lpts=ycv_data(stpt:end-2);
%mpts=ycv_data(stpt+1:end-1);
%rpts=ycv_data(stpt+2:end);

%find peaks
Rpeaks=zeros(1,tipn);
Lpeaks=zeros(1,tipn);
minpeaks=zeros(1,tipn);
fpeaks=zeros(1,tipn);
Rpeaks(stpt+1:end-stpt-1)=((mpts-lpts)>=0).*((rpts-mpts)<0); %triggers just right of peak
Lpeaks(stpt+1:end-stpt-1)=((mpts-lpts)>0).*((rpts-mpts)<=0); %triggers just left of peak
minpeaks(stpt+1:end-stpt-1)=((mpts-lpts)<=0).*((rpts-mpts)>0);
%Rpeaks(stpt+1:end-stpt)=((mpts-lpts)>=0).*((rpts-mpts)<0); %triggers just right of peak
%Lpeaks(stpt+1:end-stpt)=((mpts-lpts)>0).*((rpts-mpts)<=0); %triggers just left of peak
%minpeaks(stpt+1:end-stpt)=((mpts-lpts)<=0).*((rpts-mpts)>0);

%use minimums and multiple maximums to find best guess of peak
minlist=find(minpeaks==1);

%triggers when there is a flat landscape with a single trough
if and(sum(Rpeaks)==0,sum(Lpeaks)==0)
    disp('Warning: found only a trough.')
    npeaks=0;
    peakspos=zeros(1,0);
    xcv_data=x_data;
    ycv_data=y_data;
    return
end

%find and average doubly-occupied peaks
for j=1:length(minlist)+1
    %find bounds between which to look for two pseudo-peaks
    if j==1
        lbound=1;
        if isempty(minlist)
            rbound=tipn;
        else
            rbound=minlist(j);
        end
    elseif j==length(minlist)+1
        lbound=minlist(j-1);
        rbound=length(ycv_data);
    else
        lbound=minlist(j-1);
        rbound=minlist(j);
    end
    
    %look for peaks
    peakmask=zeros(1,tipn);
    peakmask(lbound:rbound)=1;
    
    Lpeak=find(Lpeaks.*peakmask==1,1);
    Rpeak=find(Rpeaks.*peakmask==1,1);
    fpeaks(round((Lpeak+Rpeak)/2))=1;
end

%do a final check against the peaks in the original up-sampled data
peakspos=find(fpeaks==1);
npeaks=sum(fpeaks);

%remove peaks if they are not high enough
if and(npeaks>1,exist('cuttype','var'))
    ymin=min(ycv_data);
    ymax=max(ycv_data);
    
    if strcmp('rel',cuttype)
        cutpeaks=((ycv_data(peakspos)-ymin)/(ymax-ymin))<htcut;
    else
        cutpeaks=ycv_data(peakspos)<(htcut+ymin);
    end
    npeaks=npeaks-sum(cutpeaks);
    peakspos=peakspos(cutpeaks==0);
end

if nargout==1
    varargout(1)={xcv_data(peakspos)};
elseif nargout==3
    varargout(3)={peakspos};
    varargout(2)={ycv_data};
    varargout(1)={xcv_data};
else
    error('Incorrect number of output arguments.')
end

return



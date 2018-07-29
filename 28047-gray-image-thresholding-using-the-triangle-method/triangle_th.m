function [level]=triangle_th(lehisto,num_bins)
%     Triangle algorithm
%     This technique is due to Zack (Zack GW, Rogers WE, Latt SA (1977), 
%     "Automatic measurement of sister chromatid exchange frequency", 
%     J. Histochem. Cytochem. 25 (7): 741–53, )
%     A line is constructed between the maximum of the histogram at 
%     (b) and the lowest (or highest depending on context) value (a) in the 
%     histogram. The distance L normal to the line and between the line and 
%     the histogram h[b] is computed for all values from a to b. The level
%     where the distance between the histogram and the line is maximal is the 
%     threshold value (level). This technique is particularly effective 
%     when the object pixels produce a weak peak in the histogram.

%     Use Triangle approach to compute threshold (level) based on a
%     1D histogram (lehisto). num_bins levels gray image. 

%     INPUTS
%         lehisto :   histogram of the gray level image
%         num_bins:   number of bins (e.g. gray levels)
%     OUTPUT
%         level   :   threshold value in the range [0 1];
% 
%     Dr B. Panneton, June, 2010
%     Agriculture and Agri-Food Canada
%     St-Jean-sur-Richelieu, Qc, Canad
%     bernard.panneton@agr.gc.ca


%   Find maximum of histogram and its location along the x axis
    [h,xmax]=max(lehisto);
    xmax=round(mean(xmax));   %can have more than a single value!
    h=lehisto(xmax);
    
%   Find location of first and last non-zero values.
%   Values<h/10000 are considered zeros.
    indi=find(lehisto>h/10000);
    fnz=indi(1);
    lnz=indi(end);

%   Pick side as side with longer tail. Assume one tail is longer.
    lspan=xmax-fnz;
    rspan=lnz-xmax;
    if rspan>lspan  % then flip lehisto
        lehisto=fliplr(lehisto');
        a=num_bins-lnz+1;
        b=num_bins-xmax+1;
        isflip=1;
    else
        lehisto=lehisto';
        isflip=0;
        a=fnz;
        b=xmax;
    end
    
%   Compute parameters of the straight line from first non-zero to peak
%   To simplify, shift x axis by a (bin number axis)
    m=h/(b-a);
    
%   Compute distances
    x1=0:(b-a);
    y1=lehisto(x1+a);
    beta=y1+x1/m;
    x2=beta/(m+1/m);
    y2=m*x2;
    L=((y2-y1).^2+(x2-x1).^2).^0.5;

%   Obtain threshold as the location of maximum L.    
    level=find(max(L)==L);
    level=a+mean(level);
    
%   Flip back if necessary
    if isflip
        level=num_bins-level+1;
    end
    
    level=level/num_bins;
    
   
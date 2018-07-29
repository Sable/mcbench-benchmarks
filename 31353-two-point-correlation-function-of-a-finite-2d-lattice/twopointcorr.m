%[ corrfun r rw] = twopointcorr( x,y,dr)
%
%   Computes the two point correlation function of a 2D lattice
%   of a fixed width and height
%
%   x - list of x coordinates of points
%   y - list of y coordinates of points
%   dr - binning distance for successive circles
%   blksize - optional, default 1000, number of points to be considered
%   in a single step.
%   verbose - if true, will print which step is currently processed

% coorfun - two point correlation function
% r - r-coordinates for the coordfun
% rw - number of particles that participated in particular r value 
% corrfun computation. Low rw means corrfun is unreliable at that r.

% Developed by Ilya Valmianski
% email: ivalmian@ucsd.edu

function [ corrfun r rw] = twopointcorr( x,y,dr,blksize,verbose)
    
    %validate input     
    if length(x)~=length(y),
        error('Length of x should be same as length of y'); 
    elseif  numel(dr)~=1,
        error('dr needs to have numel==1');
    elseif numel(x)~=length(x) || numel(y)~=length(y),
        error('Require x and y to be 1D arrays');
    end
    
    %set blksize is properly specified
    if nargin < 4
        blksize = 1000;
    elseif numel(blksize)~=1,
        error('blksize must have numel = 1');
    elseif blksize < 1,
        blksize = 1;
    elseif isinf(blksize) || isnan(blksize),
        blksize = length(x);
    end
    
    if nargin ~= 5,
        verbose = false;
    elseif numel(verbose)~=1,
        error('verbose must have numel = 1');
    end   
        
        
    %real height/width
    width = max(x)-min(x);
    height = max(y)-min(y);
    
    %number of particles
    totalPart = length(x);
    
    %largest radius possible
    maxR = sqrt((width/2)^2 + (height/2)^2);
    
    %r bins and area bins
    r = dr:dr:maxR;
    av_dens = totalPart/width/height;
    rareas = ((2*pi*r* dr)*av_dens);
    
    %preallocate space for corrfun/rw
    corrfun = r*0;
    rw = r*0;
    
    %number of steps to be considered
    numsteps = ceil(totalPart / blksize);
    
    for j = 1:numsteps,
 
        %loop through all particles and compute the correlation function
        indi = (j-1)*blksize+1;
        indf = min(totalPart,j*blksize);
        
        if verbose,
            disp(['Step ' num2str(j) ' of ' num2str(numsteps) '. ' ...
                'Analyzing points ' num2str(indi) ' to '  num2str(indf)...
                ' of total ' num2str(totalPart)]);
        end
        
      
        [corrfunArr rwArr] = ...
            arrayfun(@ (xj,yj) onePartCorr(xj,yj,x,y,r,rareas),...
            x(indi:indf),y(indi:indf),'UniformOutput',false);

        rw = rw + sum(cell2mat(rwArr),1);
        
        corrfun =  corrfun+sum(cell2mat(corrfunArr),1);
      
    end
   
    corrfun = corrfun ./ rw;
    
    %truncate values that have not had contirbutions
    corrfun = corrfun(rw~=0);
    r = r(rw~=0);
    rw = rw(rw~=0);
    
end

function [corrfun rw] = onePartCorr(xj,yj,x,y,r,rareas)

    %compute radiuses in the (xj,yj) centered coordinate system
    rho=hypot(x-xj,y-yj);
    rho=rho(logical(rho))';

    %compute maximum unbiased rho
    maxRho = min([max(x)-xj,xj-min(x),max(y)-yj,yj-min(y)]);
    
    %truncate to highest unbiased rho
    rho=rho(rho<maxRho);
    
    %indicate for which r-values the correlation function is computed
    rw=r*0;
    rw(r<maxRho)=1;

    %compute count with correct binning
    count=histc( rho,[-inf r]');
    count=count(2:end);

    %normalize density
    corrfun = count./rareas;  


end
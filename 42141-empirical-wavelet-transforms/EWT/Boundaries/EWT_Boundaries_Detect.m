function boundaries = EWT_Boundaries_Detect(ff,params)

%=======================================================================
% function boundaries = EWT_Boundaries_Detect(ff,params)
%
% This function segments f into a certain amount of supports by 
% using different technics: 
% - middle point between consecutive local maxima,
% - lowest minima between consecutive local maxima,
% - fine to coarse histogram segmentation algorithm.
%
% Moreover some preprocessing are available in order to remove a
% global trend:
% - by substracting a power law approximation
% - by substracting a polynomial approximation
% - by substracting the average of the opening and closing of ff
%   (the size of the structural element is automatically detected)
% - by substracting the opening of ff
%   (the size of the structural element is automatically detected)
%
% Note: the detected boundaries are given in term of indices
%
% Inputs:
%   -ff: the function to segment
%   -params: structure containing the following parameters:
%       -params.log: 0 or 1 to indicate if we want to work with
%                    the log of the ff
%       -params.preproc: 'none','plaw','poly','morpho,'tophat'
%       -params.method: 'locmax','locmaxmin','ftc'
%       -params.N: maximum number of supports (needed for the
%                  locmax and locmaxmin methods)
%       -params.degree: degree of the polynomial (needed for the
%                       polynomial approximation preprocessing)
%       -params.completion: 0 or 1 to indicate if we try to complete
%                           or not the number of modes if the detection
%                           find a lower number of mode than params.N
%
% Outputs:
%   -boundaries: list of detected boundaries
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%=======================================================================


% Apply the log if needed
if params.log==1
    ff=log(ff);
end

f=ff(1:round(length(ff)/2));

switch lower(params.preproc)
    case 'none'
        %% No preprocessing
        presig = f;
    case 'plaw'
        %% power law substraction
        [s,law,presig]=Powerlaw_Estimator(f);
    case 'poly'
        %% Polynomial interpolation substraction
        w=0:round(length(ff)/2)-1;
        w=w';
        [p,s]=polyfit(w,f,params.degree);
        presig=f-polyval(p,w);
    case 'morpho'
        %% (Opening+Closing)/2 substraction
        % We detect first the size of the structural element
        % as the smallest distance between two consecutive maxima +1
        locmax=zeros(size(f));
        % We detect the local maxima
        for i=2:length(f)-1
            if ((f(i-1)<f(i)) && (f(i)>f(i+1)))
                locmax(i)=f(i);
            end
        end
        sizeel=length(f);
        n=1;np=1;
        while (n<length(locmax)+1)
           if (locmax(n)~=0)
                if sizeel>(n-np)
                    sizeel=n-np;
                end
                np=n;
                n=n+1;
           end
           n=n+1;
        end
        presig=f-(FunctionOpening(f,sizeel+1)+FunctionClosing(f,sizeel+1))/2;
    case 'tophat'
        %% Opening substraction (TopHat operator)
        % We detect first the size of the structural element
        % as the smallest distance between two consecutive maxima +1
        locmax=zeros(size(f));
        % We detect the local maxima
        for i=2:length(f)-1
            if ((f(i-1)<f(i)) && (f(i)>f(i+1)))
                locmax(i)=f(i);
            end
        end
        sizeel=length(f);
        n=1;np=1;
        while (n<length(locmax)+1)
           if (locmax(n)~=0)
                if sizeel>(n-np)
                    sizeel=n-np;
                end
                np=n;
                n=n+1;
           end
           n=n+1;
        end
        presig=f-FunctionOpening(f,sizeel+1);
end

switch lower(params.method)
    case 'locmax'
        boundaries = LocalMax(presig,params.N);
    case 'locmaxmin'
        %% We extract the lowest local minima between to selected local maxima
        boundaries = LocalMaxMin(presig,params.N);
    case 'ftc'
        %% We extract the boundaries of Fourier segments by FTC
        boundaries = FTC_Histogram_Segmentation(presig);
end

%% If asked, and needed perform the completion of the number of modes
if params.completion==1
    boundaries=EWT_Boundaries_Completion(boundaries,params.N-1);
end

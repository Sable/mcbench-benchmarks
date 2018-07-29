function boundaries = EWT_Angles_Detect(f,params)

%================================================================
% function boundaries = EWT_Angles_Detect(f,params)
%
% This function segments f into a certain amount of supports by 
% using different techniques: 
% - middle point between consecutive local maxima,
% - lowest minima between consecutive local maxima,
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
%       -params.preproc: 'none','plaw','poly','morpho','tophat'
%       -params.method: 'locmax','locmaxmin'
%       -params.N: maximum number of supports (needed for the
%                  locmax and locmaxmin methods)
%       -params.degree: degree of the polynomial (needed for the
%                       polynomial approximation preprocessing)
%
% Outputs:
%   -boundaries: list of detected boundaries
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%===============================================================

% We perform the preprocessing
switch lower(params.curvpreproc)
    case 'none'
        %% No preprocessing
        presig = f;
    case 'plaw'
        %% power law substraction
        [s,law,presig]=Powerlaw_Estimator(f);
    case 'poly'
        %% Polynomial interpolation substraction
        w=0:length(f)-1;
        w=w';
        [p,s]=polyfit(w,f,params.curvdegree);
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
        %% Opening substraction
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
        presig=f-FunctionOpening(f,2*sizeel+1);
end

% We perform the detection itself
switch lower(params.curvmethod)
    case 'locmax'
        boundaries = AnglesLocalMax(presig,params.curvN);
    case 'locmaxmin'
        %% We extract the lowest local minima between to selected local maxima
        boundaries = AnglesLocalMaxMin(presig,params.curvN);
end
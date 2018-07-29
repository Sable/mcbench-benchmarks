function [r,c]=stdrc(w,maxr,minr,maxc,minc)
%Syntax: [r,c]=stdrc(w,maxr,minr,maxc,minc)
%__________________________________________
%
% Standardize the length and the standard deviation of the weights' matrix
% entries. An auxiliary function.
%
% r is the standardized range.
% c is the standardized standard deviation, can also be used for coloring.
% w is the weights matrix.
% maxr is the maximum possible range.
% minr is the minimum possible range.
% maxc is the maximum possible color.
% minc is the minimum possible color.
%
%
% References:
%
% Sangole A., Knopf G. K. (2002): Representing high-dimensional data sets
% as close surfaces. Journal of Information Visualization 1: 111-119
%
% Sangole A., Knopf G. K. (2003): Geometric representations for
% high-dimensional data using a spherical SOFM. International Journal of
% Smart Engineering System Design 5: 11-20
%
% Sangole A., Knopf G. K. (2003): Visualization of random ordered numeric
% data sets using self-organized feature maps. Computers and Graphics 27:
% 963-976
%
% Sangole A. P. (2003): Data-driven Modeling using Spherical
% Self-organizing Feature Maps. Doctor of Philosophy (Ph.D.) Thesis. 
% Department of Mechanical and Materials Engineering. Faculty of
% Engineering. The University of Western Ontario, London, Ontario, Canada.
%
%
% Archana P. Sangole, PhD., P.E. (TX chapter)
% School of Physical & Occupational Therapy
% McGill University
% 3654 Promenade Sir-William-Osler
% Montreal, PQ, H3G 1Y5
% e-mail: archana.sangole@mail.mcgill.ca
%
% CRIR, Rehabilitation Institute of Montreal
% 6300 Ave Darlington
% Montreal, PQ, H3S 2J5
% Tel: 514.340.2111 x2188
% Fax: 514.340.2154
%
%
% Alexandros Leontitsis, PhD
% Department of Education
% University of Ioannina
% 45110- Dourouti
% Ioannina
% Greece
% 
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
% 
% 23-Mar-2006


if nargin<2 | isempty(maxr)==1
    maxr=NaN;
else
    % maxr must be a scalar
    if sum(size(maxr))>2
        error('maxr must be a scalar.');
    end
end

if nargin<3 | isempty(minr)==1
    minr=NaN;
else
    % minr must be a scalar
    if sum(size(minr))>2
        error('minr must be a scalar.');
    end
end

if nargin<4 | isempty(maxc)==1
    maxc=NaN;
else
    % maxc must be a scalar
    if sum(size(maxc))>2
        error('maxc must be a scalar.');
    end
end

if nargin<5 | isempty(minc)==1
    minc=NaN;
else
    % minc must be a scalar
    if sum(size(minc))>2
        error('minc must be a scalar.');
    end
end


% Calculate ...
for j=1:length(w)
    % ... the range parameter
    r(j,1)=norm(w(j,:));
    if nargout==2
        % ... the color parameter 
        c(j,1)=std(w(j,:));
    end
end

if isnan(maxr)==1
    maxr=max(r);
else
    r=min(r,maxr);
end
if isnan(minr)==1
    minr=min(r);
else
    r=max(r,minr);
end

if nargout==2
    if isnan(maxc)==1
        maxc=max(c);
    else
        c=min(c,maxc);
    end
    if isnan(minc)==1
        minc=min(c);
    else
        c=max(c,minc);
    end
end

% Rescale the range: min(range)=1.0, max(range)=1.2
if maxr>minr
    r=(r-minr)/(maxr-minr)*0.2+1;
else
    r=0;
end

if nargout==2
    % Rescale the color: min(color)=1.0, max(color)=1.2
    if maxc>minc
        c=(c-minc)/(maxc-minc)*0.2+1;
    else
        c=0;
    end
end
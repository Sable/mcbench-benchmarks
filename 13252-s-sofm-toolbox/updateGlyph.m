function [wnew,freqnew]=updateGlyph(P,X,C,w,a,s,freq)
%Syntax: [wnew,freqnew]=updateGlyph(P,X,C,w,a,s,freq)
%____________________________________________________
%
% Weight matrix update of a Spherical Self-Organized Feature Map.
%
% wnew is the updated weights' matrix.
% freqnew is the updated count-dependent parameter.
% P is the A-by-B matrix with the patterns to be classified.
% X is the N-by-3 matrix with the cartesian coordinates of the points on 
%   the sphere.
% C is a cell array with the neighbors. The {i,j} cell represents the
%   neighbors of radius i of the j-th sphere point.
% w is the weights matrix to be updated.
% a is the training parameter.
% s is the neighborhood size parameter.
% freq is the count-dependent parameter.
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


if nargin<2 | isempty(P)==1 | isempty(X)==1
    error('More input arguments needed. Both P and X are rquired.');
else
    % P must be an A-by-B matrix
    if ndims(P)~=2
        error('P must be an A-by-B matrix.');
    end
    % X must be an M-by-3 matrix
    if size(X,2)~=3 | ndims(X)~=2
        error('X must be an N-by-3 matrix.');
    end
end

if isempty(C)==0
    % C and X must be of the same length
    if length(C)~=length(X)
        error('C and X must be of the same length.');
    end
    % Set the neighborhood radious
    r=size(C,2);
    % Set the h function
    h=exp(-(1:r).^2/(s*r));
end

if nargin<4 | isempty(w)==1
    w=randn(size(X,1),size(P,2));
    for i=1:size(X,2)
        w(:,i)=w(:,i)*std(P(:,i));
    end
else
    % w must be an N-by-B matrix
    if size(w,1)~=size(X,1) | size(w,2)~=size(P,2) | ndims(X)~=2
        error('w must be an N-by-B matrix.');
    end
end

if nargin<5 | isempty(a)==1
    a=0.1;
else
    % a must be a scalar
    if sum(size(a))>2
        error('a must be a scalar.');
    end
end

if nargin<6 | isempty(s)==1
    s=2;
else
    % s must be a scalar
    if sum(size(s))>2
        error('s must be a scalar.');
    end
    % s must be positive
    if s<=0
        error('s must be positive.');
    end
end

if nargin<7 | isempty(freq)==1
    freq=zeros(length(X),1);
else
    % freq must be a vector
    if min(size(freq))>1
        error('freq must be a vector.');
    end
    % freq must have the same length with X
    if length(freq)~=length(X)
        error('freq must have the same length with X.');
    end
end


% Initialize the weights
wnew=w;

% Initialize freqnew
freqnew=freq;

% Randomize the order of the patterns
q=randperm(size(P,1));

% For each uniformly random pattern
for j=1:size(P,1)
    % Measure the difference between the current P and all the weights
    A=q(j)*ones(size(wnew,1),1);
    d=P(A,:)-wnew;
    % Calculate the norm and apply the count-dependent parameter
    d=sqrt(sum((d.^2)'))'.*(freqnew+1);
    % Obtain the minimum distance and the corresponding index
    [D,I]=min(d);
    % Calculate the new weights
    wnew(I,:)=wnew(I,:)+a*(P(q(j),:)-wnew(I,:));
    % If the neighborhood matrix is given
    if isempty(C)==0
        % For each neghborhood radius
        for k=1:r
            A=q(j)*ones(size(C{I,k}));
            % Calculate the new weights of the neighbors
            wnew(C{I,k},:)=wnew(C{I,k},:)+a*h(k)*(P(A,:)-wnew(C{I,k},:));
            % Update the count-dependent parameter for the neighbors
            freqnew(C{I,k})=freqnew(C{I,k})+h(k);
        end
    end
    % Update the count-dependent parameter
    freqnew(I)=freqnew(I)+1;
end
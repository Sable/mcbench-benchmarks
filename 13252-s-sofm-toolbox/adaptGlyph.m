function [wnew,r,c,freqnew]=adaptGlyph(P,X,C,w,a,freq,showglyph)
%Syntax: [wnew,r,c,freqnew]=adaptGlyph(P,X,C,w,a,freq,showglyph)
%_______________________________________________________________
%
% Adaptive Spherical Self-Organized Feature Map training.
%
% wnew is the updated weights' matrix.
% r is a vector with the scaled range estimates for each weight.
% c is a vector with the scaled color estimates for each wieght.
% freqnew is the updated count-dependent parameter.
% P is the A-by-B matrix with the patterns to be classified.
% X is the N-by-3 matrix with the cartesian coordinates of the points on 
%   the sphere.
% a is the learning rate.
% C is a cell array with the neighbors. The {i,j} cell represents the
%   neighbors of radius i of the j-th sphere point.
% w is the weights matrix.
% freq is the count-dependent parameter.
% showglyph is a sting and it can take the following values:
%   'none' for not displaying anything.
%   'glyph' for displaying the glyph formation progress on screen.
%   otherwise acts as 'glyph' plus it makes an avi file with the same name.
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
end

if nargin<4 | isempty(w)==1
    w=rand(size(X,1),size(P,2));
else
    % w must be an N-by-B matrix
    if size(w,1)~=size(X,1) | size(w,2)~=size(P,2) | ndims(X)~=2
        error('w must be an N-by-B matrix.');
    end
end

if nargin<5 | isempty(a)==1
    a=0.01;
else
    % a must be a scalar
    if sum(size(a))>2
        error('a must be a scalar.');
    end
end

if nargin<6 | isempty(freq)==1
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

if nargin<7 | isempty(showglyph)==1
    showglyph='none';
end


if strcmp(showglyph,'none')==0
    if strcmp(showglyph,'glyph')==0
        % Create an avi file
        aviobj = avifile(showglyph,'quality',100,'fps',10);
    end
    % Standardize the range
    r=stdrc(w);
    % Draw the glyph
    glyph(X,r);
    drawnow
    if strcmp(showglyph,'glyph')==0
        % Add the first frame
        aviobj = addframe(aviobj,getframe(gcf));
    end
end

j=1;
% For each new pattern
for i=1:size(P,1)
    % Update the weights
    [w,freq]=updateGlyph(P(i,:),X,C,w,a,freq);
    if strcmp(showglyph,'none')==0
        % Standardize the range
        r=stdrc(w);
        % Draw the glyph
        glyph(X,r);
        drawnow
        if strcmp(showglyph,'glyph')==0
            % Add another frame
            aviobj = addframe(aviobj,getframe(gcf));
        end
    end
end

[r,c]=stdrc(w);
freqnew=freq;
wnew=w;

if strcmp(showglyph,{'none','glyph'})==0
    % Close the avi file
    aviobj = close(aviobj);
end

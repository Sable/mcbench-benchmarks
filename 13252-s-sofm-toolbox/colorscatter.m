function colorscatter(P,v)
%Syntax: colorscatter(P,v)
%_________________________
%
% Color scatter plot in 2 or 3 dimensions.
%
% P is the A-by-2 or A-by-3 matrix with the patterns to be classified.
% v is the center of mass vector
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


if nargin<1 | isempty(P)==1
    error('P is rquired.');
end

if nargin<2 | isempty(v)==1
    v=mean(P);
else
    % v sould be an 1-by-sise(P,2) vector
    [a b]=size(v);
    if a~=1 & b~=size(P,2)
        error('v sould be an 1-by-sise(P,2) vector.');
    end
end


% Remove the center of mass
P=P-ones(size(P,1),1)*v;

% Define the color
c=sqrt(sum(P'.^2))';

switch size(P,2)
    case 2
        scatter(P(:,1),P(:,2),20,c,'filled');
    case 3
        scatter3(P(:,1),P(:,2),P(:,3),20,c,'filled');
    otherwise
        error('The dimension of P should be either 2 or 3.');
end

axis tight
axis off

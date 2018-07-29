function [w,smooth,accurate]=Lcurve(P,X,C,s,epochs)
%Syntax: [w,smooth,accurate]=Lcurve(P,X,C,s,epochs)
%__________________________________________________
%
% The estimation of the L-curve for Spherical Self-Organized Feature Maps.
%
% w is the weights matrix.
% smooth is the smoothness parameter for each value of s.
% accurate is the accuracy parameter for each value of s.
% P is the A-by-B matrix with the patterns to be classified.
% X is the N-by-3 matrix with the cartesian coordinates of the points on 
%   the sphere.
% C is a cell array with the neighbors. The {i,j} cell represents the
%   neighbors of radius i of the j-th sphere point.
% s is the neighborhood parameter.
% epochs is a vector with positive elements in ascending order
%   its maximum element defines the total number of the training cycles.
%   the function shows the progress on every element of epochs.
%
%
% Reference:
%
% Leontitsis A. Sangole A. P. (2005): Estimating an optimal neighborhood
% size in the spherical self-organizing feature map. International Journal
% of Computational Intelligence 2(1): 94-98
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


% For each value of s...
for i=1:length(s(:))
    
    % Display the progress
    disp(['Calculating s(' num2str(i) ')...']);
    
    % Calculate the weights
    if nargin==5
        w(:,:,i)=trainSphSOFM(P,X,C,s(i),epochs);
    else
        w(:,:,i)=trainSphSOFM(P,X,C,s(i));
    end    
    
    % Calculate the accuracy parameter
    for j=1:size(P,1)
        for k=1:size(w,1)
            d(k,1)=norm(P(j,:)-w(k,:,i));
        end
        acc(j,1)=min(d);
    end
    accurate(i,1)=sum(acc);
    
    % Calculate the smoothness parameter
    for j=1:size(w,1)
        W=mean(w(C{j,1},:,i));
        try 
            smo(j,1)=norm(w(j,:,i)-W);
        catch
            W
            w(j,:,i)
            C{j,1}
            return
        end
    end
    smooth(i,1)=sum(smo);
    
end
function [w,g,r,c,freq]=trainGlyph(P,X,C,s,epochs,showglyph)
%Syntax: [w,g,r,c,freq]=trainGlyph(P,X,C,s,epochs,showglyph)
%___________________________________________________________
%
% Spherical Self-Organized Feature Map training.
%
% w is the weights matrix.
% g is an estimate of weights' convergence.
% r is a vector with the scaled range estimates for each weight.
% c is a vector with the scaled color estimates for each wieght.
% freq is the count-dependent parameter, saved for further training.
% P is the A-by-B matrix with the patterns to be classified.
% X is the N-by-3 matrix with the cartesian coordinates of the points on 
%   the sphere.
% C is a cell array with the neighbors. The {i,j} cell represents the
%   neighbors of radius i of the j-th sphere point.
% s is the neighborhood parameter.
% epochs is a vector with positive elements in ascending order
%   its maximum element defines the total number of the training cycles.
%   the function shows the progress on every element of epochs.
% showglyph is a sting and it can take the following values:
%   'none' for not displaying anything.
%   'plot' for displaying the convergence plot.
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
    % Remove the mean
    meanP=mean(P);
    % X must be an M-by-3 matrix
    if size(X,2)~=3 | ndims(X)~=2
        error('X must be an N-by-3 matrix.');
    end
end

if nargin<4 | isempty(s)==1
    s=2;
else
    % s must be a scalar
    if sum(size(s))>2
        error('s must be a scalar.');
    end
    % s must be positive
    if s<0
        error('s must be positive.');
    end
end

if nargin<5 | isempty(epochs)==1
    epochs=20;
else
    % epochs must be either a scalar or a vector
    if min(size(epochs))>1
        error('epochs must be a scalar or a vector.');
    end
    % epochs must contain integers
    if any(epochs~=round(epochs))==1
        error('epochs must contain integers.');
    end
    % All the elements in epochs must be positive
    if any(epochs<1)==1
        error('All the elements in epochs must be positive.');
    end
    % All the elements in epochs must be in ascending order
    if length(find(diff(epochs)==0))>0
        error('All the elements in epochs must be in ascending order.');
    end
end

if nargin<6 | isempty(showglyph)==1
    showglyph='none';
end


% Initialize the weights
w=randn(size(X,1),size(P,2)).*(ones(size(X,1),1)*std(P))+ones(size(X,1),1)*mean(P);

% Initialize the convergence estimate
g=zeros(max(epochs),2);
g(1,:)=[mean(stdrc(w)) 1.96*std(stdrc(w))/sqrt(size(X,1))];

% Initialize the count-dependent parameter
freq=zeros(length(w),1);

if strcmp(showglyph,{'none','plot'})==0
    if strcmp(showglyph,'glyph')==0
        % Create an avi file
        aviobj = avifile(showglyph,'quality',100,'fps',2);
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
% For each epoch
for i=1:max(epochs)
    % Define the learning rate
    a=0.1*exp(-i/max(epochs));
    % Update the weights
    [w,freq]=updateGlyph(P,X,C,w,a,s,freq);
    % Update g
    g(i+1,:)=[mean(stdrc(w)) 1.96*std(stdrc(w))/sqrt(size(X,1))];
    if strcmp(showglyph,{'none','plot'})==0
        % Standardize the range
        r=stdrc(w);
        % Draw the glyph
        glyph(X,r);
        drawnow
        if strcmp(showglyph,'glyph')==0
            % Add another frame
            aviobj = addframe(aviobj,getframe(gcf));
        end
    elseif showglyph=='plot'
        %plot(0:i,g(1:i+1),'.-','LineWidth',2);
        errorbar(0:i,g(1:i+1,1),g(1:i+1,2),'.-','LineWidth',2);
        axis([0 max(1,i) 1 1.2])
        xlabel('epoch #');
        ylabel('convergence');
        if i<=10
            if i==1
                set(gca,'XTick',0:2);
            else
                set(gca,'XTick',1:i);
            end
        else
            set(gca,'XTickMode','auto');
        end
        drawnow
    else
        % Show progress
        if i==epochs(j)
            fprintf('Epoch %4.0f, log10(convergence) %9.4f\n',i,log10(g(i)));
            j=j+1;
        end
    end
end

[r,c]=stdrc(w);

if strcmp(showglyph,{'none','plot','glyph'})==0
    % Close the avi file
    aviobj = close(aviobj);
end

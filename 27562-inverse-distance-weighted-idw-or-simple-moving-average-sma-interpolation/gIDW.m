% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                                 %
%                 Produced by Giuliano Langella                   %
%                   e-mail:gyuliano@libero.it                     %
%                        February 2010                            %
%                                                                 %
%                   Last Updated: 20 May, 2010                    %
%                                                                 %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%% DECLARATION
function Vi = gIDW(Xc,Yc,Vc,Xi,Yi,w,r1,r2)
%% OUTPUTS
% Vi:   (mandatory) [PxQ]       gIDW interpolated values
%                                --> P=1, Q=1 yields interpolation at one
%                                    point
%                                --> P>1, Q=1 yields interpolation at a
%                                    vector of points
%                                --> P>1, Q>1 yields interpolation at a
%                                    (ir)regular grid of points
%% INPUTS
% Xc:   (mandatory) [Nx1]       x coordinates of known points
% Yc:   (mandatory) [Nx1]       y coordinates of known points
% Vc:   (mandatory) [Nx1]       known values at [Xc, Yc] locations
% Xi:   (mandatory) [PxQ]       x coordinates of points to be interpolated
% Yi:   (mandatory) [PxQ]       y coordinates of points to be interpolated
% w:    (mandatory) [scalar]    distance weight
%                                --> w<0, for Inverse Distance Weighted
%                                    interpolation [IDW]
%                                --> w=0, for Simple Moving Average (only
%                                    if neighorhood size is local and not
%                                    global) [SMA]
% r1:   (optional)  [string]    neighbourhood type
%                                --> 'n'     (default) number of neighbours
%                                --> 'r'     fixed radius length
% r2:   (optional)  [scalar]    neighbourhood size
%                                --> number of neighbours,  if r1=='n'
%                                    default is length(Xc)
%                                --> radius length,         if r1=='r'
%                                    default is largest distance between known points
%% SYNTAX
% ================== IDW ==================
% all inputs:
%   Vi = gIDW(Xc,Yc,Vc,Xi,Yi,-2,'n',30);
% 6 inputs:
%   Vi = gIDW(Xc,Yc,Vc,Xi,Yi,-2);
%       --> r1='n'; r2=length(Xc);
% 7 inputs:
%   Vi = gIDW(Xc,Yc,Vc,Xi,Yi,-2,'n');
%       --> r2=length(Xc);
%   Vi = gIDW(Xc,Yc,Vc,Xi,Yi,-2,'r');
%       --> r2=largest distance between know points [Xi,Yi] (see D1 calculation)
% ================== SMA ==================
%   Vi = gIDW(Xc,Yc,Vc,Xi,Yi,0,'n',10);
% ============== Spatial Map ==============
%   Vi = gIDW(Xc,Yc,Vc,Xi,Yi,-2,'n',10);
%       -with Xi and Yi 2D arrays of coordinates relative to an (ir)regular
%        grid.
%% EXAMPLES
% Interpolation at one point location:
%   Vi = gIDW([1:1:10]',[2:2:20]',rand(10,1)*100,5.5,11,-2,'n');
% =======================================
% Interpolation at a regular grid of unknown points:
%   XYc = [1:1:10]';
%   Vc = rand(10,1)*100;
%   Xi = rand(50,50)*10;
%   Yi = rand(50,50)*10;
%   [Xi,Yi] = meshgrid(XYc);
%   Vi = gIDW(XYc,XYc,Vc,Xi,Yi,-2,'r',3);
%   hold on
%   mapshow(Xi,Yi,Vi,'DisplayType','surface')
%   colormap gray
%   scatter(XYc,XYc,Vc,'filled','MarkerFaceColor','g','MarkerEdgeColor','y')
%   axis([0,11,0,11])
%   hold off
%% CODE
% check consistency of input parameters
if ~(length(Xc)-length(Yc)==0) || ~(length(Xc)-length(Vc)==0)
    error('varargin:chk',['Vectors Xc, Yc and Vc are incorrectly sized!'])
elseif ~(length(Xi)-length(Yi)==0)
    error('varargin:chk',['Vectors Xi and Yi are incorrectly sized!'])
elseif nargin < 6
    error('varargin:chk',['Uncorrect number of inputs!'])
end

% build input parameters
if nargin ~=8
    if nargin < 7   % default is 'n'
        r1 = 'n';
        r2 = length(Xc);
    elseif nargin==7 & r1=='n'
        r2 = length(Xc);
    elseif nargin==7 & r1=='r'  %for 'r' default is largest distance between know points
        [X1,X2] = meshgrid(Xc);
        [Y1,Y2] = meshgrid(Yc);
        D1 = sqrt((X1 - X2).^2 + (Y1 - Y2).^2);
        r2 = max(D1(:));     % largest distance between known points
        clear X1 X2 Y1 Y2 D1
    end
else
    switch r1 
        case {'r', 'n'}
            %nothing
        otherwise
            error('r1:chk',['Parameter r1 ("' r1 '") not properly defined!'])
    end
end

% initialize output
Vi = zeros(size(Xi,1),size(Xi,2));
D=[]; Vcc=[];

% fixed radius
if  strcmp(r1,'r')
    if  (r2<=0)
        error('r2:chk','Radius must be positive!')
        return
    end
    wb = waitbar(0,mfilename);
    for i=1:length(Xi(:))
        waitbar(i/length(Xi(:)))
%         if length(Xi(:))> 100, progress_bar(i, length(Xi(:)), mfilename); end
        D = sqrt((Xi(i)-Xc).^2 +(Yi(i)-Yc).^2);
        D = D(D<r2);
        Vcc = Vc(D<r2);
        if isempty(D)
            Vi(i) = NaN;
        else
            if sum(D==0)>0
                Vi(i) = Vcc(D==0);
            else
                Vi(i) = sum( Vcc.*(D.^w) ) / sum(D.^w);
            end
        end
    end
    close(wb)
% fixed neighbours number
elseif  strcmp(r1,'n')
    if (r2 > length(Vc)) || (r2<1)
        error('r2:chk','Number of neighbours not congruent with data')
        return
    end
    wb = waitbar(0,mfilename);
    for i=1:length(Xi(:))
        waitbar(i/length(Xi(:)))
%         if length(Xi(:))>100, progress_bar(i, length(Xi(:)), mfilename); end
        D = sqrt((Xi(i)-Xc).^2 +(Yi(i)-Yc).^2);
        [D,I] = sort(D);
        Vcc = Vc(I);
        if D(1) == 0
            Vi(i) = Vcc(1);
        else
            Vi(i) = sum( Vcc(1:r2).*(D(1:r2).^w) ) / sum(D(1:r2).^w);
        end
    end
    close(wb)
end

return
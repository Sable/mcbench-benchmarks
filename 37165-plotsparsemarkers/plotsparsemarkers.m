function varargout = plotsparsemarkers(varargin)
%
%  [h =] plotsparsemarkers(hp, hl, markerStyle[, numberOfMarkers = 6 [,staggered = true]])
%
%  Adds only a limited number of markers to a set of lines given by
%  the handle array hp. If hl is not [] it should be the handle of 
%  the legend corresponding to the lines.
%
%  markerStyle is a cell array of styles, e.g. {'o', 'x'} describing
%  the markers for the lines in hp, the length of the cell array has
%  to be the same as hp (or shorter in which case not all lines will get 
%  markers).
%
%  numberOfMarkers is an optional parameter, default = 6, that sets 
%  the number of markers on each line, this number must be equal or less
%  than the number of points plotted for each line.
%
%  staggered is a boolean that tries to stagger the markers so that the
%  are not at the same x value for all lines. This defaults to true and
%  is intended to avoid markers overwriting each other if the x-values
%  are identical for the lines.
%
    
    
%%
% Check input parameters
if nargin <3 
    disp('[sparsemarker]: wrong number of arguments')
    help sparsemarker
    return
end

hp = varargin{1};
hl = varargin{2};
markStyle = varargin{3};

if nargin >3
    numberOfMarkers = varargin{4};
else
    numberOfMarkers = 6;
end

if nargin >4
    staggered = varargin{5};
else
    staggered = true;
end

    
%%
% Define marker lines
nrLines =    length(markStyle);

%Create stagger distance
if staggered
    x  = 1:nrLines;
    stag = -1.^(mod(x,2)+1).*x./nrLines./2;
else 
    stag = zeros(1,nrLines);
end

for ii = 1:nrLines
    % Determine number of points in line ii
    X = get(hp(ii),'XDATA');
    Y = get(hp(ii),'YDATA');
    interval = (X(end)-X(1))./(numberOfMarkers+2);
    targetx  = stag(ii)*interval + ...  %Stagger offset
                  linspace(X(1)+interval,X(end)-interval,...
                           numberOfMarkers);
    for jj = 1:numberOfMarkers
       [~,ind] = min(abs(targetx(jj)-X));
       mx(ii,jj) = X(ind);
       my(ii,jj) = Y(ind);
    end    
end

whos mx my

%%
% plot marker lines
hpp = get(hp(ii),'Parent');
set(hpp,'LineStyleOrder',markStyle); %This is a bad solution 
                                     %that works
hold on
h = plot(mx',my');
hold off
%Change markers to same color as the line
for ii = 1:nrLines
    set(h(ii),'MarkerEdgeColor',get(hp(ii),'Color'));
    set(h(ii),'Marker',markStyle{ii});
    set(h(ii),'MarkerSize',12);  %These are sizes I like  
    set(h(ii),'LineWidth',2);    %you can change them using  
end                              %the handle that is returned


%%
% update legend
if ~isempty(hl)
    hlc = get(hl,'Children');
    for ii = 1:nrLines
        jj = (nrLines-ii)*3+1;
        set(hlc(jj),'Marker',markStyle{ii});
        set(hlc(jj),'Marker',markStyle{ii});
        set(hlc(jj),'MarkerEdgeColor',get(hp(ii),'Color'));
        set(hlc(jj),'MarkerSize',12);    
    end
end

%%
% Return handle to markers
if nargout > 0
    varargout{1} = h;
end

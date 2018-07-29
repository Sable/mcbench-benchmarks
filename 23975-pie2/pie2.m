function hh = pie(varargin)
%PIE    Pie chart.
%   PIE(X) draws a pie plot of the data in the vector X.  The values in X
%   are normalized via X/SUM(X) to determine the area of each slice of pie.
%   If SUM(X) <= 1.0, the values in X directly specify the area of the pie
%   slices.  Only a partial pie will be drawn if SUM(X) < 1.
%
%   PIE(X,EXPLODE) is used to specify slices that should be pulled out from
%   the pie.  The vector EXPLODE must be the same size as X. The slices
%   where EXPLODE is non-zero will be pulled out.
%
%   PIE(...,LABELS) is used to label each pie slice with cell array LABELS.
%   LABELS must be the same size as X and can only contain strings.
%
%   PIE(AX,...) plots into AX instead of GCA.
%
%   H = PIE(...) returns a vector containing patch and text handles.
%
%   Example
%      pie([2 4 3 5],{'North','South','East','West'})
%
%   See also PIE3.

%   Clay M. Thompson 3-3-94
%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 1.16.4.8 $  $Date: 2005/10/28 15:54:38 $

% Parse possible Axes input
[cax,args,nargs] = axescheck(varargin{:});
error(nargchk(1,3,nargs,'struct'));

x = args{1}(:); % Make sure it is a vector
args = args(2:end);

nonpositive = (x <= 0);
if all(nonpositive)
    error('MATLAB:pie:NoPositiveData',...
        'Must have positive data in the pie chart.');
end
if any(nonpositive)
  warning('MATLAB:pie:NonPositiveData',...
          'Ignoring non-positive data in pie chart.');
  x(nonpositive) = [];
end

% RICHARD HACK #1: The Mathworks' PIE function only scales pie slices to sum to
% one if the sum of the values is greater than 1+sqrt(eps).  In this
% version,scaling is performed regardless.
x = x/sum(x);
% END RICHARD HACK #1

% Look for labels
if nargs>1 && iscell(args{end})
  txtlabels = args{end};
  if any(nonpositive)
    txtlabels(nonpositive) = [];
  end
  args(end) = [];
else
  for i=1:length(x)
    if x(i)<.01,
      txtlabels{i} = '< 1%';
    else
      txtlabels{i} = sprintf('%d%%',round(x(i)*100));
    end
  end
end

% Look for explode
if isempty(args),
   explode = zeros(size(x)); 
else
   explode = args{1};
   if any(nonpositive)
     explode(nonpositive) = [];
   end
end

explode = explode(:); % Make sure it is a vector

if length(txtlabels)~=0 && length(x)~=length(txtlabels),
  error(id('StringLengthMismatch'),'Cell array of strings must be the same length as X.');
end

if length(x) ~= length(explode),
  error(id('ExploreLengthMismatch'),'X and EXPLODE must be the same length.');
end

cax = newplot(cax);
next = lower(get(cax,'NextPlot'));
hold_state = ishold(cax);

theta0 = pi/2;
maxpts = 100;
inside = 0;

h       = [];
midArcX = zeros(length(x),1,'double');
midArcY = zeros(length(x),1,'double');

for i=1:length(x)
  n = max(1,ceil(maxpts*x(i)));
  r = [0;ones(n+1,1);0];
  theta = theta0 + [0;x(i)*(0:n)'/n;0]*2*pi;
  if inside,
    [xtext,ytext] = pol2cart(theta0 + x(i)*pi,.5);
  else
    [xtext,ytext] = pol2cart(theta0 + x(i)*pi,1.2);
  end
  [xx,yy] = pol2cart(theta,r);
  
  % store XY co-ordinates of the mid-point on the circumference of the pie
  % slice arc for later use in drawing a 'leader' line.
  [midArcX(i), midArcY(i)] = pol2cart(theta0 + x(i)*pi,1);
  
  if explode(i),
    [xexplode,yexplode] = pol2cart(theta0 + x(i)*pi,.1);
    xtext = xtext + xexplode;
    ytext = ytext + yexplode;
    xx = xx + xexplode;
    yy = yy + yexplode;
  end
  theta0 = max(theta);
  
  % RICHARD HACK #2: The Mathworks' PIE function sets the horizontal alignment
  % of text labels to 'center'.  In this version, labels on the left hand side
  % of the pie chart are 'right' aligned, while labels on the right hand side
  % are 'left' aligned.  This counteracts the horizontal overlapping that occurs
  % when labels are clustered at the top and bottom ends of the pie.
  % A future enhancement would be to selectively invoke 'left' and 'right' 
  % alignments only where horizontal overlaps actually exist.
  
  if xtext < 0
      horizAlign = 'right';
  else
      horizAlign = 'left';
  end
   
  h = [h,patch('XData',xx,'YData',yy,'CData',i*ones(size(xx)), ...
             'FaceColor','Flat','parent',cax), ...
       text(xtext,ytext,txtlabels{i},...
            'HorizontalAlignment',horizAlign,'parent',cax)];
        
  % END RICHARD HACK #2
end

% RICHARD HACK #3: with all labels in place, detect vertical overlaps and shift
% the overlapping label vertically towards the next label by the overlap amount.
% The process is as follows:
% 1) get the text positions and extents - positions are used to move labels,
% while extents are used to detect overlaps.

% 2) starting at the top and moving anti-clockwise around the pie, consider
% labels in pairs; if each pair is on the same side (left or right) then
% continue, else skip to the next pair.

% 3) calculate the absolute vertical distance between the y-extents - this is
% the delta-y.
%
% 4) if the y-extent of the first label is greater than the y-extent of the 
% second label, then the labels are on the left hand side of the pie, 
% otherwise they're on the right hand side.

% 5) if on the left side, then if the delta-y is less than the height-extent of
% the second label, then there is an overlap and the second label should be 
% moved down by the overlap amount, otherwise do nothing and move on.

% 6) if the labels are on the right hand side of the pie - item 4), above, then
% if the delta-y is less than the height-extent of the first label, then
% there is an overlap and the second label should be moved up by the overlap
% amount, otherwise do nothing and move on.

% 7) where an overlap occurs, and once a label has been shifted, draw a
% leader line from the pie slice to the text label for added clarity.

textHandle   = findobj(h,'Type','text');
textPosition = get(textHandle, 'Position');
textOverlap  = 0;
POSN_SCALAR  = 0.95; % scales X coordinate of the line at the label end
  
for i = 1:size(textHandle)-1  % going anti-clockwise around the pie from the top
    % refresh textExtent on each iteration to reflect label movements
    textExtent = get(textHandle, 'Extent');  
    deltaY     = abs(textExtent{i}(2) - textExtent{i+1}(2));
    
    if sign(textExtent{i}(1)) == sign(textExtent{i+1}(1))  % same side of the pie
        if textExtent{i}(2) > textExtent{i+1}(2)  % left side of pie
            textOverlap = textExtent{i+1}(4) - deltaY;
            if textOverlap > 0
                % move text label
                textPosition{i+1}(2) = textPosition{i+1}(2) - textOverlap;
                set(textHandle(i+1),'Position',textPosition{i+1});
                % draw leader line to each label in the pair
                line([midArcX(i) textPosition{i}(1)*POSN_SCALAR],...
                     [midArcY(i) textPosition{i}(2)],...
                     'color', 'k', 'clipping', 'off');
                line([midArcX(i+1) textPosition{i+1}(1)*POSN_SCALAR],...
                     [midArcY(i+1) textPosition{i+1}(2)],...
                     'color', 'k', 'clipping', 'off');
            end
        else    % right side of the pie
            textOverlap = textExtent{i}(4) - deltaY;
            if textOverlap > 0
                % move text label
                textPosition{i+1}(2) = textPosition{i+1}(2) + textOverlap;
                set(textHandle(i+1),'Position',textPosition{i+1});
                % draw leader line to each label in the pair
                line([midArcX(i) textPosition{i}(1)*POSN_SCALAR],...
                     [midArcY(i) textPosition{i}(2)],...
                     'color', 'k', 'clipping', 'off');
                line([midArcX(i+1) textPosition{i+1}(1)*POSN_SCALAR],...
                     [midArcY(i+1) textPosition{i+1}(2)],...
                     'color', 'k', 'clipping', 'off');
            end
        end
    end
end
  
% END RICHARD HACK #3

if ~hold_state, 
  view(cax,2); set(cax,'NextPlot',next); 
  axis(cax,'equal','off',[-1.2 1.2 -1.2 1.2])
end

if nargout>0, hh = h; end

% RICHARD HACK #4: register handles with m-code generator.  In The Mathworks'
% PIE function a call is made to a private function MCODEREGISTER.  The m-file
% for this function requests that MAKECODE is called instead, which is what this
% version does here.

if ~isempty(h) && ~isdeployed
  makemcode('RegisterHandle',h,'IgnoreHandle',h(1),'FunctionName','pie');
end

% END RICHARD HACK #4

function str=id(str)
str = ['MATLAB:pie:' str];

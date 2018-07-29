function [x,y]=curveintersect(varargin)
% Curve Intersections.
% [X,Y]=CURVEINTERSECT(H1,H2) or [X,Y]=CURVEINTERSECT([H1 H2]) finds the
% intersection points of the two curves on the X-Y plane identified
% by the line or lineseries object handles H1 and H2.
%
% [X,Y]=CURVEINTERSECT(X1,Y1,X2,Y2) finds the intersection points of the
% two curves described by the vector data pairs (X1,Y1) and (X2,Y2).
%
% X and Y are empty if no intersection exists.
%
% Example
% -------
% x1=rand(10,1); y1=rand(10,1); x2=rand(10,1); y2=rand(10,1);
% [x,y]=curveintersect(x1,y1,x2,y2); 
% plot(x1,y1,'k',x2,y2,'b',x,y,'ro')
%
% Original Version (-> curveintersect_local)
% ---------------------------------------
% D.C. Hanselman, University of Maine, Orono, ME 04469
% Mastering MATLAB 7
% 2005-01-06
%
% Improved Version (-> this function)
% -----------------------------------
% S. Hölz, TU Berlin, Germany
% v 1.0: October 2005
% v 1.1: April   2006     Fixed some minor bugs in function 'mminvinterp'

x=[]; y=[];
[x1,y1,x2,y2]=local_parseinputs(varargin{:});
ind_x1=sign(diff(x1)); ind_x2=sign(diff(x2));

ind1=1;
while ind1<length(x1)
    ind_max = ind1+min(find(ind_x1(ind1:end)~=ind_x1(ind1)))-1;
    if isempty(ind_max) | ind_max==ind1; ind_max=length(x1); end
    ind1=ind1:ind_max;
    
    ind2=1;
    while ind2<length(x2)
        ind_max = ind2+min(find(ind_x2(ind2:end)~=ind_x2(ind2)))-1;
        if isempty(ind_max) | ind_max==ind2; ind_max=length(x2); end
        ind2=ind2:ind_max;
        
        % Fallunterscheidung
        if ind_x1(ind1(1))==0 & ind_x2(ind2(1))~=0 
            x_loc=x1(ind1(1));
            y_loc=interp1(x2(ind2),y2(ind2),x_loc);
            if ~(y_loc>=min(y1(ind1)) && y_loc<=max(y1(ind1))); y_loc=[]; x_loc=[]; end
            
        elseif ind_x2(ind2(1))==0 & ind_x1(ind1(1))~=0
            x_loc=x2(ind2(1));
            y_loc=interp1(x1(ind1),y1(ind1),x_loc);
            if ~(y_loc>=min(y2(ind2)) && y_loc<=max(y2(ind2))); y_loc=[]; x_loc=[]; end

        elseif ind_x2(ind2(1))~=0 & ind_x1(ind1(1))~=0
            [x_loc,y_loc]=curveintersect_local(x1(ind1),y1(ind1),x2(ind2),y2(ind2));
            
        elseif ind_x2(ind2(1))==0 & ind_x1(ind1(1))==0
            [x_loc,y_loc]=deal([]);
            
        end
        x=[x; x_loc(:)];
        y=[y; y_loc(:)];
        ind2=ind2(end);
    end
    ind1=ind1(end);
end
    


% ----------------------------------------------
function [x,y]=curveintersect_local(x1,y1,x2,y2)

if ~isequal(x1,x2)
   xx=unique([x1 x2]); % get unique data points
   xx=xx(xx>=max(min(x1),min(x2)) & xx<=min(max(x1),max(x2)));
   if numel(xx)<2
      x=[];
      y=[];
      return
   end
   yy=interp1(x1,y1,xx)-interp1(x2,y2,xx);
else
   xx=x1;
   yy=y1-y2;
end
x=mminvinterp(xx,yy,0); % find zero crossings of difference
if ~isempty(x)
   y=interp1(x1,y1,x);
else
   x=[];
   y=[];
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [xo,yo]=mminvinterp(x,y,yo)
%MMINVINTERP 1-D Inverse Interpolation. From the text "Mastering MATLAB 7"
% [Xo, Yo]=MMINVINTERP(X,Y,Yo) linearly interpolates the vector Y to find
% the scalar value Yo and returns all corresponding values Xo interpolated
% from the X vector. Xo is empty if no crossings are found. For
% convenience, the output Yo is simply the scalar input Yo replicated so
% that size(Xo)=size(Yo).
% If Y maps uniquely into X, use INTERP1(Y,X,Yo) instead.
%
% See also INTERP1.

if nargin~=3
   error('Three Input Arguments Required.')
end
n = numel(y);
if ~isequal(n,numel(x))
   error('X and Y Must have the Same Number of Elements.')
end
if ~isscalar(yo)
   error('Yo Must be a Scalar.')
end

x=x(:); % stretch input vectors into column vectors
y=y(:);

if yo<min(y) || yo>max(y) % quick exit if no values exist
   xo = [];
   yo = [];
else                      % find the desired points
   
   below = y<yo;          % True where below yo 
   above = y>yo;          % True where above yo
   on    = y==yo;         % True where on yo
   
   kth = (below(1:n-1)&above(2:n)) | (above(1:n-1)&below(2:n));     % point k
   kp1 = [false; kth];                                              % point k+1
   
   xo = [];                                                         % distance between x(k+1) and x(k) 
   if any(kth);                                                     
       alpha = (yo - y(kth))./(y(kp1)-y(kth));
       xo = alpha.*(x(kp1)-x(kth)) + x(kth);
   end         
   xo = sort([xo; x(on)]);                                          % add points, which are directly on line

   yo = repmat(yo,size(xo));                                        % duplicate yo to match xo points found
end 
%--------------------------------------------------------------------------
function [x1,y1,x2,y2]=local_parseinputs(varargin)

if nargin==1 % [X,Y]=CURVEINTERSECT([H1 H2])
   arg=varargin{1};
   if numel(arg)==2 && ...
      all(ishandle(arg)) && all(strcmp(get(arg,'type'),'line'))
      data=get(arg,{'XData','YData'});
      [x1,x2,y1,y2]=deal(data{:});
   else
      error('Input Must Contain Two Handles to Line Objects.')
   end
elseif nargin==2 % [X,Y]=CURVEINTERSECT(H1,H2)
   arg1=varargin{1};
   arg2=varargin{2};
   if numel(arg1)==1 && ishandle(arg1) && strcmp(get(arg1,'type'),'line')...
   && numel(arg2)==1 && ishandle(arg2) && strcmp(get(arg2,'type'),'line')
      
      data=get([arg1;arg2],{'XData','YData'});
      [x1,x2,y1,y2]=deal(data{:});
   else
      error('Input Must Contain Two Handles to Line Objects.')
   end
elseif nargin==4
   [x1,y1,x2,y2]=deal(varargin{:});
   if ~isequal(numel(x1),numel(y1))
      error('X1 and Y1 Must Contain the Same Number of Elements.')
   elseif ~isequal(numel(x2),numel(y2))
      error('X2 and Y2 Must Contain the Same Number of Elements.')
   end
   x1=reshape(x1,1,[]); % make data into rows
   x2=reshape(x2,1,[]);
   y1=reshape(y1,1,[]);
   y2=reshape(y2,1,[]);
       
else
   error('Incorrect Number of Input Arguments.')
end
if min(x1)>max(x2) | min(x2)>max(x1) | min(y2)>max(y1) | min(y1)>max(y2) % Polygons can not have intersections
    x1=[]; y1=[]; x2=[]; y2=[]; return
end
if numel(x1)<2 || numel(x2)<2 || numel(y1)<2 || numel(y2)<2
   error('At Least Two Data Points are Required for Each Curve.')
end



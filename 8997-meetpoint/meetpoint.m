function [x,y,m1,m2] = meetpoint(x0,y0,x1,y1)
%MEETPOINT   Meet points points and slopes of curves
%   Computes the intesection points of curves and the slopes at the
%   meet points.
%
%   Syntax:
%      [X,Y,M0,M1] = MEETPOINT(X0,Y0,X1,Y1)
%      [X,Y,M0,M1] = MEETPOINT(HANDLES_0,HANDLES_1)
%
%   Inputs:
%      X0, Y0   First curve
%      X1, Y1   Secont curve
%      HANDLES_0, HANDLES_1   Handles for lines, patches, ...
%
%   Outputs:
%      X, Y     The interseption points, withou repetition for each
%               pair of curves
%      M0, M1   Slopes of the curves at the meeting points
%
%   Comments:
%      Can deal with coincident segments, vertical segments, ...
%      Works at least in Matlab versions since 5.3 utill current, R14.
%      Does not use Matlab INTERP1 or any other Matlab interpolation
%      function.
%
%   Examples:
%      figure, subplot(2,1,1)
%      [cs,ch] = contour(peaks);
%      x = rand(10,1)*size(peaks,1);
%      y = rand(10,1)*size(peaks,1);
%      hold on, h=plot(x,y);
%      [x,y,m1,m2]=meetpoint(ch,h);
%      plot(x,y,'r+')
%
%      subplot(2,1,2)
%      x1=[0 1.5 3 5 5];
%      y1=[0 1.5 1.5 2 1];
%      plot(x1,y1,'.-'), hold on
%      x2=[.2 .5 .5 1 1  2 2 5 5];
%      y2=[.2 .5 .8 1 1.3 1.3 1.8 1.8 .5];
%      plot(x2,y2,'r.:')
%      xlim([0 6]);
%      [x,y,m1,m2]=meetpoint(x1,y1,x2,y2);
%      plot(x,y,'ko','markersize',8)
%
%   MMA 10-11-2005, martinho@2fis.ua.pt

%   30-04-2007 - Small correction and avoid sort the result

x  = [];
y  = [];
m1 = [];
m2 = [];

if nargin == 2
  useHandles = 1;
  handle0 = x0;
  handle1 = y0;
  % for R14 contours:
  if isequal(get(handle0,'type'),'hggroup')
    handle0 = get(handle0,'children');
  end
  if isequal(get(handle1,'type'),'hggroup')
    handle1 = get(handle1,'children');
  end
  n0 = length(handle0);
  n1 = length(handle1);
elseif nargin ~= 4
  disp([':: ',mfilename,' - wrong input arguments']);
  return
elseif nargin == 4
  n0 = 1;
  n1 = 1;
  useHandles = 0;
end

if useHandles
  for in0 = 1:n0
    x0 = get(handle0(in0),'xdata');
    y0 = get(handle0(in0),'ydata');
    for in1 = 1:n1
      x1 = get(handle1(in1),'xdata');
      y1 = get(handle1(in1),'ydata');
      [x_,y_,m1_,m2_] = theCalc(x0,y0,x1,y1);
      x  = [x   x_];
      y  = [y   y_];
      m1 = [m1 m1_];
      m2 = [m2 m2_];
    end
  end
else
  [x,y,m1,m2] = theCalc(x0,y0,x1,y1);
end

function [X,Y,M1,M2] = theCalc(x0,y0,x1,y1)
X  = [];
Y  = [];
M1 = [];
M2 = [];

cont = 0;
i=0;
while 1
  i=i+1;
  if i+1 > length(x1)
    break
  end
  fx = x1(i:i+1);
  fy = y1(i:i+1);
  j=0;
  while 1
    j=j+1;
    if j+1 > length(x0)
      break
    end
    gx = x0(j:j+1);
    gy = y0(j:j+1);
    ang1 = atan2(diff(fy),diff(fx))*180/pi;
    ang2 = atan2(diff(gy),diff(gx))*180/pi;
    if ~(max(fx) < min(gx)  | min(fx) > max(gx) |   max(fy) < min(gy)  | min(fy) > max(gy))
      if (diff(fx) ~= 0 & diff(gx) ~= 0)
        m1 = diff(fy)/diff(fx);
        m2 = diff(gy)/diff(gx);
        x01 = fx(1);
        y01 = fy(1);
        x02 = gx(1);
        y02 = gy(1);
        if m1==m2
          x=inf;
          y=inf;
        else
          y = 1/(m1-m2) * ( m1*y02 - m2*y01 + m1*m2*(x01-x02));
          if m1 ~= 0
            x = (y-y01+m1*x01)/m1;
          elseif m2 ~= 0
            x = (y-y02+m2*x02)/m2;
          end
        end
      elseif diff(fx) == 0 & diff(gx) ~= 0
        m2 = diff(gy)/diff(gx);
        x02 = gx(1);
        y02 = gy(1);
        x = fx(1);
        y = m2*(x-x02) + y02;
      elseif diff(fx) ~= 0 & diff(gx) == 0
        m1 = diff(fy)/diff(fx);
        x01 = fx(1);
        y01 = fy(1);
        x = gx(1);
        y = m1*(x-x01) + y01;
      else
        x=inf;
        y=inf;
      end
      e=eps*1000;
      cond=x>=max([min(fx) min(gx)])-e & ...
           x<=min([max(fx) max(gx)])+e & ...
           y>=max([min(fy) min(gy)])-e & ...
           y<=min([max(fy) max(gy)])+e;
%     if x>=max([min(fx) min(gx)]) & x<=min([max(fx) max(gx)])  & y>=max([min(fy) min(gy)]) & y<=min([max(fy) max(gy)])
      if cond
        cont = cont+1;
        X(cont)  = x;
        Y(cont)  = y;
        M1(cont) = ang1;
        M2(cont) = ang2;
      end

    end
  end
end
% remove repeated pairs xy:
[X,Y,I]=unique_pairs(X,Y);
M1=M1(I);
M2=M2(I);

function [x,y,I]=unique_pairs(x0,y0)
x=[];
y=[];
I=[];
tmp={};
for i=1:length(x0)
  if ~isin([x0(i) y0(i)],tmp)
    tmp{end+1}=[x0(i) y0(i)];
    x(end+1)=x0(i);
    y(end+1)=y0(i);
    I(end+1)=i;
  end
end

function res=isin(a,b)
res=0;
for i=1:length(b)
  if isequal(b(i),a)
    res=1;
    return
  end
end

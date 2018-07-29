function C = usercolormap(varargin)

% USERCOLORMAP Create a color map.
%    USERCOLORMAP(COLOR1,COLOR2,COLOR3,...) creates a colormap
%    with colors specified by 1x3 vectors (COLOR1, COLOR2,
%    COLOR3...).
%
%    When the number of input colors are three for example,
%    the function linearly interpolates every column of a
%    3x3 matrix [COLOR1;COLOR2;COLOR3] to 256 values, which
%    is to be used as an input to COLORMAP. It means that
%    colors between those you specified change gradually.
%
%    (Example 1)
%    color1 = [1 0 0];
%    color2 = [1 1 1];
%    color3 = [0 0 1];
%    figure;
%    colormap(usercolormap(color1,color2,color3)),colorbar;
%
%
%    If you put a number (>0) as the last input argument
%    (USERCOLORMAP(...,NUM)), then the intensity scaling is
%    respected by automatically adjusting colors, in such a
%    way that the first color be the darkest (or lightest)
%    and the last be the lightest (or darkest). This is useful
%    when figures have to be printed out or photocopied in
%    grayscale.
%
%    When using this option, n-th intensity I(n) is expressed by
%    I(n) = I(1) + (I(256)-I(1))*((n-1)/255)^NUM.
%    When NUM = 1, then the scaling is linear (as in 
%    colormap(gray)). 1.2 can be a good compromise between
%    color map and intensity scale. You can check how it
%    looks in intensity (black and white) by exporting a
%    figure to a black/white eps format.
%
%    (Example 2)
%    color1 = [0 0 0];
%    color2 = [1 0 0];
%    color3 = [0.2 0.2 1];
%    color4 = [1 1 0];
%    color5 = [1 1 1];
%    figure;
%    C = usercolormap(color1,color2,color3,color4,color5,1);
%    colormap(C),colorbar;
%
%    You can also create an m-script like
%    %%%%%%
%    function C = mycolor
%    C = usercolormap([0 0 0],[1 0 0],[1 1 1]);
%    %%%%%%
%    and call this colormap by 'colormap(mycolor)'.
%
%    See also COLORMAP.
%

%    17 Mar 2005, Yo Fukushima


sz = size(varargin);
ncolor = sz(2);
C0 = [];
tol = 0.5; 

% when intensity option is given
if size(varargin{ncolor},2) == 1
   num = varargin{ncolor};
   ncolor = ncolor-1;
   isintensity = 1;
else
    isintensity = 0;
end   

% retrieve specified colors
for k = 1:ncolor
   C0 = [C0;varargin{k}];
end

% rescale when 'intensity' option is given
if isintensity == 1
   intensity_orig = (sum(C0.^2,2));
   first = intensity_orig(1);
   last = intensity_orig(ncolor);
%    if abs(first-last) < tol
%       warning('First and Last intensity should differ at least by 0.5.');
%    end
   % rescale intensity
   intensity = powerspace(first,last,ncolor,num);
   for k = 2:ncolor
      if intensity_orig(k) ~= 0
         kk = intensity(k)./intensity_orig(k);
         if kk > 1
            ind = find(C0(k,:)==0);
            C0(k,ind) = 0.01;
               a = C0(k,1);
               b = C0(k,2);
               c = C0(k,3);
               A = 3-2*(a+b+c)+a^2+b^2+c^2;
               B = a*(1-a)+b*(1-b)+c*(1-c);
               C = a^2+b^2+c^2-intensity(k);
               % sc is the root of Ax^2+2Bx+C=0
               sc = (-B+sqrt(B^2-A*C))/A;
               if ~(0 < sc & sc < 1)
                  sc = (-B-sqrt(B^2-A*C))/A;
               end
               C0(k,1) = a + (1-a).*sc;
               C0(k,2) = b + (1-b).*sc;
               C0(k,3) = c + (1-c).*sc;
         else
            C0(k,:) = sqrt(kk).*C0(k,:);
         end
      end      
   end
   
   %% disp %%
   disp('Rescaled colors:');
   disp(C0);
end

%% interpolation %%
lenC0 = size(C0,1);
step = linspace(1,256,lenC0);

C = zeros(256,3);
for k = 1:3
   foo = interp1(step',C0(:,k),1:256);
   C(:,k) = foo';
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                 SUBFUNCTIONS                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = powerspace(d1, d2, n, power)
%POWERSPACE Exponentially spaced vector.
%   POWERSPACE(d1, d2, N, POWER) generates a row vector of N
%   exponentially spaced points between d1 and d2. POWER is
%   the power.

y = [(0:n-2)/(n-1), 1].^power;
y = rescale(y,[0,1],[d1,d2]);


function y = rescale(x,xrange,yrange)

% RESCALE Rescale the range of a vector or a matrix.
%
%   Y = RESCALE(X,[XMIN,XMAX],[YMIN,YMAX]) rescales the
%   range of X from [XMIN,XMAX] to [YMIN,YMAX].
%
%   (Example)
%   x = rand(50,50);
%   y = rescale(x,[0,1],[-100,100]);
%   figure;
%   subplot(121);imagesc(x),colorbar;
%   subplot(122);imagesc(y),colorbar;
%

xmin = xrange(1); xmax = xrange(2);
ymin = yrange(1); ymax = yrange(2);
y = (x-xmin).*(ymax-ymin)./(xmax-xmin) + ymin;





%% The following lines will create the same figure as the snapshot.

%      color1 = [0 0 0]; color2 = [1 0 0];
%      color3 = [0 1 0]; color4 = [0 0 1];
%      color5 = [1 1 1]; color6 = [1 1 0];
%      color7 = [0 1 1]; color8 = [1 0 1];
%      C1 = usercolormap(color2,color5,color4);
%      foo1 = shiftdim(C1,-1); foo1 = [foo1;foo1];
%      C2 = usercolormap(color5,color2,color6,color3,color5);
%      foo2 = shiftdim(C2,-1); foo2 = [foo2;foo2];
%      C3 = usercolormap(color1,color4,color7,color5);
%      foo3 = shiftdim(C3,-1); foo3 = [foo3;foo3];
%      C4 = usercolormap(color4,color3,color6,color2);
%      foo4 = shiftdim(C4,-1); foo4 = [foo4;foo4];
%      C5 = usercolormap(color1,color2,color3,color4,color5);
%      foo5 = shiftdim(C5,-1); foo5 = [foo5;foo5];
%      N = 256;
%      figure;
%      subplot(511);surf([1:N;1:N],'CData',foo1);shading interp;
%         view(2);set(gca,'XTick',[],'YTick',[]);axis([1 N 1 2]);
%      subplot(512);surf([1:N;1:N],'CData',foo2);shading interp;
%         view(2);set(gca,'XTick',[],'YTick',[]);axis([1 N 1 2]);
%      subplot(513);surf([1:N;1:N],'CData',foo3);shading interp;
%         view(2);set(gca,'XTick',[],'YTick',[]);axis([1 N 1 2]);
%      subplot(514);surf([1:N;1:N],'CData',foo4);shading interp;
%         view(2);set(gca,'XTick',[],'YTick',[]);axis([1 N 1 2]);
%      subplot(515);surf([1:N;1:N],'CData',foo5);shading interp;
%         view(2);set(gca,'XTick',[],'YTick',[]);axis([1 N 1 2]);
%

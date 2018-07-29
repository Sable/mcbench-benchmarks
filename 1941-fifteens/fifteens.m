function  fifteens(n,num)

%  FIFTEENS  - A game of "fifteens" ("pyatnashki").
%      The purpose of the game is to arrange 15 numbered squares
%      in the 4x4 field in the numbering order: 1,2,3,4 in the
%      first row, 5,6,7,8  in the second and so on.
%      Only the square adjacent to the empty space can be moved
%      to this space at each step.
%    FIFTEENS(N) produces a field  N*N  with, correspondingly,
%      N*N-1 movable squares.

%  Kirill Pankratov,  kirill@plume.mit.edu
%  May 1, 1994

 % Execute the callbacks ***********************************
if nargin==2
  btn = get(gcf,'user');
  fr = btn(1);
  posfr = get(fr,'pos');
  btn = btn(2:length(btn));
  L = get(fr,'user');
  n0 = get(btn(num),'userdata');
  vnb = [-(n+2) -1 1 n+2];
  vp = [0 -1; -1 0; 1 0; 0 1];
  vc = L(n0(2)*(n+2)+n0(1)+1+vnb);
  fnd = find(vc==0);
  if fnd~=[]
    L = ones(size(L));
    L(n0(2)*(n+2)+n0(1)+1) = 0;
    n0 = n0+vp(fnd(1),:);
    pos = get(btn(num),'pos');
    pos(1:2) = posfr(1:2)+posfr(3:4).*[n0(2)-1 n-n0(1)]/n;
    set(btn(num),'pos',pos);
    set(btn(num),'user',n0);
    set(fr,'user',L)
  end
  return
end

if nargin == 1     % Help
  if isstr(n)
    if strcmp(n,'help')

      helptxt = [10 '   Welcome to the "fifteens" game!' 10 ...
 'The purpose of the game is to arrange the squares in the' 10 ...
 'numbering order: 1,2,3,...,15  by shifting their positions' 10 ...
 'to the only available space. Only one square adjacent to the' 10 ...
 'empty space can be moved at each step. Press the corresponding' 10 ...
 'button to move a square with a given number.' 10 '  Good luck!'];
      disp(helptxt)
    return
    end
  end
end

 % Initialization **********************************************
if nargin==0, n = 4; end   % Default is 4 ("fifteens")
if nargin<2
   % Setup parameters:
  posfr = [0 0 .77 .87];       % Position of the frame
  posfig = [300 400 260 170];  % Position of the figure
  bgc = [.8 .8 .8];            % Color of the squares
  fgc = [0 0 0];               % Color of the numbers

  fig = figure;
  set(fig,'units','pixels','pos',posfig)
  L = ones(n+2);
  L(n+1,n+1) = 0;
  [a,num] = sort(rand(n*n-1,1));
  a = ceil(num/n)-1;
  num = num-a*n-1;
  
   % Create buttons .........................................
  fr = uicontrol('style','frame',...
         'user',L,...
         'units','norm',...
         'pos',posfr,...
         'backgroundcolor',[.45 .45 .45]);
    str = ['Arrange in order from 1 to ' num2str(n*n-1) ':'];
  head = uicontrol('style','text',...
         'units','norm',...
         'pos',[.0 .88 .77 .12],...
         'backgroundcolor',[.85 .85 1],...
         'string',str);
  done = uicontrol('style','push',...
         'units','norm',...
         'pos',[.8 .05 .18 .15],...
         'backgroundcolor',[.7 .7 .8],...
         'call','close',...
         'string','Done');
   clb = uicontrol('style','push',...
         'units','norm',...
         'pos',[.8 .25 .18 .15],...
         'backgroundcolor',[.7 .7 .8],...
         'call',['close; fifteens(' num2str(n) ')'],...
         'string','Clear');
   help = uicontrol('style','push',...
         'units','norm',...
         'pos',[.8 .45 .18 .15],...
         'backgroundcolor',[.7 .7 .8],...
         'call','fifteens(''help'')',...
         'string','Help');

  btn = zeros(n*n-1,1);
  for jn = 1:n*n-1
    n0 = [num(jn) a(jn)]+1;
    pos(1:2) = posfr(1:2)+[a(jn) n-num(jn)-1].*posfr(3:4)/n;
    pos(3:4) = [1 1].*posfr(3:4)/n;
    btn(jn) = uicontrol('style','push',...
               'units','norm',...
               'pos',pos,...
               'backgroundcolor',bgc,...
               'foregroundcolor',fgc,...
               'string',num2str(jn),...
               'user',n0,...
               'call',['fifteens(' num2str(n) ',' num2str(jn) ')']);
  end
  set(gcf,'numbertitle','off')
  set(gcf,'name','"Fifteens"','user',[fr; btn])
end

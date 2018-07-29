% Nagi Hatoum, Candlestick chart ploter function, 5/29/03

function cndl(H,L,O,C)

w=.4; %width of body, change to draw body thicker or thinner
%%%%%%%%%%%Find up and down days%%%%%%%%%%%%%%%%%%%
d=C-O;
l=length(d);
hold on
%%%%%%%%draw line from Low to High%%%%%%%%%%%%%%%%%
for i=1:l
   line([i i],[L(i) H(i)])
end
%%%%%%%%%%draw red body (down day)%%%%%%%%%%%%%%%%%
n=find(d<0);
if ~isempty(n)
   for i=1:length(n)
      x=[n(i)-w n(i)-w n(i)+w n(i)+w n(i)-w];
      y=[O(n(i)) C(n(i)) C(n(i)) O(n(i)) O(n(i))];
      patch(x,y,'r')
   end
   %plot(n,C(n),'rs','MarkerFaceColor','r')
end
%%%%%%%%%%draw blue body(up day)%%%%%%%%%%%%%%%%%%%
n=find(d>=0);
if ~isempty(n)
   for i=1:length(n)
      x=[n(i)-w n(i)-w n(i)+w n(i)+w n(i)-w];
      y=[O(n(i)) C(n(i)) C(n(i)) O(n(i)) O(n(i))];
      patch(x,y,'b')
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold off
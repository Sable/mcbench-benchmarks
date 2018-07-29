% Is In Range function written by NKN(C)-2006
% is c E [a,b]
% True=1; 
% False=0;
% 
% Example: isinrange(1,2,3)
% ans=0;
function g=isinrange(a,b,c)
bb=max(a,b);
aa=min(a,b);
if (c<=bb) & (c>=aa)
%% disp('true');
g=1;
else
%% disp('false');
g=0;
end
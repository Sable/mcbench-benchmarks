function B = chb(A,a,b) 

% B = chb(A,a,b) change numerical base:
% a,b scalars from 2 to 64 , A,B strings.
% Number A in base a , expressed in base b by B.
% Symbols are 0 .. 9 A .. Z a .. z @ &.
% 
% Example:
% '-54.13'-chb(chb('-54.13',6,27),27,6)
% 
% Giampiero Campa 21-2-94

B=[];
l=length(A);
v=0;
c=0;
d=0;
y=0;

if l==0, error('A is unexisting')
end

if      ~isstr(A)|l==0|A=='-', error('A must be a string')
elseif   (a > 64)|(b > 64)|(a < 2)|(b < 2), error('invalid base')
end

if A(1)=='-',

s='-'; 
l=l-1;
A=A(2:l+1);

else s='';
end

for i = 1:l,

if      (A(i)=='&' & a<64)|(A(i)=='@' & a<63), error('invalid base or symbol')
elseif  (A(i)~='&' & A(i)~='@'),
	if  A(i)<'.'|A(i)=='/'|A(i)>'z'|...
	    (A(i)>'9' & A(i)<'A')|(A(i)>'Z' & A(i)<'a'), error('invalid base or symbol')    
	end
end

if   (abs(A(i)) > a+60)|(abs(A(i))>a+54 & a<37)|(abs(A(i))>a+47 & a<11)|(A(i)=='.' & v>0),
     error('invalid base or symbol')

elseif  A(i)=='.', v=i; 
end

end

if v==0, v=l+1;
end

for i=1:v-1;

if       A(i)<':', y=A(i)-'0';
elseif   A(i)<'[', y=A(i)-55;
else     y=A(i)-61;
end

if       A(i)=='@', y=62;
elseif   A(i)=='&', y=63;
end

c=c+y*a^(v-1-i);
end

for i=v+1:l;

if       A(i)<':', y=A(i)-'0';
elseif   A(i)<'[', y=A(i)-55;
else     y=A(i)-61;
end

if       A(i)=='@', y=62;
elseif   A(i)=='&', y=63;
end

d=d+y*a^(v-i);
end

while c>0,

z=round(b*(c/b-fix(c/b)));
c=fix(c/b);

if      z<10, q=setstr(48+z);
elseif  z<36, q=setstr(55+z);
else          q=setstr(61+z);
end

if z=='62', q='@';
elseif z>='63', q='&';
end

B=[q,B];
end

B=[s,B];

if d>0,

B=[B,'.'];
for i=1:38;

z=fix(d*b);
d=d*b-z;

if z==b, 
d=1-1e-10;
z=b-1;
end

if      z<10, q=setstr(48+z);
elseif  z<36, q=setstr(55+z);
else          q=setstr(61+z);
end

if z=='62', q='@';
elseif z>='63', q='&';
end

B=[B,q];
end

while B(length(B))=='0',
B=B(1:length(B)-1);
end

end

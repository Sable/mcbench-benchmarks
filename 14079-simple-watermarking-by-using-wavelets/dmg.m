% Damga uretme
% 
% imgew: Damga imgesi
% imge1: Orjinal imge
% 
function W=dmg(imgew,imge1);

[w h]=size(imgew');
[w1 h1]=size(imge1');
a=1;
b=1;
W=zeros(size(imge1'));

for i=1:w:w1
    for j=1:h:h1
        W(i:a*w,j:b*h)=imgew';
        b=b+1;
    end
    a=a+1;
    b=1;
end

    W=W';    
    
function vn=sym2num(v,names,tn)
% vn=sym2num(v,names,tn)
if isnumeric(v), vn=v;
else
  if length(size(v))<3,   
    vnn=subs(v,{names(1),names(2),names(3)},...
               {tn(1),tn(2),tn(3)});  
    vn=double(vnn);  
  else
    vn=zeros(3,3);
    for j=1:3
      vn(:,:,j)=double(subs(v(:,:,j),...
                {names(1),names(2),names(3)},...
                {tn(1),tn(2),tn(3)})); 
    end
  end
end
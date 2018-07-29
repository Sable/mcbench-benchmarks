function [newstr,same]=samenum(same,num) %#codegen
coder.extrinsic('strrep','strcat')
newstr=[];


for n=1:1:(length(same)-num+1)
    if n>length(same)-num+1
        break 
    end
num3=find(same(n:1:n+num-1)==same(n));
if length(num3)==num
   same= strrep(same,same(n:1:n+num-1),same(n));
   newstr=strcat(newstr,same(n));
   sound(sin(1:2:10))
   
else
   
end
end

    
end
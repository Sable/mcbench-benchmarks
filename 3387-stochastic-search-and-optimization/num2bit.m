function y=num2bit(th_element,b,thetmin,thetmax)
%This function takes a real number and converts it to a b-bit
%representation. The value b is chosen in GAbit_roulette to satisfy
%the decimal accuracy requirements given in M (as in step 1 of encoding 
%process of Subsection 9.3.2 of ISSO).
%
d=(thetmax-thetmin)/(2^b-1);
rnd=round((th_element-thetmin)/d);
y=zeros(1,b);
for i=b:-1:1
   ratio=rnd/(2^(i-1));
   if ratio >= 1
      y(b-i+1)=1;
      rnd=rnd-2^(i-1);
   else
   end   
end   

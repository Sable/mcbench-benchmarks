function [swav]=s_wav(x,a_swav,d_swav,t_swav,li)
l=li;
x=x-t_swav;
a=a_swav;
b=(2*l)/d_swav;
n=100;
s1=(a/(2*b))*(2-b);
s2=0;
for i = 1:n
    harm3=(((2*b*a)/(i*i*pi*pi))*(1-cos((i*pi)/b)))*cos((i*pi*x)/l);
    s2=s2+harm3;
end
swav=-1*(s1+s2);
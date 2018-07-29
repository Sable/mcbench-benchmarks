function [qwav]=q_wav(x,a_qwav,d_qwav,t_qwav,li)
l=li;
x=x+t_qwav;
a=a_qwav;
b=(2*l)/d_qwav;
n=100;
q1=(a/(2*b))*(2-b);
q2=0;
for i = 1:n
    harm5=(((2*b*a)/(i*i*pi*pi))*(1-cos((i*pi)/b)))*cos((i*pi*x)/l);
    q2=q2+harm5;
end
qwav=-1*(q1+q2);
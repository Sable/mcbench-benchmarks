function [y1 y2 y3] = hrate(a,vad)



y1 =  mean(vad(a==1)); %hit rate speech

y2 = 1-mean(vad(a==0)); %hit rate silence


y3 = sum(abs(a-vad))/length(a);


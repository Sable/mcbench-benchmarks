% Encode Data
%data(i)=1--> level chane
%data(i)=0--> no level change

function y=enc_data(x)

clf;
clear;
bits=8;
threshold=0.5;
data=rand(1,bits);
for i=1:length(data)
if data(i)>threshold
data2(i)=1;
else
data2(i)=0;
end
end
data
data2
figure(1)
subplot(3,1,1);
stairs(data2);
title('Original Digital Data');
ylabel('Amplitude');
xlabel('Time');
axis([0 bits -0.2 1.2]);
grid off;


for i=1:length(data2)
 if i==1
   if data2(i)==0
    temp(i)=0;
   else
    temp(i)=1;
   end
 else
   if data2(i)==0
     temp(i)=temp(i-1);
   else
     if data2(i)==1
         temp(i)=bitcmp(temp(i-1),1)
     end
   end
 end
end
for i=1:length(data2)
  if temp(i)==0;
       temp(i)=-1;
  end
end
temp
figure(1)
subplot(3,1,2);
stairs(temp);
title('NRZ-I Digital Data');
ylabel('Amplitude');
xlabel('Time');
axis([0 bits -1.2 1.2]);
grid off;

for i=1:length(temp)
 if i==1
   if temp(i)==0
    temp1(i)=0;
   else
    temp1(i)=1;
   end
 else
   if temp(i)== 1 
       if temp(i-1) == -1
           if i ~= 1
         temp1(i)=temp(i);
           end
       else
         temp1(i)=bitcmp(temp(i),1) 
       end
   else
     if temp(i)== -1
         temp1(i)=temp(i-1)
     end
   end
 end
end
for i=1:length(temp)
 if temp1(i)==-1;
      temp1(i)=0;
 end
end
temp1
figure(1)
subplot(3,1,3);
stairs(temp1);
title('NRZ-I Digital Decoded Data');
ylabel('Amplitude');
xlabel('Time');
axis([0 bits -0.2 1.2]);
grid off;


y=temp;
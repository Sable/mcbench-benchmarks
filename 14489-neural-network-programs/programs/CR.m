% CHARACTER RECOGNITION SYSTEM

function CR()
clear workspace
clear
% Input Data Preparation
x=65;
for i=1:4
al=char(x);
fl=strcat(al,'.bmp');
inp(i,:)=roworder(fl);
x=x+1;
end
inp=inp';
inp=double(inp);
%Output Data Preparation
for i=0:3
    x=dec2bin(i,2);
    for j=1:2
        y(j)=str2num(x(j));
    end
    out(i+1,:)=y;
end
out=out';
% Network Creation
     network=newff([zeros(size(inp,1),1) ones(size(inp,1),1)],[7 2],{'logsig','logsig'});
  %   network=init(network);
     
network.iw{1}=dlmread('layer1.txt');
network.b{1}=dlmread('layer1b.txt');
network.lw{2}=dlmread('layer2.txt');
network.b{2}=dlmread('layer2b.txt');

% Network Training  
network.performFcn = 'sse';
network.trainParam.epochs = 500;
network=train(network,inp,out);
% Network Testing 
  display('Network Testing - With Boldness (Arial)');
  D=sim(network,inp);
  D=round(D);
  D
 % Testing with new data
x=65;
for i=1:4
al=char(x);
fl=strcat(al,'1.bmp');
in(i,:)=roworder(fl);
x=x+1;
end 
in=in';
in=double(in);
display('Testing with New Data - Without Boldness (Arial)');
E=sim(network,in);
E=round(E);
E
%Testing with new data
 x=65;
for i=1:4
al=char(x);
fl=strcat(al,'2.bmp');
in1(i,:)=roworder(fl);
x=x+1;
end 
in1=in1';
in1=double(in1);
display('Testing with New Data - With Boldness (Tahoma)');
F=sim(network,in1);
F=round(F);
F
end

function inprs=roworder(fl)
inpdt=imread(fl);
inprs=reshape(inpdt',1,size(inpdt,1)*size(inpdt,2));
end

  


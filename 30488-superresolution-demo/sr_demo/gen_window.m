function w=gen_window(s,d1,d2);

if ~exist('d1','var')
    d1=0.1;
end
if ~exist('d2','var');
    d2=0.1;
end

x=ones(s(1),1);
slope=linspace(0,1,round(s(1)*d1));
x(1:length(slope))=slope;
x(length(x)-length(slope)+1:length(x))=fliplr(slope);

y=ones(1,s(2));
slope=linspace(0,1,round(s(2)*d2));
y(1:length(slope))=slope;
y(length(y)-length(slope)+1:length(y))=fliplr(slope);

w=x*y;


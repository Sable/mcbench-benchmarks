function [fname,fnc,low,up,dim]=setttingOfBenchmarkFnc(i)

load myfncsetting
textdata=myfncsetting.fnclist;
data=myfncsetting.fnc_LowUpDim;

fname=textdata(i,1);
fname=fname{1};

fnc=eval(textdata{i,2});

low=data(i,1);
up=data(i,2);
dim=data(i,3);

assignin('base','fname',fname);
assignin('base','fnc',fnc);
assignin('base','low',low);
assignin('base','up',up);
assignin('base','dim',dim);

return
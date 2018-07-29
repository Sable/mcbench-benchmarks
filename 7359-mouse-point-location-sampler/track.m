function track(imagefig,varargins)
global M
global Nsamples

%%% Setting figure properties to start tracking
set(gcf,'windowbuttondownfcn',@dataout);
set(gcf,'WindowButtonMotionFcn',@datain);
set(gcf,'userdata',[]);

%%% Creating initial input, since the filter will need samplea at
%%% n=0,-1,-2... When processing the X[n=1] sample.
for k=1:Nsamples
    temp=get(gca,'currentpoint');
    set(gcf,'userdata',[get(gcf,'userdata'); [temp(1,1:2), 0 ]]);
end
tic; % Begin time measuring

    


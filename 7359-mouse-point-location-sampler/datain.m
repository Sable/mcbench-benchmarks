function datain(imagefig,varargins)
global M
global Nsamples
temp=get(gca,'currentpoint'); % Sample current mouse position, in axes units
%%% keep current position in figure property 'USERDATA'
set(gcf,'userdata',[get(gcf,'userdata'); temp(1,1:2), toc  ]);
%%%

X=get(gcf,'userdata'); %%% Get data for processing
Len=size(X,1);

plot(X(Len,1),X(Len,2),'xr'); %%% Plot the last sampled position
XY=M*X(Len-Nsamples-1:Len,1:2); % Filter the last N samples
plot(XY(1),XY(2),'.b')          % Plot the filtered point
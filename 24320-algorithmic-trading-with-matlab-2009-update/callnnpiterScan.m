% routine to call nnpiter
% load some data
load GBPdata1s
%x=diff(eurusd(1:300000,4));
N=round(length(bid)/10);
x = diff(0.5*(bid(1:N)+ask(1:N)));
tic
%WW = [25,50,75,100,150];
WW = 15:2:75;
DD = 2:20;
NN = 1:12;
%SH=zeros(length(WW),length(DD), length(NN));
for ii=24:length(WW)
    window=WW(ii);
    for jj=1:length(DD)
        d=DD(jj);
        for kk = 1:length(NN);
            n=NN(kk);
            %tic
            % parameters for the model
            %window=25; d = 10; n=5;
            % evaluate the model and compute predictions and signal
            xp2=zeros(length(x),1);
            sig2=zeros(length(x),1);
            % call the iterative nnpred routine
            parfor ll=1:length(x)
                [x2,s2]=nnpiter(x(ll),window,d,n,0);
                xp2(ll)=x2; sig2(ll)=s2;
            end
            % calculate the time for the backtest
            %toc
            [window,d,n]
            % calculate PnL
            pnl = ([0;x(2:end).*sig2(1:end-1)-abs(diff(sig2))*0]);
            SH(ii,jj,kk)=sqrt(60*60*11*255)*mean(pnl)/std(pnl);
            clear persistent
        end
    end
end

toc
% find the best sharpes ratio
[I,J]=find(SH==max(max(max(SH))));
K=ceil(J/size(SH,2));
J=rem(J,size(SH,2));
% best parameters
[WW(I), DD(J), NN(K)]
save nnpresults WW DD NN SH I J K
% plot it
figure
[W,D,M]=ndgrid(WW,DD,NN);
isoplot(W,D,M,SH)

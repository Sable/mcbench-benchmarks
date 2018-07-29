function trstoploss(t,p,pos,th,ph,thresh)
% trailing stop loss function.
% t,p = time and price sampled half hourly
% pos = position from marisa with N=220, M=25
% th,ph, time and price sampled minutely
% thresh is the stoploss threshold in ticks

N=length(ph);
% make a long vector or positions at the minute timescale
pos1m=zeros(N,1); pos1msl=zeros(N,1);
step=30;

% now loop down the long vector and copy the last position down
for i=1:length(pos)-1
    index=(i-1)*step+1:i*step;
    if pos(i)>0 % taking a long position
        hiprice=p(i);
        for j=index
            % follow the price up, resetting the stoploss level
            if ph(j)>hiprice, hiprice=ph(j); pos1msl(j)=1;
            % check to see if we have breached the stoploss threshold
            elseif hiprice-ph(j) < thresh, pos1msl(j)=1;
            end
        end
    elseif pos(i) < 0 % taking a short position
        loprice=p(i);
        for j=index
            % follow the price down, resetting the stoploss level
            if ph(j)<loprice, loprice=ph(j); pos1msl(j)= -1;
            % check to see if we have breached the stoploss threshold
            elseif ph(j)-loprice < thresh, pos1msl(j)= -1;
            end
        end
    end
    % position with no stoploss considerations
    pos1m(index)=pos(i);
end
pos1m(i*step:end)=pos(end);

pnl=cumsum(diff(p).*pos(1:end-1));
pnl1m=cumsum(diff(ph).*pos1m(1:end-1));
pnl1msl = cumsum(diff(ph).*pos1msl(1:end-1));
figure
ax(1)=subplot(2,1,1);
plot(t,p,th,ph,'r')
grid on
legend('30-min','1min')
ax(2)=subplot(2,1,2);
plot(th,pos1m,'r',th,pos1msl,'k'); grid on
legend('1min','1min SL')
set(ax(2),'ylim',[-3 3]);
figure
ax(3)=axes;
plot(t(1:end-1),pnl,th(1:end-1),pnl1m,'r',th(1:end-1),pnl1msl,'k')
grid on
linkaxes(ax,'x');

function butterfly
% BUTTERFLY Visualize payoff schedule of option strategy
% PURPOSE : The function aims to assist students and instructors of 
%           finance in visualizing payoffs of simple option strate-
%           gies. Portfolios of n < 9 securities including a stock,
%           a zero-coupon bond,  a forward contract, and a European 
%           call or  put option, are allowed. Terminal  payoff  and
%           terminal payoff adjusted for accrued time-0 expense are
%           plotted. Discounting and valuation follow Black-Scholes.
% EXAMPLE : buttefly (Oh, the FEX code metrics..)  
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 11/5/07

fw = 560;     fh = 350;
bx = .62*fw;  by = .07*fh;
ew = .08*fw;  eh = .5*ew;
tx = .1*ew;   ty = .25*eh;
bw = 2*ew+tx; bh = .25*bw;
wy = 1.5*bh;  
x2 = bx+bw+tx;
x3 = x2+ew+tx; 

n = 8;  % max number of securities 
st = {' Stock', ...
      ' Bond', ...
      ' Forward', ...
      ' Call option', ...
      ' Put option'};
pT = {'S', ...
      'K', ...
      '(S-K)', ...
      'max(S-K,0)', ...
      'max(K-S,0)'};   
p0 = {'(-S0)', ...
      '(-exp(-R*T)*K)', ...
      '(exp(-R*T)*K-S0)', ...
      '(-blscall(S0,K,R,T,sigma))', ...
      '(-blsput(S0,K,R,T,sigma))'};

ax = setupAxisAndButtons;
hp = setupParameterSelection;
[hs,hk,hn] = setupSecuritySelection;
clearSecuritySelection

function[ax] = setupAxisAndButtons
ax = .05; ay = (by + bh + wy)/fh;
ah = .7;  aw = (bx - ew)/fw;   
figure('Name','Butterfly: visualize payoffs of an option strategy', ...
       'NumberTitle','off', 'Position',[232 246 fw fh], ...
       'Color','white','Resize','off','MenuBar','none');
ax = axes('Position' ,[ax ay aw ah],'FontSize',8);
guiinput('pushbutton',[bx by bw bh],'Plot' ,@evalSecuritySelection);   
guiinput('pushbutton',[x2 by bw bh],'Reset',@clearSecuritySelection);
end

function[h] = setupParameterSelection
tw = .75*bw;
iw = .75*ew;
tt = .10*ew;
v = {'90' ,'100','0.05';
     '110','0.1','1'};
l = {'xmin','Stock price','Interest rate';
     'xmax','Volatility','Time to expiry'};
h = nan(2,3);
for i = 1:2
   y = .4*by + (i-1)*(eh + ty);
   for j = 1:3
       x = (j-1)*(tw + tx + iw + tt);
       guilabel([x y-4 tw eh],l{i,j});
       h(i,j) = guiinput('edit',[x+tw+tx y iw eh],v{i,j},@checkIfPositive);
   end          
end
end

function[hs,hk,hn] = setupSecuritySelection
bx = .62*fw; 
by = .07*fh;
[hs,hk,hn] = deal(nan(n,1));
for i = 1:n
    y = by + bh + wy + (i-1)*(eh + ty);
    hs(i) = guiinput('popupmenu',[bx y-3 bw eh+2],st,''); 
    hk(i) = guiinput('edit',[x2 y ew eh],'',@checkIfPositive); 
    hn(i) = guiinput('edit',[x3 y ew eh],'',@checkIfNumber);          
end    
y = y + ty + 1.2*eh;
guilabel([bx y bw eh],'Security type')
guilabel([x2 y-10 ew 2*eh],{'Strike /','Face value'})
guilabel([x3 y ew eh],'Units') 
end

function[h] = guiinput(style,position,string,callback)
h = uicontrol('Style',style,'Position',position,'BackgroundColor','white',...
              'FontSize',8,'String',string,'Callback',callback); 
end

function guilabel(position,string)
guiinput('text',position,string,'');
end

function checkIfPositive(hObject,eventdata)      %#ok
i = str2double(get(hObject,'String'));
if isnan(i) || i < 0, beep, end
end

function checkIfNumber(hObject,eventdata)        %#ok
i = str2double(get(hObject,'String'));
if isnan(i), beep, end
end

function evalSecuritySelection(hObject,eventdata)%#ok
cla(ax)
[p,e] = evalSchedule;
plotSchedule(p,e)
end

    function[p,e] = evalSchedule
    p = ''; e = '';
    for i = 1:n
        m = get(hn(i),'String');
        if ~isempty(m) 
           if strcmp(m(1),'-')
              m = ['(' m ')'];
           end   
           s = get(hs(i),'Value');
           k = get(hk(i),'String');
           p = [p '+(' m '*'           strrep(pT{s},'K',k)  ')'];
           e = [e '+(exp(R*T)*(' m '*' strrep(p0{s},'K',k) '))'];
        end
    end
    v = {'S0','R'; 'sigma','T'};
    for i = 1:2
        for j = 1:2
            m = get(hp(i,j+1),'String');
            p = strrep(p,v{i,j},m);
            e = strrep(e,v{i,j},m);
        end    
    end
    end
         
    function plotSchedule(p,e)
    try
       a = str2double(get(hp(1,1),'String'));
       b = str2double(get(hp(2,1),'String'));
       x = linspace(a,b,100);
       p = feval(eval(['@(S) ' p]),x);
       e = feval(eval(['@(S) ' e]),x);
       plot(ax,x,p  ,'Color',[.1 .1 .1],'LineWidth',1.5); hold on
       plot(ax,x,p+e,'Color',[.8 .8 .8],'LineWidth',1.5); hold on
       legend(ax,'\pi_{\itT}','\pi_{\itT} + \ite^{rT}\rm\pi_{0}','Location','Best')
       legend('boxoff') 
       plot(ax,[a b],[0 0],'k:')
    catch
       beep 
    end   
    
end

function clearSecuritySelection(hObject,eventdata) %#ok
% Clear/initialize security selections
m = fliplr([1:5 4 4 5]);
for i = 1:n
    set(hn(i),'String','')
    set(hk(i),'String','')
    set(hs(i),'Value',m(i))
end    
cla(ax)
end

function[c] = blscall(S,K,r,T,sigma)
% Black-Scholes call price
d = (log(S/K) + (r + [1 -1]*sigma^2/2)*T)/(sigma*sqrt(T));
c = S*normcdf(d(1)) - K*exp(-r*T)*normcdf(d(2));
end

function[p] = blsput(S,K,r,T,sigma)
% Black-Scholes put price
d = -(log(S/K) + (r + [1 -1]*sigma^2/2)*T)/(sigma*sqrt(T));
p = K*exp(-r*T)*normcdf(d(2)) - S*normcdf(d(1));
end

end
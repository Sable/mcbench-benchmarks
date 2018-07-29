function RDP_GUI
%Drawing Pad
h_f = figure('name','RDP GUI Demo(Drawing Pad)',...
    'color',[1 1 1],'menubar','none','numbertitle','off',...
    'position',[50 150 600 450]);
h_a = axes('parent',h_f,'xlim',[0 4],'ylim',[0 3],...
    'box','on','dataaspectratio',[1 1 1]);
%Data Reporting
h_f2 = figure('name','Ramer-Douglas-Peucker algorithm',...
    'color',[1 1 1],'menubar','none','numbertitle','off',...
    'position',[700 150 600 450]);
h_a2 = axes('parent',h_f2,'xlim',[0 4],'ylim',[0 3],...
    'box','on','dataaspectratio',[1 1 1]);
%Original data
l_o = line(NaN,NaN,'parent',h_a2,...
    'color',[1 0.5 0],'linestyle','-','linewidth',2,...
    'marker','o','markersize',6);
%Reduced data
l_r = line(NaN,NaN,'parent',h_a2,...
    'color',[0 0 1],'linestyle','-','linewidth',2.5,...
    'marker','o','markersize',6.5);

N = 10;
n = 0;
k = 0;
x = zeros(1,2^k*N);
y = zeros(1,2^k*N);
nk = 1;

h_l = line(NaN,NaN,'parent',h_a,...
    'linewidth',3,...
    'color','r');

set(h_f,'windowbuttonupfcn',@stopdragfcn)
set(h_a,'buttondownfcn',@startdragfcn)

    function startdragfcn(varargin)
        set(h_f,'windowbuttonmotionfcn',@draggingfcn);
        nk = n+1;
    end

    function stopdragfcn(varargin)
        set(h_f,'windowbuttonmotionfcn','');
        n = n+1;
        if n > 2^k*N
            x = repmat(x,1,2);
            y = repmat(y,1,2);
            k = k+1;
        end
        x(n) = NaN;
        y(n) = NaN;
        %Call RDP Fcn
        ptList = DouglasPeucker([x(nk:n-1);y(nk:n-1)],0.05,false);
        set(l_o,'xdata',x(nk:n-1),'ydata',y(nk:n-1));
        set(l_r,'xdata',ptList(:,1),'ydata',ptList(:,2));
    end

    function draggingfcn(varargin)
        n = n+1;
        if n > 2^k*N
            x = repmat(x,1,2);
            y = repmat(y,1,2);
            k = k+1;
        end
        pt = get(h_a,'currentpoint');
        x(n) = pt(1,1);
        y(n) = pt(1,2);
        set(h_l,'xdata',x(1:n),'ydata',y(1:n))
    end
end

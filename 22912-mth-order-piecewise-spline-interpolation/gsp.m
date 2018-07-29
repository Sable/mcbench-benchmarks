function gsp()
% GSP General Piecewise Spline Interpolation
%
% GSP is a graphical user interface which takes x and y points as inputs, along with
% the order m, then outputs mth order splines between each of the x points. In most 
% cases additional constraints are to be entered as well.
% 
% Example:
% 
% Input:
% 
% x points : [1 2 3 4]
% y points : [2 7 -1 5]
% Order    : 2
% *One Additional Constraint is Required*
% f''(1) = 0
% 
% Output:
% Polynomials:
%   0             5            -3
% -13            57           -55
%  27          -183           305
% 
% In the Range:
% 1  2
% 2  3
% 3  4
% 
% This means the following:
% 
% for 1 < x < 2   y = 0*x^2 + 5*x - 3
% for 2 < x < 3   y = -13*x^2 + 57*x - 55
% for 3 < x < 4   y = 27*x^2 - 183*x + 305
% 
% You can obtain the mentioned forms using poly2sym (requires Symbolic Math Toolbox).
% 
% If you want to delete constraints, put its values as '*'. For more help and examples,
% see the pictures accompanied in the zip file. An optional feature can be
% accesessed if the function MQUAKE is present. mquake.m can be found here:
% <http://www.mathworks.com/matlabcentral/fileexchange/22816>
% 
% To launch the GUI, type gsp in the command window with this file in the current directory.
% Alternatively, you can choose Debug -> Run from this editor window, or press F5.
% 
% 
% Husam Aldahiyat, 2009
% numandina@gmail.com
%
global aA

%% figure and uicontrols
figure('units','normalized','position',[.2 .2 .65 .65],'menubar','none','numbertitle','off','color','w','name','General Splines')
axes('position',[.35 .1 .5 .5])
ed1=uicontrol('style','edit','units','normalized','position',[.025 .875 .1 .05],'backgroundcolor','w');
uicontrol('style','text','units','normalized','position',[.025 .94 .1 .025],'backgroundcolor','w','string','x Points');
ed2=uicontrol('style','edit','units','normalized','position',[.025 .75 .1 .05],'backgroundcolor','w');
uicontrol('style','text','units','normalized','position',[.025 .81 .1 .025],'backgroundcolor','w','string','Y Points');
px=uicontrol('style','listbox','units','normalized','position',[.2 .75 .1 .2],'max',2,'backgroundcolor','w',...
	'string',{'Example 1';'Example 2';'Example 3';'Example 4';'Example 5';'Example 6'},'callback',@pn);
ed3=uicontrol('style','edit','units','normalized','position',[.045 .63 .05 .05],'backgroundcolor','w','callback',@cond);
uicontrol('style','text','units','normalized','position',[.025 .69 .1 .025],'backgroundcolor','w','string','Spline Order');
err=uicontrol('style','text','foregroundcolor','r','units','normalized','position',[.025 .55 .22 .05],'backgroundcolor','w',...
	'horizontalalignment','left');
uicontrol('style','pushbutton','units','normalized','position',[.15 .63 .05 .05],'backgroundcolor','w','callback',@go,'string','Solve');
pv=uicontrol('style','pushbutton','units','normalized','position',[.22 .63 .075 .05],'backgroundcolor','w','callback',@dv,...
	'string','Continuity','visible','off');
thih=uicontrol('style','edit','units','normalized','position',[.025 .025 .125 .525],'backgroundcolor','w','max',2,'string','',...
	'horizontalalignment','right','fontsize',13,'fontname','calibri');
edc=uicontrol('style','edit','units','normalized','position',[.15 .025 .075 .525],'backgroundcolor','w','max',2,...
	'horizontalalignment','left','fontsize',13,'fontname','calibri','string','');
Ap=uicontrol('style','listbox','units','normalized','position',[.35 .675 .5 .25],'backgroundcolor','w','max',2,'fontname','courier',...
	'callback',@chv);
Ac=uicontrol('style','listbox','units','normalized','position',[.85 .675 .125 .25],'backgroundcolor','w','max',2,'fontname','courier');
uicontrol('style','text','units','normalized','position',[.35 .935 .5 .025],'backgroundcolor','w','max',2,'string','Spline Polynomials');
uicontrol('style','text','units','normalized','position',[.85 .935 .12 .025],'backgroundcolor','w','max',2,'string','For x in the range');

	function cond(varargin)		
		m=str2double(get(ed3,'string'));
		if m>1
			x=str2num(get(ed1,'string')); %#ok
			if isempty(x)
				set(err,'string','Please give values for x')
				return
			end
			set(err,'string',sprintf('%d Additional Condition(s) Needed',m-1))
			trip=cell(m*2,1);
			for k1=1:m
				koi=repmat('''',1,k1);
				trip{k1}=['f ',koi,'(',num2str(x(1)),') = '];
				trip{k1+m}=['f ',koi,'(',num2str(x(end)),') = '];
			end
			set(thih,'string',trip);
		else
			set(err,'string','No Additional Constraints Required');
			set(edc,'string','')
			set(thih,'string','')
		end
		if m>1
			set(edc,'string',repmat('*',m*2,1))
		end
	end

	function pn(varargin)
		switch get(px,'value')
			case 1
				 set(ed1,'string','0 10')
				 set(ed2,'string','0 0')
				 set(ed3,'string','2')
				 cond
				 set(err,'string','')
				 set(edc,'string',['5';'*';'*';'*'])
			case 2
				 set(ed1,'string','0 1 2')
				 set(ed2,'string','0 1 0')
				 set(ed3,'string','3')
				 cond
				 set(err,'string','')
				 set(edc,'string',['0';'*';'*';'0';'*';'*'])	
			case 3
				 set(ed1,'string','0 1 2')
				 set(ed2,'string','0 1 0')
				 set(ed3,'string','5')
				 cond
				 set(err,'string','')
				 set(edc,'string',['0';'0';'*';'*';'*';'0';'0';'*';'*';'*'])				
			case 4
				 set(ed1,'string','1 2 3 4 7')
				 set(ed2,'string','2 -4 0 3 0')
				 set(ed3,'string','3')
				 cond
				 set(err,'string','')
				 set(edc,'string',['*';'0';'*';'*';'0';'*'])				
			case 5
				 set(ed1,'string','1 2 4 6 8 10')
				 set(ed2,'string','2 4 -2 3 1 0')
				 set(ed3,'string','5')
				 cond
				 set(err,'string','')
				 set(edc,'string',strvcat('5','0','*','*','*','-4','3','*','*','*')) %#ok			
			case 6			
				 set(ed1,'string','1 2 4 6 8 10')
				 set(ed2,'string','2 4 -2 3 1 0')
				 set(ed3,'string','5')
				 cond
				 set(err,'string','')
				 set(edc,'string',strvcat('-5','0','*','*','*','4','3','*','*','*')) %#ok
		end		
	end

%% Solution

	function go(varargin)
		set(pv,'visible','off')
		x=str2num(get(ed1,'string')); %#ok
		y=str2num(get(ed2,'string')); %#ok
		if length(y)~=length(x)
			set(err,'string','Points are not of equal lengths')
			return
		end
		if any(find(abs(sort(x)-x)>1e-10))
			set(err,'string','x Points need to be ascending')
			return
		end
		if length(unique(x))<length(x)
			set(err,'string','Repeated x points found')
			return
		end
		m=str2double(get(ed3,'string'));
		n=length(x)-1; % number of splines
		g=fliplr(0:m);
		DAT=zeros((m+1)*n);
		B=zeros(n*(1+m),1);
		B(1:n+1)=y;
		S=zeros(n,m+1);
		for k=1:n
			DAT(k,k+m*k-m:k+m*k)=x(k).^g;
		end
		DAT(k+1,k+m*k-m:k+m*k)=x(k+1).^g;
		k=k+2;
		poln=ones(1,m+1);
		for k2=1:m
			pol=[poln,zeros(1,(k2-1))];
			for p=1:n-1
				DAT(k+p+k2*n-k2-n,p*m+p-m:p*m+p+m+1)=...
					repmat(pol,1,2).*repmat(x(p+1),1,(m+1)*2).^repmat(g-(k2-1),1,2).*[ones(1,m+1),-ones(1,m+1)];
			end			
			poln=polyder(poln);
		end
		aa=(get(edc,'string'));	
		if m>1
			con=find(~ismember(1:m*2,findstr(aa(:,1)','*'))==1);
			if length(con)>m-1
				set(err,'string','Too many constraints entered')
				return
			end
			if isempty(con)
				set(err,'string','Too few constraints entered')
				return
			end
			for lp=1:m-1
				poln=ones(1,m+1);
				wo=con(1);
				if wo>m
					con(1)=con(1)-m;
				end
				for h1=1:con(1)
					poln=polyder(poln);
				end
				if wo>m					
					DAT(end-(m-1-lp),end-m:end)=repmat(x(end),1,m+1).^(g-con(1)).*[poln,zeros(1,m+1-length(poln))];
					B(end-(m-1-lp))=str2double(aa(wo,:));
				end
				if wo<=m
					DAT(end-(m-1-lp),1:m+1)=[poln,zeros(1,m+1-length(poln))].*repmat(x(1),1,m+1).^(g-con(1));
					B(end-(m-1-lp))=str2double(aa(con(1),:));
				end
				con(1)=[];
			end
		end
		DAT(isnan(DAT))=0;		
		s=DAT\B;
		C=zeros(n,2);
		for k=1:n
			S(k,:)=s(k*(m+1)-m:k*(m+1));
			C(k,:)=x(k:k+1);
		end
		set(err,'string','')

%% Displaying Results

		set(Ap,'string',num2str(S))
		set(Ac,'string',num2str(C))
		cla reset
		hold on
		st=[1 0 0;0 1 0];
		for k=1:n
			t=linspace(C(k,1),C(k,2),100);
			f=polyval(S(k,:),t);
			aA(k)=plot(t,f);
			set(findobj('color','b'),'color',st(mod(k,2)+1,:),'linewidth',2)			
		end
		plot(x,y,'.')
		set(findobj('marker','.'),'markersize',10,'color','k')
		xlabel('x')
		ylabel('y')
		xlim([x(1)-1 x(end)+1])
		h=axis;
		if h(3)>min(y)-1
			h(3)=min(y)-1;
		end
		if h(4)<max(y)+1
			h(4)=max(y)+1;
		end
		axis(h)
		set(pv,'visible','on')
	end

	function dv(varargin)
		S=str2num(get(Ap,'string')); %#ok
		C=str2num(get(Ac,'string')); %#ok
		st=[1 0 0;0 1 0];
		m=str2double(get(ed3,'string'));
		n=length(str2num(get(ed1,'string')))-1; %#ok
		figure('color','w','menubar','none','numbertitle','off','name','Continuity')
		for k2=1:m
			for g=1:n
				S(g,:)=[zeros(m+1-length([polyder(S(g,1:end-k2+1)),zeros(1,k2)])),polyder(S(g,1:end-k2+1)),zeros(1,k2)];
			end
			subplot(ceil(m/2),ceil(m/ceil(m/2)),k2)
			hold on
			for k=1:n
				t=linspace(C(k,1),C(k,2),100);
				f=polyval(S(k,1:end-k2),t);
				plot(t,f);
				set(findobj('color','b'),'color',st(mod(k,2)+1,:),'linewidth',2)
			end
			title(sprintf('Derivate Order %d',k2))
		end
	end

	function chv(varargin)		
		h=axis;
		try
			mquake(aA(get(Ap,'value')),(h(2)+h(4))/4,.5,1)
		catch
		end
	end

end
% this function calculates the required traffic inforamtion for a basic cell in our example the ju area

function traffic()
% here we define oure figure from pushbuttons to edit boxes to axis and etc..
figure('name','traffic','menubar','none','numbertitle','off','units','normalized','color',[1 1 1],'position',[0.25 0.25 0.7 0.6])
uicontrol('style','text','units','normalized','position',[0.05 0.8 0.2 0.1],'string','Number of users');
e1=uicontrol('style','edit','units','normalized','position',[0.25 0.8 0.2 0.1]);
uicontrol('style','text','units','normalized','position',[0.05 0.6 0.2 0.1],'string','Lambda');
e2=uicontrol('style','edit','units','normalized','position',[0.25 0.6 0.2 0.1]);
uicontrol('style','text','units','normalized','position',[0.05 0.5 0.2 0.1],'string','Gamma');
e3=uicontrol('style','edit','units','normalized','position',[0.25 0.5 0.2 0.1]);
uicontrol('style','text','units','normalized','position',[0.05 0.4 0.2 0.1],'string','Totla number of channels');
e4=uicontrol('style','edit','units','normalized','position',[0.25 0.4 0.2 0.1]);
uicontrol('style','text','units','normalized','position',[0.05 0.7 0.2 0.1],'string','percent');
e5=uicontrol('style','edit','units','normalized','position',[0.25 0.7 0.2 0.1]);
uicontrol('style','text','units','normalized','position',[0.05 0.3 0.2 0.1],'string','min C/I');

e6=uicontrol('style','edit','units','normalized','position',[0.25 0.3 0.2 0.1]);
uicontrol('style','text','units','normalized','position',[0.05 0.2 0.2 0.1],'string','Number of Sectors');

e7=uicontrol('style','edit','units','normalized','position',[0.25 0.2 0.2 0.1]);

uicontrol('style','pushbutton','callback',@push,'string','Calculate','units','normalized','position',[0.15 0.01 0.2 0.1]);

tt1=uicontrol('style','text','units','normalized','position',[0.5 0.7 0.4 0.1]);
tt=uicontrol('style','text','units','normalized','position',[0.46 .7 0.03 0.1],'string','A');
tt2=uicontrol('style','text','units','normalized','position',[0.5 0.6 0.4 0.1]);
uicontrol('style','text','units','normalized','position',[0.46 .6 0.03 0.1],'string','Ncell');
tt3=uicontrol('style','text','units','normalized','position',[0.5 0.5 0.4 0.1]);
uicontrol('style','text','units','normalized','position',[0.46 .5 0.03 0.1],'string','#of cell');
mi=	uimenu('label','example','callback',@ex);
	function ex(varargin)
% 		This function loads the already saved example in the directory
		load('example.mat','n','l','g','Nt','pe','ci','nm');
		n;
		l;
		g;
		Nt;
		pe;
		ci;
		nm;
		set(e1,'string',num2str(n));
		set(e2,'string',num2str(l));
		set(e3,'string',num2str(g));
		set(e4,'string',num2str(Nt));
		set(e5,'string',num2str(pe));
		set(e6,'string',num2str(ci));
		set(e7,'string',num2str(nm));
	end

	function push(varargin)
		%calculation of the traffic
		n=str2num(get(e1,'string'));
		l=str2num(get(e2,'string'));
		g=str2num(get(e3,'string'));
		Nt=str2num(get(e4,'string'));
		pe=str2num(get(e5,'string'));
		ci=str2num(get(e6,'string'));
		nm=str2num(get(e7,'string'));
		A=(n*(pe/100)*l)/60;
		set(tt1,'string',num2str(A,6));
		q=((10^(ci/10))*(6/nm))^(1/3);
		er=[0.01;0.15;0.43;0.81;1.26;1.76;2.30;2.87;3.46;4.08;4.71;5.36;6.03;6.71;7.39;8.09;8.80;9.52;10.24;20.97;11.71;12.45;13.21;12.96;14.72;15.49;16.25;17.03;17.81;18.59;19.37;20.16;20.95;21.75;22.55;23.35;24.15;24.96;25.76;26.58;27.39;28.20;29.02;29.84;30.67;31.49;32.31;33.14;33.97;34.81;35.58;36.42;37.27;38.10;38.94;39.78;40.63;41.47;42.32;43.16];
		cc=length(er);
		gg=round(er);
		k=(q^2)/3;
		cd=k;
		i=1;
		j=1;
		k=i^2+j^2+i*j;

		ee=0;
		i=0;
		j=1;
		while ee<cd

			i=i+1;
			ee=i^2+j^2+i*j;

			j=j+1;;
			k=ee;

		end
		if nm == 1
			nc=Nt/(k*nm);
			set(tt2,'string',num2str(nc));
			aaa=er(nc);
			nce=A/aaa;
			nce=ceil(nce);
			set(tt3,'string',num2str(nce));
		else
			Ns=63/(nm*k);
			As=er(round(Ns));
			Acell=3*As;
			set(tt2,'string',num2str(find(gg==ceil(Acell),1)));
			nce=A/Acell;
			nce=ceil(nce);
			set(tt3,'string',num2str(nce))
				save('model.mat','nce')
		end

	end

function push1(varargin)
	%save the number of channels that we calculated to be used on the site
	%configruation.
		save('model.mat','nce')
	end
end

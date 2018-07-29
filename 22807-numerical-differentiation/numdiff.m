function numdiff()
% Numerical Single Dimensional Differentiation
%
% Differentiates functions using different numbers of points around a specific
% value (Finite Differences). The numerical formulas can be easily derived using
% Taylor Series but the code here uses an algorithm I once read. There
% are basically three things that are factored in the process of choosing a formula: 
% 
% 1) Number of points around our value
% 2) Order of derivative used
% 3) Which points around the value to use (Backward/Forward/Central)
% 
% Example:
% npoints=3;
% Order=1;
% d=datnum(npoints,Order)
% d=
% -1.5           2        -0.5           % Forward
% -0.5          -0         0.5           % Central         
%  0.5          -2         1.5           % Backward                 
% 
% The result is a matrix consisting of coefficients that can be used to
% numerically differentiate, like this:
% 
% x=1;
% f=inline('cos(x)')
% h=.1;
% 
% s = ( d(1,1)*f(x) + d(1,2)*f(x+h) + d(1,3)*f(x+2*h) )/h^Order
% s =
%       -0.8444
% 
% s = ( d(2,1)*f(x-h) + d(2,2)*f(x) + d(2,3)*f(x+h) )/h^Order
% s =
%      -0.84007
% 
% s = ( d(3,1)*f(x-2*h) + d(3,2)*f(x-h) + d(3,3)*f(x) )/h^Order
% s =
%      -0.84413
% 
% The true answer is s = -0.84147
% 
% Alternatively, you can use this GUI to automatically handle differentiation.
% To run, type numdiff in the command window, or choose Debug -> Run from this
% editor window, or press F5.
%
% If you need help in operating the GUI, check the pictures accompanied in the
% ZIP file.
% 
% Function needs the Symbolic Math Toolbox to calculate the error. If you don't
% have this toolbox, the error values will be incorrect.
%
% Written for MATLAB R2007a (7.4)
% 
% numandina@gmail.com

fig = openfig('Adv3.fig');
handles = guihandles(fig);
movegui(fig,'west')
set(handles.pushbutton1,'callback',@show)
set(handles.edit12,'callback',@mult)

	function mult(varargin)
		n1=str2num(get(handles.text4,'string')); %#ok
		n2=str2num(get(handles.edit12,'string'));%#ok
		set(handles.text4,'string',num2str(n1*n2,5))
	end

	function show(varargin)
		set(handles.edit12,'string','1');
		set(handles.err1,'string',' ');
		n=str2num(get(handles.edit2,'string'));%#ok
		m=str2num(get(handles.edit5,'string'));%#ok
		set(handles.text4,'visible','off')
		if m+1>n
			set(handles.err1,'string','(m) needs to be less than (n)');
			return
		end
		d=dat(n,m);
		d1=num2str(d,5);
		lip=size(d1);
		lip2=lip(1);
		d2=[];
		eE=repmat(' ',1,lip(2));
		for i=1:lip2
			d2=[d2;d1(i,:);eE];
		end
		set(handles.text4,'string',d2);
		set(handles.uipanel3,'visible','on')
		set(handles.text4,'visible','on')
	end

set(handles.pushbutton2,'callback',@solve)

	function solve(varargin)
		set(handles.uipanel5,'visible','off')
		set(handles.err1,'string',' ');
		f=inline(get(handles.edit3,'string'));
		x=str2num(get(handles.edit1,'string'));%#ok
		n=str2num(get(handles.edit2,'string'));%#ok
		N=length(x);
		h=x(2)-x(1);
		H=diff(x);
		U=repmat(h,N-1,1);
		M=H-U;
		if ~isempty(find(abs(M)>1e-15,1))
			set(handles.err1,'string','Points are not equally spaced')
			return
		end
		KS=str2num(get(handles.edit4,'string'));%#ok
		if length(KS)~=length(x)
			set(handles.err1,'string','Please be so kind as to specify (K)')
			return
		end
		KS2=chk(N,n);
		if n==N
			for i=1:length(KS2)
				if KS2(i)~=KS(i)
					set(handles.err1,'string','Choices for (K) are ill conceived')
					return
				end
			end
		end
		if N<n
			set(handles.err1,'string','Too many points for proposed points formula')
			set(handles.edit4,'string',' ')
			return
		end
		m=str2num(get(handles.edit5,'string'));%#ok
		d=dat(n,m);
		Y=[];
		for i=1:N
			s2=0;
			for j=1:n
				if j+i-KS(i)<=0 || KS(i)>length(d) || (j+i-KS(i))>length(x)
					set(handles.err1,'string','(K) values are ill conceived')
					return
				end
				s2=s2+d(KS(i),j)*feval(f,x(j+i-KS(i)))/(h^m);
			end
			Y=[Y;s2];
		end
		T=zeros(N,1);
		E=zeros(N,1);
		for i=1:N
			try
				T(i)=feval(inline(diff(get(handles.edit3,'string'),m)),x(i)); %SMT
			catch
				T(i)=inf;
			end
			E(i)=abs(T(i)-Y(i))/abs(T(i))*100;
		end
		A=(([x,Y]));
		A1=num2str(A,7);
		A2=num2str(E,3);
		eE=repmat(' ',N,1);
		A=[A1,eE,eE,eE,eE,eE,A2];
		set(handles.uipanel5,'visible','on')
		set(handles.text10,'string',(A));
	end

set(handles.pushbutton3,'callback',@best)

	function best(varargin)
		set(handles.err1,'string',' ');
		x=str2num(get(handles.edit1,'string'));%#ok
		n=str2num(get(handles.edit2,'string'));%#ok
		N=length(x);
		h=x(2)-x(1);
		H=diff(x);
		U=repmat(h,N-1,1);
		M=H-U;
		if ~isempty(find(abs(M)>1e-15,1))
			set(handles.err1,'string','Points are not equally spaced')
			return
		end
		if N<n
			set(handles.err1,'string','Too many points for proposed points formula')
			set(handles.edit4,'string',' ')
			return
		end
        KS=chk(N,n);
        set(handles.edit4,'string',num2str(KS));
	end

set(handles.pushbutton4,'callback',@small)

	function small(varargin)
		set(handles.err1,'string',' ')
		a=str2num(get(handles.edit7,'string'));%#ok
		h=str2num(get(handles.edit8,'string'));%#ok
		n=str2num(get(handles.edit2,'string'));%#ok
		lppp=n^2;
		lppp=ceil(lppp/2);
		x=linspace(a-lppp*h,a+lppp*h,lppp*2+1);
		f=inline(get(handles.edit11,'string'));
		n=str2num(get(handles.edit2,'string'));%#ok
		KS=str2num(get(handles.edit9,'string'));%#ok
		m=str2num(get(handles.edit5,'string'));%#ok
		d=dat(n,m);
		i=(lppp+1);
		s2=0;
		for j=1:n
			if j+i-KS<=0 || KS>length(d) || (j+i-KS)>length(x)				
				length(x)
				set(handles.err1,'string','(K) value is ill conceived')
				return
			end
			s2=s2+d(KS,j)*feval(f,x(j+i-KS))/(h^m);
		end
		try
			T=abs(feval(inline(diff(get(handles.edit11,'string'),m)),a)-s2)/abs(feval(inline(diff(get(handles.edit11,'string'),m)),a));
		catch
			T=0;
		end
		E=((T.*100));
		set(handles.text16,'string',num2str(s2,7))
		set(handles.edit10,'string',num2str(E,3))
	end

set(handles.popupmenu2,'callback',@change)
    
	function change(varargin)
		a=get(handles.popupmenu2,'value');
		if a==2
			set(handles.uipanel6,'visible','on')
			set(handles.uipanel2,'visible','off')
			set(handles.uipanel4,'visible','off')
			set(handles.uipanel5,'visible','off')
			set(handles.uipanel7,'visible','off')
		elseif a==1
			set(handles.uipanel6,'visible','off')
			set(handles.uipanel2,'visible','on')
			set(handles.uipanel4,'visible','on')
			set(handles.uipanel7,'visible','off')
		elseif a==3
			set(handles.uipanel7,'visible','on')
			set(handles.uipanel2,'visible','off')
			set(handles.uipanel4,'visible','off')
			set(handles.uipanel5,'visible','off')
			set(handles.uipanel6,'visible','off')
		end
	end

set(handles.popupmenu3,'callback',@expch)

	function expch(varargin)
		f=get(handles.popupmenu3,'value');
		if f==1
			set(handles.uipanel8,'visible','on')
			set(handles.uipanel10,'visible','off')
		else
			set(handles.uipanel8,'visible','off')
			set(handles.uipanel10,'visible','on')
		end
	end

set(handles.pushbutton5,'callback',@begin)

	function begin(varargin)
		klj= get(handles.popupmenu3,'value');
		if klj==1
			set(handles.edit20,'string',' ')
			set(handles.text50,'string',' ')
			set(handles.text33,'string',' ')
			set(handles.text35,'string',' ')
			m=str2num(get(handles.edit5,'string'));%#ok
			n=str2num(get(handles.edit2,'string'));%#ok
			KS=str2num(get(handles.edit19,'string'));%#ok
			h1=str2num(get(handles.edit16,'string'));%#ok
			h2=str2num(get(handles.edit17,'string'));%#ok
			hc=str2num(get(handles.edit18,'string'));%#ok
			a=str2num(get(handles.edit13,'string'));%#ok
			f=(get(handles.edit14,'string'));
			dell=str2num(get(handles.edit15,'string'))/100;%#ok
			set(handles.text30,'visible','off');
			set(handles.text31,'visible','on');
			d=dat(n,m);
			if h2<h1
				hc=hc*-1;
			end
			for h=h1:hc:h2
				x=linspace(a-25*h,a+25*h,51);
				i=(26);
				s2=0;
				for j=1:n
					s2=s2+d(KS,j)*feval(inline(f),x(j+i-KS))/(h^m);
				end
				try
					err=abs(feval(inline(diff(get(handles.edit14,'string'),m)),a)-s2)/abs(feval(inline(diff(get(handles.edit14,'string'),m)),a));
				catch
					err=0;
				end
				E=((err.*100));
				set(handles.text33,'string',num2str(E,3));
				set(handles.edit20,'string',num2str(h))
				pause(.001)
				if dell>err
					break
				end
			end
			set(handles.edit20,'string',num2str(h))
			set(handles.text33,'string',num2str(E,3));
			set(handles.text34,'visible','on')
			set(handles.text35,'visible','on')
			set(handles.text35,'string',num2str(s2,7));
			set(handles.text30,'visible','on')
			set(handles.text31,'visible','off')
		else
			m=str2num(get(handles.edit30,'string')) ;%#ok
			set(handles.text50,'string',' ')
			set(handles.text35,'string',' ')
			n1=str2num(get(handles.edit26,'string'));%#ok
			n2=str2num(get(handles.edit27,'string'));%#ok
			a=str2num(get(handles.edit13,'string'));%#ok
			h=str2num(get(handles.edit31,'string'));%#ok
			f=(get(handles.edit14,'string'));
			dell=str2num(get(handles.edit15,'string'))/100;%#ok
			set(handles.text30,'visible','off');
			set(handles.text31,'visible','on');
			gh=get(handles.popupmenu4,'value');
			if n2>n1
				icpc=1;
			else
				icpc=-1;
			end
			for n=n1:icpc:n2
				d=dat(n,m);
				if gh==1
					KS=1;
				elseif gh==3
					KS=n;
				else
					KS=ceil((n+1)/2);
				end
				x=linspace(a-99*h,a+99*h,99*2+1);
				i=(100);
				s2=0;
				for j=1:n
					s2=s2+d(KS,j)*feval(inline(f),x(j+i-KS))/(h^m);
				end
				try
					err=abs(feval(inline(diff(get(handles.edit14,'string'),m)),a)-s2)/abs(feval(inline(diff(get(handles.edit14,'string'),m)),a));
				catch
					err=0;
				end
				E=((err.*100));
				set(handles.text48,'string',num2str(n))
				pause(.001)
				set(handles.text50,'string',num2str(E,3));
				if dell>err
					break
				end
			end
			set(handles.text48,'string',num2str(n))
			set(handles.text50,'string',num2str(E,3));
			set(handles.text34,'visible','on')
			set(handles.text35,'visible','on')
			set(handles.text35,'string',num2str(s2,7));
			set(handles.text30,'visible','on')
			set(handles.text31,'visible','off')
		end
	end

	function [d]=dat(n,m)
		set(handles.ld1,'foregroundcolor','r')
		set(handles.ld2,'foregroundcolor','r')
		set(handles.ld3,'foregroundcolor','r')
		set(handles.ld4,'foregroundcolor','r')
		set(handles.ld5,'foregroundcolor','r')
		set(handles.ld6,'foregroundcolor','r')
		set(handles.ld7,'foregroundcolor','r')
		set(handles.ld8,'foregroundcolor','r')
		set(handles.ld9,'foregroundcolor','r')
		set(handles.ld10,'foregroundcolor','r')
		cll=0;
		sel=0;
		n=n-1;
		d=ones(n+1);
		AAA=cell(n+1,n+1);
		ld=0;
		if m==1 && n==1
			for i=0:n
				s=0;
				for j=0:n
					if j~=i
						d(i+1,j+1)=(((-1)^(m-j))*factorial(m)*1)/(factorial(j)*factorial(n-j));
						s=s+d(i+1,j+1);
					end
				end
				d(i+1,i+1)=-1*s;
			end
			return
		end
		for i=0:n
			for j=0:n
				K=[];
				for k=0:n
					if k~=j
						if k~=i
							if j~=i
								K=[K,k-i];
							end
						end
					end
				end
				if ~isempty(K)
					lop=length(K);
					if m==1 && m~=n
						AA2=cumprod(K);
						AA=AA2(lop);
					elseif m==n
						AA=1;
					elseif m==n-1
						AA=cumsum(K);
						AA=AA(length(K));
					elseif m==n-2
						L=K;
						s=0;
						for f1=1:2*n-m
							for k1=f1+1:lop
								pr=1*L(f1)*L(k1);
								s=s+pr;
							end
						end
						AA=s;
					else
						c=nchoosek(K,(n-m));
						dr=cumprod(c')';
						as=size(dr);
						df=dr(:,as(2));
						ld=ld+1;
						cll=cll+1;
						hcj=((n+1)^2-n-1);
						pause(.001)
						ice=floor(hcj/10);
						if cll==ice
							sel=sel+1;
							switch sel
								case 1
									set(handles.ld1,'foregroundcolor','g');
								case 2
									set(handles.ld2,'foregroundcolor','g');
								case 3
									set(handles.ld3,'foregroundcolor','g');
								case 4
									set(handles.ld4,'foregroundcolor','g');
								case 5
									set(handles.ld5,'foregroundcolor','g');
								case 6
									set(handles.ld6,'foregroundcolor','g');
								case 7
									set(handles.ld7,'foregroundcolor','g');
								case 8
									set(handles.ld8,'foregroundcolor','g');
								case 9
									set(handles.ld9,'foregroundcolor','g');
								case 10
									set(handles.ld10,'foregroundcolor','g');
							end
							cll=0;
						end
						sss=0;
						for gh=1:as(1)
							sss=sss+df(gh);
						end
						AA=sss;	
					end
					AAA{i+1,j+1}=AA;
				end
			end
		end
		for i=0:n
			s=0;
			for j=0:n
				if j~=i
					d(i+1,j+1)=(((-1)^(m-j))*factorial(m)*AAA{i+1,j+1})/(factorial(j)*factorial(n-j));
					s=s+d(i+1,j+1);
					ld=ld+1;
				end
			end
			d(i+1,i+1)=-1*s;
		end
		set(handles.ld1,'foregroundcolor','g');
		set(handles.ld2,'foregroundcolor','g');
		set(handles.ld3,'foregroundcolor','g');
		set(handles.ld4,'foregroundcolor','g');
		set(handles.ld5,'foregroundcolor','g');
		set(handles.ld6,'foregroundcolor','g');
		set(handles.ld7,'foregroundcolor','g');
		set(handles.ld8,'foregroundcolor','g');
		set(handles.ld9,'foregroundcolor','g');
		set(handles.ld10,'foregroundcolor','g');
	end

	function [KS]=chk(N,n)
		K=floor(n/2);
		KS=[];
		for i=0:K-1
			KS=[KS;i+1];
		end
		for i=K:N-K-1
			KS=[KS;K+1];
		end	
		for i=N-K:N-1
			KS=[KS;n+i-N+1];
		end
	end

end
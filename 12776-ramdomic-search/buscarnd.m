function [xo,Ot,nS]=buscarnd(S,x0,ip,nOt,samples,Lb,Ub,problem,tol,mxit,R,red,mem)
%   Unconstrained global optimization using adaptive random search.
%
%   [xo,Ot,nS]=buscarnd(S,x0,ip,nOt,samples,Lb,Ub,problem,tol,mxit,R,red,mem)
%
%   S: objective function
%   x0: initial point
%   ip: (0): no plot (default), (>0) plot figure ip with pause, (<0) plot figure ip
%   nOt: maximum number of optimal points (default = 1)
%   samples: number of samples per stage (default = 3*size(x0(:),1))
%   Lb, Ub: lower and upper bound vectors to plot (default = x0*(1+/-2))
%   problem: (-1): minimum (default), (1): maximum
%   tol: tolerance (default = 1e-4)
%   mxit: maximum number of stages (default = 50*(1+4*~(ip>0)))
%   R: axis vector of the hyperellipse centered in x0 (default = max(0.1*abs(x0+~x0),1))
%   red: factor to reduce the size of the axis vector (0,1) (default = 0.2)
%   mem: number of stored points during the exploration phase [0, min(18,samples-1)]
%   xo: matrix of optimal points (column vectors)
%   Ot: vector of optimal values of S
%   nS: number of objective function evaluations

%   Copyright (c) 2001 by LASIM-DEQUI-UFRGS
%   $Revision: 1.0 $  $Date: 2001/07/10 19:40:05 $
%   Argimiro R. Secchi (arge@enq.ufrgs.br)
%
%   Based on the algorithm of the same author written in C
%   for constrained global optimization in 1989/09/29 and published as:
%   A.R. Secchi and C.A. Perlingeiro, "Busca Aleatoria Adaptativa",
%   in Proc. of XII Congresso Nacional de Matematica Aplicada e
%   Computacional, Sao Jose do Rio Preto, SP, pp. 49-52 (1989).
%
% Modified by Giovani Tonel(giovani.tonel@ufrgs.br) on September 2006



rand('state',sum(100*clock)); 	%rand('state',sum(100*clock)) resets it to 
													%		         a different state each time.



if nargin < 2,
   error('buscarnd requires two input arguments');
 end
 if nargin < 3 | isempty(ip),
   ip=0;
 end
 if nargin < 4 | isempty(nOt),
   nOt=1;
 end
 if nargin < 5 | isempty(samples),
   samples=3*size(x0(:),1);
 end
 if nargin < 6 | isempty(Lb),
   Lb=-x0-~x0;
 end
 if nargin < 7 | isempty(Ub),
   Ub=2*x0+~x0;
 end
 if nargin < 8 | isempty(problem),
   problem=-1;
 end
 if nargin < 9 | isempty(tol),
   tol=1e-4;
 end
 if nargin < 10 | isempty(mxit),
   mxit=50*(1+4*~(ip>0));
 end
 if nargin < 11 | isempty(R),
   R=max(0.1*abs(x0+~x0),1);
 end
 if nargin < 12 | isempty(red) | red <= 0 | red >= 1,
   red=0.2;
 end
 if nargin < 13 | isempty(mem),
   mem=min(18,samples-1);
 end
 if mem >= samples,
   mem=samples-1;
 end
                    % initialization 
 x0=x0(:);
 R=abs(R(:));
 n=size(x0,1);
 distrib=1;          % distr =  1  --> exploration phase
                     % distr >  1  --> progression phase
 asym1=-1*ones(n,1); % asym1 =  1  --> asymmetric distribution to reduce xo
                     % asym1 = -1  --> asymmetric distribution to increase xo
 asym2=2*ones(n,1);  % asym2 =  2  --> symmetric distribution
                     % asym2 = 1.5 --> asymmetric distribution
 metric=0.5*norm(R);
 a0=0.5*metric;
 a2=0.1*metric;
 a3=10*tol;
 n3=1;
 holdm=floor(1/red+0.5)*n;
 nhold=0;            % counter to keep distribution constant during holdm times

 top=0;
 if mem > 0,
   n4=10*mem;
   idx=[1:n4+1];
   last=n4;
   first=0;
   idx(last+1)=first;
   mem_x=zeros(n,n4);
   mem_S=-ones(1,n4)*inf;
 end

%     Criterion of axis vector reduction
%
%     R_red = R*0.5^(distrib-1)
%
%     or norm(R_red) = norm(R)*0.5^(distrib-1)
%
%     then if the criterion is norm(R_red) < tol = 10^(-asc)
%
%     the distrib is limited by
%
%     distrib = 1 + (asc + log10(norm(R))) / log10(2)

 lim_distrib=floor(0.5*(1+log10(metric/tol)/log10(2.0)));

 if ip & n == 2,
   figure(abs(ip));
   [X1,X2]=meshgrid(Lb(1):(Ub(1)-Lb(1))/20:Ub(1),Lb(2):(Ub(2)-Lb(2))/20:Ub(2));
   [n1,n2]=size(X1);
   f=zeros(n1,n2);
   for i=1:n1,
    for j=1:n2,
      f(i,j)=feval(S,[X1(i,j);X2(i,j)]);
    end
   end
   mxf=max(max(f));
   mnf=min(min(f));
   df=mnf+(mxf-mnf)*(2.^(([0:10]/10).^2)-1);
   [v,h]=contour(X1,X2,f,df); hold on;
%   clabel(v,h);
   h1=plot(x0(1),x0(2),'ro');
   legend(h1,'start point');

   if ip > 0,
     disp('Pause: hit any key to continue...'); pause;
   end
 end

 xOt=[];
 Ot=[];
 xo=x0;
 yo=feval(S,x0)*problem;
 nS=1;
 it=0;
 opt=0;
 x=zeros(n,samples);
 y=zeros(1,samples);
 
 while it < mxit & opt < nOt,
  l3=0;
  it=it+1;
  for j=1:samples,   % sampling
    a=min(max(rand(n,1),0.05),0.95);
    x(:,j)=xo+(R.*asym1.*(asym2.*a-1).^distrib)/distrib;
    y(j)=feval(S,x(:,j))*problem;
    nS=nS+1;
  end

  l4=mem & distrib == 1;  % sorting the samples
  if samples > 1,
    if ~l4, 
      [y(1),i]=max(y);
      x(:,1)=x(:,i);
    else
      [y,i]=sort(-y); y=-y;
      x=x(:,i);
    end
  end

  if l4,                  % memorize samples
    n2=top;
    l1=0;
    for j=1:samples,
      n1=0;
      if opt,
        for i=1:opt
          if norm(xOt(:,i)-x(:,j)) < a2,
            n1=1;
            if j == 1,
              l1=1;
            end
            break;
          end
        end
      end
      
      if ~n1,       
	for i=1:j-1
	   if norm(x(:,j)-x(:,i)) < metric,
	     n1=1;
	     break;
	   end
	end
	
	if ~n1,
	  k=idx(1);
	  for i=1:top
             if norm(mem_x(:,k)-x(:,j)) < metric,
               n1=1;
               break;
             else
               k=idx(k+1);
             end
          end
          
	  if ~n1,
            first=idx(first+1);
            if ~first,              % expand memory
              mem_x=[mem_x,zeros(n,n4)];
              mem_S=[mem_S,-ones(1,n4)*inf];
              idx=[idx,[n2+1:n2+n4+1]];
              first=n2;
              idx(last+1)=first;
              last=n2+n4;
              idx(last+1)=0;
            end
            k=first;
            n2=n2+1;
          end  

          if ~n1 | y(j) > mem_S(k),
            mem_x(:,k)=x(:,j);
            mem_S(:,k)=y(j);
          end
          
	  if l1,
            l1=0;
            x(:,1)=x(:,j);
            y(1)=y(j);
          end    
        end  
      end
          
      if n2-top == mem,
        break;
      end
    end
    top=n2;
  end
                  % analysis of best sampled point
  a1=norm(x(:,1)-xo)/(0.1+norm(xo))+abs(y(1)-yo)/(0.1+abs(yo));
  l1=y(1) > yo;
  if l1,
    if norm(x(:,1)-xo) > a0,
      nhold=0;
      n3=1;
    end
    
    z=xo; xo=x(:,1); x(:,1)=z;
    a4=yo; yo=y(1); y(1)=a4;
    
    if ip & n == 2,
      plot([x(1) xo(1)],[x(2) xo(2)],'r');
      if ip > 0,
        disp('Pause: hit any key to continue...'); pause;
      end
    end
  end

  if a1 < tol & distrib >= lim_distrib,
    l2=1;
    if opt,
      for i=1:opt,
        if norm(xOt(:,i)-xo) < a3,
          l2=0;
          break;
        end
      end
    end

    if l2,
      opt=opt+1;
      Ot=[Ot,yo];
      xOt=[xOt,xo];
      if ip & n == 2,
        h2=plot(xo(1,:),xo(2,:),'r*');
        if opt == 1,
          legend([h1,h2],'start point','optimum');
        end
      end
    end

        % rescue another point from memory
    if ~top,
      if opt,
        xo=xOt;
        yo=Ot;
      end
      break;
    end
    
    if l2 & ~l1,
      n2=0;
      for j=1:top,
        k=idx(n2+1);
        if norm(mem_x(:,k)-xo) < a2,
          top=top-1;
          idx(last+1)=k;
          last=k;
          idx(n2+1)=idx(k+1);
          idx(k+1)=0;
          if k == first,
            first=n2;
          end
        else
          n2=k;
        end
      end
    end

    if ~top,
      if opt,
        xo=xOt;
        yo=Ot;
      end
      break;
    end	
          
    k=idx(1);
    xo=mem_x(:,k);
    yo=mem_S(k);
    idx(last+1)=k;
    last=k;
    idx(1)=idx(k+1);
    idx(k+1)=1;
    top=top-1;
    
    if k == first,
      first=1;
    end
    
    l3=1;

    if ip & n == 2 & opt < nOt,
      plot(xo(1),xo(2),'ro');
    end
  elseif opt & (~l1 | (l1 & ~l4))
        n1=0;
	for i=1:opt,
          if norm(xOt(:,i)-xo) < a2,
            n1=1;
            break;
          end
        end
	
	if n1,
          if ~top,
            xo=xOt;
            yo=Ot;
            break;
          end	
          
          k=idx(1);
          xo=mem_x(:,k);
          yo=mem_S(k);
          idx(last+1)=k;
          last=k;
          idx(1)=idx(k+1);
          idx(k+1)=1;
          top=top-1;

          if k == first,
            first=1;
          end

	  l3=1;
	  
          if ip & n == 2 & opt < nOt,
            plot(xo(1),xo(2),'ro');
          end
        end
  end
                 % adjust search direction and criterion
  if l3,
    n3=1;
    distrib=1;
    nhold=0;
  elseif (a1 < a2 | ~l1) & (nhold+n3 > holdm),
        n3 = n3+~mod(distrib,3);
        distrib=distrib+2;
	nhold=0;
  else
    nhold=nhold+n3;
  end
  
  for i=1:n,
    if l3 | (~l3 & x(i,1) == xo(i)),
      asym2(i)=2;
    else
      asym2(i)=1.5;
      if x(i,1) < xo(i),
        asym1(i)=1;
      else
        asym1(i)=-1;
      end
    end
  end
 end
 
 if it == mxit,
   %disp('Warning Buscarnd: reached maximum number of stages!');
   if opt,
     yo=Ot;
     xo=xOt;
   end
 end

 if opt == nOt,
   yo=Ot;
   xo=xOt;
 end
 
 if opt > 1,
   [yo,i]=sort(-yo); yo=-yo;
   xo=xo(:,i);
 end
 
 Ot=yo*problem;

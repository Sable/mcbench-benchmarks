function gam = vario(x,y,z,cloud) 
%VARIO 2D calculation of variogram in two dimension -  scatter points
%     
% inputs:  
%  x -- coordinates X
%  y -- coordinates Y
%  z -- variable
%  cloud -- plot the cloud

%  example:   
% load 'cluster.dat'
% x = cluster(:,1);
% y = cluster(:,2);
% z = cluster(:,3);
% clear cluster
% [length(z) mean(z) var(z)]
% variogram(x,y,z,0)

%   Written by Moacir Cornetti & Armando Remacre, IG/UNICAMP
%   Revision: 1.0  Date: 2003/12/05
%   This function is not supported by The MathWorks, Inc.

x = x(:); y = y(:); z = z(:); n = length(x);
rad = 180/pi;
dmax = sqrt((max(x)-min(x))^2 + (max(y)-min(y))^2);
npdft    = 5   ; 
passodft = 5   ;  passodft = (fix(passodft*100)+1)/100;
passodft = num2str(passodft,1);
npdft    = num2str(npdft);
tolpasdft = 0.5                ; tolpasdft = num2str(tolpasdft);
angi = 0; angidft = num2str(angi);

nangdft = 1 ;     nangdft = num2str(nangdft);
tolangdft = .2; tolangdft = num2str(tolangdft);
prompt={'Enter the number of lags           ',...
        'Enter the lag                      ',...
        'Enter the lag tolerance   [0 - 0.5]',...
        'Enter the number of directions     ',...    
        'Enter the direction tolerance      ',...
        'Enter the initial direction        '} ; 
        
default = {npdft,passodft,tolpasdft,nangdft,tolangdft,angidft};
title2  = 'Variogram Parameter ';
lineNo  = 1;
Resize  = 'on';
answer=inputdlg(prompt,title2,lineNo,default,Resize);

np     = str2num(answer{1}); if np==0, np = 10; end
passo  = str2num(answer{2}); if passo==0, passo = str2num(passodft); end
tolpas = str2num(answer{3}); if tolpas>0.5, tolpas=0.5; end

nang    = str2num(answer{4}); if nang==0, nang=1 ; end
tolang  = str2num(answer{5}); if tolang<=0, tolang=0.1; end
angi = str2num(answer{6}) ; 

dd = 180/nang;
dir = [angi]; for i=1:nang-1, ss = angi+dd*i; dir = [dir ss ]; end
tolpas = tolpas*passo;
ang    = 180/nang; 
tolang = tolang*ang;

d = [];
for i=1:n,        
   d(:,i)=sqrt( (x-x(i)).^2 +  (y-y(i) ).^2);    
end

%===============================================
% Replace zeros along diagonal with ones 
d(1:n+1:prod(size(d))) = ones(1,n);
% eps  Floating point relative accuracy.
non = find(d <= eps);
if ~isempty(non),
   % If we've made it to here, then some points aren't distinct.  Remove
   % the non-distinct points by averaging.
   [r,c] = find(d == 0);
   k = find(r < c);
   r = r(k); c = c(k);  % Extract unique (row,col) pairs
   v = (z(r) + z(c))/2; % Average non-distinct pairs
   
   rep = find(diff(c)==0);
   if ~isempty(rep),    % More than two points need to be averaged.
      runs = find(diff(diff(c)==0)==1)+1;
      for i=1:length(runs),
         k = find(c==c(runs(i)));                 % All the points in a run
         v(runs(i)) = mean(z([r(k);c(runs(i))])); % Average (again)
      end
   end
   z(r) = v;
   if ~isempty(rep),
      z(r(runs)) = v(runs); % Make sure average is in the dataset
   end
   
   % Now remove the extra points.
   
   x(c) = [];    y(c) = [];    z(c) = []; d(c,:)  = [];  d(:,c)  = [];
   
   % Determine the non distinct points
   ndp = sort([r;c]);
   ndp(find(ndp(1:length(ndp)-1)==ndp(2:length(ndp)))) = [];
   
   warning(sprintf(['Averaged %d non-distinct points.\n' ...
         '         Indices are: %s.'],length(ndp),num2str(ndp')))
end
%===============================================
% return the zeros in the diagonal
n = size(d,1);
d(1:n+1:prod(size(d))) = zeros(1,n);
% [r,c] = find(d ~= 0); 
d = triu(d) ; [r,c] = find(d ~= 0); 
r = int16(r) ; c = int16(c);
d = d(find(d~=0)) ; % d torna-se 1D coluna

% distancias reduzidas
tolpas = tolpas/passo;
aux = d/passo + tolpas;

ipasso = fix(aux);
aux = aux ./ (fix(aux)+ 2*tolpas);
iaux = find(aux <= 1.0001);
ipasso = ipasso( iaux );clear aux;

% redefine os conjuntos só com as distâncias selecionadas
d = d(iaux); r = r(iaux); c = c(iaux);

angulo = ones(size(d))*90;

ii = find((x(r)-x(c))~=0);
angulo(ii) = atan( (y(r(ii))-y(c(ii)))./((x(r(ii))-x(c(ii)))))*rad; 
ii = find(angulo < 0); 
angulo(ii)=angulo(ii)+180;
angulo = angulo - angi;

angulo = fix(angulo ./ tolang)+1;
angulo = fix(angulo/2)+1; 
ii = find(angulo == nang+1);
angulo(ii) = 1;

clf
simb =  [ 'r+-'; 'k*-'; 'b*-'; 'gs-'; 'mx-' ; 'co-'];
pimb =  [ 'r.' ; 'k.' ; 'b.' ; 'g.' ; 'm.'  ; 'c.' ; 'y.'];
hmax = np*passo+tolpas; 
gmax = 1.5*var(z);
for ia=1:nang,
   hh = []; gg = []; npp = []; vzh = [];
   for i=0:np,
      ipp = find(angulo==ia & ipasso==i);
      if isempty(ipp)~=1
         dv =  z(r(ipp)) - z(c(ipp)); dv = dv.*dv;
         npp = [npp ; length(ipp)];
         hh =  [ hh ; mean(d(ipp))];
         gg =  [ gg ; mean(dv) ];
         vzh = [vzh ;  var(dv) ];
         pp = dv/2; 
         
         if cloud==1 
             gmax = max(pp);
             plot(d(ipp),pp,pimb(i+1,:)), hold on
         end 
      else
         npp = [npp; 0];
         hh = [ hh ; 0];
         gg = [ gg ; 0];
        vzh = [ vzh; 0];
      end
   end
   ip = [0:np]'; gg = gg/2; 
   result = [ip  hh  gg  npp sqrt(vzh)];
   disp([' Direction >',num2str(dir(ia))])
   disp( sprintf('%3.0f  %7.4f  %8.4f  %4.0f   %8.4f \n',result') )
   plot(hh,gg,simb(ia,:)), hold on
 % if n<=201, text(hh+.1,gg,num2str(npp)); end
   
end

axis([0 hmax 0 1.1*gmax ])
xlabel(' Distance h'); ylabel('Gamma(h)'); title('Variogram 2D')
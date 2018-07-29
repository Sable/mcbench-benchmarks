function spectmesh(x,Ts,wn,N)
% Plot the mesh-spectrogram.
% spectmesh(x,[Ts,wn,N])

% Set parameters.
if nargin < 2, Ts = 1; end
if nargin < 3, wn = struct('type','hanning','len',128,'lag',8); end
if nargin < 4, N  = 2*wn.len; end

% Set constants.
xlen = length(x);
wlen = wn.len;
wlag = wn.lag;
w    = feval(wn.type,wlen);

% Zero-pad signal.
xpad = wlag-rem(xlen-wlen-1,wlag)-1;
x    = [x(:); zeros(xpad,1)];
L    = (xlen+xpad-wlen)/wlag+1;
c1   = (L-1)*Ts*wlag;
c2   = (N+2)/(N+1)/Ts/2;

% Calculate FFT coefficients.
u1 = transpose([1:wlen]);
u2 = wlag*[0:L-1];
y  = x(u1(:,ones(1,L))+u2(ones(1,wlen),:));
y  = fft(w(:,ones(1,L)).*y,N);
%% for k = 1:L, y(:,k) = fft(w.*x((k-1)*wlag+(1:wlen)),N); end
y  = y(1:N/2+1,:);

[X1,X2] = meshgrid(linspace(0,c1,L),linspace(0,c2,N/2+1));
%% figure, contour(X1,X2,log(abs(y)+eps)); set(gca,'FontSize',8);
figure, mesh(X1,X2,abs(y),'CDataMapping','direct','EdgeColor',[0 0 0],'MeshStyle','column');
set(gca,'FontSize',8,'XLim',[0 c1],'YLim',[0 c2]); xlabel('Time'); ylabel('Frequency');

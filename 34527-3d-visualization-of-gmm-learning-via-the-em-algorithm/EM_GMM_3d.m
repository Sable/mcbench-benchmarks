function X = EM_GMM_3d(c,wk,N,movie,Y,D,Cv)
%% 3D visualization of EM for GMMs
% function X = EM_GMM_3d(c,wk,N,movie,Y,D,Cv)
%
% Inputs: c      - # clusters (default: 5)
%         wk     - array of # gaussians to fit (default: 1:10)
%         N      - # GMM samples (default: 200)
%         movie  - string: writes .avi for each k (default: [])
%         Y      - NxD data matrix (default: generate new data)
%         D      - data dimensionality (default: 3)
%         Cv     - covariance type (0: diag, 1: full) (default: full)
% Output: X      - NxD data matrix
%
% How it works:
%   For each value of k in 'wk':
%    - Fit GMM with EM
%    - Interpolate model params between EM iterations
%    - Coloring: Gaussians - transparency = GMM mixing weights
%                data      - color blend = posterior probs
%    - Play movie of EM learning
%    - (optional) Save movie to .avi file
%
% Author: Johannes Traa, UIUC, Nov-Dec '11
% 
% Revised Mar '13 (cleaned up code, added full covariance capability)


%% check input args
if nargin < 1 || isempty(c);  c  = 5;    end
if nargin < 2 || isempty(wk); wk = 1:10; end
if nargin < 3 || isempty(N);  N  = 200;  end
if nargin < 4 || isempty(movie)
  m_val = 0;
  set(0,'DefaultFigureWindowStyle','docked')
else
  m_val = 1;
  set(0,'DefaultFigureWindowStyle','normal')
  if ~ischar(movie)
    movie = 'EM_k';
  end
end
if nargin < 6 || isempty(D);  D  = 3; end
if nargin < 7 || isempty(Cv); Cv = 1; end

%% get data
if ~(nargin<5 || isempty(Y))
  X = Y;
  [N,D] = size(X);
else
  % GMM params
  m = 10*randn(c,D); % means
  C = zeros(D,D,c); % covariance matrices
  for j=1:c
    Cj = randn(D,10);
    C(:,:,j) = Cj*Cj';
  end
  w = dirrand(3*ones(1,c),1); % mixing weights
  
  % sample from GMM
  X = zeros(N,D);
  for i=1:N
    j = find(mnrnd(1,w));
    X(i,:) = m(j,:) + randn(1,D)*sqrtm(C(:,:,j));
  end
end

%% get GMM and show movie for different k
% initialize figure window
fh = figure;

for k=wk
  % ----- fit k-gaussian GMM -----
  [M,C,P,ii] = EM_GMM_movie(X,k,Cv);
  
  % ----- interpolate params between iterations -----
  fps = 35; % frames per second
  f = fps*ii+1; % # frames
  
  m = zeros(k,D,f); % interpolated means
  Cm = zeros(D,D,k,f); % interpolated covars
  Pi = zeros(N,k,f); % interpolated posteriors
  
  % set anchor frames (true values of model at each iteration)
  for i=1:ii
    m(:,:,(i-1)*fps+1) = M{i};
    Cm(:,:,:,(i-1)*fps+1) = C{i};
    Pi(:,:,(i-1)*fps+1) = P{i};
  end
  
  % correct last frame
  m(:,:,ii*fps+1) = m(:,:,(ii-1)*fps+1);
  Cm(:,:,:,ii*fps+1) = Cm(:,:,:,(ii-1)*fps+1);
  Pi(:,:,ii*fps+1) = Pi(:,:,(ii-1)*fps+1);
  
  % interpolate missing frames for continuity
  mix = linspace(0,1,fps); % mixing weights for interpolation
  for i=1:ii
    % get anchor values
    m1 = m(:,:,(i-1)*fps+1);
    m2 = m(:,:,i*fps+1);
    c1 = Cm(:,:,:,(i-1)*fps+1);
    c2 = Cm(:,:,:,i*fps+1);
    p1 = Pi(:,:,(i-1)*fps+1);
    p2 = Pi(:,:,i*fps+1);
    
    % interpolate
    for j=2:fps
      m(:,:,(i-1)*fps+j) = m1*mix(fps-j+1) + m2*mix(j);
      Cm(:,:,:,(i-1)*fps+j) = c1*mix(fps-j+1) + c2*mix(j);
      Pi(:,:,(i-1)*fps+j) = p1*mix(fps-j+1) + p2*mix(j);
    end
  end
    
  % fills (2D) or ellipsoids (3D)
  rr = 20; % resolution
  theta = linspace(0,2*pi,rr);
  if D == 2
    E = zeros(rr,D,k,f); % fill boundaries
    v = [cos(theta); sin(theta)]';
  else
    E = zeros(rr,rr,D,k,f); % surf contours
    phi = linspace(0,pi,rr);
    v = [kron(cos(theta),sin(phi)); ...
      kron(sin(theta),sin(phi)); ...
      repmat(cos(phi),[1,rr])]';
  end
  for i=1:f
    for j=1:k
      E_ij = bsxfun(@plus,m(j,:,i),v*sqrtm(Cm(:,:,j,i)));
      if D == 2
        E(:,:,j,i) = E_ij;
      else
        for d=1:3
          E(:,:,d,j,i) = reshape(E_ij(:,d),[rr,rr]);
        end
      end
    end
  end
  
  % ----- coloring -----
  % posterior = color
  cc = jet(k);
  C = zeros(N,3,f);
  for i=1:f
    C(:,:,i) = Pi(:,:,i)*cc;
  end
  
  % mixing weight = transparency
  w = sum(Pi,1)/N; % mixing weights
  w = reshape(w,[k,f])'; % (frames x Gaussians)
  w = bsxfun(@rdivide,w,max(w,[],2)); % normalize rows
  w = bsxfun(@times,w,linspace(0.2,0.6,f)'); % fade in ellipsoids
  
  
  % ----- set up for movie -----
  % set up to write frames to avi object/set frame skip rate
  if ~m_val % don't write movie, skip frames for speed
    fi = 5;
  else % write frames for movie
    aviobj = avifile([movie num2str(k)]);
    fi = 1;
  end
  
  % axis handles (means, fills/ellipsoids, data)
  hold on
  eh = zeros(k,1); % fills/ellipsoids
  if D == 2
    mmh = scatter(m(:,1,1),m(:,2,1),200,'+k'); % means
    for g=1:k % fills
      eh(g) = fill(E(:,1,g,1),E(:,2,g,1),cc(g,:),...
        'FaceAlpha',w(1,g),'EdgeColor','none');
    end
    Xh = scatter(X(:,1),X(:,2),30,C(:,:,1),'filled'); % data
  else
    mmh = scatter3(m(:,1,1),m(:,2,1),m(:,3,1),200,'+k'); % means
    for g=1:k % ellipsoids
      eh(g) = surf(E(:,:,1,g,1),E(:,:,2,g,1),E(:,:,3,g,1),...
        'FaceColor',cc(g,:),'FaceAlpha',w(1,g),'EdgeColor','none');
    end
    Xh = scatter3(X(:,1),X(:,2),X(:,3),30,C(:,:,1),'filled'); % data
  end
  
  % figure details
  axis tight square
  if D == 3
    axis vis3d
  end
  grid on
  rot = 0;
  set(gcf,'Color','w')
  
  
  % ----- play movie showing evolution of GMM -----
  for i=[1:fi:f-1 f]
    it = 1+floor((i-1)/fps); % iteration #
    
    % update data coloring
    set(Xh,'CData',C(:,:,i));
    
    % update interpolated means ('+')
    set(mmh,'XData',m(:,1,i));
    set(mmh,'YData',m(:,2,i));
    if D == 3
      set(mmh,'ZData',m(:,3,i));
    end
        
    % update ellipsoids
    for g=1:k
      if D == 2
        set(eh(g),'XData',E(:,1,g,i))
        set(eh(g),'YData',E(:,2,g,i))
      else
        set(eh(g),'XData',E(:,:,1,g,i))
        set(eh(g),'YData',E(:,:,2,g,i))
        set(eh(g),'ZData',E(:,:,3,g,i))
      end
      set(eh(g),'FaceAlpha',w(i,g))
    end
    
    % figure details
    xlabel(['iteration: ' num2str(it) '  '])
    if D == 3
      view(-50+rot,30)
      rot = rot + 0.4;
    end
    
    % add frame to .avi object
    if m_val
      F = getframe(fh);
      aviobj = addframe(aviobj,F);
    end
    
    pause(1/fps);
  end
  
  
  % ----- clean up for next k -----
  xlabel(['iteration: ' num2str(ii) '  '])
  
  % write out video
  if m_val
    for i=1:fps
      aviobj = addframe(aviobj,F);
    end
    aviobj = close(aviobj);
    clf
  elseif k ~= wk(end)
    pause
  end
  
  % new figure
  if k < wk(end) && ~m_val
    figure
  end
end




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dirrand

function X = dirrand(a,N)
%% Sample from Dirichlet distribution
% function X = dirrand(a,N)
%
% Inputs: a - parameters of Dirichlet distribution
%         N - number of samples
% Output: X - Nxd matrix of Dirichlet samples

%% 
X = gamrnd(repmat(a,N,1),1);
X = bsxfun(@rdivide,X,sum(X,2));



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EM_GMM_movie

function [M,C,P,i] = EM_GMM_movie(X,k,Cv)
%% EM for GMMs
% [M,C,P,iters] = EM_GMM(X,k)
%
% Inputs: X - data (points x dims)
%         k - # clusters
% Outputs: M - cell array of means at each iteration
%          C - cell array of covars at each iteration
%          P - cell array of posteriors at each iteration
%          i - iterations to convergence

[N,d] = size(X);
A = zeros(N,k); % posteriors

% initialize
Cx = sqrtm(cov(X));
m = bsxfun(@plus,sum(X,1)/N,randn(k,d)*Cx);
w = ones(1,k)/k; % mixing weights
if Cv; Ca = repmat(Cx,[1,1,k]); % full cov
else   Ca = ones(k,d); % diagonal cov
end

% save params from each iteration
M = cell(1,50);
C = cell(1,50);
P = cell(1,50);

M{1} = m;
if Cv
  C{1} = Ca;
else
  C{1} = zeros(d,d,k);
  for j=1:k
    C{1}(:,:,j) = diag(Ca(j,:));
  end
end
P{1} = ones(N,k)/k;

% iterate
ll = -Inf;
for i=2:50
  ll_old = ll;
  
  % -- E step --
  if Cv
    for j=1:k
      v = bsxfun(@minus,X,m(j,:));
      A(:,j) = -1/2*log(det(2*pi*Ca(:,:,j))) ...
        - 1/2*sum((v/(Ca(:,:,j)+10^-3)).*v,2) + log(w(j));
    end
  else
    for j=1:k
      v = bsxfun(@minus,X,m(j,:));
      A(:,j) = sum(bsxfun(@minus,-1/2*log(2*pi*Ca(j,:)), ...
        bsxfun(@rdivide,v.^2,2*Ca(j,:)+10^-3)),2) ...
        + log(w(j));
    end
  end
  As = logsum(A,2);
  p = exp(bsxfun(@minus,A,As)); % Nxk posteriors
  
  % -- M step --
  ps = sum(p,1) + eps;
  m = bsxfun(@rdivide,p'*X,ps');
  if Cv
    for j=1:k
      Xm = bsxfun(@minus,X,m(j,:));
      Ca(:,:,j) = bsxfun(@times,p(:,j),Xm)'*Xm/ps(j);
    end
  else
    for j=1:k
      Ca(j,:) = p(:,j)'*bsxfun(@minus,X,m(j,:)).^2/ps(j);
    end
  end
  w = ps/N;
  
  % -- save means, covars, posteriors --
  M{i} = m;
  if Cv
    C{i} = Ca;
  else
    C{i} = zeros(d,d,k);
    for j=1:k
      C{i}(:,:,j) = diag(Ca(j,:));
    end
  end
  P{i} = p;
  
  % -- convergence --
  ll = sum(As);
  if abs((ll-ll_old)/ll_old) < 10^-4
    break
  end
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% logsum

function y = logsum(x,d)
%% Log-sum-exp for sumation in the log domain
% function y = logsum(x,d)
%
% Inputs: x - matrix or vector
%         d - dimension to sum over
% Output: y - logsum output

m = max(x,[],d);
y = log(sum(exp(bsxfun(@minus,x,m)),d)) + m;
% visualise juggling dataset as an animation
%
% © Copyright Phil Tresadern, University of Oxford, 2006

clc; clear all; % close all; 
addpath('./toolbox');

% load data
datapath	= './data/';
dset = 'real_juggling'; load([datapath,dset,'.mat']); W = lr2W(W1,W2sync,0);

% number of frames
nframes = size(W,3);

% image dimensions in two views
ax = [0 320 0 240; 
			0 720 0 576];
		
% get 3D structure and calibrate
[intra,inter] = assign_cons(W);
[S,P,X,T,opt_data] = calib_minimal(W,intra,inter);
[S,P,X,L,Phi] = fix_lengths(S,P,X,inter);

% better aligned with axes
X(:,:) = getRx(-pi/2)*X(:,:);

% range of viewing angles
arng = linspace(135,-45,nframes);
erng = linspace(-25,-25,nframes);

% linewidth
lw = 1.5;

for f = 1:nframes
	figure(1);
	
	% original 2D data
	for i = 1:2
		subplot(2,2,i); hold off;
		plot(nan); hold on;
		Wf = W((2*i)-1:(2*i),:,f);
		
		p = [1,2,5,1];
		plot(Wf(1,p),Wf(2,p),'k-','Linewidth',lw); % body
		p = [2,3,4];
		plot(Wf(1,p),Wf(2,p),'r-','Linewidth',lw); % left arm
		p = [5,6,7];
		plot(Wf(1,p),Wf(2,p),'b-','Linewidth',lw); % right arm
		p = [8];
		plot(Wf(1,p),Wf(2,p),'ko','Linewidth',lw,'MarkerSize',15); % head
		p = [9];
		plot(Wf(1,p),Wf(2,p),'r.','MarkerSize',18); % red ball
		p = [10];
		plot(Wf(1,p),Wf(2,p),'g.','MarkerSize',18); % green ball
		p = [11];
		plot(Wf(1,p),Wf(2,p),'b.','MarkerSize',18); % blue ball
		
		title(sprintf('View %i',i));
		axis('equal','ij',ax(i,:));
	end

	subplot(2,1,2); hold off;
	plot(nan); hold on;
	
	Xf = X(:,:,f);
	p = [1,2,5,1];
	plot3(Xf(1,p),Xf(2,p),Xf(3,p),'k-','Linewidth',lw); % body
	p = [2,3,4];
	plot3(Xf(1,p),Xf(2,p),Xf(3,p),'r-','Linewidth',lw); % left arm
	p = [5,6,7];
	plot3(Xf(1,p),Xf(2,p),Xf(3,p),'b-','Linewidth',lw); % right arm
	p = [8];
	plot3(Xf(1,p),Xf(2,p),Xf(3,p),'ko','Linewidth',lw,'MarkerSize',15); % head
	p = [9];
	plot3(Xf(1,p),Xf(2,p),Xf(3,p),'r.','MarkerSize',18); % red ball
	p = [10];
	plot3(Xf(1,p),Xf(2,p),Xf(3,p),'g.','MarkerSize',18); % green ball
	p = [11];
	plot3(Xf(1,p),Xf(2,p),Xf(3,p),'b.','MarkerSize',18); % blue ball
		
	axis('equal','ij',3*[-1,1,-1,1,-1,1]);
	set(gca,'box','on');
	view(arng(f),erng(f));
	title('Reconstruction');
	
	drawnow;
end

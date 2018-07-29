% this script runs the calibration tools on several datasets and generates
% graphs of scale and joint angles. These correspond to Table 1 and 
% Figures 3, 7, 9 and 12 of Tresadern and Reid, IVC 2008
%
% © Copyright Phil Tresadern, University of Oxford, 2006

clc; clear all; close all; 
addpath('./toolbox');

% where to load/save data
datapath	= './data/';
	
% load data and copy joint locations to a single matrix
% uncomment one of these:
dset = 'synth_run'; load([datapath,dset,'.mat']); W = lr2W(W1(1:30,:),W2(1:30,:),0);
% dset = 'real_run'; load([datapath,dset,'.mat']); W = lr2W(W1,W2,0);
% dset = 'real_handstand'; load([datapath,dset,'.mat']); W = lr2W(W1,W2,0);
% dset = 'real_juggling'; load([datapath,dset,'.mat']); W = lr2W(W1,W2sync,0);

% define (and create if necessary) the folder for figures
figpath		= ['./figs/',dset,'/'];
if ~exist(figpath,'dir')
	mkdir(figpath);
end


% input parameters
calib_fun = 'min'; % calibration function: lieb or min
bundle_fun = 'affine'; % bundle adjustment: affine, persp or none

% output values
outdata	= struct(	'its1',-1,... % #iterations for 'local' optimization
									'time1',-1,... % time taken for 'local' optimization
									'its2',-1,... % #iterations for 'global' optimization
									'time2',-1,... % time taken for 'global' optimization
									'its3',-1,... % #iterations for bundle adjustment
									'time3',-1,... % time taken for bundle adjustment
									'totaltime',-1,... % total time taken without bundle adj.
									'rms',-1,... % reprojection error
									'jointrms',-1,... % error in joint angles
									'limberr',-1,... % error in limb lengths
									'psi',-1,... % error in camera rotation axes
									'omegaerr',-1,... % error in camera rotation angles
									'converged',0); % whether the method converged

nframes	= size(W,3);
npoints	= size(W,2);
it	= 1;

rand('state',sum(100*clock));
t0 	= clock;

% assign intra-frame (i.e. symmetry) and inter-frame (i.e. rigidity)
% constraints
[intra,inter] = assign_cons(W);

if (exist('Xgt'))
	Xgt = Xgt(:,:,1:nframes);
	
	% add additional constraints from body centre to hip joints
	if (size(W,2)==14)
		inter	= [inter; 1 8; 1 11];
	end
	
	% compute median lengths over all frames
	Lgt	= median(get_lengths(Xgt,inter),1);
	
	% normalize so that LHip-RHip segment has unit length
	Xgt	= Xgt / Lgt(1);
	Lgt	= Lgt / Lgt(1);
	
	% compute poses, given ground truth structure
	Pgt	= compute_poses(Xgt,inter);
end

% Recover structure and motion using either:
% Liebowitz & Carlsson's parameterisation ('lieb') or 
% Tresadern and Reid's minimal parameterisation ('min')
switch lower(calib_fun)
	case{'lieb'},	[S,P,X,T,data] = calib_lieb(W,intra,inter);
	case{'min'},	[S,P,X,T,data] = calib_minimal(W,intra,inter);
end

s1 = S(1,1,:); % recovered image scaling in view 1
s2 = S(3,3,:); % recovered image scaling in view 2

% plot recovered scales
graph(1); clf; hold on;
	plot(s1(:),'r-.');
	plot(s2(:),'b-');
	axis([1,nframes,min([s1(:);s2(:)])-0.1,max([s1(:);s2(:)])+0.1]);
	xlabel('Frame');
	ylabel('Recovered scale');
	legend('view 1','view 2','location','southeast');
	set(gca,'box','on');
	exportfig([figpath,'scales']);

% reconstruct estimated point positions from affine projections of
% estimated 3D structure
Wnew	= zeros(4,npoints,nframes);
Tmat	= T(:,ones(1,npoints));
for f = 1:nframes
	Wnew(:,:,f) = (S(:,:,f)*P*X(:,:,f)) + Tmat;
end

% compute residual and RMS error
Res	= Wnew(:) - W(:);
RMS	= sqrt( (Res'*Res)/(length(Res)/2) );
fprintf('RMS error (variable lengths): %g\n\n',RMS);

% take a copy of performance statistics
outdata(it).its1 = data(1);
outdata(it).time1 = data(2);
outdata(it).its2 = data(3);
outdata(it).time2 = data(4);
outdata(it).converged = data(5);


% If we didn't add these constraints before, do it now
if ~exist('Xgt','var') && (size(W,2)==14)
	inter		= [inter; 1 8; 1 11];
end

% this bit is a 'hack' to resolve the affine ambiguity by hand
% it just means the results make more sense
P(:,3)	= -P(:,3);
X(3,:)	= -X(3,:);

% get the median length of the limbs from the estimated structure
L	= median(get_lengths(X,inter));

% rescale so that first limb in 'inter' has unit length and adjust other
% parameters accordingly
S	= S * L(1);
X	= X / L(1);
L	= L / L(1);

% estimate joint angles from the computed structure
Phi		= real(compute_poses(X,inter));

% reconstruct the 3D joint locations with fixed limb lengths and estimated
% joint angles
Xnew	= reconstruct(L,Phi);

% compute image projections of joint centres using fixed-length skeleton
Wnew	= zeros(4,npoints,nframes);
for f = 1:nframes
	Wnew(:,:,f)	= S(:,:,f)*P*Xnew(:,:,f);
end
Wnew(:,:)	= Wnew(:,:) + T(:,ones(size(Wnew(1,:))));

% reprojection error as a result of using a fixed-length skeleton
Res	= Wnew(:) - W(:);
RMS	= sqrt( (Res'*Res)/(length(Res)/2) );
fprintf('RMS error (fixed lengths): %g\n\n',RMS);
outdata(it).rms = RMS;

if exist('Xgt')
	% compute camera orientation error
	[phir,omegar] = compute_cam_errors(P(3:4,:));

	% compute relative limb length error
	Lerr	= abs(100*(L-Lgt) ./ Lgt);

	% compute joint angle error
	% only fixed axis joints (eg. elbows and knees) are well-defined so we
	% ignore others
	ResMat	= Pgt([19,23,27,31],:) - Phi([19,23,27,31],:);
	Res			= ResMat(:);
	RMS			= sqrt( (Res'*Res)/length(Res) );
	fprintf('Joint RMS error : %g rad\n\n',RMS);

	% store performance statistics
	outdata(it).jointrms = RMS;
	outdata(it).limberr = mean(Lerr(2:end)); % ignore normalized length (elem. 1)
	outdata(it).psi = phir;
	outdata(it).omegaerr = omegar;
end

clear Pb;

% Bundle adjustment
switch (lower(bundle_fun))
	case{'persp'},
		% compute perspective projection matrix of first camera
		C1	= mycamcald([Xnew(:,:);W(1:2,:)]');
		[K1,R1,t1]	= getcparams(C1);

		% if the translation is negative then adjust for affine ambiguity and
		% solve again
		if (t1(3) < 0)
			P(:,3)		= -P(:,3);
			Xnew(3,:) = -Xnew(3,:);

			C1	= mycamcald([Xnew(:,:);W(1:2,:)]');
			[K1,R1,t1]	= getcparams(C1);
		end

		% transform structure so that first camera is aligned with global frame
		Xnew(:,:)	= R1*Xnew(:,:) + t1*ones(size(X(1,:)));

		% get camera matrix that best generates second view data from known
		% structure
		C2	= mycamcald([Xnew(:,:);W(3:4,:)]');

		% get parameters of second camera
		[K2,R2,t2] = getcparams(C2);

		% re-estimate joint angles
		Phi	= compute_poses(Xnew,inter);
		
		% do bundle adjustment with perspective cost function
		[P1,P2,Lb,Phib,data] = bundle_persp(K1,K2,R2,t2,L,Phi,W,inter);
		
		% get rotation matrix of camera 2
		[K,Pb]	= getcparams(P2);
		Pb			= Pb(1:2,:);

	case{'affine'},
		% do bundle adjustment with affine cost function
		[Sb,Pb,Tb,Lb,Phib,data] = bundle_affine(S,P,T,L,Phi,W);

		% get rotation & translation of camera 2
		Pb	= Pb(3:4,:);

	otherwise, % e.g. 'none'
		outdata(it).totaltime = etime(clock,t0);
		fprintf('Total time : %g sec\n\n',outdata(it).totaltime);
end

if exist('Pb','var')
	% store performance statistics
	outdata(it).its3 = data(1);
	outdata(it).time3 = data(2);
	outdata(it).rms = data(3);

	if (exist('Xgt'))
		% compute camera orientation error
		[phir,omegar] = compute_cam_errors(Pb);

		% compute limb length error
		Lerr	= abs(100*(Lb-Lgt) ./ Lgt);
		fprintf('Mean rel. limb length error : %g%%\n',mean(Lerr(2:end)))

		% compute joint angle error
		ResMat	= Pgt([19,23,27,31],:) - Phib([19,23,27,31],:);
		Res			= ResMat(:);
		RMS			= sqrt( (Res'*Res)/length(Res) );
		fprintf('Joint RMS error : %g rad\n\n',RMS);

		outdata(it).psi = phir;
		outdata(it).omegaerr = omegar;
		outdata(it).limberr = mean(Lerr(2:end));
		outdata(it).jointrms = RMS;
	end

	outdata(it).totaltime = etime(clock,t0);
	fprintf('Total time : %g sec\n\n',outdata(it).totaltime);
end

% get joint angles
switch size(W,2)
	case 14, % full body
		% get knee angles from estimated pose
		jointangles	= Phi(13:end,:);
		j1	= jointangles(15,:) * 180/pi;
		j2	= jointangles(19,:) * 180/pi;

	case 11, % full body
		% get elbow angles from estimated pose
		jointangles	= real(Phi(22:end,:));
		j1	= jointangles(4,:) * 180/pi;
		j2	= jointangles(8,:) * 180/pi;
		
	otherwise, % dunno
		error('Unknown body model');
end

% plot joint angles
graph(2); clf; hold on;
	plot(j1(:),'r-.');
	plot(j2(:),'b-');
	axis([1,nframes,min([j1(:);j2(:)])-10,max([j1(:);j2(:)])+10]);
	xlabel('Frame');
	ylabel('Recovered joint angle (degrees)');
	legend('left','right','location','northwest');
	set(gca,'box','on');
	exportfig([figpath,'jointangles']);
	
% display performance measures 
% (Table 1 of Tresadern and Reid, IVC 2008)
outdata
	
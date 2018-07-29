function f = WPSNR(A,B,varargin)

% This function computes WPSNR (weighted peak signal-to-noise ratio) between
% two images. The answer is in decibels (dB).
%
% Using contrast sensitivity function (CSF) to weight spatial frequency
% of error image.
%
% Using: 	WPSNR(A,B)
%
% 

	if A == B
   	error('Images are identical: PSNR has infinite value')
	end

	max2_A = max(max(A));
	max2_B = max(max(B));
	min2_A = min(min(A));
	min2_B = min(min(B));

	if max2_A > 1 | max2_B > 1 | min2_A < 0 | min2_B < 0
   	error('input matrices must have values in the interval [0,1]')
	end

	e = A - B;
	if nargin<3
		fc = csf;	% filter coefficients of CSF
	else
		fc = varargin{1};
	end
	ew = filter2(fc, e);		% filtering error with CSF
	
	decibels = 20*log10(1/(sqrt(mean(mean(ew.^2)))));
%	disp(sprintf('WPSNR = +%5.2f dB',decibels))
	f=decibels;

%=============
function fc = csf()
%=============
% Program to compute CSF
% Compute contrast sensitivity function of HVS
%
% Output:	fc	---	filter coefficients of CSF
%
% Reference:
%	Makoto Miyahara
%	"Objective Picture Quality Scale (PQS) for Image Coding"
%	IEEE Trans. on Comm., Vol 46, No.9, 1998.
%
% 
	% compute frequency response matrix
	Fmat = csfmat;

	% Plot frequency response
	%mesh(Fmat); pause

	% compute 2-D filter coefficient using FSAMP2
	fc = fsamp2(Fmat);   
	%mesh(fc)


%========================
function Sa = csffun(u,v)
%========================
% Contrast Sensitivity Function in spatial frequency
% This file compute the spatial frequency weighting of errors
%
% Reference:
%	Makoto Miyahara
%	"Objective Picture Quality Scale (PQS) for Image Coding"
%	IEEE Trans. on Comm., Vol 46, No.9, 1998.
%
% Input :  	u --- horizontal spatial frequencies
%		v --- vertical spatial frequencies
%		
% Output:	frequency response
%
% Written by Ruizhen Liu, http://www.assuredigit.com

	% Compute Sa -- spatial frequency response
	%syms S w sigma f u v
	sigma = 2;
	f = sqrt(u.*u+v.*v);
	w = 2*pi*f/60;
	Sw = 1.5*exp(-sigma^2*w^2/2)-exp(-2*sigma^2*w^2/2);

	% Modification in High frequency
	sita = atan(v./(u+eps));
	bita = 8;
	f0 = 11.13;
	w0 = 2*pi*f0/60;
	Ow = ( 1 + exp(bita*(w-w0)) * (cos(2*sita))^4) / (1+exp(bita*(w-w0)));

	% Compute final response
	Sa = Sw * Ow;


%===================
function Fmat = csfmat()
%===================
% Compute CSF frequency response matrix
% Employ function csf.m
% frequency range
% the rang of frequency seems to be:
% 		w = pi = (2*pi*f)/60
%		f = 60*w / (2*pi),	about 21.2
%
	min_f = -20;
	max_f = 20;
	step_f = 1;
	u = min_f:step_f:max_f; 
	v = min_f:step_f:max_f;
	n = length(u);
	Z = zeros(n);
	for i=1:n
		for j=1:n
			Z(i,j)=csffun(u(i),v(j));	% calling function csffun
		end
	end
	Fmat = Z;




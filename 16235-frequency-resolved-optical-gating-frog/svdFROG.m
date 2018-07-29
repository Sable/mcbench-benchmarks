function [Pt, Gt, Fr, eps, iter] = svdFROG(F, seed, EPSTol, iterMAX, constr, mov)
%svdFROG: reconstructs a pulse and gate function (in time) from a FROG
%   trace by use of the SVD algorithm.
%
%Usage:
%
%   [Pt, Gt, Fr, eps, iter] = svdFROG(F, seed, EPSTol, iterMAX, constr, mov)
%
%       Pt      =   Reconstructed pulse field (in time).
%       Gt      =   Reconstructed gate field (in time).
%       Fr      =   reconstructed FROG trace.
%       eps     =   Final error
%       iter    =   Number of iterations to convergence
%
%       F       =   Experimental / Simulated FROG Trace
%		seed	=	(Optional) Initial guess (either Pt or [Pt Gt] in column format)
%       EPSTol  =   (Optioanl) Tolerence on the error (default = 1e-5).
%       iterMAX =   Maximum number of iterations allowed (default = +inf)
%		constr	=	Matlab command which imposes constraints on Pt/Gt
%		mov		=	Output movie if true
%
%       EPS = sqrt[ (N^-2) * sum( sum{ [Fr - F].^2 } ) ] <= EPSTol
%
%	See also SVDEXFROG, SVD, MAKEFROG



%   ------------------------------------------------------------
%   Get trace dimensions
N = size(F, 1);

chi2 = @(F_recon, F_meas) sqrt(sum(sum((F_recon-F_meas).^2)))/N;
normalise = @(M) M/sum(sum(abs(M)));

if (~exist('constr', 'var')||isempty(constr))
	constr = '';
end

%   Set maximum number of iterations
if (~exist('iterMAX', 'var')||isempty(iterMAX))
    iterMAX = inf;
end

%   Set convergence limit
if (~exist('EPSTol', 'var')||isempty(EPSTol))
    EPSTol = 1e-5;
end

%   Show movie during convergence?
if (~exist('mov', 'var')||isempty(mov))
    mov = 0;
end

%	User defined seed?
if (~exist('seed', 'var')||isempty(seed))
	%   Generate initial guess of gate and pulse from noise times a gaussian
	%   envelope function
	Pt = exp(-2*log(2)*(((0:N-1)'-N/4)/(N/10)).^2).*(1+.2*rand(N,1));
	Gt = exp(-2*log(2)*(((0:N-1)'-N/4)/(N/10)).^2).*(1+.2*rand(N,1));
else
    if (size(seed, 2)==1)
		Pt = seed;
		Gt = seed;
	else
		Pt = seed(:,1);
		Gt = seed(:,2);
	end
end

% if issame(constr,[])
% 	constr = '';
% end
% 
% if iterMAX==[]
% 	iterMAX = inf;
% end
% 
% if EPSTol==[]
% 	EPSTol = 1e-5;
% end

%   Normalise FROG trace to unity intensity
F = normalise(F);

%   Generate FROG trace
[Fr, Ew] = makeFROG(Pt, Gt);
Fr = normalise(Fr);

%   Find chi^2 error
eps = chi2(F, Fr);
iter = 0;

if mov
	subplot(2,2,1)
	imagesc(F);
	title('Original FROG trace');
	xlabel('Delay /pxls');
	ylabel('Spectrum /pxls');
	subplot(2,2,2)
	imagesc(Fr);
	title(['Reconstructed FROG trace: iter = ' num2str(iter)]);
	xlabel('Delay /pxls');
	ylabel('Spectrum /pxls');
	subplot(2,1,2)
	plot((0:N-1)', abs([Pt Gt]));
	title('Reconstructed pulse and gate fields');
	xlabel('Time /pxls');
	ylabel('Intensity /arb.');
	getframe;
end

%   ------------------------------------------------------------
%   F R O G   I T E R A T I O N   A L G O R I T H M
%   ------------------------------------------------------------
while ((eps>EPSTol)&(iter<iterMAX))
    iter = iter+1;                  %   keep count of no. of iterations
	if ~mov
		disp(['Iteration number: ' num2str(iter) '  Error: ' num2str(eps)]);
	end
    
    Fr(find(abs(Fr)==0)) = NaN;     %   Find any zero amplitudes
    Ew = Ew.*(sqrt(F./Fr));         %   Normalise amplitudes (keep phase information)
    Ew(find(isnan(Fr))) = 0;        %   Remove divide by zeros
    
    [Pt, Gt] = svdexFROG(Ew);       %   Extract pulse and gate fields from FROG complex amplitude
    
%     if PG                           %   Takes absolute value of Gt for PG FROG
%         Gt = abs(Gt);
%     end
    eval(constr);
	
    [Fr, Ew] = makeFROG(Pt, Gt);    %   Make a FROG trace from new fields
    Fr = normalise(Fr);
    
    eps = chi2(F, Fr);

	if mov
		subplot(2,2,2)
		imagesc(Fr);
		title(['Reconstructed FROG trace: iter = ' num2str(iter) '  Err = ' num2str(eps)]);
		xlabel('Delay /pxls');
		ylabel('Spectrum /pxls');
		subplot(2,1,2)
		plot((0:N-1)', abs([Pt Gt]));
		title('Reconstructed pulse and gate field absolute amplitudes');
		xlabel('Time /pxls');
		ylabel('Intensity /arb.');
		getframe;
	end
end
%   ------------------------------------------------------------
%   E N D   O F   A L G O R I T H M
%   ------------------------------------------------------------

%   Normalise to unity INTENSITY
Gt = normalise(Gt);
Pt = normalise(Pt);
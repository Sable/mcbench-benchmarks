function [ imOut ] = Segmentation_Continuum_TD( imIn, cls, bt, perc, kIni, optCls, Tol)
% Segmentation_Continuum_TD segmentates an image using the Continuum
% Topological Derivative algorithm. The main idea behind this algorithm is
% to compute the topological derivative for an appropriate functional
% and a perturbation given by changing the class that a particular
% pixel is segmented in from one class to another in the set cls. This derivative is used 
% as an indicator function to find the best class that each pixels should be 
% classified in (see references in 'references.txt' file).
% The associated parameters are:
% imIn = Image to be segmented.
% cls = The classes to segment the image, it might be either the number of
% classes or the classes itself.
% bt = (Optional) Scaling parameter for the cost function.
% perc = (Optional) Percentage of pixels to be reclassified in each
% iteration.
% kIni = (Optional) Conductivity for the non-perturbed problem.
% optCls = (Optional) true to optimize classes values.
% Tol = (Optional) A small values used to stop the algorithm
% 
% 
% LNCC - Laboratório Nacional de Computação Científica.
% Petrópolis, RJ, Brazil, March 2007.
% 
% Permission to use for evaluation purposes is granted provided that 
% proper acknowledgments are given. For a commercial licence, contact 
% nacho@lncc.br or feij@lncc.br.
% 
% This software comes with no warranty, expressed or implied. By way of
% example, but not limitation, we make no representations of warranties
% of merchantability or fitness for any particular purpose or that the
% use of the software components or documentation will not infringe any
% patents, copyrights, trademarks, or other rights.
% 
% The remaining files are copyright Ignacio Larrabide. Permission is
% granted to use the material for noncommercial and research purposes.
% 

    disp('Image segmentation based on the continuum topological derivative.');
% Total number of finite elements in the image. Mesh nodes are centered in
% the image pixels centers.
	[n,m] = size(imIn);
    imIn = double(imIn);
    if ~exist('cls')
        cls = 3;
    end
    mn = min(min(imIn));
    mx = max(max(imIn));
    if (mn - mx)==0
        error('Image has no information to be segmented!.');
    end
    if length(cls) == 1
        clsVals = mn:(mx-mn)/(cls-1):mx;
        cls = clsVals;
    end
    if ~exist('bt')
        bt = 0.3;
    end
    if ~exist('perc')
        perc = 0.5;
    end
    if ~exist('kIni')
        kIni = 1;
    end
    if ~exist('optCls')
        optCls = true;
    end
    if ~exist('Tol')
        Tol = 0.1;
    end
    if optCls
        clsOrg = cls;
    end
% Vector shaped input image.
    v = reshape(imIn, n*m,1);
% Initial guess of the segmented image.
    u = cls(1) * ones(n*m,1);
% Temporary solution.
	uTmp = u;
% As kIni could come from the Restoration_Continuum_TD algorithm, we check
% for its dimension.
% If it is a scalar, we create new diffusion coeficients for each element.
    if (max(size(kIni))==1)
        kElem = kIni * [ones(n*m,1), zeros(n*m,1), zeros(n*m,1), ones(n*m,1)];
	else
        kElem = kIni;
	end
    disp('Preparing linear system...');
% Symbolic elemental matrix.
	IEN = MountIEN(n, m);
% Obtain the global K matrix.
	KG = MountKG(n, m, IEN, kElem);
% Obtain the global M matrix.
	MG = MountMG(n, m, IEN);
    KDir = KG + MG;
% Compute the initial cost function value
    fi = uTmp * 0;
    xi = (fi + (uTmp-v));
    fctmp = ((MulKX(MG, xi)' * xi) + (MulKX(KG, fi)' * fi))/(n*m);
    fc = [Inf, fctmp];
    disp('done. Entering iterative process...');
% For the first iteration.
    minGT = -1;
	it = 1;
	while (abs(fc(it+1)-fc(it))>Tol || minGT < 0)
% Compute the forcing term.
        vu = bt * (v-u);
		f = MulKX(MG, vu);
% Solve the direct problem.	
		tol = 1e-8; maxiter = 100;
		fi = pcg(KDir, f, tol, maxiter);
% Solve the adjoint equation.
        lam = ((1-bt)/(bt)) * fi;
% Compute the topological derivative for each element.
		for i = 1:length(cls)
            DT(:,:,i) = reshape(1/2 * ((cls(i) - u) .* ((fi + u - v) + (fi + cls(i) - v) + 2 * bt * lam)), n, m);
		end
% Fixed point algorithm
		[GT, ind] = min(DT, [], 3);
        minGT = min(min(GT));
		[gradSort, jSort] = sort(reshape(GT, n*m, 1));
% Find the pixels that have negative dtopological derivative.
        j = find(gradSort<0);
		Nchange = round(length(j) * perc);
% Take the class that produced the smaller value for each pixel.
		uTmp(jSort(j(1:Nchange))) = cls(ind(jSort(j(1:Nchange))));
% Auxiliary variable
        xi = (fi + (uTmp-v));
% Compute the cost function value.
        fctmp = ((MulKX(MG, xi)' * xi) + (MulKX(KG, fi)' * fi))/(n*m);
        fc = [fc, fctmp];
% Optimize the classes values?
        if optCls
            [ cls , uTmp] = AdjustClassesValues( cls, uTmp, v, fi, MG, KG);
        end
% Update the result.
        u = uTmp;
        if ~mod(it,5)
            disp(sprintf('Currently at iteration %d.',it));
        end
        it = it + 1;
	end
    imOut = uint8(reshape(u,n,m));
    disp(sprintf('Done in %d iterations.',it - 1));
    if optCls
        disp('Class values optimization was used, initial classes values:');
        disp(clsOrg);
        disp('Optimized values');
        disp(cls);
    end

function [ cn , un] = AdjustClassesValues( co, us, v, fi, MG, KG)
% AdjustClassesValues Adjust classes values in each iteration.
    cn = [];
    for c = co
        fcvd = inf; fcvi = inf;    
        xi = (fi + (us - v));
        fcvo = (MulKX(MG, xi)' * xi) + (MulKX(KG, fi)' * fi);
        cl =  min(min(us));
        if c > min(min(us))-1
            cl =  c - 1;
            tmp = us;
            I = find(tmp==c);
            tmp(I) = cl;
            xi = (fi + (tmp - v));
            fcvd = (MulKX(MG, xi)' * xi) + (MulKX(KG, fi)' * fi);
        end
        ci =  max(max(us));
        if c < max(max(us))+1
            ci =  c + 1;
            tmp = us;
            I = find(tmp==c);
            tmp(I) = ci;
            xi = (fi + (tmp - v));
            fcvi = (MulKX(MG, xi)' * xi) + (MulKX(KG, fi)' * fi);
        end
        
        fct   = [fcvd, fcvo, fcvi];
        ct    = [  cl,    c,   ci];
        [m,i] = min(fct);        
        cn    = [cn ct(i)];
    end
% Substitute the new classes values in the segmented image.
    un = us;
    for i= 1:length(co)
        I = find (us==co(i));
        un(I) = cn(i);
    end

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 SOME SIMPLE FEM TOOLS                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ K ] = MountKG( n, m, IEN, kElem)
    nel = (n-1)*(m-1);
	K = sparse(n*m,n*m);
	for i=1:nel
        Kel = MountKel(kElem(i,:));
        K(IEN(i,:),IEN(i,:)) = K(IEN(i,:),IEN(i,:)) + Kel;
	end
    
function [ kel ] = MountKel( c )
	c11 = c(1); c12 = c(2);	c21 = c(3);	c22 = c(4);
    k1 = (1/12) * (4 * c11 + 3 * c12 + 3 * c21 + 4 * c22);
	k2 = (1/12) * (2 * c11 - 3 * c12 + 3 * c21 - 4 * c22);
	k3 = (1/12) * (-2* c11 - 3 * c12 - 3 * c21 - 2 * c22);
	k4 = (1/12) * (-4* c11 + 3 * c12 - 3 * c21 + 2 * c22);
    kel = [k1, k2, k3, k4;
           k2, k1, k4, k3;
           k3, k4, k1, k2;
           k4, k3, k2, k1];

function [ M ] = MountMG( n, m, IEN)
	Mel = [1/9,1/18,1/36,1/18;
           1/18,1/9,1/18,1/36;
           1/36,1/18,1/9,1/18;
           1/18,1/36,1/18,1/9];
    nel = (n-1)*(m-1);
	M = sparse(n*m, n*m);
	for i=1:nel
        M(IEN(i,:),IEN(i,:)) = M(IEN(i,:),IEN(i,:)) + Mel;
	end
    
function IEN = MountIEN(n, m)
	IEN = zeros((m-1)*(n-1),4);
	for i=1:m-1
        for j=1:n-1
            IENaux = [idx(j+1,i+1,n),idx(j+1,i,n),idx(j,i,n),idx(j,i+1,n)];
            nel = (n-1)*(i-1)+j;
            IEN(nel,:) = IENaux;
        end
	end

function uxy = Grad(IEN,u)
	for i = 1:size(IEN, 1)
        uloc = u(IEN(i,:));
        uxy(1,i) = ((uloc(2)-uloc(1))+(uloc(3)-uloc(4)))/2;
        uxy(2,i) = ((uloc(4)-uloc(1))+(uloc(3)-uloc(2)))/2;
	end

function id = idx(j,i,n)
    id = n*(i-1) + j;
    
function [ Ku ] = MulKX( K, u )
    Ku = K * u;    
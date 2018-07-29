%vectorsM_demo
%Demo for vector processing with partial prediction

%S. de Waele, March 2003.

clear
close all

%-----------------------------------------------------------------------
%Choice of process
%-----------------------------------------------------------------------
disp('Processes')
disp('=========')
disp('1)  x1:AR(5); x2:rel. to x1; x3:AR(1)')
disp('2)  Marple')
selection = input('Select process: ');

nobs0  = 1000; Lmax0 = 100;
nspec = 200;
ncov = nobs0;
simux = 1;
valid_choice = 1;
switch selection
    case 1
        disp('Selected: x1:AR(5); x2:rel. to x1; x3:AR(1)')
        order = 5;
        dim = 3; I = eye(dim);
        R0 = I;
        pc = zeros(dim,dim,order+1); p.pc(:,:,1) = I;
        pc(1,1,:) = [1 -.3 -.3 .1 .2 .5];
        pc(2,1,5) = 0.8;
        pc(3,3,1:2) = [1 -.7];
        n_obs = nobs0;   
        fext = ['WN' int2str(dim) 'd'];
        Lmax = Lmax0;
        % Some options for M:
        % M = [0 1 0];
        % M = [1 0 0; 0 1 0];
        M = [0 0 1]; 

        a = [1 0 0];
        b = [0 0 1];
     case 2
        disp('Selected: Marple')
        order = 1;
        dim = 2; I = eye(dim);
        par = zeros(dim,dim,order+1); par(:,:,1) = I;
        par(:,:,2) = [-.85  .75;
                      -.65 -.55]; %Marple, p. 409, (15.119)
        Peps = I;
        [pc Pf] = par2pcv(par,[],Peps);
        R0 = Pf(:,:,1)
        n_obs = nobs0;
        Lmax = Lmax0
        M = [0 1]; 
        a = [1 0];
        b = [0 1];
    otherwise
        disp('Invalid choice')
        valid_choice = 0;
end
if valid_choice==0
    error('Invalid process choice: Choose 1 or 2.')
end    
dimY = size(M,1);
M
disp(['Dimension of Y [vector to be predicted] = ' int2str(dimY)])

disp('Stationarity check:')
if ~isstatv(pc), disp('pc''s non-stationary'), break, end
disp('OK')
pt = length(pc)-1;

x = gendatav(pc,R0,n_obs);

%----------------------------------------------
%Estimation
%----------------------------------------------
[pcsel, R0hat, logres, cic, pchat, psel, fsic] = ARselv(x,Lmax,M);


%----------------------------------------------
%Results
%----------------------------------------------
[dummy, mes] = moderrv(pchat,R0hat,pc,R0,n_obs,M);

figure
me_th = dim*dimY*(0:Lmax);
cic_s = cic-cic(pt+1)+mes(pt+1); %CIC shifted; Does not influence selection result.
plot(0:Lmax,[mes' me_th' cic_s'])
legend('Model Error','Asympt. theory','CIC')
xx = axis;
xx(3) = 0; xx(4) = 2*mes(end);
axis(xx)
xlabel('order'); ylabel('ME'); title(['Error of AR estimates (true order = ' int2str(order) '), N=' int2str(n_obs) ', dim=' int2str(dim)])
psel
disp(['Model error selected model = ' num2str(mes(psel+1))])


%----------------------------------------------
%spectra
%----------------------------------------------
[h,f] = pc2specv(pc,R0,nspec);
hsel = pc2specv(pcsel,R0hat,nspec);
hm = pc2specv(pchat,R0hat,nspec);

figure
semilogy(f,real(traces(h)),'--',f,real([traces(hm) traces(hsel)]));
title('Power spectrum')
legend(['True = AR(' int2str(pt) ')'],['AR(' int2str(Lmax) ')'],['sel = AR(' int2str(psel) ')'])
xlabel('\nu')
ylabel('h')

%Autospectra and coherence
disp('a and b: scalar mappings of x of which the auto- and x-correlation are calculated:')
a,b
%Process
[fiab fs] = pc2cohv(pc,R0,a,b,nspec);
msc = abs(fiab).^2;
phase = angle(fiab)/2/pi*360; %in degrees
hab = pc2xspecv(pc,R0,a,b,nspec);
haa      = real(pc2xspecv(pc,R0,a,a,nspec));
hbb      = real(pc2xspecv(pc,R0,b,b,nspec));

%for the maximum order
[fiabm fs] = pc2cohv(pchat,R0hat,a,b,nspec);
mscm = abs(fiabm).^2;
phasem = angle(fiabm)/2/pi*360; %in degrees
habm = pc2xspecv(pchat,R0hat,a,b,nspec);
haam      = real(pc2xspecv(pchat,R0hat,a,a,nspec));
hbbm      = real(pc2xspecv(pchat,R0hat,b,b,nspec));

%for the selected order
fiabsel = pc2cohv(pcsel,R0hat,a,b,nspec);
mscsel = abs(fiabsel).^2;
phasesel = angle(fiabsel)/2/pi*360; %in degrees
habsel = pc2xspecv(pcsel,R0hat,a,b,nspec);
haasel      = real(pc2xspecv(pcsel,R0hat,a,a,nspec));
hbbsel      = real(pc2xspecv(pcsel,R0hat,b,b,nspec));

figure
	subplot(221)
	semilogy(fs,haa,'--',fs,[haam haasel])
	axis tight	
	xlabel('n','Fontname','Symbol');
	ylabel('f_a','Rotation',0)

	subplot(222)
	semilogy(fs,hbb,'--',fs,[hbbm hbbsel])
	axis tight	
	xlabel('n','Fontname','Symbol');
	ylabel('f_b','Rotation',0)

	subplot(223)
	plot(fs,msc,'--',fs,[mscm mscsel])
	xlabel('n','Fontname','Symbol');
	ylabel('MSC')
	axis tight
	xx = axis;
	xx(3) = 0; xx(4) = 1;
	try, axis(xx), end
	
	subplot(224)
	plot(fs,phase,'--',fs,[phasem phasesel])
	xlabel('n','Fontname','Symbol');
	ylabel('Phase (degrees)')
	axis tight
	xx = axis;
	xx(3) = 90*floor(min([phasem; phasesel])/90);
	xx(4) = 90*ceil(max([phasem; phasesel])/90);
	try, axis(xx), end
title('Estimates: max and selected order')

%Auto- and x-correlation
[dummy xcov] = pc2xcovv(pc,R0,a,b,ncov);
[dummy xcovm] = pc2xcovv(pchat,R0hat,a,b,ncov);
[dummy xcovsel] = pc2xcovv(pcsel,R0hat,a,b,ncov);

figure
plot(-ncov:ncov,xcov,'--',-ncov:ncov,[xcovm xcovsel])
legend(['True = AR(' int2str(pt) ')'],['AR(' int2str(Lmax) ')'],['sel = AR(' int2str(psel) ')'])
title('cross-covariance')
zoom on
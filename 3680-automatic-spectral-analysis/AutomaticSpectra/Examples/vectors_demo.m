%vectors_demo

%S. de Waele, March 2003.

clear
close all

%-----------------------------------------------------------------------
%Choice of process
%-----------------------------------------------------------------------
signalopt = {'Marple' 'AR(1)' 'white noise' 'only autocorrelation'};
disp('Processes')
disp('=========')
for t = 1:length(signalopt)
    disp([int2str(t) ') ' signalopt{t}])
end
selection = input('Select process: ');
signal = signalopt{selection};

nobs0  = 400; Lmax0 = 100;
nspec = 200;
ncov = nobs0;
simux = 1;
switch signal
    case 'Marple'
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

        case 'AR(1)'
        order = 1;
        dim = 2; I = eye(dim);
        R0 = I;
        pc = zeros(dim,dim,order+1); p.pc(:,:,1) = I;
        pc(:,:,2) = [	0	.8
            0	.5 ];
        n_obs = nobs0;
        fext = 'AR(1)';
        Lmax = Lmax0;
        
    case 'white noise'
        order = 0;
        dim = 2; I = eye(dim);
        R0 = I;
        pc = zeros(dim,dim,order+1); p.pc(:,:,1) = I;
        n_obs = nobs0;   
        fext = ['WN' int2str(dim) 'd'];
        Lmax = Lmax0;
        
    case 'only autocorrelation'
        order = 2;
        dim = 2; I = eye(dim);
        R0 = I;
        pc = zeros(dim,dim,order+1); p.pc(:,:,1) = I;
        h = -.9
        pc(:,:,2) = [	0	0
            0	h];
        pc(:,:,3) = [	0	0
            0	h];
        n_obs = nobs0;
        fext = 'autocor'   ;
        Lmax = Lmax0;
end

disp('Stationarity check:')
if ~isstatv(pc), disp('pc''s non-stationary'), break, end
disp('OK')
pt = length(pc)-1;

x = gendatav(pc,R0,n_obs);

%----------------------------------------------
%Estimation
%----------------------------------------------
[pcsel, R0hat, logres, cic, pchat, psel, fsic] = ARselv(x,Lmax);


%----------------------------------------------
%Results
%----------------------------------------------
[dummy, mes] = moderrv(pchat,R0hat,pc,R0,n_obs);
[dummy, klds] = KLDiscrepancyv(pchat,R0hat,pc,R0,n_obs);

figure
me_th = dim^2*(0:Lmax);
cic_s = cic-cic(pt+1)+mes(pt+1); %CIC shifted; Does not influence selection result.
plot(0:Lmax,[mes' klds' me_th' cic_s'])
legend('Model Error','KLDiscrepancy','Asympt. theory','CIC')
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
a = zeros(1,dim); b = zeros(1,dim);
a(1) = 1
b(2) = 1

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
% m-file which generates data from a simple system with a localized
% nonlinearity and processes it using RLM's zeroing algorithm.
%
% Matt Allen, June 27, 2005
% MSA: Major Update - Nov, 2005 - changed to two arbitrary subsystems.
% 
clear all; close all;

% Set up system parameters
% m1 = 1; m2 = 1; m3 = 1; m4 = 1; m5 = 1;
    M1 = eye(5);
    M2 = 0.1*eye(2); % Subsystem is about 10% the weight of normal system.
    
    kall = 1e6;
    k1 = kall; k2 = kall; k3 = kall; k4 = kall; k5 = kall; k6 = kall; kat = kall;
    K1 = [k1, -k1, 0, 0, 0; % System 1
        -k1, k1+k2, -k2, 0, 0
        0, -k2, k2+k3, -k3, 0;
        0, 0, -k3, k3+k4, -k4;
        0, 0, 0, -k4, k4];
    Ns1 = 5; Ns2 = 2; Ntot = 7;
    K2 = [k5, -k5; % System 2 - attached subsystem - dof's
        -k5, k5];
    Mtot = [M1, zeros(size(M1,1),size(M2,2));
        zeros(size(M2,1),size(M1,2)), M2];
    Ktot = [K1, zeros(size(K1,1),size(K2,2));
        zeros(size(K2,1),size(K1,2)), K2];
    % Specify how systems are connected
    at_ns = [2,6]; % attachment happens between this pair of nodes.
    fext_ns = 5; % Node at which external force is applied
    fnl_vec = zeros(Ntot,1); fnl_vec(at_ns(1)) = -1; fnl_vec(at_ns(2)) = 1;
    fext_vec = zeros(Ntot,1); fext_vec(fext_ns(1)) = 1;
    dnodes = [1:Ntot];
    vnodes = [(Ntot+1):(Ntot*2)];
    
    % Damping Matrix    
    cfactk = 0.00003; % multiplied by K to get damping.
    cfactm = 8; % Multiplied by M to get damping
    % for k = 1:5; eval(['c',num2str(k),' = cfact*k',num2str(k),';']); end
    C1 = cfactk*K1 + cfactm*M1;
    C2 = cfactk*K2 + cfactm*M2; % proportional damping
    Ctot = [C1, zeros(size(C1,1),size(C2,2));
        zeros(size(C2,1),size(C1,2)), C2];
    
    % Linearized System Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % add a linear spring between attachment nodes
        Mlin = Mtot;
        Klin = Ktot;
        Klin(at_ns,at_ns) = Klin(at_ns,at_ns) + kat*[1, -1; -1, 1];
        % Linear Damping matrix:
        Clin = Ctot;
        Clin(at_ns,at_ns) = Clin(at_ns,at_ns) + cfactk*kat*[1, -1; -1, 1];

    % State Space Eigenanalysis
    Slin = [Clin, Mlin; Mlin, zeros(size(Mlin))];
    Rlin = [-Klin, zeros(size(Mlin));
        zeros(size(Mlin)), Mlin];
    Alin = (Slin\Rlin);
    [Philin,lamlin] = eig(Alin);
    lamlin = diag(lamlin);
    [junk,sind] = sort(abs(lamlin) - 0.001*min(abs(lamlin))*(imag(lamlin) > 0));
    lamlin = lamlin(sind);
    Philin = Philin(:,sind);

%         % Plot Mode Shapes
%         figure(1)
%         hls = plot([1:Ntot], imag(Philin(1:Ntot,1:2:end ))); grid on;
%         legend(hls, num2str([1:Ntot].'));
%         xlabel('X-coordinate');
%         ylabel('Im\{Mode Shape\}');

    wns = abs(lamlin);
    fns = wns/2/pi;
    zts = -real(lamlin)./abs(lamlin);
    disp('Natural Frequencies:, Damping Ratios:');
    [fns, zts]
%     DispFnZt(lamlin) - replace 2 lines abouve with this if you have the EMA Functions toolbox
    
    % Nonlinear Parameters
    NLType = 'bang'
    if strcmp(NLType,'bang');
        % Bang (Contact) Nonlinearity
        delcont = 1e-3;
        k4mult = 20; % Factor by which k4 increases: k4_contact = k4*k4mult
        c4mult = 1; % Factor by which c4 increases: c4_contact = c4*c4mult
    elseif strcmp(NLType,'cubic');
        % Cubic Spring
        katnl = 1e8;
    else
        error('NLType not recognized');
    end
    % Force paramters
        % length of half-sine force pulse
        % This is normalized in the EOM to unit area and multiplied by Afnl
        tfp = 1e-4;
        Afnl = 4e9;
        
    % Which Response to Use in evaluating Nonlinearity (i.e. x1, x2, x3..?)
    respind = 6;
    
    % Number of numerical derivatives to evaluate.  This M-file simulates
    % the displacement response of the 5-DOF system.  To simulate the
    % measurement of the velocity or acceleration response, the
    % displacement response is differentiated using finite differences
    % (i.e. Matlab's 'diff' command.)  This parameter sets the number of
    % derivatives to perform:
    nders = 2;
        % nders = 0; => use displacement
        % nders = 1; => use velocity
        % nders = 2; => use acceleration

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Put all of this in a structure for the EOM
global eom
S = whos;
for k = 1:length(S)
    eval(['eom.',S(k).name,' = ',S(k).name,';']);
end
    
    % Compute TF of Linearized System
    F = zeros(Ntot,1); F(fext_ns) = 1;
    wlin = [1:1:500]*2*pi;
    Halin = zeros(Ntot,length(wlin));
    for k = 1:length(wlin)
        Halin(:,k) = wlin(k).^2*([Mlin*-wlin(k).^2 + Clin*i*wlin(k) + Klin]\F);
    end
    Halin = Halin.';

%     figure(2)
%     semilogy(wlin/2/pi,abs(Halin)); grid on;
%     xlabel('Frequency (Hz)')
%     ylabel('H_{ACCEL}(\omega)');
%     for k = 1:Ntot; leg_txt{k} = ['H_{',num2str(k),',5}']; end
%     legend(leg_txt);

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nonlinear Simulation
% Compute sample rate and time
    elas_modes = find(imag(lamlin) > 0);
    dt = (5*2*max(fns(elas_modes)))^-1;
    Tmin = log(0.001)/(-min(abs(real(lamlin(elas_modes)))));
    N = 2^ceil(log2(Tmin/dt));
    
    ts = [0:dt:(N-1)*dt].';
    
% Specify initial time step so the solver doesn't miss the pulse:
    odeopts = odeset('InitialStep',tfp/10,'AbsTol',1e-9);
    
    % [ts_ode,hnl] = ode45(@nldetect_anex2_v1_eom,ts,zeros(10,1),odeopts,eom);
    
% Alternate Calling form:
sol = ode45(@nldt_bng_cub_v2_eom,[ts(1),ts(end)],zeros(Ntot*2,1),odeopts);
    [hnl, hnldot] = deval(sol,ts);
    hnl = hnl.';  hnldot = hnldot.';
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear Simulation
ltisys = ss(Alin,Slin\[F; zeros(Ntot,1)],[eye(Ntot), zeros(Ntot)], zeros(Ntot,1));
    
    % Use fine sample increment over duration of pulse
    if tfp < dt
        tlini = [0:100].'*tfp/100;
        ulini = (Afnl*2*tfp/pi)*sin((pi/tfp)*tlini);
        % Over Pulse duation to first sample
        [ylini,junki,xlini] = lsim(ltisys, [ulini], [tlini], zeros(Ntot*2,1));
        [ylin, junk2, xlin2] = lsim(ltisys, zeros(2,1), [junki(end); ts(2)], xlini(end,:).');
        % Free Response
        [ylin, junk3, xlin3] = lsim(ltisys, zeros(size(ts(2:end))), ts(2:end), xlin2(end,:).');
        hlin = [xlini(1,:); xlin2(end,:); xlin3(2:end,:)];
    else
        error('tfp > dt not yet supported!');
    end
    
% Plot Results
figure(10); set(gcf,'Position',[532   189   560   567]);
subplot(2,1,1)
plot(ts, hlin(:,respind), ts, hnl(:,respind), 'o-',sol.x, sol.y(respind,:), '.:'); grid on;
legend('h_{(r,5)} LIN','h_{(r,5)} NL','h_{(r,5)} ODE45');
xlabel('time (s)');
title('Comparison of Linear and Nonlinear Time Responses')

% Approximate derivatives of the response:
disp(['Number of Derivatives Requested: ',num2str(nders)]);
ndhlin = [zeros(nders,1); dt^-nders*diff(hlin(:,respind ),nders,1);];
ndhnl = [zeros(nders,1); dt^-nders*diff(hnl(:,respind ),nders,1); ];
%   Derivatives computed by "diff" don't appear to be ideal.  I don't know
%   that they are equivalent to a forward difference scheme.
% Select ODE45 derivatives - USE ODE45 Derivatives in the analysis!
if nders == 0;
    dhnlode = hnl(:,respind);
elseif nders == 1;
    dhnlode = hnl(:,respind + Ntot);
elseif nders == 2;
    dhnlode = hnldot(:,respind + Ntot);
end    
tsdh = ts;%ts((1+nders):end);
subplot(2,1,2)
plot(tsdh, ndhlin, tsdh, ndhnl, ts, dhnlode, '.'); grid on;
legend(['h_D_{(',num2str(respind),',5)} LIN'],['h_D_{(',num2str(respind),',5)} NL'],...
    ['h_D_{(',num2str(respind),',5)} NL-ODE45']);
xlabel('time (s)');
title('Comparison of Derivatives of Linear and Nonlinear Responses')

% Find Actual force curve:
% This must be modified manually
% Fnl2 = Mtot(at_ns(2),at_ns(2))*hnldot(:,Ntot+at_ns(2)) - k5*(hnl(:,at_ns(2)) - hnl(:,at_ns(2)+1));
Fnl2 = Mtot(at_ns(2),:)*(hnldot(:,vnodes).') + Ktot(at_ns(2),:)*(hnl(:,dnodes).');
    if abs(fext_vec(at_ns(1))) > 0; warning('Equation for Force may not be correct'); end
Fnl3 = - Mtot(at_ns(1),:)*(hnldot(:,vnodes).') - Ktot(at_ns(1),:)*(hnl(:,dnodes).');
    if abs(fext_vec(at_ns(1))) > 0; warning('Equation for Force may not be correct'); end
delt_nl = hnl(:,at_ns(1)) - hnl(:,at_ns(2));

% Track the magnitude of the displacement of spring 4 - for NL
figure(11); set(gcf, 'Units','Normalized'); set(gcf,'Position',[0.069444,  0.48444, 0.43819, 0.39111]);
    set(gcf,'Name','Force vs. Delta Curve','Toolbar','figure');
subplot(1,3,1)
deltas = [-100:100]*(max(delt_nl)/100);
if strcmp(NLType,'bang');
    for k = 1:length(deltas)
        if deltas(k) < eom.delcont % No Contact Occurs
            Fnl(k) = eom.kat*deltas(k);
        else                % Contact Occurs
            Fnl(k) = eom.kat*eom.k4mult*deltas(k);
        end
    end
elseif strcmp(NLType,'cubic');
    Fnl = kat*deltas.*(1+katnl.*deltas.^2);
end
plot(Fnl, deltas*1e3, ...
    k4*deltas, deltas*1e3, '--',...
    Fnl2,delt_nl*1e3,'.',...
    Fnl3,delt_nl*1e3,'k.'); grid on;
ax1h = gca;
ylabel('\bf\Delta - NL Spring (mm)'); xlabel('\bfSpring Force')
title('\bfSpring Curve');
hx = subplot(1,3,2:3)
plot(ts*1e3, delt_nl*1e3); grid on;
% Set Axes to Equal
    ylim2 = get(gca,'Ylim');
    set(ax1h,'Ylim',ylim2);
xlabel('\bftime (ms)'); ylabel('\bf\Delta - NL Spring (mm)');
title('\bfDisplacement of NL Spring');

% Add button to make y-axes equal
set(hx,'tag','Main');
    PointsPerPixel = 72/get(0,'ScreenPixelsPerInch');
    hf = gcf;
    h1 = uicontrol('Parent',hf, ...
        'Units','points', ...
        'Position',[168, 51, 45, 25]*PointsPerPixel, ...
        'Callback','set_equal_ylims(hf);', ...
        'String','EqYlim', ...
        'Tag','YAxEqual');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis

if strcmp(NLType,'bang');
    % ZNLDetect(hlin(:,respind),ts,[0,0.2],400)
    [Hmat,fs,ts_zc] = ZNLDetect(dhnlode,tsdh,[0,0.1],500);
    % ZNLDetectC(hnldot(:,6:10),tsdh,[0,0.3],30,400)
elseif strcmp(NLType,'cubic');
    [Hmat,fs,ts_zc] = ZNLDetect(dhnlode,tsdh,[0,0.15],500,4);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alternate analysis - use all sensors with ZNLDetectC
% This gives 20 ZEFFTs equally distributed between 0 and 0.1 s, 0 to 500 Hz
%
% [Hmat,fs,ts_zc] = ZNLDetectC(hnldot(:,8:end),tsdh,[0,0.1],500,20);

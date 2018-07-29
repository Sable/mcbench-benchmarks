global ZNLD

if ~isfield(ZNLD,'fline_ind') || ~isfield(ZNLD,'lam_fit');
    error('You must curve fit before computing the IBEND integral metric');
end

% Create curve fit models
for k = 1:length(ZNLD.ts_zc);
    % Find Linear System Propagated Backwards in Time
    Hfit(:,k) = ss_model(ZNLD.lam_fit,ZNLD.A_fit.*...
        exp(-ZNLD.lam_fit*(ZNLD.ts_zc(ZNLD.fline_ind) - ZNLD.ts_zc(k))),ZNLD.ws,'D');
end

% Ask user how far out in frequency to go
% fmax_str = inputdlg('Enter Maximum Frequency for Metric (Hz)',...
%     'Max. Freq.',1,{num2str(max(ZNLD.ws/2/pi))});
% band_ind = find(ZNLD.ws <= str2num(fmax_str{1})*2*pi);
fr_str = inputdlg({'Enter Minimum Frequency for Metric (Hz)',...
    'Maximum Frequency (Hz)'},'Freq. Range',1,...
    {num2str(0),num2str(max(ZNLD.ws/2/pi))});
band_ind = find(ZNLD.ws <= str2double(fr_str{2})*2*pi & ...
    ZNLD.ws >= str2double(fr_str{1})*2*pi);

dW = ZNLD.ws(2)-ZNLD.ws(1);
% Find Difference between Linear and Nonlinear
    HDiff = abs(ZNLD.Hmat(band_ind,:))-abs(Hfit(band_ind,:));
    IntHdata = trapz(ZNLD.ws(band_ind),abs(ZNLD.Hmat(band_ind,:)));
    IntHfit = trapz(ZNLD.ws(band_ind),abs(Hfit(band_ind,:)));
    % IntHD = dW*sum(abs(HDiff),1);%*(freq(2)-freq(1));
    % Change this to trapezoidal integration? - Shouldn't matter much!
    IntHD = trapz(ZNLD.ws(band_ind), abs(HDiff));
    IntHDn = IntHD./IntHdata;
    IntHDn_alt = IntHD./IntHfit;

figure(2000); set(gcf,'Name','Nonlinearity Metric');
    set(gcf,'Units', 'normalized', 'Position', [0.25,0.534,0.414,0.268])
hls(1) = plot(ZNLD.ts_zc*1e3,IntHDn,'-'); % ZNLD.ts_zc*1e3,IntHD2,'-.',
% Added for Pres
hold on; scatter(ZNLD.ts_zc*1e3,IntHDn,[],IntHDn,'filled'); colorbar;
hls(2) = plot(ZNLD.ts_zc(ZNLD.fline_ind)*1e3, IntHDn(ZNLD.fline_ind),'kd','MarkerSize',7);
hold off
% Previous difference curve
% ZNLD.ts_zc*1e3,dW*sum(abs(ZNLD.Hmat(band_ind,:)),1) - dW*sum(abs(Hfit(band_ind,:)),1),'-.'
title('\bfNormalized Integral of Difference FRF over Frequency');
xlabel('\bftime (ms)'); ylabel('\bfNormalized Integral');
legend(hls,'Integral','fit time');
set(hls,'LineWidth',2); grid on;

% figure(2002); set(gcf,'Name','Nonlinearity Metric');
%     set(gcf,'Units', 'normalized', 'Position', [0.25,0.534,0.414,0.268])
% hls(1) = plot(ZNLD.ts_zc*1e3,IntHDn_alt,'-'); % ZNLD.ts_zc*1e3,IntHD2,'-.',
% % Added for Pres
% hold on; scatter(ZNLD.ts_zc*1e3,IntHDn_alt,[],IntHDn_alt,'filled'); colorbar;
% hls(2) = plot(ZNLD.ts_zc(ZNLD.fline_ind)*1e3, IntHDn_alt(ZNLD.fline_ind),'kd','MarkerSize',7);
% hold off
% % Previous difference curve
% % ZNLD.ts_zc*1e3,dW*sum(abs(ZNLD.Hmat(band_ind,:)),1) - dW*sum(abs(Hfit(band_ind,:)),1),'-.'
% title('\bfNormalized Integral of Difference FRF over Frequency');
% xlabel('\bftime (ms)'); ylabel('\bfNormalized Integral');
% legend(hls,'Integral','fit time');
% set(hls,'LineWidth',2); grid on;


% figure(2003); set(gcf,'Name','Nonlinearity Metric');
%     set(gcf,'Units', 'pixels', 'Position', [220  778  560  320])
% hls = plot(ZNLD.ts_zc*1e3,IntHdata,...
%     ZNLD.ts_zc*1e3,dW*sum(abs(Hfit(band_ind,:)),1),'--',...
%     ZNLD.ts_zc*1e3,IntHD,'-.',... % ZNLD.ts_zc*1e3,IntHD2,'-.',
%      ZNLD.ts_zc(ZNLD.fline_ind)*1e3, IntHD(ZNLD.fline_ind),'ko');
% % Previous difference curve
% % ZNLD.ts_zc*1e3,dW*sum(abs(ZNLD.Hmat(band_ind,:)),1) - dW*sum(abs(Hfit(band_ind,:)),1),'-.'
% title('\bfIntegrals of Magnitude FRF over Frequency');
% xlabel('\bftime (ms)'); ylabel('\bfIntegral');
% legend('Measured','Fit','Difference','Fit Pt');
% set(hls,'LineWidth',2); grid on;


if 0;
    exportfig(2000,'Slip_IntMetric_norm.emf','Format','meta','height',2.5,'Width',4.5,'Color','cmyk',...
        'FontMode','scaled');
end

% Integral under curves on a log scale
IntHdataLog = trapz(ZNLD.ws(band_ind), 20*log10(abs(ZNLD.Hmat(band_ind,:))));
% IntHfitLog = trapz(ZNLD.ws(band_ind), 20*log10(abs(Hfit(band_ind,:))));
IntDiffLog = trapz(ZNLD.ws(band_ind), abs(20*log10(abs(ZNLD.Hmat(band_ind,:))) - 20*log10(abs(Hfit(band_ind,:)))));

figure(2001); set(gcf,'Name','Nonlinearity Metric: Log');
    set(gcf,'Units', 'normalized', 'Position', [0.25,0.19,0.414,0.268])
hls = plot(ZNLD.ts_zc*1e3,IntDiffLog./IntHdataLog,'-',...
    ZNLD.ts_zc(ZNLD.fline_ind)*1e3, IntDiffLog(ZNLD.fline_ind)/IntHdataLog(ZNLD.fline_ind),'ko');
title('\bfNormalized Integral of Log Magnitude Difference FRF over Frequency');
xlabel('\bftime (ms)'); ylabel('\bfNormalied Integral');
legend('Integral','fit time');
set(hls,'LineWidth',2); grid on;

% figure(2001); set(gcf,'Name','Nonlinearity Metric: Log');
%     set(gcf,'Units', 'pixels', 'Position', [506  611  560  320])
% hls = plot(ZNLD.ts_zc*1e3,IntHdataLog,ZNLD.ts_zc*1e3,IntHfitLog,'--',...
%     ZNLD.ts_zc*1e3,IntDiffLog,'-.',...
%     ZNLD.ts_zc(ZNLD.fline_ind)*1e3, IntDiffLog(ZNLD.fline_ind),'ko');
% title('\bfIntegrals of Log Magnitude FRF over Frequency');
% xlabel('\bftime (ms)'); ylabel('\bfIntegral (dB*rad/s)');
% legend('Measured','Fit','Difference','Fit Pt');
% set(hls,'LineWidth',2); grid on;


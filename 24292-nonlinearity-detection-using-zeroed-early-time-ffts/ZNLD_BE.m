% Backwards extrapolation routine for ZNLDetect.m
%
% Matt Allen, July 2005-Aug 2006

global ZNLD, ZNLD

if ~isfield(ZNLD,'fline_ind') || ~isfield(ZNLD,'lam_fit');
    error('You must curve fit before extrapolating.');
end

% Find Extrapolation line and add to plot
extrap_lineh = gco;
    if isempty(extrap_lineh) | isempty(get(get(extrap_lineh,'Parent'),'Parent'))
        error('No Line on Figure 102 was selected. Select a line and run the script again.');
    end
    if get(get(extrap_lineh,'Parent'),'Parent') ~= 102;
        error('No Line on Figure 102 was selected. Select a line and run the script again.');
    end
    
    
% Make this line wider to facilitate visualization
set(gco,'LineWidth',2);
ZNLD.eline_ind = get(extrap_lineh,'UserData');
    % Add to the list of lines to keep
    ZNLD.lhands.hands = [ZNLD.lhands.hands; extrap_lineh];
    ZNLD.lhands.legend{length(ZNLD.lhands.legend)+1} = [num2str(ZNLD.ts_zc(ZNLD.eline_ind)*1e3,3)];

Hfit0 = ss_model(ZNLD.lam_fit,ZNLD.A_fit.*...
    exp(-ZNLD.lam_fit*(ZNLD.ts_zc(ZNLD.fline_ind) - ZNLD.ts_zc(ZNLD.eline_ind))),ZNLD.ws,'D');

% Add to plot
figure(102);
hl = line(ZNLD.ws/2/pi,abs(Hfit0),'Color',get(extrap_lineh,'Color'),'LineWidth',3,...
    'LineStyle','-.','UserData',['Extrap ',num2str(ZNLD.eline_ind),', FitLine ', num2str(ZNLD.fline_ind)]);
    % Add Curve Fit line to the list of lines to keep
    ZNLD.lhands.hands = [ZNLD.lhands.hands; hl];
    ZNLD.lhands.legend{length(ZNLD.lhands.legend)+1} = ['Extrap from ',num2str(ZNLD.ts_zc(ZNLD.fline_ind)*1e3,3),...
        ' to ',num2str(ZNLD.ts_zc(ZNLD.eline_ind)*1e3,4)];
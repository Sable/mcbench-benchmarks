function [h, x] = histnc(varargin)
% histnc - plot a normalized histogram colorful and stylized.
% The PDF is estimated using the area equal one.
%
% Syntax:  histc(data,bins,'r',style)
%
% Example:
%   x = randn(10000,1);
%   histnc(x,50,'g','LineWidth',.5,'LineStyle','--',...
%       'EdgeColor','b','BarWidth',.6,'BarLayout','stacked');
%   g=1/sqrt(2*pi)*exp(-0.5*x.^2);
%   hold on; plot(x,g,'.r'); hold off;
%   legend('Histogram','PDF');
%
% Inputs:
%    data - empirical data
%    bins - number of the histogram bins
%   style - LineSpec and ColorSpec
%
% Outputs:
%       h - the normalized "height" of the histogram bars
%       x - centers of bins
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none;

% Author: Marco Borges, Ph.D. Student, Computer/Biomedical Engineer
% UFMG, PPGEE, Neurodinamica Lab, Brazil
% email address: marcoafborges@gmail.com
% Website: http://www.cpdee.ufmg.br/
% August 2013; Version: v1; Last revision: 2013-08-30
% Changelog:

%------------------------------- BEGIN CODE -------------------------------

% Parse possible Axes input
[data, bins, CL, LW, LS, FC, EC, BW, BV, BL, cax] = parseArgs(varargin);

[h, x] = hist(data,bins);
step = abs(x(2) - x(1));
area = sum(step*h);
h = h/area;
if ishandle(cax)
    bar(cax,x,h,CL,'LineWidth',LW,'LineStyle',LS,'FaceColor',FC,...
        'EdgeColor',EC,'BarWidth',BW,'BaseValue',BV,'BarLayout',BL);
else
    figure('units','pixels','Position',[0 0 1024 768]);
    bar(x,h,CL,'LineWidth',LW,'LineStyle',LS,'FaceColor',FC,...
        'EdgeColor',EC,'BarWidth',BW,'BaseValue',BV,'BarLayout',BL);
end
end
%-------------------------------- END CODE --------------------------------
function [data, bins, CL, LW, LS, FC, EC, BW, BV, BL, cax] = parseArgs(inargs)
[cax, args, nargs] = axescheck(inargs{:});
if nargs < 1 || rem(nargs,2) == 0
    error(message('MATLAB:hist:InvalidInput',...
        'HISTNC requires one or more parameters.'));
else
    data = args{1};
    bins = 10;      % 10 bins as default
    CL = 'b';       % Color
    LW = 0.5;       % LineWidth
    LS = '-';       % LineStyle
    FC = 'flat';    % FaceColor
    EC = [0,0,0];   % EdgeColor
    BW = 0.8;       % BarWidth
    BV = 0;         % BaseValue
    BL = 'grouped'; % BarLayout or stacked
    
    if nargs > 1
        bins = args{2};
    end
    if nargs > 2
        ii = 3;
        while (ii <= nargs)
            if (ischar(args{ii}) && length(args{ii}) == 1) || ...
                    (isnumeric(args{ii}) && length(args{ii}) == 3)
                CL = args{ii};
                ii = ii - 1;
            else
                switch args{ii}
                    case 'Color'
                        CL = args{ii+1};
                    case 'LineWidth'
                        LW = args{ii+1};
                    case 'LineStyle'
                        LS = args{ii+1};
                    case 'FaceColor'
                        FC = args{ii+1};
                    case 'EdgeColor'
                        EC = args{ii+1};
                    case 'BarWidth'
                        BW = args{ii+1};
                    case 'BaseValue'
                        BV = args{ii+1};
                    case 'BarLayout'
                        BL = args{ii+1};
                end
            end
            ii = ii + 2;
        end
    end
end
end
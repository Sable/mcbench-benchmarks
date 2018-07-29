function h = getFigRxStreams(nStr, type)
% Helper fcn used to create the corresponding
% saved figure files (*2.fig and *4.fig for 2 and 4 layers)
%
% Reuse the fcn for more plots, just keep tags unique

h = figure;
Parent1 = h;

if strcmp(type, 'pre')      % After MIMO receiver
    titleLbl = 'Pre-demodulation data stream ';
    axLbl = 'preRx';
elseif strcmp(type, 'post') % After OFDM receiver
    titleLbl = 'Received data stream ';
    axLbl = 'postRx';
end
    
if (nStr == 4) % for 4 streams
    % Create Receive axes
    for n = 1:4
        str_title = [titleLbl, num2str(n)];
        str_tag = [axLbl, num2str(n)];
        b = 0.05 + 0.5*((n-2.5)<0);
        a = 0.05 + 0.5*(rem(n,2)==0);
        axes1 = axes('Parent', Parent1, 'Tag', str_tag, ...
            'YGrid', 'on', 'XGrid',' on',...
            'Position', [a b 0.4 0.4], 'FontSize', 9);
        xlim(axes1,[-1.75 1.75]);
        ylim(axes1,[-1.75 1.75]);
        box(axes1,'on');
        hold(axes1,'all');
        title(str_title,'FontWeight','bold');
    end
elseif (nStr == 2) % for 2 streams
    % Create Receive axes
    for n = 1:2
        str_title = [titleLbl, num2str(n)];
        str_tag = [axLbl, num2str(n)];
        b = 0.3 + 0.5*((n-2.5)>0);
        a = 0.05 + 0.5*(rem(n,2)==0);
        axes1 = axes('Parent', Parent1, 'Tag', str_tag, ...
            'YGrid', 'on', 'XGrid',' on',...
            'Position', [a b 0.4 0.4], 'FontSize', 9);
        xlim(axes1,[-1.75 1.75]);
        ylim(axes1,[-1.75 1.75]);
        box(axes1,'on');
        hold(axes1,'all');
        title(str_title,'FontWeight','bold');
    end
end

% [EOF]

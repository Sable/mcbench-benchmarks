function wlan80211g_graphics(s, ax, firstcall, params)
% WLAN80211A_GRAPHICS  Update MATLAB graphics from IEEE 802.11g simulation.
% wlan80211g_graphics(s, ax, firstcall, params) updates axes.
% 
% s: structure, containing data corresponding to multiple matrices
% ax: structure of axes handles
% firstcall: first plot
% params: modulation parameters

% % Copyright 2012 anuj saxena.

% handles
haxes = cell2mat(struct2cell(ax));
fig = get(haxes(1), 'parent');

% Create structure, d, containing all data required by plotting functions
% part of d is stored in guidata
d = guidata(fig);
if firstcall
    
    % set axes-related handles
    d.axes_handles = haxes;
    d.num_axes = length(d.axes_handles);
    d.axes_tags = get(d.axes_handles, 'tag');
    for n = 1:d.num_axes
        d.plotfn_handles{n} = str2func(['plot_' d.axes_tags{n}]);
    end
    
    d.frame_number = 1;
    d.txdata_xrange = 1:256; 
    d.block_Npoints = 50; 
    d.block_x_range = 1:d.block_Npoints;
    d.block_y_init = uNaN(1, d.block_Npoints);
    
else 

    d.frame_number = d.frame_number + 1;
    
end
guidata(fig, d);

% Pre-computation
link_delay = 34;
speceff = params.bitsPerSymbol(s.mode);  % spectral efficiency

d.first_frame = (d.frame_number == 1);
d.block_full = (d.frame_number > d.block_Npoints);
d.bit_period = params.bitPeriod(s.mode);
d.txbits = s.txbits.';
d.magresp = s.magresp.';
d.eqresp = s.eqresp.';
d.prerxg = s.prerxg.';
d.postrxg = s.postrxg.';
d.estSNRdB = s.estSNRdB.';
d.bitrate = 54*speceff/2.4;  % 802.11g-specific(5.0 for 802.11a)
d.ber = calcBER(s.txbits, s.rxbits, params.bitsPerBlock(s.mode), link_delay);

% alternative: call each function explicitly, with its axes handle
for i = 1:d.num_axes
    feval(d.plotfn_handles{i}, firstcall, d.axes_handles(i), d);   
end

drawnow

%--------------------------------------------------------------------------
% Plot functions (one for each axes object) 
% For object xyz, corresponding function name is plot_xyz
%--------------------------------------------------------------------------
function plot_txdata(fc, ax, d)
tmax = 5e-6; % maximum time (needs to be consistent with axis limits)
x = 0:d.bit_period:tmax;  
y = d.txbits(1:(length(x)-1));
plot_data_sequence(fc, ax, x, y, 50);

%--------------------------------------------------------------------------
function plot_prerxg(fc, ax, d)
plot_constellation(fc, ax, d.prerxg, 3);

%--------------------------------------------------------------------------
function plot_postrxg(fc, ax, d)
plot_constellation(fc, ax, d.postrxg, 5);

%--------------------------------------------------------------------------
function plot_avSNRdB(fc, ax, d)
y_append = d.estSNRdB;
plot_signal_evolution(fc, ax, d.block_x_range, y_append, {'.-', 'm-'});

%--------------------------------------------------------------------------
function plot_throughput(fc, ax, d)
y_append = d.bitrate; 
plot_signal_evolution(fc, ax, d.block_x_range, y_append, {'r.-'});

%--------------------------------------------------------------------------
function plot_freqResp(fc, ax, d)
y = fftshift(d.magresp);
plot_real_sig(fc, ax, y);

%--------------------------------------------------------------------------
function plot_eqResp(fc, ax, d)
y = [uNaN(1,6) d.eqresp uNaN(1,5)];
plot_real_sig(fc, ax, y);

%--------------------------------------------------------------------------
function plot_ber(fc, ax, d)
y_append = [0 d.ber 0] + eps;
ii = 3*(d.frame_number - 1) + (1:3);
if fc  
    init_axes(ax) 
    x = d.block_x_range;  x = [x; x; x];  x = x(:).';
    y = uNaN(1, length(x));
    y(ii) = y_append;
    plot(x, y, '-', 'linewidth', 2);
else 
    y = get_line_data(ax);
    if ~d.block_full
        y(ii) = y_append;
    else
        y = [y(4:end) y_append];
    end  
    set_line_data(ax, {y});
end

%--------------------------------------------------------------------------
% Support functions
%--------------------------------------------------------------------------

function ber = calcBER(txbits, rxbits, bits_per_block, link_delay)
% calculate bit-error-rate, expressed as percentage
txb = txbits( 1 : bits_per_block-link_delay );
rxb = rxbits( link_delay+1 : bits_per_block );
[Nbits, Nv] = size(txb);
decisionerror = rxb~=txb;
nerrors = nnz(decisionerror);
ber=nerrors/Nbits;

%--------------------------------------------------------------------------
function plot_data_sequence(fc, ax, x, y, Nmax)
x = [x; x];  x = x(:).';  x = x(2:(end-1));
y = [y; y];  y = y(:).';
u = uNaN(1, 2*Nmax - length(x));
x = [x u];
y = [y u];
if fc
    init_axes(ax);
    plot(x, y, '-');
else   
    c = get(ax, 'child');
    set(c, 'xdata', x, 'ydata', y);
end

%--------------------------------------------------------------------------
function plot_real_sig(fc, ax, y)
if fc
    Lx = length(y);
    x = (1:Lx)-Lx/2 - 1;
    init_axes(ax);
    plot(x, y, '-', 'linewidth', 2);
else   
    c = get(ax, 'child');
    set(c, 'ydata', y);
end


%--------------------------------------------------------------------------
function plot_constellation(fc, ax, x, marker_size)
if fc
    init_axes(ax);
    plot(x, '.', 'markersize', marker_size);
else 
    c = get(ax, 'child');
    set(c, 'xdata', real(x));  % for speed
    set(c, 'ydata', imag(x));    
end

%--------------------------------------------------------------------------
function plot_signal_evolution(fc, ax, x, y_append, linetypes)
% if fc: x is not used
if fc
    init_axes(ax);
    n = 1;  % x index number
    y = uNaN(1, length(x));
    y = [y; y];
    y(:, n) = y_append;
    if length(y_append)==2
        plot(x, y(1,:), linetypes{1}, x, y(2,:), linetypes{2});
    else
        plot(x, y(1,:), linetypes{1});
    end
    set(ax, 'userdata', n);
else
    n = get(ax, 'userdata') + 1;    
    yc = get_line_data(ax);
    if length(y_append)==2
        y = [yc{1}; yc{2}];
    else
        y = yc;
    end
    if n <= size(y, 2)
        y(:, n) = y_append;
    else
        y = [y(:, 2:end) y_append];
    end  
    set_line_data(ax, {y});
    set(ax, 'userdata', n);
end


%--------------------------------------------------------------------------
% General functions
%--------------------------------------------------------------------------

function y = uNaN(M,N)
uNaN = NaN;
y = uNaN([ones(M,N)]);

%--------------------------------------------------------------------------
function init_axes(ax)
axes(ax)
cla
hold on % needed if followed by plot command

%--------------------------------------------------------------------------
function yd = get_line_data(ax)
% yd is cell array of ydata, in reverse order of axes children
c = get(ax, 'child');
nc = length(c);
if nc==1
    yd = get(c, 'ydata');
else
    cr = 1:nc;
    yr = fliplr(cr);
    yd = cell(1, nc);
    for i = cr
        yd{yr(i)} = get(c(i), 'ydata');
    end
end

%--------------------------------------------------------------------------
function set_line_data(ax, ld, mode)
% ld is cell array of  line data, in reverse order of axes children
% if mode = 'complex', does ld is assumed to be ydata, otherwise complex data
if nargin==2, mode = 'ydata'; end
if strcmp(mode, 'ydata')
    set_ydata(ax, ld);
else
    set_complexdata(ax, ld);
end

%--------------------------------------------------------------------------
function set_ydata(ax, yd)
% yd is cell array of ydata, in reverse order of axes children
c = get(ax,'child');
s = length(yd);
cr = 1:s;
yr = fliplr(cr);
k = 1;
for i = cr
    ydi = yd{yr(i)};
    s2 = size(ydi, 1);
    yr2 = fliplr(1:s2);
    for m = 1:s2
        set(c(k), 'ydata', ydi(yr2(m),:));
        k = k+1;
    end
end

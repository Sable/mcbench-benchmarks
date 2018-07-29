function plot_strips(xinn,n,vstart,m,ipl,icolor,filenames,fs,smin,smax)
% plot speech file samples in a set of waveform strips
%
% xinn=input speech waveform to be plotted
% n=number of samples to be plotted
% vstart=starting sample in waveform
% m=number of samples to be plotted on each line of strips plot
% ipl=heading for x-axis label (samples or seconds)
% icolor=choice of color for waveform plots
% filenames=filename for headers
% fs=sampling rate in Hertz
% smin=minimum value in speech file
% smax=maximum value in speech file
%
% select color from choice of icolor
    switch icolor
        case 1
            color='k';
        case 2
            color='r';
        case 3
            color='b';
        case 4
            color='g';
        case 5
            color='m';
        case 6
            color='c';
    end

% move samples vstart:vstart+n-1 to xins for plotting
    xins=xinn(vstart:vstart+n-1);
    
% plot waveform using strips_modified routine
% previous version called striplot_modified(xins,sd,vstart,fs,scale,color);
%   xins'=input signal to be plotted
%   sd=duration of signal per line of plot (either in samples or seconds)
%   vstart=starting sample or starting time in seconds
%   fs=sampling rate of speech for seconds; fs=1 for samples
%   scale=scaling of input signal values
%   color=color of lines for plotting

    if (ipl == 1)
        strips_modified(xins',m,vstart-1,1,1,color);
    elseif (ipl == 2)
        strips_modified(xins',m/fs,(vstart-1)/fs,fs,1,color);
    else
        strips_modified(xins',m,vstart-1,1,1,color);
    end
    
% attach title to figure for identification purposes
    stitle1=sprintf('file: %s, FS: %d, SS: %d, NS: %d, max/min: %d %d',...
        filenames,fs,vstart,n,smax,smin);
    if (ipl == 1)
        xpp=['Sample Number; fs=',num2str(fs),' samples/second'];
        xlabel(xpp),ylabel('Samples Offset');
    elseif (ipl ==2)
        xpp=['Seconds Past Offset; fs=',num2str(fs),' samples/second'];
        xlabel(xpp),ylabel('Seconds Offset');
    else
        xpp=['fs=',num2str(fs),' samples/second'];
        xlabel(xpp),ylabel('Full Waveform');
    end
end


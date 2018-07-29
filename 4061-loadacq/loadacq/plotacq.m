function plotacq(chan)
%PLOTACQ Plots a channel structure generated from loadacq
%  (c) 2003 Mihai Moldovan 
%   M.Moldovan@mfi.ku.dk


fig_hndl=figure(...
            'Units','normalized',...
             'Color',get(0,'defaultUicontrolBackgroundColor'),...
            'Name','Acqknowledge import',...
            'NumberTitle','off',...
            'Resize','on',...
            'WindowStyle','normal',...
            'PaperUnits','normalized',...
            'PaperOrientation','Landscape',...
            'PaperPositionMode','manual',...
            'PaperPosition',[0 0 1 1],...
            'PaperType','A4');

% --------------------------------------------------------------------
% plot all channels
% --------------------------------------------------------------------
       
n=length(chan);       

for i=1:n
    ax_hndl=subplot(n,1,i);
    set(ax_hndl,'FontUnits','points','FontName','Arial','FontSize',7,'NextPlot','add','LineWidth',1);
    
    y=chan(i).data;
    x=(1:length(y));
    x=x.*chan(i).ms/1000;
    plot (x,y,'Color',chan(i).color);
    
    t=ylabel([chan(i).name ' (' chan(i).units ')']);
    set (t,'Rotation',0,'HorizontalAlignment','right','FontWeight','bold');
    
    if i~=n
        set(ax_hndl,'XTickLabel',{})
    else
        xlabel ('Time (seconds)')
    end        
    
    mk=chan(i).mdata;
    for j=1:length(mk)
        x=mk(j).*chan(i).ms/1000;
        plot ([x x],ylim,'k--')
    end    
end    

% --------------------------------------------------------------------
% save the metafile
% --------------------------------------------------------------------


   [ST,I] = dbstack; 
   n=length(ST);
     
   mfile=ST(n).name;
     
   [file_path mname emxt mversn] = fileparts(mfile);
   meta=[file_path filesep mname '.emf'];
   
   %print -dwinc for color
   print ( '-dmeta', meta);

%return
%-----------------------------------------------

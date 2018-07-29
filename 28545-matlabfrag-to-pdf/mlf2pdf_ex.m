% mlf2pdf_ex is an example for how to use mlf2pdf.
% It creates two buttons (Exit and PDF), which you may use either to exit the
% script or to create the pdf file from the current figure. So you can edit
% the plot "online" and create the pdf from the figure the way it is. 

function mlf2pdf_ex

fpl=figure('units','centimeters',...%plotfigure
           'Position',[10 10 10 5]); % position: [llx lly width height]
f=figure('units','centimeters','Position',[5 10 2 2]);     %Buttons
uicontrol(f,'Style','pushbutton','String','-> PDF',...
            'Units','normalized','Pos',[0 0 1 .5],'Callback',@callback_mlf2pdf);
uicontrol(f,'Style','pushbutton','String','Exit',...
            'Units','normalized','Pos',[0 0.5 1 .5],'Callback','close all');
figure(fpl);                %activate plot figure


filename='yourfilename';    %enter your filename here
yourplot;                   %place your plot commands here


 function callback_mlf2pdf(dummy1,dummy2)
    mlf2pdf(fpl,filename,'SIUnits');
 end

 function yourplot
        X=0:pi/10:2*pi;
        Y=sin(X);
        plot(X,Y);
        axis([0,2*pi,-1.5,1.5]);
        grid on;
end
end
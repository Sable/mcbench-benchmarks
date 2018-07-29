function Callbacks_strips_plot_GUI25(f,C,start_path)

%SENSE COMPUTER AND SET FILE DELIMITER
switch(computer)				
    case 'MACI64',		char= '/';
    case 'GLNX86',  char='/';
    case 'PCWIN',	char= '\';
    case 'PCWIN64', char='\';
    case 'GLNXA64', char='/';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=C{1,1};
y=C{1,2};
a=C{1,3};
b=C{1,4};
u=C{1,5};
v=C{1,6};
m=C{1,7};
n=C{1,8};
lengthbutton=C{1,9};
widthbutton=C{1,10};
enterType=C{1,11};
enterString=C{1,12};
enterLabel=C{1,13};
noPanels=C{1,14};
noGraphicPanels=C{1,15};
noButtons=C{1,16};
labelDist=C{1,17};%distance that the label is below the button
noTitles=C{1,18};
buttonTextSize=C{1,19};
labelTextSize=C{1,20};
textboxFont=C{1,21};
textboxString=C{1,22};
textboxWeight=C{1,23};
textboxAngle=C{1,24};
labelHeight=C{1,25};
fileName=C{1,26};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PANELS
for j=0:noPanels-1
uipanel('Parent',f,...
'Units','Normalized',...
'Position',[x(1+4*j) y(1+4*j) x(2+4*j)-x(1+4*j) y(3+4*j)-y(2+4*j)]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GRAPHIC PANELS
for i=0:noGraphicPanels-1
switch (i+1)
case 1
graphicPanel1 = axes('parent',f,...
'Units','Normalized',...0
'Position',[a(1+4*i) b(1+4*i) a(2+4*i)-a(1+4*i) b(3+4*i)-b(2+4*i)],...
'GridLineStyle','--');
case 2
graphicPanel2 = axes('parent',f,...
'Units','Normalized',...
'Position',[a(1+4*i) b(1+4*i) a(2+4*i)-a(1+4*i) b(3+4*i)-b(2+4*i)],...
'GridLineStyle','--');
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TITLE BOXES
for k=0:noTitles-1
switch (k+1)
case 1
titleBox1 = uicontrol('parent',f,...
'Units','Normalized',...
'Position',[u(1+4*k) v(1+4*k) u(2+4*k)-u(1+4*k) v(3+4*k)-v(2+4*k)],...
'Style','text',...
'FontSize',textboxFont{k+1},...
'String',textboxString(k+1),...
'FontWeight',textboxWeight{k+1},...
'FontAngle',textboxAngle{k+1});
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BUTTONS
for i=0:(noButtons-1)
enterColor='w';
if strcmp(enterType{i+1},'pushbutton')==1 ||strcmp(enterType{i+1},'text')==1
enterColor='default';
end
if (strcmp(enterLabel{1,(i+1)},'')==0 &&...
        strcmp(enterLabel{1,(i+1)},'...')==0) %i.e. there is a label
%creating a label for some buttons
uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i)-labelDist-labelHeight(i+1) ...
(m(2+2*i)-m(1+2*i)) labelHeight(i+1)],...
'Style','text',...
'String',enterLabel{i+1},...
'FontSize', labelTextSize(i+1),...
'HorizontalAlignment','center');
end
switch (i+1)
case 1
button1=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button1Callback);
case 2
button2=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button2Callback);
case 3
button3=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button3Callback);
case 4
button4=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button4Callback);
case 5
button5=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button5Callback);
case 6
button6=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button6Callback);
case 7
button7=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button7Callback);
case 8
button8=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button8Callback);
case 9
button9=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button9Callback);
case 10
button10=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button10Callback);
case 11
button11=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button11Callback);
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%USER CODE FOR THE VARIABLES AND CALLBACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

curr_file=[];
fs=10000;
directory_name='abcd';
wav_file_names='abcd';
file_info_string=' ';
ss=1;
es=1000;
m=4000;
ipl=1;
fname='output';
nsamp=1;
indexOfDrpDwnMenu=1;
deviation = [];
toggle = 0;

% Name the GUI
    set(f,'Name','strips_plot');

%CALLBACKS

% Callback for button1 -- Get Speech Files Directory
 function button1Callback(h,eventdata)
     directory_name=uigetdir(start_path,'dialog_title');
     waitfor(msgbox('Please make sure you have already downloaded the speech and audio files and have put them in the same folder to which you downloaded the various speech processing exercises in order for the program to work seamlessly.'));
     A=strvcat(strcat((directory_name),'\*.wav'));
     struct_filenames=dir(A);
     wav_file_names={struct_filenames.name};
     set(button2,'String',wav_file_names);
     set(button2,'val',1);
     
% once the popupmenu/drop down menu is created, by default, the first
% selection from the popupmenu/drop down menu id is selected
    indexOfDrpDwnMenu=1;
    
% by default first speech/audio file from the popupmenu/dropdown menu will be loaded
    [curr_file,fs]=loadSelection(directory_name,wav_file_names,indexOfDrpDwnMenu);
    button2Callback(h,eventdata);
 end

% Callback for button2 -- Choose speech file for play and plot
 function button2Callback(h,eventdata)
     indexOfDrpDwnMenu=get(button2,'val');    
     [curr_file,fs]=loadSelection(directory_name,wav_file_names,indexOfDrpDwnMenu);
     ss=1;
     es=length(curr_file);
     
     set(button3,'string',num2str(ss));
     set(button9,'string',num2str(length(curr_file)));
 end

%*************************************************************************
% function -- load selection from designated directory and selected speech/audio file
%
function [curr_file,fs]=loadSelection(directory_name,wav_file_names,...
    indexOfDrpDwnMenu);
%
% read in speech/audio file
% fin_path is the complete path of the .wav file that is selected
    fin_path=strcat(directory_name,'\',strvcat(wav_file_names(indexOfDrpDwnMenu)));
    
% clear speech/audio file
    clear curr_file;
    
% read in speech/audio signal into curr_file; sampling rate is fs 
    [curr_file,fs]=wavread(fin_path);
    
% scale speech signal to +/- 32768 range
    xin=curr_file*32768;
    
% create title information with filename (fname), sampling rate (fs), 
% number of samples in file (nsamp)
    fname=wav_file_names(indexOfDrpDwnMenu);
    FS=num2str(fs);
    nsamp=num2str(length(curr_file));
    file_info_string=strcat('  file: ',fname,', fs: ',FS,' Hz, nsamp:',nsamp);

% retrieve fname from cell array
    fname=wav_file_names{indexOfDrpDwnMenu};
    
% correct filename by changing underbar characters to space characters
    fname(find(fname(:)=='_'))=' ';
end
%*************************************************************************

% Callback for button3 -- load starting sample, ss, in speech file
 function button3Callback(h,eventdata)
     ss=str2num(get(button3,'string'));
     if (ss < 1) ss=1;
     end
     if (ss > length(curr_file)) ss=length(curr_file)-100;
     end
     set(button3,'string',num2str(ss));
 end

% Callback for button9 -- load ending sample, es, in speech file
 function button9Callback(h,eventdata)
     es=str2num(get(button9,'string'));
     if (es > length(curr_file)) es=length(curr_file);
     end
     if (es < ss) es=length(curr_file);
     end
     set(button9,'string',num2str(es));
 end

% Callback for button4 -- number of samples per line, m, in plot
 function button4Callback(h,eventdata)
     m=str2num(get(button4,'string'));
     if (m < 0) m=4000; end
     set(button4,'string',num2str(m));
 end

% Callback for button5 -- option, ipl, for samples (1), seconds (2) for x-axis
 function button5Callback(h,eventdata)
     ipl=get(button5,'val');
 end

% Callback for button6 -- play speech file
 function button6Callback(h,eventdata)
     button3Callback(h,eventdata);
     button9Callback(h,eventdata);
     soundsc(curr_file(ss:es),fs);
 end

% Callback for button7 -- plot file as strips plot
 function button7Callback(h,eventdata)
     if (toggle == 1 || toggle == 2)
         ontoggle();
     end
     xnrm=max(max(curr_file),-min(curr_file));
     curr_file=curr_file/xnrm;

% set up graphics Panel 1 to plot waveform in a strips format
     hold off;  % turn hold off so that previous contents of panel are replaced   
     grid off;
     reset(graphicPanel1);
     axes(graphicPanel1);
     
% plot signal in a strips format in graphics Panel 1
    button3Callback(h,eventdata);
    button9Callback(h,eventdata);

     plot_strips(curr_file,es-ss+1,ss,m,ipl,1,fname,...
          fs,min(curr_file(ss:es)),max(curr_file(ss:es)))
      
     len=es-ss+1;
     num_strips=ceil(len/m);
     xmax=max(curr_file(ss:es));
     xmin=min(curr_file(ss:es));
     del=0.25*(xmax-xmin);
     sep=(xmax-xmin)+del;
     deviation=(num_strips-1:-1:0)*sep;
     
% title box information from run
    stitle1=strcat('Strips Plot -- ',file_info_string);
    set(titleBox1,'String',stitle1);
    set(titleBox1,'FontSize',25);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     hold off;  % turn hold off so that previous contents of panel are replaced   
     grid off;
     
    axes(graphicPanel2);
     
    plot_strips(curr_file,length(curr_file),1,length(curr_file),0,1,fname,...
          fs,min(curr_file(ss:es)),max(curr_file(ss:es)))
      
    toggle = 0;  
 end

% Callback for button8
 function button8Callback(h,eventdata)
     close(gcf);
 end

 function button10Callback(h,eventdata)
     if (toggle == 1 || toggle == 2)
         ontoggle();
     end
     cla(graphicPanel1);
     axes(graphicPanel2);
     hold on;
     p1 = round(ginput(1))
     if (p1(1) > length(curr_file) || p1(1) < 0)
         waitfor(errordlg('Invalid point'))
         return;
     end
     if (p1(2) > 1 || p1(2) < -1)
         waitfor(errordlg('Pick a valid point on the graph'))
         return;
     end
     set(button3,'string',num2str(round(p1(1))));
     start = plot([p1(1) p1(1)],[-2 2],'--rs','LineWidth',2);
     set(start,'Color','green')
     p2 = round(ginput(1))
     if ((p2(1) < p1(1)) && (p2(2) < 1 && p2(2) > -1 ))
         waitfor(errordlg('Pick ending sample after the starting sample.'))
         toggle = 1;
         return;
     elseif (p2(1) > length(curr_file) || p2(1) < 0)
         waitfor(errordlg('Invalid point'))
         toggle = 1;
     elseif (p2(2) > 1 || p2(2) < -1)
         waitfor(errordlg('Pick a valid point on the graph'))
         toggle = 1;
         return;
     end
     set(button9,'string',num2str(round(p2(1))));
     finish = plot([p2(1) p2(1)],[-2 2],'--rs','LineWidth',2);
     set(finish,'Color','green')
     
     
     reset(graphicPanel1);
     axes(graphicPanel1);
                 
      plot_strips(curr_file,p2(1)-p1(1),p1(1),m,ipl,1,fname,...
          fs,min(curr_file(ss:es)),max(curr_file(ss:es)))
         
     toggle = 1; 
 end

  function button11Callback(h,eventdata)
     ontoggle();
     axes(graphicPanel1);
     hold on;
     
     np1 = round(ginput(1));
     if (np1(1) < 0 || np1(1) > m)
         errordlg('Invalid point')
         toggle = 2;
         return;
     end
     [num1 indx1] = min(abs(deviation-np1(2)));
     pos1 = m*(indx1-1) + np1(1);
     if (indx1 > 1 && indx1 < length(deviation))
         tp = deviation(indx1-1) - 1;
         bp = deviation(indx1+1) + 1;
     elseif (indx1 == 1)
         tp = deviation(indx1) + 1.0;
         bp = deviation(indx1+1) + 1.0;
     elseif (indx1 == length(deviation))
         tp = deviation(indx1-1) - 1;
         bp = deviation(indx1) - 1;
     end
         axes(graphicPanel1)
         set(button3,'string',num2str(pos1));
         start = plot([np1(1) np1(1)],[tp bp],'--bs','LineWidth',2);
         axes(graphicPanel2)
          hold on
         start2 = plot([pos1 pos1],[-2 2],'--rs','LineWidth',2);
         
     np2 = round(ginput(1));
     if (np2(1) < 0 || np2(1) > m)
         errordlg('Invalid point')
         toggle = 2;
         return;
     end
     [num2 indx2] = min(abs(deviation-np2(2)));
     pos2 = m*(indx2-1) + np2(1);
     if (pos2 < pos1)
        waitfor(errordlg('Pick the ending sample after the starting sample'))
        return;
     end
      if (indx2 > 1 && indx2 < length(deviation))
         tp2 = deviation(indx2-1) - 1;
         bp2 = deviation(indx2+1) + 1;
     elseif (indx2 == 1)
         tp2 = deviation(indx2) + 1;
         bp2 = deviation(indx2+1) + 1;
     elseif (indx2 == length(deviation))
         tp2 = deviation(indx2-1) - 1;
         bp2 = deviation(indx2) - 1;
     end
         axes(graphicPanel1)
         set(button9,'string',num2str(pos2));
         start = plot([np2(1) np2(1)],[tp2 bp2],'--bs','LineWidth',2);
         axes(graphicPanel2)
          hold on
         start2 = plot([pos2 pos2],[-2 2],'--rs','LineWidth',2);
         pause(2.5);
     
     cla(graphicPanel1)
     axes(graphicPanel1)
     plot_strips(curr_file,pos2-pos1+1,pos1,m,0,1,fname,...
          fs,min(curr_file(ss:es)),max(curr_file(ss:es)));
     
      toggle = 2;
     
  end

    function ontoggle()
        axes(graphicPanel2)
        cla(graphicPanel2)
         plot_strips(curr_file,length(curr_file),1,length(curr_file),0,1,fname,...
          fs,min(curr_file(ss:es)),max(curr_file(ss:es)));
        cla(graphicPanel1);
        set(button3,'string',1)
        set(button9,'string',length(curr_file))
        axes(graphicPanel1)
        plot_strips(curr_file,length(curr_file),1,m,0,1,fname,...
          fs,min(curr_file(ss:es)),max(curr_file(ss:es)))
    end
end
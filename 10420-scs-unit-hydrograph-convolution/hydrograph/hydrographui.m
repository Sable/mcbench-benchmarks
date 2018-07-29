function [tq,q,tu,u,t,p,Q]=hydrographui(task)
% SCS Unit Hydrograph Convolution User Interface (R11)
%
% Type "help hydrograph" for more information.
%
% Example:
%
%   hydrographui % invokes graphical user interface and returns
%                % tq,q,tu,u,t,p,Q to the current workspace;
%                % note that neither input nor output arguments
%                % are specified
%
% See also help\hydrographui.html.

% Version 2.03 Copyright(c)2008
% Tom Davis (tdavis@metzgerwillard.com)
%
% Last revision: 03/16/2008

global uhUI   rdUI   methodUI         KUI DUI RUI AUI CNUI TcUI ToUI
global uhname rdname methodndx method K   D   R   A   CN   Tc   To

global plot2UI plot3UI plot4UI plot5UI compareUI summaryUI detailUI
global plot2   plot3   plot4   plot5   compare   summary   detail

global win1UI win2UI win3UI win4UI win5UI work   IarUI metUI impUI
global qmaxUI tmaxUI rvolUI uvolUI duhlib drdlib Iar   met   imp

global units  dunit  aunit  funit  vunit  sk2ac
global Runits Aunits Funits Vunits Hunits cm2cf

if  nargin < 1
  task='setup';
end

switch task
  case 'setup'
    if exist('config.mat','file')==2
      load('config.mat')
    else % default imperial configuration
      uhname='scs-484';
      rdname='scsii-024';
      methodndx=1;
      K=484;
      D=24;
      R=8;
      Iar=0.2;
      A=640;
      CN=75;
      Tc=90;
      To=15;
      units=0;
      plot2='on';
      plot3='on';
      plot4='on';
      plot5='on';
      summary='off';
      detail='off';
      duhlib='library\';
      drdlib='library\';
      hydrographui('config');
    end
    work='work\';
    hydrographui('units');
    compare='off'; white=[1 1 1];
    sk2ac=247.105381467165;               % square kilometers to acres
    %    =1e10/(43560*12^2*2.54^2);
    cm2cf=35.3146667214886;               % cubic meters to cubic feet
    %    =1e6/(12^3*2.54^3);

    % Make relative work path absolute
    root=cd;
    cd(work);
    work=[cd,'\'];
    cd(root);

    figure(1)
    clf
    bgc=get(1,'Color');
    set(1,'Name','Untitled',...
      'Units','normalized','NumberTitle','off',...
      'DefaultUicontrolUnits','normalized',...
      'DefaultUicontrolHorizontalAlignment','right',...
      'DefaultUicontrolStyle','text','Menu','none',...
      'DefaultUicontrolBackgroundColor',bgc,...
      'DefaultUicontrolInterruptible','off');
    
    % Initialize controls
  
    uicontrol('String','SCS Unit Hydrograph Convolution',...
      'HorizontalAlignment','center',...
      'FontWeight','bold',...
      'Position',[0.20 0.95 0.60 0.03]);
  
    % Input
    uicontrol('String','Unit Hydrograph',...
      'Position',[0.11 0.88 0.38 0.03]);
    uhUI=uicontrol('BackgroundColor',white,...
      'String',uhname,...
      'HorizontalAlignment','left',...
      'Position',[0.51 0.88 0.20 0.044],...
      'Style','edit',...
      'Enable','inactive',...
      'ButtonDownFcn','hydrographui(''uhname'');');
    uicontrol('String','Rainfall Distribution',...
      'Position',[0.11 0.83 0.38 0.03]);
    rdUI=uicontrol('BackgroundColor',white,...
      'String',rdname,...
      'HorizontalAlignment','left',...
      'Position',[0.51 0.83 0.20 0.044],...
      'Style','edit',...
      'Enable','inactive',...
      'ButtonDownFcn','hydrographui(''rdname'');');
    uicontrol('String','Interpolation Method',...
      'Position',[0.11 0.78 0.38 0.03]);
    methodUI=uicontrol('BackgroundColor',white,...
      'String',{' linear',' cubic',' spline'},...
      'Position',[0.51 0.78 0.20 0.044],...
      'Value',methodndx,...
      'Style','popup',...
      'Callback','hydrographui(''method'');');
    uicontrol('String','Peak Factor',...
      'Position',[0.11 0.73 0.38 0.03]);
    KUI=uicontrol('BackgroundColor',white,...
      'String',num2str(K),...
      'Position',[0.51 0.73 0.20 0.044],...
      'Style','edit',...
      'Callback','hydrographui(''K'');');
    uicontrol('String','Storm Duration (hr)',...
      'Position',[0.11 0.68 0.38 0.03]);
    DUI=uicontrol('BackgroundColor',white,...
      'String',num2str(D),...
      'Position',[0.51 0.68 0.20 0.044],...
      'Style','edit',...
      'Callback','hydrographui(''D'');');
    Runits=uicontrol('String',['Rainfall Depth ',dunit],...
      'Position',[0.11 0.63 0.38 0.03]);
    RUI=uicontrol('BackgroundColor',white,...
      'String',num2str(R),...
      'Position',[0.51 0.63 0.20 0.044],...
      'Style','edit',...
      'Callback','hydrographui(''R'');');
    uicontrol('String','Initial Abstraction Ratio',...
      'Position',[0.11 0.58 0.38 0.03]);
    IarUI=uicontrol('BackgroundColor',white,...
      'String',num2str(Iar),...
      'Position',[0.51 0.58 0.20 0.044],...
      'Style','edit',...
      'Callback','hydrographui(''Iar'');');
    Aunits=uicontrol('String',aunit,...
      'Position',[0.11 0.53 0.38 0.03]);
    AUI=uicontrol('BackgroundColor',white,...
      'String',num2str(A),...
      'Position',[0.51 0.53 0.20 0.044],...
      'Style','edit',...
      'Callback','hydrographui(''A'');');
    uicontrol('String','Curve Number',...
      'Position',[0.11 0.48 0.38 0.03]);
    CNUI=uicontrol('BackgroundColor',white,...
      'String',num2str(CN),...
      'Position',[0.51 0.48 0.20 0.044],...
      'Style','edit',...
      'Callback','hydrographui(''CN'');');
    uicontrol('String','Time of Concentration (min)',...
      'Position',[0.11 0.43 0.38 0.03]);
    TcUI=uicontrol('BackgroundColor',white,...
      'String',num2str(Tc),...
      'Position',[0.51 0.43 0.20 0.044],...
      'Style','edit',...
      'Callback','hydrographui(''Tc'');');
    uicontrol('String','Output Time Increment (min)',...
      'Position',[0.11 0.38 0.38 0.03]);
    ToUI=uicontrol('BackgroundColor',white,...
      'String',num2str(To),...
      'Position',[0.51 0.38 0.20 0.044],...
      'Style','edit',...
      'Callback','hydrographui(''To'');');
    
    % Output
    uicontrol('Position',[0.1 0.095 0.8 0.25],...
      'Style','frame');
    Funits=uicontrol('String',['Peak Runoff ',funit],...
      'Position',[0.11 0.28 0.38 0.03]);
    qmaxUI=uicontrol('String','',...
      'Position',[0.51 0.28 0.20 0.03]);
    uicontrol('String','Time to Peak (hr)',...
      'Position',[0.11 0.23 0.38 0.03]);
    tmaxUI=uicontrol('String','',...
      'Position',[0.51 0.23 0.20 0.03]);
    Vunits=uicontrol('String',['Runoff Volume ',dunit],...
      'Position',[0.11 0.18 0.38 0.03]);
    rvolUI=uicontrol('String','',...
      'Position',[0.51 0.18 0.20 0.03]);
    Hunits=uicontrol('String',['Unit Hydrograph Volume ',dunit],...
      'Position',[0.11 0.13 0.38 0.03]);
    uvolUI=uicontrol('String','',...
      'Position',[0.51 0.13 0.20 0.03]);
    hydrographui('method');

    uicontrol('String','Run',...
      'Position',[0.29 0.02 0.20 0.044],...
      'Style','pushbutton',...
      'Callback','[tq,q,tu,u,t,p,Q]=hydrographui(''run'');');
    uicontrol('String','Exit',...
      'Position',[0.51 0.02 0.20 0.044],...
      'Style','pushbutton',...
      'Callback','hydrographui(''exit'');');
    
    % Menu bar
    fileUI=uimenu('Label','&File');
      uimenu(fileUI,'Label','&Load...',...
        'Callback','hydrographui(''load'');');
      uimenu(fileUI,'Label','&Save...',...
        'Callback','hydrographui(''save'');');
      uimenu(fileUI,'Label','&Run',...
        'Separator','on',...
        'Callback','hydrographui(''run'');');
      uimenu(fileUI,'Label','&Exit',...
        'Callback','hydrographui(''exit'');');
      impUI=uimenu(fileUI,'Label','&Imperial',...
        'Separator','on',...
        'Checked',imp,...
        'Callback','hydrographui(''imp'');');
      metUI=uimenu(fileUI,'Label','&Metric',...
        'Checked',met,...
        'Callback','hydrographui(''met'');');
      uimenu(fileUI,'Label','Save &Configuration',...
        'Separator','on',...
        'Callback','hydrographui(''config'');');
    editUI=uimenu('Label','&Edit');
      uimenu(editUI,'Label','&Unit Hydrograph...',...
        'Callback','hydrographui(''duhedit'');');
      uimenu(editUI,'Label','Rainfall &Distribution...',...
        'Callback','hydrographui(''drdedit'');');
      uimenu(editUI,'Label','&Report...',...
        'Callback','hydrographui(''rptedit'');');
      
    title2='&2  Rainfall-Runoff Curves';
    title3='&3  Dimensionless Unit Hydrograph';  
    title4='&4  Unit Hydrograph';  
    title5='&5  Runoff Hydrograph';  
    title6='&Compare Plots';  
    
    plotUI=uimenu('Label','&Plot');
      plot2UI=uimenu(plotUI,'Label',title2,...
        'Checked',plot2,...
        'Callback','hydrographui(''plot2'');');
      plot3UI=uimenu(plotUI,'Label',title3,...
        'Checked',plot3,...
        'Callback','hydrographui(''plot3'');');
      plot4UI=uimenu(plotUI,'Label',title4,...
        'Checked',plot4,...
        'Callback','hydrographui(''plot4'');');
      plot5UI=uimenu(plotUI,'Label',title5,...
        'Checked',plot5,...
        'Callback','hydrographui(''plot5'');');
      compareUI=uimenu(plotUI,'Label',title6,...
        'Checked',compare,...
        'Separator','on',...
        'Callback','hydrographui(''compare'');');
    reportUI=uimenu('Label','&Report');
      summaryUI=uimenu(reportUI,'Label','&Summary',...
        'Checked',summary,...
        'Callback','hydrographui(''summary'');');
      detailUI=uimenu(reportUI,'Label','&Detail',...
        'Checked',detail,...
        'Callback','hydrographui(''detail'');');
    windowUI=uimenu('Label','&Window',...
      'Callback','hydrographui(''window'');');
      uimenu(windowUI,'Label','&0  MATLAB Command Window',...
        'Callback','uimenufcn(gcbf,''WindowCommandWindow'')');
      win1UI=uimenu(windowUI,'Label','&1  Untitled',...
        'Callback','figure(1)');
      win2UI=uimenu(windowUI,'Label',title2,...
        'Separator','on',...
        'Callback','figure(2)');
      win3UI=uimenu(windowUI,'Label',title3,...
        'Callback','figure(3)');
      win4UI=uimenu(windowUI,'Label',title4,...
        'Callback','figure(4)');
      win5UI=uimenu(windowUI,'Label',title5,...
        'Callback','figure(5)');
      uimenu(windowUI,'Label','&Cascade Plots',...
        'Separator','on',...
        'Callback','hydrographui(''cascade'');');
      uimenu(windowUI,'Label','&Stack Plots',...
        'Callback','hydrographui(''stack'');');
    helpUI=uimenu('Label','&Help');
      uimenu(helpUI,'Label','&Hydrograph Help',...
        'Callback','hydrographui(''help'');');
      uimenu(helpUI,'Label','&About Hydrograph',...
        'Separator','on',...
        'Callback','hydrographui(''about'');');

  %-----------------------------------------------------------------------
  case 'run'
    
    if exist([duhlib,uhname,'.duh'],'file')~=2
      msgbox('Unit Hydrograph does not exist.',...
        'File Error','error','modal');
      tq=[];q=[];tu=[];u=[];t=[];p=[];Q=[];
      return
    end
    if exist([drdlib,rdname,'.drd'],'file')~=2
      msgbox('Rainfall Distribution does not exist.',...
        'File Error','error','modal');
      tq=[];q=[];tu=[];u=[];t=[];p=[];Q=[];
      return
    end
    if isnan(K) | K<=0                    %#ok (R11)
      msgbox('Peak Factor must be greater than zero.',...
        'Value Error','error','modal');
      tq=[];q=[];tu=[];u=[];t=[];p=[];Q=[];
      return
    end
    if isnan(D) | D<=0                    %#ok (R11)
      msgbox('Storm Duration must be greater than zero.',...
        'Value Error','error','modal');
      tq=[];q=[];tu=[];u=[];t=[];p=[];Q=[];
      return
    end
    if isnan(R) | R<=0                    %#ok (R11)
      msgbox('Rainfall Depth must be greater than zero.',...
        'Value Error','error','modal');
      tq=[];q=[];tu=[];u=[];t=[];p=[];Q=[];
      return
    end
    if isnan(Iar) | Iar<0 | Iar>1         %#ok (R11)
      msgbox(['Initial Abstraction Ratio must be ',...
        'greater than or equal to zero and less '...
        'than or equal to one.'],...
        'Value Error','error','modal');
      tq=[];q=[];tu=[];u=[];t=[];p=[];Q=[];
      return
    end
    if isnan(A) | A<=0                    %#ok (R11)
      msgbox('Basin Area must be greater than zero.',...
        'Value Error','error','modal');
      tq=[];q=[];tu=[];u=[];t=[];p=[];Q=[];
      return
    end
    if isnan(CN) | CN<=0 | CN>100         %#ok (R11)
      msgbox({'Curve Number must be greater than',...
        'zero and less than or equal to 100.'},...
        'Value Error','error','modal');
      tq=[];q=[];tu=[];u=[];t=[];p=[];Q=[];
      return
    end
    if isnan(Tc) | Tc<=0                  %#ok (R11)
      msgbox('Time of Concentration must be greater than zero.',...
        'Value Error','error','modal');
      tq=[];q=[];tu=[];u=[];t=[];p=[];Q=[];
      return
    end
    if isnan(To) | To<=0                  %#ok (R11)
      msgbox('Output Time Increment must be greater than zero.',...
        'Value Error','error','modal');
      tq=[];q=[];tu=[];u=[];t=[];p=[];Q=[];
      return
    end
    [tq,q,tu,u,t,p,Q,pass]=hydrograph([duhlib,uhname,'.duh'],...
      [drdlib,rdname,'.drd'],method,K,D,R,Iar,A,CN,Tc,units);
    if ~pass, return, end
    if units
      AA=A*sk2ac;                         % always acres
      qq=q*cm2cf; uu=u*cm2cf;             % always cfs
    else
      AA=A; qq=q; uu=u;
    end
    [qmax ndx]=max(q);
    tmax=tq(ndx);
    rvol=sum(qq)*Tc/(AA*453.75);
    %   =sum(qq)*2*Tc*60*12/(AA*43560*15)
    uvol=sum(uu)*Tc/(AA*453.75);
    %   =sum(uu)*2*Tc*60*12/(AA*43560*15)
    cK=K/uvol;
    if units
      rvol=rvol*25.4; uvol=uvol*25.4;     % mm
    end
  
    set(qmaxUI,'String',num2str(qmax))
    set(tmaxUI,'String',num2str(tmax))
    set(rvolUI,'String',num2str(rvol))
    set(uvolUI,'String',num2str(uvol))
    
    title2='Rainfall-Runoff Curves';
    title3='Dimensionless Unit Hydrograph';  
    title4='Unit Hydrograph';  
    title5='Runoff Hydrograph';  
    
    if strcmp(plot2,'on')
      figure(2)
      if strcmp(compare,'on') & strcmp(get(2,'Name'),title2) %#ok (R11)
        hold on, legend off
        plot(t,p,t,Q)
        hold off
      else
        clf
        set(2,'Name',title2,'NumberTitle','off')
        plot(t,p,t,Q)
        grid on
        legend('Rainfall','Runoff',0)
        xlabel('Time (hr)')
        ylabel(['Depth ',dunit])
        title(['\bf',title2])
      end
    end
  
    if strcmp(plot3,'on')
      figure(3)
      dt=90*tu/Tc;
      % =tu/Tp=tu/(2*(Tc/60)/3)
      du=uu*Tc*64/(K*AA*9);
      % =uu*Tp/(K*(AA/640))=uu*(2*(Tc/60)/3)/(K*AA/640)
      if strcmp(compare,'on') & strcmp(get(3,'Name'),title3) %#ok (R11)
        hold on, legend off
        plot(dt,du,dt,cumtrapz(dt,du)*3*K/1936)
        hold off
      else
        clf
        set(3,'Name',title3,'NumberTitle','off')
        plot(dt,du,dt,cumtrapz(dt,du)*3*K/1936)
        ylim([0,1])
        grid on
        legend('Flow Ratio','Mass Ratio',0)
        xlabel('T/T_p')
        ylabel('Flow-Mass Ratios')
        title(['\bf',title3])
      end
    end
  
    if strcmp(plot4,'on')
      figure(4)
      if strcmp(compare,'on') & strcmp(get(4,'Name'),title4) %#ok (R11)
        hold on, legend off
        plot(tu,u)
        hold off
      else
        clf
        set(4,'Name',title4,'NumberTitle','off')
        plot(tu,u)
        grid on
        xlabel('Time (hr)')
        ylabel(['Runoff ',funit])
        title(['\bf',title4])
      end
    end
    
    if strcmp(plot5,'on')
      figure(5)
      if strcmp(compare,'on') & strcmp(get(5,'Name'),title5) %#ok (R11)
        hold on, legend off
        plot(tq,q)
        hold off
      else
        clf
        set(5,'Name',title5,'NumberTitle','off')
        plot(tq,q)
        grid on
        xlabel('Time (hr)')
        ylabel(['Runoff ',funit])
        title(['\bf',title5])
      end
    end
  
    basin=get(1,'Name');
  
    if strcmp(summary,'on')
      fn=[work,basin,' summary.rpt'];
      fid=fopen(fn,'wt');
      fprintf(fid,'%s\n\n',        '        SCS Unit Hydrograph Convolution');
      fprintf(fid,'%s  %s\n',      '                 Basin Name',basin);
      fprintf(fid,'%s  %s\n',      '            Unit Hydrograph',uhname);
      fprintf(fid,'%s  %s\n',      '      Rainfall Distribution',rdname);
      fprintf(fid,'%s  %s\n',      '       Interpolation Method',method);
      fprintf(fid,'%s  %10.4f\n',  '                Peak Factor',K);
      fprintf(fid,'%s  %10.4f\n',  '        Storm Duration (hr)',D);
      fprintf(fid,'%s  %10.4f\n', ['        Rainfall Depth ',dunit],R);
      fprintf(fid,'%s  %10.4f\n',  '  Initial Abstraction Ratio',Iar);
      fprintf(fid,'%s  %10.4f\n', ['           ',aunit],A);
      fprintf(fid,'%s  %10.4f\n',  '               Curve Number',CN);
      fprintf(fid,'%s  %10.4f\n',  'Time of Concentration (min)',Tc);
      fprintf(fid,'%s  %10.4f\n\n','Output Time Increment (min)',To);
      fprintf(fid,'%s  %10.4f\n', ['          Peak Runoff ',funit],qmax);
      fprintf(fid,'%s  %10.4f\n',  '          Time to Peak (hr)',tmax);
      fprintf(fid,'%s  %10.4f\n', ['         Runoff Volume ',dunit],rvol);
      fprintf(fid,'%s  %10.4f\n', ['Unit Hydrograph Volume ',dunit],uvol);
      fprintf(fid,'%s  %10.4f\n',  '       Computed Peak Factor',cK);
      fclose(fid);
      edit(fn)
    end
  
    if strcmp(detail,'on')
      to=(0:To/60:tq(end))';
      v =cumtrapz(tq,qq)*120/(AA*121);
      % =cumtrapz(tq,qq)*3600*12/(AA*43560);
      qo=interp1(tq,q,to,method);
      vo=interp1(tq,v,to,method);
      vv=AA*vo*3630;
      % =AA*vo*43560/12;
      if units
        vv=vv/cm2cf; vo=vo*25.4;          % m^3 and mm
      end
      fn=[work,basin,' detail.rpt'];
      fid=fopen(fn,'wt');
      fprintf(fid,'%s\n','      SCS Unit Hydrograph Convolution');
      fprintf(fid,'%s\n\n',['      ',basin]);
      fprintf(fid,'%s\n', '      Time      Runoff      Volume      Volume');
      fprintf(fid,'%s\n',['      (hr)       ',funit,'        ',...
        dunit,'        ',vunit]);
      fprintf(fid,'%10.4f  %10.4f  %10.4f  %10.0f\n',[to,qo,vo,vv]');
      fclose(fid);
      edit(fn)
    end
  
  figure(1)
  
  %-----------------------------------------------------------------------
  case 'met'
    met=get(metUI,'Checked');
    if strcmp(met,'off')
      units=1;
      hydrographui('units');
      hydrographui('setunits');
      R=R*25.4;
      set(RUI,'String',num2str(R))
      A=A/sk2ac;
      set(AUI,'String',num2str(A))
      qmax=str2double(get(qmaxUI,'String'))/cm2cf;
      set(qmaxUI,'String',num2str(qmax))
      rvol=str2double(get(rvolUI,'String'))*25.4;
      set(rvolUI,'String',num2str(rvol))
      uvol=str2double(get(uvolUI,'String'))*25.4;
      set(uvolUI,'String',num2str(uvol))
    end
  %-----------------------------------------------------------------------
  case 'imp'
    imp=get(impUI,'Checked');
    if strcmp(imp,'off')
      units=0;
      hydrographui('units');
      hydrographui('setunits');
      R=R/25.4;
      set(RUI,'String',num2str(R))
      A=A*sk2ac;
      set(AUI,'String',num2str(A))
      qmax=str2double(get(qmaxUI,'String'))*cm2cf;
      set(qmaxUI,'String',num2str(qmax))
      rvol=str2double(get(rvolUI,'String'))/25.4;
      set(rvolUI,'String',num2str(rvol))
      uvol=str2double(get(uvolUI,'String'))/25.4;
      set(uvolUI,'String',num2str(uvol))
    end
  %-----------------------------------------------------------------------
  case 'units'
    if units,
      met='on'; imp='off';
      dunit='(mm)'; aunit=['Basin Area (km',char(178),')'];
      funit='(cms)'; vunit=['(m',char(179),')'];
    else
      imp='on'; met='off';
      dunit='(in)'; aunit=' Basin Area (ac)';
      funit='(cfs)'; vunit='(cf)';
    end
  %-----------------------------------------------------------------------
  case 'setunits'
    set(metUI,'Checked',met)
    set(impUI,'Checked',imp)
    set(Runits,'String',['Rainfall Depth ',dunit])
    set(Aunits,'String',aunit)
    set(Funits,'String',['Peak Runoff ',funit])
    set(Vunits,'String',['Runoff Volume ',dunit])
    set(Hunits,'String',['Unit Hydrograph Volume ',dunit])
  %-----------------------------------------------------------------------
  case 'summary'
    summary=get(summaryUI,'Checked');
    if strcmp(summary,'on')
      summary='off';
    else
      summary='on';
    end
    set(summaryUI,'Checked',summary)
  %-----------------------------------------------------------------------
  case 'detail'
    detail=get(detailUI,'Checked');
    if strcmp(detail,'on')
      detail='off';
    else
      detail='on';
    end
    set(detailUI,'Checked',detail)
  %-----------------------------------------------------------------------
  case 'plot2'
    plot2=get(plot2UI,'Checked');
    if strcmp(plot2,'on')
      plot2='off';
    else
      plot2='on';
    end
    set(plot2UI,'Checked',plot2)
  %-----------------------------------------------------------------------
  case 'plot3'
    plot3=get(plot3UI,'Checked');
    if strcmp(plot3,'on')
      plot3='off';
    else
      plot3='on';
    end
    set(plot3UI,'Checked',plot3)
  %-----------------------------------------------------------------------
  case 'plot4'
    plot4=get(plot4UI,'Checked');
    if strcmp(plot4,'on')
      plot4='off';
    else
      plot4='on';
    end
    set(plot4UI,'Checked',plot4)
  %-----------------------------------------------------------------------
  case 'plot5'
    plot5=get(plot5UI,'Checked');
    if strcmp(plot5,'on')
      plot5='off';
    else
      plot5='on';
    end
    set(plot5UI,'Checked',plot5)
  %-----------------------------------------------------------------------
  case 'compare'
    compare=get(compareUI,'Checked');
    if strcmp(compare,'on')
      compare='off';
    else
      compare='on';
    end
    set(compareUI,'Checked',compare)
  %-----------------------------------------------------------------------
  case 'cascade'
    a=23; b=23;
    cascade(a,b)
  %-----------------------------------------------------------------------
  case 'stack'
    a=0; b=0;
    cascade(a,b)
  %-----------------------------------------------------------------------
  case 'duhedit'
    root=cd;
    cd(duhlib)
    [fn,pn]=uigetfile('*.duh','Select Unit Hydrograph');
    cd(root)
    if fn
      edit([pn,fn]);
    end
  %-----------------------------------------------------------------------
  case 'drdedit'
    root=cd;
    cd(drdlib)
    [fn,pn]=uigetfile('*.drd','Select Rainfall Distribution');
    cd(root)
    if fn
      edit([pn,fn]);
    end
  %-----------------------------------------------------------------------
  case 'rptedit'
    root=cd;
    cd(work)
    [fn,pn]=uigetfile('*.rpt','Select Report');
    cd(root)
    if fn
      edit([pn,fn]);
    end
  %-----------------------------------------------------------------------
  case 'config'
    save('config.mat','uhname','rdname','methodndx','K','D','R','Iar',...
      'A','CN','Tc','To','plot2','plot3','plot4','plot5','summary',...
      'detail','duhlib','drdlib','units')
  %-----------------------------------------------------------------------
  case 'save'
    fn=get(1,'Name');
    root=cd;
    cd(work)
    [fn,pn]=uiputfile([fn,'.mat'],'Save Basin');
    cd(root)
    [basin,ext]=strtok(fn,'.');
    if fn & strcmp(ext,'.mat')            %#ok (R11)
      work=pn;
      save([pn,fn],'uhname','rdname','methodndx','K','D','R','Iar','A',...
        'CN','Tc','To','plot2','plot3','plot4','plot5','summary',...
        'detail','duhlib','drdlib','units')
      set(1,'Name',basin);
    end
  %-----------------------------------------------------------------------
  case 'load'
    fn=get(1,'Name');
    root=cd;
    cd(work)
    [fn,pn]=uigetfile([fn,'.mat'],'Load Basin');
    cd(root)
    [basin,ext]=strtok(fn,'.');
    if fn & strcmp(ext,'.mat')            %#ok (R11)
      load([pn,fn]);
      work=pn;
      set(uhUI,'String',uhname)
      set(rdUI,'String',rdname)
      set(methodUI,'Value',methodndx)
      hydrographui('method');
      set(KUI,'String',num2str(K))
      set(RUI,'String',num2str(R))
      set(IarUI,'String',num2str(Iar))
      set(DUI,'String',num2str(D))
      set(AUI,'String',num2str(A))
      set(CNUI,'String',num2str(CN))
      set(TcUI,'String',num2str(Tc))
      set(ToUI,'String',num2str(To))
      set(plot2UI,'Checked',plot2)
      set(plot3UI,'Checked',plot3)
      set(plot4UI,'Checked',plot4)
      set(plot5UI,'Checked',plot5)
      set(summaryUI,'Checked',summary)
      set(detailUI,'Checked',detail)
      set(1,'Name',basin)
      hydrographui('units');
      hydrographui('setunits');
      clrout
    end
  %-----------------------------------------------------------------------
  case 'window'
    set(win1UI,'Label',['&1  ',get(1,'Name')])
    figs=get(0,'children');
    if any(figs==2)
      set(win2UI,'Enable','on')
    else
      set(win2UI,'Enable','off')
    end
    if any(figs==3)
      set(win3UI,'Enable','on')
    else
      set(win3UI,'Enable','off')
    end
    if any(figs==4)
      set(win4UI,'Enable','on')
    else
      set(win4UI,'Enable','off')
    end
    if any(figs==5)
      set(win5UI,'Enable','on')
    else
      set(win5UI,'Enable','off')
    end
  %-----------------------------------------------------------------------
  case 'uhname'
    root=cd;
    cd(duhlib)
    [fn,pn]=uigetfile([uhname,'.duh'],'Select Unit Hydrograph');
    cd(root)
    [fn,ext]=strtok(fn,'.');
    if fn & strcmp(ext,'.duh')            %#ok (R11)
      duhlib=pn;
      uhname=fn;
      set(uhUI,'String',uhname);
      num=str2double(uhname(end-2:end));
      if ~isnan(num)
        set(KUI,'String',num2str(num));
        K=num;
      end
      clrout
    end
  %-----------------------------------------------------------------------
  case 'rdname'
    root=cd;
    cd(drdlib)
    [fn,pn]=uigetfile([rdname,'.drd'],'Select Rainfall Distribution');
    cd(root)
    [fn,ext]=strtok(fn,'.');
    if fn & strcmp(ext,'.drd')            %#ok (R11)
      drdlib=pn;
      rdname=fn;
      set(rdUI,'String',rdname);
      num=str2double(rdname(end-2:end));
      if ~isnan(num)
        set(DUI,'String',num2str(num));
        D=num;
      end
      clrout
    end
  %-----------------------------------------------------------------------
  case 'method'
    methodndx=get(methodUI,'Value');
    lst=get(methodUI,'String');
    method=lst{methodndx};
    method=method(2:end);
    clrout
  %-----------------------------------------------------------------------
  case 'K'
    K=str2double(get(KUI,'String'));
    set(KUI,'String',num2str(K));
    clrout
  %-----------------------------------------------------------------------
  case 'D'
    D=str2double(get(DUI,'String'));
    set(DUI,'String',num2str(D));
    clrout
  %-----------------------------------------------------------------------
  case 'R'
    R=str2double(get(RUI,'String'));
    set(RUI,'String',num2str(R));
    clrout
  %-----------------------------------------------------------------------
  case 'Iar'
    Iar=str2double(get(IarUI,'String'));
    set(IarUI,'String',num2str(Iar));
    clrout
  %-----------------------------------------------------------------------
  case 'A'
    A=str2double(get(AUI,'String'));
    set(AUI,'String',num2str(A));
    clrout
  %-----------------------------------------------------------------------
  case 'CN'
    CN=str2double(get(CNUI,'String'));
    set(CNUI,'String',num2str(CN));
    clrout
  %-----------------------------------------------------------------------
  case 'Tc'
    Tc=str2double(get(TcUI,'String'));
    set(TcUI,'String',num2str(Tc));
    clrout
  %-----------------------------------------------------------------------
  case 'To'
    To=str2double(get(ToUI,'String'));
    set(ToUI,'String',num2str(To));
  %-----------------------------------------------------------------------
  case 'help'
    !helpbrowser &
  %-----------------------------------------------------------------------
  case 'about'
    str=version;
    ver='  Version 2.03      Copyright \copyright 2008';
    if str2double(str(1:3))<6.5
      icon=imread('hydrograph53.png','png');
      if str2double(str(1:3))<6.0
        ver='  Version 2.03     Copyright \copyright 2008';
      end
    else
      icon=imread('hydrograph65.png','png');
    end
    Struct.WindowStyle='modal';
    Struct.Interpreter='tex';
    msgbox({'';'  SCS Unit Hydrograph Convolution'; ver;...
      '  Metzger & Willard, Incorporated';...
      '  http://www.metzgerwillard.com'},'About',...
      'custom',icon,jet,Struct);
  %-----------------------------------------------------------------------
  case 'exit'
    figs=get(0,'Children');
    for fig=figs(figs<6)
      delete(fig)
    end
  %-----------------------------------------------------------------------
  otherwise
    error('Unrecognized task')
    
end

%-------------------------------------------------------------------------

function clrout
% clear output fields
global qmaxUI tmaxUI rvolUI uvolUI
set(qmaxUI,'String','')
set(tmaxUI,'String','')
set(rvolUI,'String','')
set(uvolUI,'String','')

%-------------------------------------------------------------------------

function cascade(a,b)
% cascade or stack plot windows
figs=sort(get(0,'Children'))';
figs=figs(figs>1 & figs<6);
n=length(figs);
if n>1
  fig=figs(n);
  figure(fig)
  set(fig,'Units','pixels');
  position=get(fig,'Position');
  x=position(1);
  y=position(2);
  w=position(3);
  h=position(4);
  j=n;
  for fig=figs
    figure(fig)
    j=j-1;
    set(fig,'Units','pixels','Position',[x-j*b y+j*a w h]);
  end
end
figure(1)

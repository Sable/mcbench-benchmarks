function VoigtSpectrGUI
%this is a GUI program i wrote about simulating absorption lineshape and 
%spectrum from HITRAN output data 
% this program simulate the spectrum using the HITRAN data and 
% Calculating the Voigt porfile According to the paper: 
%   Applied spectro. V58, 468(2004);
%   Phi= A*K(x,y) 
% The lineshape depends on Guassian (vD) width and Lorentzian width(vL). 
% Absorption depends on number density and absorption length, I/I0 = Exp(-aNL);
% Notice the Half Width at Half Maxium for the vD and vL inputs;

    fh = figure('Visible','off','Name','Spectrum Simulation',...
             'position',[50,50, 850, 600]);
         
    hax = axes('Units','pixels','Position',[60,60,500,500]);
    
    %construct the components
    hp = uipanel('Units','pixels','ShadowColor',[0.1,1,0.01],...
              'Position',[628 160 200 430]);
        
    
    hpb1 = uicontrol('Style','pushbutton','String','Open HITRFile',...
          'Foregroundcolor',[1 0.1 0.2],'FontWeight','bold',...
           'Position',[650 540, 110, 30],'Callback',{@fileopen_Callback});
       
    het1 = uicontrol('Style','edit','String','file name',...
           'Foregroundcolor',[0.2 0.4 0.1],'FontWeight','bold',...
           'Position',[650,510,110,30],'Callback',{@edittext_Callback});
       
    hst1 = uicontrol('Style','text', 'String','HWHM[vD vL]/cm-1',...
            'Foregroundcolor',[0.2 0.3 0.3],'FontWeight','bold',...
             'Backgroundcolor',[0.7 0.98 0.98],...
             'Position', [650 470 160 15]);
         
    het2 = uicontrol('Style','edit', 'String','0.003',...
            'Foregroundcolor',[0.30 0.1 1],'FontWeight','bold',...
             'Backgroundcolor',[0.97842 0.98 1],...
             'Position', [650 445 75 20]);     
   
    het3 = uicontrol('Style','edit', 'String','0.006',...
            'Foregroundcolor',[0.30 0.1 1],'FontWeight','bold',...
             'Backgroundcolor',[1 0.99 1],...
             'Position', [735 445 75 20]);     

             
    hst2 = uicontrol('Style','text', 'String','NumDensity/Lightpath/cm',...
            'Foregroundcolor',[0.2 0.3 0.3],'FontWeight','bold',...
             'Backgroundcolor',[0.7 0.98 1],...
             'Position', [650 410 160 15]);
         
    het4 = uicontrol('Style','edit', 'String','1E+10',...
            'Foregroundcolor',[0.30 0.1 1],'FontWeight','bold',...
             'Backgroundcolor',[0.97842 0.98 1],...
             'Position', [650 385 75 20]);     
   
    het5 = uicontrol('Style','edit', 'String','1E+5',...
            'Foregroundcolor',[0.30 0.1 1],'FontWeight','bold',...
             'Backgroundcolor',[1 0.99 1],...
             'Position', [735 385 75 20]);     
         
    hpb2 = uicontrol('Style','pushbutton','String','Simu-LineShape',... 
        'Foregroundcolor',[1 0.1 0.2],'FontWeight','bold',...
           'Position',[650 340, 110, 30],'Callback',{@SimuLS_Callback}); 
       
    het6 = uicontrol('Style','edit', 'String','VoigtWidth',...
        'Foregroundcolor',[0.30 0.1 1],'FontWeight','bold',...
         'Backgroundcolor',[0.4 0.9 0.7],...
         'Position', [735 315 75 20]);         
       
    hpb3 = uicontrol('Style','pushbutton','String','Simu-Absorption',... 
        'Foregroundcolor',[1 0.1 0.2],'FontWeight','bold',...
           'Position',[650 280, 110, 30],'Callback',{@SimuAp_Callback}); 
    
    hpb4 = uicontrol('Style','pushbutton','String','Open ExpSpec',... 
        'Foregroundcolor',[1 0.1 0.2],'FontWeight','bold',...
           'Position',[650 240, 110, 30],'Callback',{@ExpSpectr_Callback});
             
       
    hst4 = uicontrol('Style','text', 'String','Display Options',...       
          'Backgroundcolor',[0.678402 0.98 1],...
            'Foregroundcolor',[0.2 0.3 0.3],'FontWeight','bold',...
             'Position',[650 210 130 15]);       


    hpm = uicontrol('Style','popupmenu',...
                'String',{'LineShape','Absorption','CombinedPlot'},...
                'Foregroundcolor',[0.99 0.01 0.01],'FontWeight','bold',...
                'Value',1,'Position',[690 170 110 30],'Callback',{@popup_Callback});  
            
    
    hp2 = uipanel('Units','pixels','ShadowColor',[0.1 0.1 1],...
               'Position',[628 40 200 100]); 
           
           
    het7 = uicontrol('Style','edit','String','FileName.dat',...
             'Foregroundcolor',[0.2 0.4 0.1],'FontWeight','bold',...
             'Position',[640,105,90,25]);        
           
    hcb1 = uicontrol('Style','checkbox','String','Line Shape',...
                'Position',[655 75 85 25],'Foregroundcolor',[0.2 0.3 0.9]);
    hcb2 = uicontrol('Style','checkbox','String','Absorption',...
                'Position',[655 50 85 25],'Foregroundcolor',[0.2 0.3 0.9]);
    
    hpb5 = uicontrol('Style','pushbutton','String','Save',... 
              'Foregroundcolor',[0.6 0.2 0.3],'FontWeight','bold',...
              'Position',[750 66, 60, 50],'Callback',{@save_Callback});
       
      % to align the controls
    align([hp,het1,het6,hpb1,hpb2,hpb3,hpb4,hst1,hst2,hst4,hpm,hp2],'Center','None');

    % Initialize the GUI.
    % Change units to normalized so components resize automatically.
    set([hp,het1,het2,het3,het4,het5,het6,het7,hpb1,hpb2,hax,hst1,hst2,...
       hst4,hpm,hpb3,hpb4,hp2,hcb1,hcb2,hpb5],'Units','normalized');
   
    %make figure visible.
    set(fh, 'Visible','on');
    set(fh, 'NumberTitle','off')%% supress the NumverTitle
    
    % define some variables
    format long e ; %% define numerical format
    stp=0.0002; %% calculation(convolution) stepsize 
    Dd = 0.5; %% define the edge extended beyond the spectrum region
    Nd = 1E+10; %% Number density
    L  = 1E+5; %% Optical path length cm
   
    gL = 0.001; %% in cm -1, pressure broadening cofffient at 50 torr.
    gD = 0.003; %% 0.0032 doppler broadening in cm-1
    SgmvTot= zeros(1,10);  %% initiate the arrays
    expx = zeros(1,10); 
    expy = zeros(1,10);
    A = zeros(1,10);
    dtfl = zeros(1,10);
    grd = zeros(1,10); %% default grid
    
    %%file open callback
    function fileopen_Callback(source,eventdata)
        % **********uiputfile for open the save file dialog*********
        
        [flnm, flpth] = uigetfile({'*.out','All Files' },...
                         'Select HITRAN outputfile','fl.out');
        %specify application data, so it can be used by other objects;
        % setappdata(h,'name',value) 
        setappdata(hpb1,'fname',flnm);
        
        set(het1, 'String',flnm);
        % set the edit text box value.
    
     end
   
  % read in the HITRAN data and simulate Line Shape spectrum
    function SimuLS_Callback(source, eventdata)%callback is just a regular func
        
        format long e ;
        % get the value of specified data
        % value = getappdata(h,name)
        % values = getappdata(h)
        flnm = getappdata(hpb1,'fname');
        
        fid = fopen(flnm);
        C = textscan(fid,...
        '%d%f%f%u%f%f%f%f %d%d%d%d%d %d%d%d%d %d%d%d%d %d%d%d%d%d%d%d%d%d%d%d%d%d ');
        fclose(fid);  %% returned C is a cell 
        
        N = length(C{2}); %% Number of lines/ Cell length
        %% define a grid
        rangeL= -Dd + min(C{2});  %% spectrum region: First line minus 1 cm-1
        rangeH = Dd + max(C{2}); %% Last line position + 1 cm-1
        grd=[rangeL:stp:rangeH];  %% define the grid
 
        v = grd;
        gD = str2num(get(het2, 'string'));
        gL = str2num(get(het3, 'string'));
        gV = 0.5346*gL + sqrt(0.2166*gL^2 + gD^2); %% Voigt profile half width
        x = gL/gV;
        SgmvTot = 0;
        
        for i=1:N  %% calculate the line shape for each peak
    
            v0(i) = C{2}(i);
            S(i) = C{3}(i);
            y = abs(v-v0(i))/gV;
            Sgmv0(i) = S(i)/(2*gV*(1.065 + 0.447*x + 0.058*x^2));
            Sgmv = Sgmv0(i)*((1-x)*exp(-0.693.*y.^2) + (x./(1+y.^2)) + ...
              0.016*(1-x)*x*(exp(-0.0841.*y.^2.25)-1./(1 + 0.021.*y.^2.25)));
    
         SgmvTot = SgmvTot + Sgmv; 
    
        end

        plot(grd,SgmvTot,'-b.');
        xlabel('WaveLength in cm-1');
        ylabel('Effective absorption Cross Section in cm2');
        
        set(hpm, 'Value',1)% change the popup menu settings;
        
        %% display the Voigt width;
        strg = sprintf('gV= %1.4f',gV);
        set(het6,'string',strg);
        set(het6,'Backgroundcolor',[0.9 0.9 0.9])

        %%figure, plot(v,A);
        %%ylabel('Absorption')
    end
  

    function SimuAp_Callback(source, eventdata)      
        %% calculate absorption
        
        Nd = str2num(get(het4, 'string')); %% Number density in molecule/cm3
        L = str2num(get(het5, 'string')); %% effective length path in cm
        A = 1 - exp(-SgmvTot.*Nd*L); %% I/I0 = Exp(-aNL);
        
        plot(grd,A,'-m');
        xlabel('WaveLength in cm-1'); 
        set(hpm, 'Value',2)% change the popup menu settings;
        
    end


    %slice X callback
    function ExpSpectr_Callback(source, eventdata)
        
        format long e ;
        [flnm, flpth] = uigetfile({'*.dat','All Files' },'Select Exp. file','ExpSpectr.dat');
        fid = fopen(flnm, 'r');
        a = fscanf(fid, '%f %f', [2 inf]);    % It has two rows now.
        a = a';
        fclose(fid)
        expx = a(:,1);
        expy = a(:,2);
        hold on;
        plot3 = plot(expx,expy,'-.b');
        ylabel('Absorption')
        
        hold off;
  
    end


   %popup menu callback
    function popup_Callback(source,eventdata)
        str = get(source, 'String');
        val = get(hpm, 'Value'); %use either function handle 'hpm' or 'source';
        % the string of popup menu is a cell array {}, cell{num} returns num th
        % element of the cell.
        switch val
        case 1  %'showImage'   
             %disp(str{val});
                hold off;
                plot(grd,SgmvTot,'-b.');
                xlabel('WaveLength in cm-1')
                ylabel('Effective absorption Cross Section in cm2')
              
        case 2 
                hold off;
                plot(grd,A,'-m');
            
        case 3 %combined plot
                hold on;
                plot(expx,expy,'-.b');
                ylabel('Absorption')
        
                hold off;
            
        end
    end
    

    function save_Callback(source, eventdata)
       
        if get(hcb1,'Value')> 0.9 % it should be 1.0   
            dtfl = [grd;SgmvTot]; %% create a data matrix for data saving
            fid = fopen(get(het7, 'string'), 'wt');
            fprintf(fid, '%6.4f %e\n', dtfl); %% set the data format
            fclose(fid);
  
        end
           
        if get(hcb2,'Value')> 0.9 % it should be 1.0 
                
           dtfl = [grd;A]; %% create a data matrix for data saving
           fid = fopen(get(het7, 'string'), 'wt');
           fprintf(fid, '%6.4f %5.6f\n', dtfl); %% set the data format
           fclose(fid);  
        end   
        
        if get(hcb1,'Value')> 0.9 && get(hcb2,'Value')> 0.9 % it should be 1.0 
                
            dtfl = [grd;SgmvTot;A]; %% create a data matrix for data saving
                            
            fid = fopen(get(het7, 'string'), 'wt');
            fprintf(fid, '%6.4f %e %5.6f\n', dtfl); %% set the data format
            fclose(fid);
 
        end
    end

%%% read in the HITRAN file to obtain line positions and intensities.
end


function drawDATCOMaircraft(datcominputfile)

%--------------------------------------------------------------------------
%viewDATCOMaircraft
%Version 1.00
%Created by Stepen
%Created 6 November 2011
%Last modified 20 November 2011
%--------------------------------------------------------------------------
%viewDATCOMaircraft reads a DATCOM input file written in ASCI formats and
%draws simplified three view drawing of the aircraft defined by the input
%file.
%--------------------------------------------------------------------------
%Syntax:
%drawDATCOMaircraft(datcominputfile)
%Input argument:
%datcominputfile (str) specifies file address and file name for DATCOM
%input file to be read.
%--------------------------------------------------------------------------

%CodeStart-----------------------------------------------------------------
%Defining input (Comment this section to treat this m-files as function)
    clc
    clear
    datcominputfile=['D:\Personal Project Workspace\',...
                     'MATLAB - ACD Toolbox\PublishedCode\'...
                     'drawDATCOMaircraft\TestCase\',...
                     'TestCase05.dat'];
%Reading line by line datcom input file
    dcmstring=cell(1,1);
    tempdat=fopen(datcominputfile);
    count=1;
    tempstr='';
    while ischar(tempstr)
        tempstr=fgetl(tempdat);
        %Ignoring blank line and comment line
        if ~isempty(tempstr)
        if ~strcmp(tempstr(1),'*')
            dcmstring{count,1}=tempstr;
            count=count+1;
        end
        end
    end
    fclose(tempdat);
    clear('tempdat','tempstr')
%Defining custom variable for airfoil thickness and geometry
    WAT=0.05;
    HAT=0.05;
    VAT=0.05;
    VFAT=0.05;
    xafl_f=[0,0.0123116594048622,0.0489434837048465,0.108993475811632,...
            0.190983005625053,0.292893218813453];
    xafl_r=[0.292893218813453,0.412214747707527,...
            0.546009500260453,0.690983005625053,0.843565534959769,1];
    yafl_f=[0,0.0188036221875515,0.0352243977012065,0.0482776739701557,...
            0.0568242985323753,0.0600062953297346]/0.12;
    yafl_r=[0.0600062953297346,0.0575526726791933,...
            0.0498151946968353,0.0375106087229983,0.0212787901073766,...
            0]/0.12;
%Extracting and separating each namecard from dcmstring
    %Defining list of namecard to be extracted
    namecardlist={'SYNTHS','BODY','WGPLNF','HTPLNF','VTPLNF','VFPLNF',...
                  'TVTPAN','WGSCHR','HTSCHR','VTSCHR','VFSCHR'};
    %Performing extraction
        for namecardid=1:numel(namecardlist)
        %Finding the desired namecard
        namecardstat=zeros(numel(dcmstring),1);
        tempstat=0;
        for count=1:numel(dcmstring)
            if tempstat==0
                if strfind(dcmstring{count},namecardlist{namecardid})
                    namecardstat(count)=1;
                    if sum(dcmstring{count}=='$')==1
                        tempstat=1;
                    end
                end
            else
                namecardstat(count)=1;
                if sum(dcmstring{count}=='$')==1
                    tempstat=0;
                end
            end
        end
        %Extracting string for the desired namecard
        namecardstring=cell(sum(namecardstat),1);
        count2=1;
        for count1=1:numel(dcmstring)
            if namecardstat(count1)==1
                namecardstring{count2}=dcmstring{count1};
                count2=count2+1;
            end
        end
        %Storing string
        if namecardid==1
            synthstring=namecardstring;
            if isempty(synthstring)
                synthstat=0;
            else
                synthstat=1;
            end
        elseif namecardid==2
            bodystring=namecardstring;
            if isempty(bodystring)
                bodystat=0;
            else
                bodystat=1;
            end
        elseif namecardid==3
            wingstring=namecardstring;
            if isempty(wingstring)
                wingstat=0;
            else
                wingstat=1;
            end
        elseif namecardid==4
            htpstring=namecardstring;
            if isempty(htpstring)
                htpstat=0;
            else
                htpstat=1;
            end
        elseif namecardid==5
            vtpstring=namecardstring;
            if isempty(vtpstring)
                vtpstat=0;
            else
                vtpstat=1;
            end
        elseif namecardid==6
            vfpstring=namecardstring;
            if isempty(vfpstring)
                vfpstat=0;
            else
                vfpstat=1;
            end
        elseif namecardid==7
            tvtstring=namecardstring;
            if isempty(tvtstring)
                tvtstat=0;
            else
                tvtstat=1;
            end
        elseif namecardid==8
            waflstring=namecardstring;
            if isempty(waflstring)
                waflstat=0;
            else
                waflstat=1;
            end
        elseif namecardid==9
            haflstring=namecardstring;
            if isempty(haflstring)
                haflstat=0;
            else
                haflstat=1;
            end
        elseif namecardid==10
            vaflstring=namecardstring;
            if isempty(vaflstring)
                vaflstat=0;
            else
                vaflstat=1;
            end
        elseif namecardid==11
            vfaflstring=namecardstring;
            if isempty(vfaflstring)
                vfaflstat=0;
            else
                vfaflstat=1;
            end
        end
        end
%Extracting aircraft configuration parameters
    prop={'XCG=','ZCG=','XW=','ZW=','XH=','ZH=','XV=','ZV=','XVF=','ZVF='};
    temparray=zeros(numel(prop),1);
    for propcount=1:numel(prop)
        %Finding SYNTH parameter from synthstring
        if synthstat==1
            for count=1:numel(synthstring)
                if strfind(synthstring{count},prop{propcount})
                    tempstr=synthstring{count}...
                                       (strfind(synthstring{count},...
                                                prop{propcount})+...
                                        numel(prop{propcount}):end);
                    tempcell=textscan(tempstr,'%f');
                    tempval=tempcell{1};
                    break
                end
            end
            clear('tempstr','tempcell')
        end
        if exist('tempval','var')
            temparray(propcount)=tempval;
        end
        clear('tempval')
    end
%Assigning variables for aircraft configuration parameters
    XCG=temparray(1);ZCG=temparray(2);XW=temparray(3);ZW=temparray(4);
    XH=temparray(5);ZH=temparray(6);XV=temparray(7);ZV=temparray(8);
    XVF=temparray(9);ZVF=temparray(10);
%Reading fuselage geometry
    if bodystat==1
        %Extracting fuselage station number
        for count=1:numel(bodystring)
            if strfind(bodystring{count},'NX')
                tempstr=bodystring{count}...
                                  (strfind(bodystring{count},'NX')+3:end);
                tempcell=textscan(tempstr,'%f');
                NX=tempcell{1};
                break
            end
        end
        clear('tempstr','tempcell')
        %Generating format for textscan
        bodyscanformat='%f';
        for count=2:NX
            bodyscanformat=[bodyscanformat,',%f'];
        end
        %Extracting station related properties
        prop={'X(1)','ZU(1)','ZL(1)','R(1)','P(1)','S(1)'};
        for propcount=1:numel(prop)
            for count=1:numel(bodystring)
                if strfind(bodystring{count},prop{propcount})
                    tempstr=bodystring{count}...
                                      (strfind(bodystring{count},...
                                               prop{propcount})+...
                                       numel(prop{propcount})+1:...
                                       end);
                    tempcell=textscan(tempstr,bodyscanformat);
                    tempval=[];
                    for tempcount=1:numel(tempcell)
                        if ~isempty(tempcell{tempcount})
                            tempval=[tempval,tempcell{tempcount}];
                        else
                            break
                        end
                    end
                    temparray=tempval;
                    i=1;
                    while numel(temparray)<NX
                        tempstr=bodystring{count+i};
                        tempcell=textscan(tempstr,bodyscanformat);
                        tempval=[];
                        for tempcount=1:numel(tempcell)
                            if ~isempty(tempcell{tempcount})
                                tempval=[tempval,tempcell{tempcount}];
                            else
                                break
                            end
                        end
                        temparray=[temparray,tempval];
                        i=i+1;
                    end
                    break
                end
            end
            clear('tempstr','tempcell','tempval')
            if exist('temparray','var')
                if propcount==1
                    X=temparray;
                elseif propcount==2
                    ZU=temparray;
                elseif propcount==3
                    ZL=temparray;
                elseif propcount==4
                    R=temparray;
                elseif propcount==5
                    P=temparray;
                elseif propcount==6
                    S=temparray;
                end
                clear('temparray')
            end
        end
        %Extracting single value properties
        prop={'BNOSE','BTAIL','BLN','BLA','DS'};
        for propcount=1:numel(prop)
        for count=1:numel(bodystring)
            if strfind(bodystring{count},prop{propcount})
                tempstr=bodystring{count}...
                                  (strfind(bodystring{count},...
                                           prop{propcount})+...
                                   numel(prop{propcount})+1:end);
                tempcell=textscan(tempstr,'%f');
                tempval=tempcell{1};
                break
            end
        end
        clear('tempstr','tempcell')
        if exist('tempval','var')
            if propcount==1
                BNOSE=tempval;
            elseif propcount==2
                BTAIL=tempval;
            elseif propcount==3
                BLN=tempval;
            elseif propcount==4
                BLA=tempval;
            elseif propcount==5
                DS=tempval;
            end
        end
        clear('tempval')
        end
    end
%Reading wing geometry
    %Extracting wing planform properties
    if wingstat==1
        prop={'CHRDTP=','CHRDBP=','CHRDR=',...
              'SSPNOP=','SSPNE=','SSPN=','SSPNDO=',...
              'SAVSI=','SAVSO=','TWISTA=','DHDADI=','DHDADO=',...
              'TYPE=','CHSTAT='};
        for propcount=1:numel(prop)
        for count=1:numel(wingstring)
            if strfind(wingstring{count},prop{propcount})
                tempstr=wingstring{count}...
                                  (strfind(wingstring{count},...
                                           prop{propcount})+...
                                   numel(prop{propcount}):end);
                tempcell=textscan(tempstr,'%f');
                tempval=tempcell{1};
                break
            end
        end
        clear('tempstr','tempcell')
        if exist('tempval','var')
            if propcount==1
                WCHRDTP=tempval;
            elseif propcount==2
                WCHRDBP=tempval;
            elseif propcount==3
                WCHRDR=tempval;
            elseif propcount==4
                WSSPNOP=tempval;
            elseif propcount==5
                WSSPNE=tempval;
            elseif propcount==6
                WSSPN=tempval;
            elseif propcount==7
                WSSPNDO=tempval;
            elseif propcount==8
                WSAVSI=tempval;
            elseif propcount==9
                WSAVSO=tempval;
            elseif propcount==10
                WTWISTA=tempval;
            elseif propcount==11
                WDHDADI=tempval;
            elseif propcount==12
                WDHDADO=tempval;
            elseif propcount==13
                WTYPE=tempval;
            elseif propcount==14
                WCHSTAT=tempval;
            end
        end
        clear('tempval')
        end
    end
    %Extracting wing cross-section properties
    if waflstat==1
        %Extracting wing airfoil's point number
        for count=1:numel(waflstring)
            if strfind(waflstring{count},'NPTS')
                tempstr=waflstring{count}...
                                  (strfind(waflstring{count},'NPTS')+5:...
                                   end);
                tempcell=textscan(tempstr,'%f');
                WAFLNX=tempcell{1};
                break
            end
        end
        clear('tempstr','tempcell')
        %Generating format for textscan
        if exist('WAFLNX','var')
        waflscanformat='%f';
        for count=2:WAFLNX
            waflscanformat=[waflscanformat,',%f'];
        end
        end
        %Extracting wing airfoil geometry
        if exist('WAFLNX','var')
        prop={'XCORD(1)','MEAN(1)','THICK(1)','YUPPER(1)','YLOWER(1)'};
        for propcount=1:numel(prop)
            for count=1:numel(waflstring)
                if strfind(waflstring{count},prop{propcount})
                    tempstr=waflstring{count}...
                                      (strfind(waflstring{count},...
                                               prop{propcount})+...
                                       numel(prop{propcount})+1:...
                                       end);
                    tempcell=textscan(tempstr,waflscanformat);
                    tempval=[];
                    for tempcount=1:numel(tempcell)
                        if ~isempty(tempcell{tempcount})
                            tempval=[tempval,tempcell{tempcount}];
                        else
                            break
                        end
                    end
                    temparray=tempval;
                    i=1;
                    while numel(temparray)<WAFLNX
                        tempstr=waflstring{count+i};
                        tempcell=textscan(tempstr,waflscanformat);
                        tempval=[];
                        for tempcount=1:numel(tempcell)
                            if ~isempty(tempcell{tempcount})
                                tempval=[tempval,tempcell{tempcount}];
                            else
                                break
                            end
                        end
                        temparray=[temparray,tempval];
                        i=i+1;
                    end
                    break
                end
            end
            clear('tempstr','tempcell','tempval')
            if exist('temparray','var')
                if propcount==1
                    WAFLX=temparray;
                elseif propcount==2
                    WAFLMEAN=temparray;
                elseif propcount==3
                    WAFLTHICK=temparray;
                elseif propcount==4
                    WAFLYU=temparray;
                elseif propcount==5
                    WAFLYL=temparray;
                end
                clear('temparray')
            end
        end
        end
    else
        %Extracting NACA airfoil from dcmstring
        for count=1:numel(dcmstring)
            if strfind(dcmstring{count},'NACA-W-')
                tempstr=dcmstring{count}...
                                 (strfind(dcmstring{count},...
                                          'NACA-W-')+7);
                WNACATYPE=str2double(tempstr);
                if (WNACATYPE==4)||(WNACATYPE==5)||...
                   ((WNACATYPE==6)&&...
                   (~strcmp(dcmstring{count}...
                                     ((strfind(dcmstring{count},...
                                               'NACA-W-'))+12),'-')))
                    tempval=WNACATYPE;
                elseif (WNACATYPE==6)&&...
                       (strcmp(dcmstring{count}...
                                        ((strfind(dcmstring{count},...
                                                  'NACA-W-'))+12),'-'))
                    tempval=WNACATYPE+1;
                elseif WNACATYPE==1
                    tempval=5;
                end
                tempstr=dcmstring{count}...
                                 ((strfind(dcmstring{count},...
                                           'NACA-W-'))+9:...
                                  (strfind(dcmstring{count},...
                                           'NACA-W-')+8+tempval));
                WNACA=tempstr;
                break
            end
            if strfind(dcmstring{count},'NACA W ')
                tempstr=dcmstring{count}...
                                 (strfind(dcmstring{count},...
                                          'NACA W ')+7);
                WNACATYPE=str2double(tempstr);
                if (WNACATYPE==4)||(WNACATYPE==5)||...
                   ((WNACATYPE==6)&&...
                   (~strcmp(dcmstring{count}...
                                     ((strfind(dcmstring{count},...
                                               'NACA-W-'))+12),'-')))
                    tempval=WNACATYPE;
                elseif (WNACATYPE==6)&&...
                       (strcmp(dcmstring{count}...
                                        ((strfind(dcmstring{count},...
                                                  'NACA-W-'))+12),'-'))
                    tempval=WNACATYPE+1;
                elseif WNACATYPE==1
                    tempval=5;
                end
                tempstr=dcmstring{count}...
                                 ((strfind(dcmstring{count},...
                                           'NACA W '))+9:...
                                  (strfind(dcmstring{count},...
                                           'NACA W ')+8+tempval));
                WNACA=tempstr;
                break
            end
        end
        clear('tempstr')
        %Generating NACA airfoil geometry
        if exist('WNACA','var')
            try
                [WAFLX,WAFLYU,WAFLYL]=generateNACAairfoil(WNACATYPE,WNACA);
                waflstat=1;
                drawwingafl=1;
            catch
                waflstat=0;
                drawwingafl=0;
                disp(['Unexpected wing airfoil parameter!',...
                      ' Wing airfoil will not be drawn!'])
            end
        else
            waflstat=0;
            drawwingafl=0;
            disp(['Unexpected wing airfoil parameter!',...
                  ' Wing airfoil will not be drawn!'])
        end
    end
%Reading horizontal tail geometry
    %Extracting horizontal tail planform properties
    if htpstat==1
        prop={'CHRDTP=','CHRDBP=','CHRDR=',...
              'SSPNOP=','SSPNE=','SSPN=','SSPNDO=',...
              'SAVSI=','SAVSO=','TWISTA=','DHDADI=','DHDADO=',...
              'TYPE=','CHSTAT='};
        for propcount=1:numel(prop)
        for count=1:numel(htpstring)
            if strfind(htpstring{count},prop{propcount})
                tempstr=htpstring{count}...
                                  (strfind(htpstring{count},...
                                           prop{propcount})+...
                                   numel(prop{propcount}):end);
                tempcell=textscan(tempstr,'%f');
                tempval=tempcell{1};
                break
            end
        end
        clear('tempstr','tempcell')
        if exist('tempval','var')
            if propcount==1
                HCHRDTP=tempval;
            elseif propcount==2
                HCHRDBP=tempval;
            elseif propcount==3
                HCHRDR=tempval;
            elseif propcount==4
                HSSPNOP=tempval;
            elseif propcount==5
                HSSPNE=tempval;
            elseif propcount==6
                HSSPN=tempval;
            elseif propcount==7
                HSSPNDO=tempval;
            elseif propcount==8
                HSAVSI=tempval;
            elseif propcount==9
                HSAVSO=tempval;
            elseif propcount==10
                HTWISTA=tempval;
            elseif propcount==11
                HDHDADI=tempval;
            elseif propcount==12
                HDHDADO=tempval;
            elseif propcount==13
                HTYPE=tempval;
            elseif propcount==14
                HCHSTAT=tempval;
            end
        end
        clear('tempval')
        end
    end
    %Extracting horizontal tail cross-section properties
    if haflstat==1
        %Extracting horizontal tail airfoil's point number
        for count=1:numel(haflstring)
            if strfind(haflstring{count},'NPTS')
                tempstr=haflstring{count}...
                                  (strfind(haflstring{count},'NPTS')+5:...
                                   end);
                tempcell=textscan(tempstr,'%f');
                HAFLNX=tempcell{1};
                break
            end
        end
        clear('tempstr','tempcell')
        %Generating format for textscan
        if exist('HAFLNX','var')
        haflscanformat='%f';
        for count=2:HAFLNX
            haflscanformat=[haflscanformat,',%f'];
        end
        end
        %Extracting horizontal tail airfoil geometry
        if exist('HAFLNX','var')
        prop={'XCORD(1)','MEAN(1)','THICK(1)','YUPPER(1)','YLOWER(1)'};
        for propcount=1:numel(prop)
            for count=1:numel(haflstring)
                if strfind(haflstring{count},prop{propcount})
                    tempstr=haflstring{count}...
                                      (strfind(haflstring{count},...
                                               prop{propcount})+...
                                       numel(prop{propcount})+1:...
                                       end);
                    tempcell=textscan(tempstr,haflscanformat);
                    tempval=[];
                    for tempcount=1:numel(tempcell)
                        if ~isempty(tempcell{tempcount})
                            tempval=[tempval,tempcell{tempcount}];
                        else
                            break
                        end
                    end
                    temparray=tempval;
                    i=1;
                    while numel(temparray)<HAFLNX
                        tempstr=haflstring{count+i};
                        tempcell=textscan(tempstr,haflscanformat);
                        tempval=[];
                        for tempcount=1:numel(tempcell)
                            if ~isempty(tempcell{tempcount})
                                tempval=[tempval,tempcell{tempcount}];
                            else
                                break
                            end
                        end
                        temparray=[temparray,tempval];
                        i=i+1;
                    end
                    break
                end
            end
            clear('tempstr','tempcell','tempval')
            if exist('temparray','var')
                if propcount==1
                    HAFLX=temparray;
                elseif propcount==2
                    HAFLMEAN=temparray;
                elseif propcount==3
                    HAFLTHICK=temparray;
                elseif propcount==4
                    HAFLYU=temparray;
                elseif propcount==5
                    HAFLYL=temparray;
                end
                clear('temparray')
            end
        end
        end
    else
        %Extracting NACA airfoil from dcmstring
        for count=1:numel(dcmstring)
            if strfind(dcmstring{count},'NACA-H-')
                tempstr=dcmstring{count}...
                                 (strfind(dcmstring{count},...
                                          'NACA-H-')+7);
                HNACATYPE=str2double(tempstr);
                if (HNACATYPE==4)||(HNACATYPE==5)||...
                   ((HNACATYPE==6)&&...
                   (~strcmp(dcmstring{count}...
                                     ((strfind(dcmstring{count},...
                                               'NACA-H-'))+12),'-')))
                    tempval=HNACATYPE;
                elseif (HNACATYPE==6)&&...
                       (strcmp(dcmstring{count}...
                                        ((strfind(dcmstring{count},...
                                                  'NACA-H-'))+12),'-'))
                    tempval=HNACATYPE+1;
                elseif HNACATYPE==1
                    tempval=5;
                end
                tempstr=dcmstring{count}...
                                 ((strfind(dcmstring{count},...
                                           'NACA-H-'))+9:...
                                  (strfind(dcmstring{count},...
                                           'NACA-H-')+8+tempval));
                HNACA=tempstr;
                break
            end
            if strfind(dcmstring{count},'NACA H ')
                tempstr=dcmstring{count}...
                                 (strfind(dcmstring{count},...
                                          'NACA H ')+7);
                HNACATYPE=str2double(tempstr);
                if (HNACATYPE==4)||(HNACATYPE==5)||...
                   ((HNACATYPE==6)&&...
                   (~strcmp(dcmstring{count}...
                                     ((strfind(dcmstring{count},...
                                               'NACA-H-'))+12),'-')))
                    tempval=HNACATYPE;
                elseif (HNACATYPE==6)&&...
                       (strcmp(dcmstring{count}...
                                        ((strfind(dcmstring{count},...
                                                  'NACA-H-'))+12),'-'))
                    tempval=HNACATYPE+1;
                elseif HNACATYPE==1
                    tempval=5;
                end
                tempstr=dcmstring{count}...
                                 ((strfind(dcmstring{count},...
                                           'NACA H '))+9:...
                                  (strfind(dcmstring{count},...
                                           'NACA H ')+8+tempval));
                HNACA=tempstr;
                break
            end
        end
        clear('tempstr')
        %Generating NACA airfoil geometry
        if exist('HNACA','var')
            try
                [HAFLX,HAFLYU,HAFLYL]=generateNACAairfoil(HNACATYPE,HNACA);
                haflstat=1;
                drawhtpafl=1;
            catch
                haflstat=0;
                drawhtpafl=0;
                disp(['Unexpected horizontal tail airfoil parameter!',...
                      ' Horizontal tail airfoil will not be drawn!'])
            end
        else
            haflstat=0;
            drawhtpafl=0;
            disp(['Unexpected horizontal tail airfoil parameter!',...
                  ' Horizontal tail airfoil will not be drawn!'])
        end
    end
%Reading vertical tail geometry
    %Extracting vertical tail planform properties
    if vtpstat==1
        prop={'CHRDTP=','CHRDBP=','CHRDR=',...
              'SSPNOP=','SSPNE=','SSPN=',...
              'SAVSI=','SAVSO=',...
              'TYPE=','CHSTAT='};
        for propcount=1:numel(prop)
        for count=1:numel(vtpstring)
            if strfind(vtpstring{count},prop{propcount})
                tempstr=vtpstring{count}...
                                  (strfind(vtpstring{count},...
                                           prop{propcount})+...
                                   numel(prop{propcount}):end);
                tempcell=textscan(tempstr,'%f');
                tempval=tempcell{1};
                break
            end
        end
        clear('tempstr','tempcell')
        if exist('tempval','var')
            if propcount==1
                VCHRDTP=tempval;
            elseif propcount==2
                VCHRDBP=tempval;
            elseif propcount==3
                VCHRDR=tempval;
            elseif propcount==4
                VSSPNOP=tempval;
            elseif propcount==5
                VSSPNE=tempval;
            elseif propcount==6
                VSSPN=tempval;
            elseif propcount==7
                VSAVSI=tempval;
            elseif propcount==8
                VSAVSO=tempval;
            elseif propcount==9
                VTYPE=tempval;
            elseif propcount==10
                VCHSTAT=tempval;
            end
        end
        clear('tempval')
        end
    end
    %Extracting vertical tail cross-section properties
    if vaflstat==1
        %Extracting vertical tail airfoil's point number
        for count=1:numel(vaflstring)
            if strfind(vaflstring{count},'NPTS')
                tempstr=vaflstring{count}...
                                  (strfind(vaflstring{count},'NPTS')+5:...
                                   end);
                tempcell=textscan(tempstr,'%f');
                VAFLNX=tempcell{1};
                break
            end
        end
        clear('tempstr','tempcell')
        %Generating format for textscan
        if exist('VAFLNX','var')
        vaflscanformat='%f';
        for count=2:VAFLNX
            vaflscanformat=[vaflscanformat,',%f'];
        end
        end
        %Extracting horizontal tail airfoil geometry
        if exist('VAFLNX','var')
        prop={'XCORD(1)','MEAN(1)','THICK(1)','YUPPER(1)','YLOWER(1)'};
        for propcount=1:numel(prop)
            for count=1:numel(vaflstring)
                if strfind(vaflstring{count},prop{propcount})
                    tempstr=vaflstring{count}...
                                      (strfind(vaflstring{count},...
                                               prop{propcount})+...
                                       numel(prop{propcount})+1:...
                                       end);
                    tempcell=textscan(tempstr,vaflscanformat);
                    tempval=[];
                    for tempcount=1:numel(tempcell)
                        if ~isempty(tempcell{tempcount})
                            tempval=[tempval,tempcell{tempcount}];
                        else
                            break
                        end
                    end
                    temparray=tempval;
                    i=1;
                    while numel(temparray)<VAFLNX
                        tempstr=vaflstring{count+i};
                        tempcell=textscan(tempstr,vaflscanformat);
                        tempval=[];
                        for tempcount=1:numel(tempcell)
                            if ~isempty(tempcell{tempcount})
                                tempval=[tempval,tempcell{tempcount}];
                            else
                                break
                            end
                        end
                        temparray=[temparray,tempval];
                        i=i+1;
                    end
                    break
                end
            end
            clear('tempstr','tempcell','tempval')
            if exist('temparray','var')
                if propcount==1
                    VAFLX=temparray;
                elseif propcount==2
                    VAFLMEAN=temparray;
                elseif propcount==3
                    VAFLTHICK=temparray;
                elseif propcount==4
                    VAFLYU=temparray;
                elseif propcount==5
                    VAFLYL=temparray;
                end
                clear('temparray')
            end
        end
        end
    else
        %Extracting NACA airfoil from dcmstring
        for count=1:numel(dcmstring)
            if strfind(dcmstring{count},'NACA-V-')
                tempstr=dcmstring{count}...
                                 (strfind(dcmstring{count},...
                                          'NACA-V-')+7);
                VNACATYPE=str2double(tempstr);
                if (VNACATYPE==4)||(VNACATYPE==5)||...
                   ((VNACATYPE==6)&&...
                   (~strcmp(dcmstring{count}...
                                     ((strfind(dcmstring{count},...
                                               'NACA-V-'))+12),'-')))
                    tempval=VNACATYPE;
                elseif (VNACATYPE==6)&&...
                       (strcmp(dcmstring{count}...
                                        ((strfind(dcmstring{count},...
                                                  'NACA-V-'))+12),'-'))
                    tempval=VNACATYPE+1;
                elseif VNACATYPE==1
                    tempval=5;
                end
                tempstr=dcmstring{count}...
                                 ((strfind(dcmstring{count},...
                                           'NACA-V-'))+9:...
                                  (strfind(dcmstring{count},...
                                           'NACA-V-')+8+tempval));
                VNACA=tempstr;
                break
            end
            if strfind(dcmstring{count},'NACA V ')
                tempstr=dcmstring{count}...
                                 (strfind(dcmstring{count},...
                                          'NACA V ')+7);
                VNACATYPE=str2double(tempstr);
                if (VNACATYPE==4)||(VNACATYPE==5)||...
                   ((VNACATYPE==6)&&...
                   (~strcmp(dcmstring{count}...
                                     ((strfind(dcmstring{count},...
                                               'NACA-V-'))+12),'-')))
                    tempval=VNACATYPE;
                elseif (VNACATYPE==6)&&...
                       (strcmp(dcmstring{count}...
                                        ((strfind(dcmstring{count},...
                                                  'NACA-V-'))+12),'-'))
                    tempval=VNACATYPE+1;
                elseif VNACATYPE==1
                    tempval=5;
                end
                tempstr=dcmstring{count}...
                                 ((strfind(dcmstring{count},...
                                           'NACA V '))+9:...
                                  (strfind(dcmstring{count},...
                                           'NACA V ')+8+tempval));
                VNACA=tempstr;
                break
            end
        end
        clear('tempstr')
        %Generating NACA airfoil geometry
        if exist('VNACA','var')
            try
                [VAFLX,VAFLYU,VAFLYL]=generateNACAairfoil(VNACATYPE,VNACA);
                vaflstat=1;
                drawvtpafl=1;
            catch
                vaflstat=0;
                drawvtpafl=0;
                disp(['Unexpected vertical tail airfoil parameter!',...
                      ' Vertical tail airfoil will not be drawn!'])
            end
        else
            vaflstat=0;
            drawvtpafl=0;
            disp(['Unexpected vertical tail airfoil parameter!',...
                  ' Vertical tail airfoil will not be drawn!'])
        end
    end
%Reading ventral fin geometry
    %Extracting ventral fin planform properties
    if vfpstat==1
        prop={'CHRDTP=','CHRDBP=','CHRDR=',...
              'SSPNOP=','SSPNE=','SSPN=',...
              'SAVSI=','SAVSO=',...
              'TYPE=','CHSTAT='};
        for propcount=1:numel(prop)
        for count=1:numel(vfpstring)
            if strfind(vfpstring{count},prop{propcount})
                tempstr=vfpstring{count}...
                                  (strfind(vfpstring{count},...
                                           prop{propcount})+...
                                   numel(prop{propcount}):end);
                tempcell=textscan(tempstr,'%f');
                tempval=tempcell{1};
                break
            end
        end
        clear('tempstr','tempcell')
        if exist('tempval','var')
            if propcount==1
                VFCHRDTP=tempval;
            elseif propcount==2
                VFCHRDBP=tempval;
            elseif propcount==3
                VFCHRDR=tempval;
            elseif propcount==4
                VFSSPNOP=tempval;
            elseif propcount==5
                VFSSPNE=tempval;
            elseif propcount==6
                VFSSPN=tempval;
            elseif propcount==7
                VFSAVSI=tempval;
            elseif propcount==8
                VFSAVSO=tempval;
            elseif propcount==9
                VFTYPE=tempval;
            elseif propcount==10
                VFCHSTAT=tempval;
            end
        end
        clear('tempval')
        end
    end
%Reading twin vertical tail geometry
    %Extracting twin vertical tail planform properties
    if tvtstat==1
        prop={'BH=','BVP=','BV=',...
              'SV=','VPHITE=','VLP=','ZP='};
        for propcount=1:numel(prop)
        for count=1:numel(tvtstring)
            if strfind(tvtstring{count},prop{propcount})
                tempstr=tvtstring{count}...
                                  (strfind(tvtstring{count},...
                                           prop{propcount})+...
                                   numel(prop{propcount}):end);
                tempcell=textscan(tempstr,'%f');
                tempval=tempcell{1};
                break
            end
        end
        clear('tempstr','tempcell')
        if exist('tempval','var')
            if propcount==1
                TVTBH=tempval;
            elseif propcount==2
                TVTBVP=tempval;
            elseif propcount==3
                TVTBV=tempval;
            elseif propcount==4
                TVTSV=tempval;
            elseif propcount==5
                TVTVPHITE=tempval;
            elseif propcount==6
                TVTVLP=tempval;
            elseif propcount==7
                TVTZP=tempval;
            end
        end
        clear('tempval')
        end
    end
%Performing check and calculation for fuselage drawing
    if bodystat==1
    %Checking fuselage parameter from BODY namecard
    if (~exist('X','var'))||((~exist('R','var'))&&(~exist('P','var'))&&...
                             (~exist('S','var')))
        drawfuselage=0;
        disp(['Insufficient fuselage parameter!',...
              ' Fuselage will not be drawn!'])
    else
        drawfuselage=1;
    end
    %Calculating fuselage line based on fuselage parameter read
    if drawfuselage==1
        %Estimating fuselage radius
        if ~exist('R','var')
            if exist('P','var')&&~exist('S','var')
                R=P/(2*pi);
            elseif exist('S','var')
                R=sqrt(S/pi);
            end
        end
    end
    end
%Performing check and calculation for wing drawing
    if wingstat==1
    %Checking the existence of wing type parameter
    if ~exist('WTYPE','var')
        WTYPE=1;
        disp(['Wing type parameter is not found!',...
              ' Parameter value was set to 1.'])
    end
    %Checking wing parameter from WGPLNF namecard
    if WTYPE==1
        if (~exist('WSSPN','var'))||...
           (~exist('WCHRDTP','var'))||(~exist('WCHRDR','var'))
            drawwing=0;
            disp(['Insufficient wing parameter!',...
                  ' Wing will not be drawn!'])
        else
            drawwing=1;
            if ~exist('WSAVSI','var')
                WSAVSI=0;
            end
            if ~exist('WDHDADI','var')
                WDHDADI=0;
            end
        end
    elseif (WTYPE==2)||(WTYPE==3)
        if (~exist('WSSPN','var'))||(~exist('WSSPNOP','var'))||...
           (~exist('WCHRDTP','var'))||(~exist('WCHRDBP','var'))||...
           (~exist('WCHRDR','var'))
            drawwing=0;
            disp(['Insufficient wing parameter!',...
                  ' Wing will not be drawn!'])
        else
            drawwing=1;
            if ~exist('WSAVSI','var')
                WSAVSI=0;
            end
            if ~exist('WDHDADI','var')
                WDHDADI=0;
            end
            if ~exist('WSAVSO','var')
                WSAVSO=0;
            end
            if ~exist('WDHDADO','var')
                WDHDADO=0;
            end
        end
    else
        drawwing=0;
        disp(['Unexpected wing type parameter!',...
              ' Wing will not be drawn!'])
    end
    %Checking wing parameter from SYNTHS namecard
    if (~exist('XW','var'))||(~exist('ZW','var'))
        drawwing=0;
        disp(['Undefined wing synths parameter!',...
              ' Wing will not be drawn!'])
    end
    %Determining WCHSTAT value
    if ~exist('WCHSTAT','var')
        WCHSTAT=0;
    end
    %Calculating wing line based on wing parameter read
    if drawwing==1
        %Calculating LE and TE line for straight tapered planform
        if WTYPE==1
            xwing=[XW,...
                   (XW+(WCHSTAT*WCHRDR)+(WSSPN*tand(WSAVSI)-...
                                        (WCHSTAT*WCHRDTP))),...
                   (XW+(WCHSTAT*WCHRDR)+(WSSPN*tand(WSAVSI)+...
                                        ((1-WCHSTAT)*WCHRDTP))),...
                   XW+WCHRDR];
            ywing=[0,WSSPN,WSSPN,0];
            zwing=[ZW,...
                   (ZW+(WSSPN*tand(WDHDADI))),...
                   (ZW+(WSSPN*tand(WDHDADI))),...
                   ZW];
            zwingf=[(ZW+(WAT*WCHRDR)),...
                    (ZW+(WSSPN*tand(WDHDADI))+(WAT*WCHRDTP)),...
                    (ZW+(WSSPN*tand(WDHDADI))-(WAT*WCHRDTP)),...
                    (ZW-(WAT*WCHRDR))];
        end
        %Calculating LE and TE line for double cranked planform
        if (WTYPE==2)||(WTYPE==3)
            xwing=[XW,...
                   (XW+(WCHSTAT*WCHRDR)+((WSSPN-WSSPNOP)*tand(WSAVSI))-...
                                        (WCHSTAT*WCHRDBP)),...
                   (XW+(WCHSTAT*WCHRDR)+((WSSPN-WSSPNOP)*tand(WSAVSI))+...
                                        (WSSPNOP*tand(WSAVSO))-...
                                        (WCHSTAT*WCHRDTP)),...
                   (XW+(WCHSTAT*WCHRDR)+((WSSPN-WSSPNOP)*tand(WSAVSI))+...
                                        (WSSPNOP*tand(WSAVSO))+...
                                        ((1-WCHSTAT)*WCHRDTP)),...
                   (XW+(WCHSTAT*WCHRDR)+((WSSPN-WSSPNOP)*tand(WSAVSI))+...
                                        ((1-WCHSTAT)*WCHRDBP)),...
                   XW+WCHRDR];
            ywing=[0,(WSSPN-WSSPNOP),WSSPN,WSSPN,(WSSPN-WSSPNOP),0];
            zwing=[ZW,...
                   (ZW+((WSSPN-WSSPNOP)*tand(WDHDADI))),...
                   (ZW+((WSSPN-WSSPNOP)*tand(WDHDADI))+...
                       (WSSPNOP*tand(WDHDADO))),...
                   (ZW+((WSSPN-WSSPNOP)*tand(WDHDADI))+...
                       (WSSPNOP*tand(WDHDADO))),...
                   (ZW+((WSSPN-WSSPNOP)*tand(WDHDADI))),...
                   ZW];
            zwingf=[(ZW+(WAT*WCHRDR)),...
                    (ZW+((WSSPN-WSSPNOP)*tand(WDHDADI))+(WAT*WCHRDBP)),...
                    (ZW+((WSSPN-WSSPNOP)*tand(WDHDADI))+...
                        (WSSPNOP*tand(WDHDADO))+(WAT*WCHRDTP)),...
                    (ZW+((WSSPN-WSSPNOP)*tand(WDHDADI))+...
                        (WSSPNOP*tand(WDHDADO))-(WAT*WCHRDTP)),...
                    (ZW+((WSSPN-WSSPNOP)*tand(WDHDADI))-(WAT*WCHRDBP)),...
                    (ZW-(WAT*WCHRDR))];
        end
    end
    end
%Performing check and calculation for wing airfoil drawing
    if waflstat==1
    %Checking wing airfoil parameter
    if (exist('WAFLX','var'))&&...
       (((exist('WAFLMEAN','var'))||(exist('WAFLTHICK','var')))||...
        (exist('WAFLYU','var'))&&(exist('WAFLYL','var')))
        drawwingafl=1;
    else
        drawwingafl=0;
        disp(['Insufficient wing airfoil parameter!',...
              ' Wing airfoil will not be drawn!'])
    end
    %Calculating wing airfoil line
    if drawwingafl==1
        if (~exist('WAFLYU','var'))||(~exist('WAFLYL','var'))
            if (~exist('WAFLTHICK','var'))
                WAFLTHICK=zeros(size(WAFLX));
            end
            if (~exist('WAFLMEAN','var'))
                WAFLMEAN=zeros(size(WAFLX));
            end
            WAFLYU=WAFLMEAN+(0.5*WAFLTHICK);
            WAFLYL=WAFLMEAN-(0.5*WAFLTHICK);
        end
    end
    end
%Performing check and calculation for horizontal tail drawing
    if htpstat==1
    %Checking the existence of horizontal tail type parameter
    if ~exist('HTYPE','var')
        HTYPE=1;
        disp(['Horizontal tail type parameter is not found!',...
              ' Parameter value was set to 1.'])
    end
    %Checking horizontal parameter from HTPLNF namecard
    if HTYPE==1
        if (~exist('HSSPN','var'))||...
           (~exist('HCHRDTP','var'))||(~exist('HCHRDR','var'))
            drawhtp=0;
            disp(['Insufficient horizontal tail parameter!',...
                  ' Horizontal tail will not be drawn!'])
        else
            drawhtp=1;
            if ~exist('HSAVSI','var')
                HSAVSI=0;
            end
            if ~exist('HDHDADI','var')
                HDHDADI=0;
            end
        end
    elseif (HTYPE==2)||(HTYPE==3)
        if (~exist('HSSPN','var'))||(~exist('HSSPNOP','var'))||...
           (~exist('HCHRDTP','var'))||(~exist('HCHRDBP','var'))||...
           (~exist('HCHRDR','var'))
            drawhtp=0;
            disp(['Insufficient horizontal tail parameter!',...
                  ' Horizontal tail will not be drawn!'])
        else
            drawhtp=1;
            if ~exist('HSAVSI','var')
                HSAVSI=0;
            end
            if ~exist('HDHDADI','var')
                HDHDADI=0;
            end
            if ~exist('HSAVSO','var')
                HSAVSO=0;
            end
            if ~exist('HDHDADO','var')
                HDHDADO=0;
            end
        end
    else
        drawhtp=0;
        disp(['Unexpected horizontal tail type parameter!',...
              ' Horizontal tail will not be drawn!'])
    end
    %Checking horizontal tail parameter from SYNTHS namecard
    if (~exist('XH','var'))||(~exist('ZH','var'))
        drawhtp=0;
        disp(['Undefined horizontal tail synths parameter!',...
              ' Horizontal tail will not be drawn!'])
    end
    %Determining HCHSTAT value
    if ~exist('HCHSTAT','var')
        HCHSTAT=0;
    end
    %Calculating h-tail line based on horizontal tail parameter read
    if drawhtp==1
        %Calculating LE and TE line for straight tapered planform
        if HTYPE==1
            xhtp=[XH,...
                  (XH+(HCHSTAT*HCHRDR))+(HSSPN*tand(HSAVSI))-...
                                        (HCHSTAT*HCHRDTP),...
                  (XH+(HCHSTAT*HCHRDR))+(HSSPN*tand(HSAVSI))+...
                                        ((1-HCHSTAT)*HCHRDTP),...
                   XH+HCHRDR];
            yhtp=[0,HSSPN,HSSPN,0];
            zhtp=[ZH,...
                  (ZH+(HSSPN*tand(HDHDADI))),...
                  (ZH+(HSSPN*tand(HDHDADI))),...
                  ZH];
            zhtpf=[(ZH+(HAT*HCHRDR)),...
                   (ZH+(HSSPN*tand(HDHDADI))+(HAT*HCHRDTP)),...
                   (ZH+(HSSPN*tand(HDHDADI))-(HAT*HCHRDTP)),...
                   (ZH-(HAT*HCHRDR))];
        end
        %Calculating LE and TE line for double cranked planform
        if (HTYPE==2)||(HTYPE==3)
            xhtp=[XH,...
                  (XH+(HCHSTAT*HCHRDR))+((HSSPN-HSSPNOP)*tand(HSAVSI))-...
                                        (HCHSTAT*HCHRDBP),...
                  (XH+(HCHSTAT*HCHRDR))+((HSSPN-HSSPNOP)*tand(HSAVSI))+...
                                        (HSSPNOP*tand(HSAVSO))-...
                                        (HCHSTAT*HCHRDTP),...
                  (XH+(HCHSTAT*HCHRDR))+((HSSPN-HSSPNOP)*tand(HSAVSI))+...
                                        (HSSPNOP*tand(HSAVSO))+...
                                        ((1-HCHSTAT)*HCHRDTP),...
                  (XH+(HCHSTAT*HCHRDR))+((HSSPN-HSSPNOP)*tand(HSAVSI))+...
                                        ((1-HCHSTAT)*HCHRDBP),...
                  XH+HCHRDR];
            yhtp=[0,(HSSPN-HSSPNOP),HSSPNOP,HSSPNOP,(HSSPN-HSSPNOP),0];
            zhtp=[ZH,...
                  (ZH+((HSSPN-HSSPNOP)*tand(HDHDADI))),...
                  (ZH+((HSSPN-HSSPNOP)*tand(HDHDADI))+...
                      (HSSPNOP*tand(HDHDADO))),...
                  (ZH+((HSSPN-HSSPNOP)*tand(HDHDADI))+...
                      (HSSPNOP*tand(HDHDADO))),...
                  (ZH+((HSSPN-HSSPNOP)*tand(HDHDADI))),...
                  ZH];
            zhtpf=[(ZH+(HAT*HCHRDR)),...
                   (ZH+((HSSPN-HSSPNOP)*tand(HDHDADI))+(HAT*HCHRDBP)),...
                   (ZH+((HSSPN-HSSPNOP)*tand(HDHDADI))+...
                       (HSSPNOP*tand(HDHDADO))+(HAT*HCHRDTP)),...
                   (ZH+((HSSPN-HSSPNOP)*tand(HDHDADI))+...
                       (HSSPNOP*tand(HDHDADO))-(HAT*HCHRDTP)),...
                   (ZH+((HSSPN-HSSPNOP)*tand(HDHDADI))-(HAT*HCHRDBP)),...
                   (ZH-(HAT*HCHRDR))];
        end
    end
    end
%Performing check and calculation for horizontal tail airfoil drawing
    if haflstat==1
    %Checking horizontal tail airfoil parameter
    if (exist('HAFLX','var'))&&...
       (((exist('HAFLMEAN','var'))||(exist('HAFLTHICK','var')))||...
        (exist('HAFLYU','var'))&&(exist('HAFLYL','var')))
        drawhtpafl=1;
    else
        drawhtpafl=0;
        disp(['Insufficient horizontal tail airfoil parameter!',...
              ' Horizontal tail will not be drawn!'])
    end
    %Calculating horizontal tail airfoil line
    if drawhtpafl==1
        if (~exist('HAFLYU','var'))||(~exist('HAFLYL','var'))
            if (~exist('HAFLTHICK','var'))
                HAFLTHICK=zeros(size(HAFLX));
            end
            if (~exist('HAFLMEAN','var'))
                HAFLMEAN=zeros(size(HAFLX));
            end
            HAFLYU=HAFLMEAN+(0.5*HAFLTHICK);
            HAFLYL=HAFLMEAN-(0.5*HAFLTHICK);
        end
    end
    end
%Performing check and calculation for vertical tail drawing
    if vtpstat==1
    %Checking the existence of vertical tail type parameter
    if ~exist('VTYPE','var')
        VTYPE=1;
        disp(['Vertical tail type parameter is not found!',...
              ' Parameter value was set to 1.'])
    end
    %Checking vertical parameter from VTPLNF namecard
    if VTYPE==1
        if (~exist('VSSPN','var'))||...
           (~exist('VCHRDTP','var'))||(~exist('VCHRDR','var'))
            drawvtp=0;
            disp(['Insufficient vertical tail parameter!',...
                  ' Vertical tail will not be drawn!'])
        else
            drawvtp=1;
            if ~exist('VSAVSI','var')
                VSAVSI=0;
            end
        end
    elseif (VTYPE==2)||(VTYPE==3)
        if (~exist('VSSPN','var'))||(~exist('VSSPNOP','var'))||...
           (~exist('VCHRDTP','var'))||(~exist('VCHRDBP','var'))||...
           (~exist('VCHRDR','var'))||...
           (~exist('VSAVSI','var'))||(~exist('VSAVSO','var'))
            drawvtp=0;
            disp(['Insufficient vertical tail parameter!',...
                  ' Vertical tail will not be drawn!'])
        else
            drawvtp=1;
            if ~exist('VSAVSI','var')
                VSAVSI=0;
            end
            if ~exist('VSAVSO','var')
                VSAVSO=0;
            end
        end
    else
        drawvtp=0;
        disp(['Unexpected vertical tail type parameter!',...
              ' Vertical tail will not be drawn!'])
    end
    %Checking vertical tail parameter from SYNTHS namecard
    if (~exist('XV','var'))||(~exist('ZV','var'))
        drawvtp=0;
        disp(['Undefined vertical tail synths parameter!',...
              ' Vertical tail will not be drawn!'])
    end
    %Determining VCHSTAT value
    if ~exist('VCHSTAT','var')
        VCHSTAT=0;
    end
    %Calculating vertical tail line based on vertical parameter read
    if drawvtp==1
        %Calculating LE and TE line for straight tapered planform
        if VTYPE==1
            xvtp=[XV,...
                  (XV+(VCHSTAT*VCHRDR)+(VSSPN*tand(VSAVSI))-...
                                       (VCHSTAT*VCHRDTP)),...
                  (XV+(VCHSTAT*VCHRDR)+(VSSPN*tand(VSAVSI))+...
                                       ((1-VCHSTAT)*VCHRDTP)),...
                  XV+VCHRDR];
            yvtp=[VAT*VCHRDR,VAT*VCHRDTP,-VAT*VCHRDTP,-VAT*VCHRDR];
            zvtp=ZV+[0,VSSPN,VSSPN,0];
        end
        %Calculating LE and TE line for double cranked planform
        if (VTYPE==2)||(VTYPE==3)
            xvtp=[XV,...
                  (XV+(VCHSTAT*VCHRDR)+((VSSPN-VSSPNOP)*tand(VSAVSI))-...
                                       (VCHSTAT*VCHRDBP)),...
                  (XV+(VCHSTAT*VCHRDR)+((VSSPN-VSSPNOP)*tand(VSAVSI))+...
                                       (VSSPNOP*tand(VSAVSO))-...
                                       (VCHSTAT*VCHRDTP)),...
                  (XV+(VCHSTAT*VCHRDR)+((VSSPN-VSSPNOP)*tand(VSAVSI))+...
                                       (VSSPNOP*tand(VSAVSO))+...
                                       ((1-VCHSTAT)*VCHRDTP)),...
                  (XV+(VCHSTAT*VCHRDR)+((VSSPN-VSSPNOP)*tand(VSAVSI))+...
                                       (VSSPNOP*tand(VSAVSO))+...
                                       ((1-VCHSTAT)*VCHRDBP)),...
                  XV+VCHRDR];
            yvtp=[VAT*VCHRDR,VAT*VCHRDBP,VAT*VCHRDTP,...
                  -VAT*VCHRDTP,-VAT*VCHRDBP,-VAT*VCHRDR];
            zvtp=ZV+[0,(VSSPN-VSSPNOP),VSSPNOP,VSSPNOP,(VSSPN-VSSPNOP),0];
        end
    end
    end
%Performing check and calculation for vertical tail airfoil drawing
    if vaflstat==1
    %Checking vertical tail airfoil parameter
    if (exist('VAFLX','var'))&&...
       (((exist('VAFLMEAN','var'))||(exist('VAFLTHICK','var')))||...
        (exist('VAFLYU','var'))&&(exist('VAFLYL','var')))
        drawvtpafl=1;
    else
        drawvtpafl=0;
        disp(['Insufficient vertical tail airfoil parameter!',...
              ' Vertical tail will not be drawn!'])
    end
    %Calculating vertical tail airfoil line
    if drawvtpafl==1
        if (~exist('VAFLYU','var'))||(~exist('VAFLYL','var'))
            if (~exist('VAFLTHICK','var'))
                VAFLTHICK=zeros(size(VAFLX));
            end
            if (~exist('VAFLMEAN','var'))
                VAFLMEAN=zeros(size(VAFLX));
            end
            VAFLYU=VAFLMEAN+(0.5*VAFLTHICK);
            VAFLYL=VAFLMEAN-(0.5*VAFLTHICK);
        end
    end
    end
%Performing check and calculation for ventral fin drawing
    if vfpstat==1
    %Checking the existence of ventral fin type parameter
    if ~exist('VFTYPE','var')
        VFTYPE=1;
        disp(['Ventral fin type parameter is not found!',...
              ' Parameter value was set to 1.'])
    end
    %Checking ventral fin parameter from VFPLNF namecard
    if VFTYPE==1
        if (~exist('VFSSPN','var'))||...
           (~exist('VFCHRDTP','var'))||(~exist('VFCHRDR','var'))||...
           (~exist('VFSAVSI','var'))
            drawvfp=0;
            disp(['Insufficient ventral fin parameter!',...
                  ' Ventral fin will not be drawn!'])
        else
            drawvfp=1;
        end
    elseif (VFTYPE==2)||(VFTYPE==3)
        if (~exist('VFSSPN','var'))||(~exist('VFSSPNOP','var'))||...
           (~exist('VFCHRDTP','var'))||(~exist('VFCHRDBP','var'))||...
           (~exist('VFCHRDR','var'))||...
           (~exist('VFSAVSI','var'))||(~exist('VFSAVSO','var'))
            drawvfp=0;
            disp(['Insufficient ventral fin parameter!',...
                  ' Ventral fin will not be drawn!'])
        else
            drawvfp=1;
        end
    else
        drawvfp=0;
        disp(['Unexpected ventral fin type parameter!',...
              ' Ventral fin will not be drawn!'])
    end
    %Checking ventral fin parameter from SYNTHS namecard
    if (~exist('XVF','var'))||(~exist('ZVF','var'))
        drawvtp=0;
        disp(['Undefined ventral fin synths parameter!',...
              ' Ventral fin will not be drawn!'])
    end
    %Determining VFCHSTAT value
    if ~exist('VFCHSTAT','var')
        VFCHSTAT=0;
    end
    %Calculating ventral fin line based on vertical parameter read
    if drawvfp==1
        %Calculating LE and TE line for straight tapered planform
        if VFTYPE==1
            xvfp=[XVF,...
                  (XVF+(VFCHSTAT*VFCHRDR)+(VFSSPN*tand(VFSAVSI))-...
                                          (VFCHSTAT*VFCHRDTP)),...
                  (XVF+(VFCHSTAT*VFCHRDR)+(VFSSPN*tand(VFSAVSI))+...
                                          ((1-VFCHSTAT)*VFCHRDTP)),...
                   XVF+VFCHRDR];
            yvfp=[VFAT*VFCHRDR,VFAT*VFCHRDTP,-VFAT*VFCHRDTP,-VFAT*VFCHRDR];
            zvfp=ZVF+[0,VFSSPN,VFSSPN,0];
        end
        %Calculating LE and TE line for double cranked planform
        if (VFTYPE==2)||(VFTYPE==3)
            xvfp=[XVF,...
                  (XVF+(VFCHSTAT*VFCHRDR)+...
                       ((VFSSPN-VFSSPNOP)*tand(VFSAVSI))-...
                       (VFCHSTAT*VFCHRDBP)),...
                  (XVF+(VFCHSTAT*VFCHRDR)+...
                       ((VFSSPN-VFSSPNOP)*tand(VFSAVSI))+...
                       (VFSSPNOP*tand(VFSAVSO))-...
                       (VFCHSTAT*VFCHRDTP)),...
                  (XVF+(VFCHSTAT*VFCHRDR)+...
                       ((VFSSPN-VFSSPNOP)*tand(VFSAVSI))+...
                       (VFSSPNOP*tand(VFSAVSO))+...
                       ((1-VFCHSTAT)*VFCHRDTP)),...
                  (XVF+(VFCHSTAT*VFCHRDR)+...
                       ((VFSSPN-VFSSPNOP)*tand(VFSAVSI))+...
                       (VFSSPNOP*tand(VFSAVSO))+...
                       ((1-VFCHSTAT)*VFCHRDBP)),...
                  XVF+VFCHRDR];
            yvfp=[VFAT*VFCHRDR,VFAT*VFCHRDBP,VFAT*VFCHRDTP,...
                  -VFAT*VFCHRDTP,-VFAT*VFCHRDBP,-VFAT*VFCHRDR];
            zvfp=ZVF+[0,(VFSSPN-VFSSPNOP),VFSSPNOP,...
                      VFSSPNOP,(VFSSPN-VFSSPNOP),0];
        end
    end
    end
%Performing check and calculation for twin vertical tail drawing
    if tvtstat==1
    %Checking twin vertical plane parameter from TVTPAN namecard
    if (~exist('TVTBH','var'))||...
       ((~exist('TVTBV','var'))&&(~exist('TVTBVP','var')))||...
       (~exist('TVTVLP','var'))||(~exist('TVTZP','var'))||...
       (~exist('TVTSV','var'))
        drawtvt=0;
        disp(['Insufficient twin vertical tail parameter!',...
              ' Twin vertical tail will not be drawn!'])
    else
        drawtvt=1;
        if ~exist('TVTBV','var')
            TVTBV=0;
        end
        if ~exist('TVTBVP','var')
            TVTBVP=0;
        end
        if ~exist('TVTPHITE','var')
            TVTPHITE=0;
        end
    end
    end
    %Calculating twin vertical tail line based on vertical parameter read
    %to be added
%Generating figure for three view drawing
    tvdfigure=figure('Name','Three View Drawing',...
                     'NumberTitle','Off',...
                     'Units','normalized',...
                     'Position',[0.1,0.075,0.8,0.8]);
    topviewaxis=axes('Parent',tvdfigure,...
                     'Box','on',...
                     'XAxisLocation','top',...
                     'YAxisLocation','right',...
                     'Units','normalized',...
                     'Position',[0.55,0.55,0.4,0.4]);
    uicontrol('Parent',tvdfigure,...
              'Style','text',...
              'String','Top View Drawing',...
              'HorizontalAlignment','left',...
              'BackgroundColor',[0.8,0.8,0.8],...
              'Units','normalized',...
              'Position',[0.551,0.55,0.1,0.025])
    sideviewaxis=axes('Parent',tvdfigure,...
                      'Box','on',...
                      'XAxisLocation','bottom',...
                      'YAxisLocation','right',...
                      'Units','normalized',...
                      'Position',[0.55,0.05,0.4,0.4]);
    uicontrol('Parent',tvdfigure,...
              'Style','text',...
              'String','Side View Drawing',...
              'HorizontalAlignment','left',...
              'BackgroundColor',[0.8,0.8,0.8],...
              'Units','normalized',...
              'Position',[0.551,0.449-0.025,0.1,0.025])
    frontviewaxis=axes('Parent',tvdfigure,...
                       'Box','on',...
                       'XAxisLocation','bottom',...
                       'YAxisLocation','left',...
                       'Units','normalized',...
                       'Position',[0.05,0.05,0.4,0.4]);
    uicontrol('Parent',tvdfigure,...
              'Style','text',...
              'String','Front View Drawing',...
              'HorizontalAlignment','right',...
              'BackgroundColor',[0.8,0.8,0.8],...
              'Units','normalized',...
              'Position',[0.449-0.1,0.449-0.025,0.1,0.025])
    wingaflaxis=axes('Parent',tvdfigure,...
                     'Box','on',...
                     'Units','normalized',...
                     'Position',[0.1,0.85,0.3,0.1]);
    uicontrol('Parent',tvdfigure,...
              'Style','text',...
              'String','Wing Airfoill',...
              'HorizontalAlignment','right',...
              'BackgroundColor',[0.8,0.8,0.8],...
              'Units','normalized',...
              'Position',[0.399-0.075,0.85,0.075,0.025])
    htpaflaxis=axes('Parent',tvdfigure,...
                    'Box','on',...
                    'Units','normalized',...
                    'Position',[0.1,0.7,0.3,0.1]);
    uicontrol('Parent',tvdfigure,...
              'Style','text',...
              'String','HTP Airfoill',...
              'HorizontalAlignment','right',...
              'BackgroundColor',[0.8,0.8,0.8],...
              'Units','normalized',...
              'Position',[0.399-0.075,0.7,0.075,0.025])
    vtpaflaxis=axes('Parent',tvdfigure,...
                    'Box','on',...
                    'Units','normalized',...
                    'Position',[0.1,0.55,0.3,0.1]);
    uicontrol('Parent',tvdfigure,...
              'Style','text',...
              'String','VTP Airfoill',...
              'HorizontalAlignment','right',...
              'BackgroundColor',[0.8,0.8,0.8],...
              'Units','normalized',...
              'Position',[0.399-0.075,0.55,0.075,0.025])
%Drawing aircraft's topview
    %Holding axis
    hold(topviewaxis,'on')
    %Determining fuselage most upper limit for wing and h-tail placement
    if (exist('ZU','var'))&&(exist('R','var'))
        testval=max(ZU);
    elseif (~exist('ZU','var'))&&(exist('R','var'))
        testval=max(R);
    else
        testval=-Inf;
    end
    %Drawing low-mounted wing
    if wingstat==1
    if drawwing==1
    if ZW<testval
        wtv_left=fill([xwing,xwing(end:-1:1)],-[ywing,ywing(end:-1:1)],...
                      'w','Parent',topviewaxis);
        wtv_right=fill([xwing,xwing(end:-1:1)],[ywing,ywing(end:-1:1)],...
                       'w','Parent',topviewaxis);
    end
    end
    end
    %Drawing low-mounted horizontal tail
    if htpstat==1
    if drawhtp==1
    if ZH<testval
        htv_left=fill([xhtp,xhtp(end:-1:1)],-[yhtp,yhtp(end:-1:1)],'w',...
                      'Parent',topviewaxis);
        htv_right=fill([xhtp,xhtp(end:-1:1)],[yhtp,yhtp(end:-1:1)],'w',...
                       'Parent',topviewaxis);
    end
    end
    end
    %Drawing fuselage
    if bodystat==1
    if drawfuselage==1
        ftv=fill([X(1),X,X(end:-1:1),X(1)],[0,-R,R(end:-1:1),0],'w',...
                 'Parent',topviewaxis);
    end
    end
    %Drawing high-mounted wing
    if wingstat==1
    if drawwing==1
    if ZW>=testval
        wtv_left=fill([xwing,xwing(end:-1:1)],-[ywing,ywing(end:-1:1)],...
                      'w','Parent',topviewaxis);
        wtv_right=fill([xwing,xwing(end:-1:1)],[ywing,ywing(end:-1:1)],...
                       'w','Parent',topviewaxis);
    end
    end
    end
    %Drawing high-mounted horizontal tail
    if htpstat==1
    if drawhtp==1
    if ZH>=testval
        htv_left=fill([xhtp,xhtp(end:-1:1)],-[yhtp,yhtp(end:-1:1)],'w',...
                      'Parent',topviewaxis);
        htv_right=fill([xhtp,xhtp(end:-1:1)],[yhtp,yhtp(end:-1:1)],'w',...
                       'Parent',topviewaxis);
    end
    end
    end
    %Drawing vertical tail
    if vtpstat==1
    if drawvtp==1
        if VTYPE==1
            XVTIP=xvtp(2);
        elseif (VTYPE==2)||(VTYPE==3)
            XVTIP=xvtp(3);
        end
        if XV<=XVTIP
        vtv_rear=fill([XV+([xafl_r,xafl_r(end-1:-1:1)]*VCHRDR),...
                       XVTIP+([xafl_r,xafl_r(end-1:-1:1)]*VCHRDTP)],...
                      [([yafl_r,-yafl_r(end-1:-1:1)]*VCHRDR*VAT),...
                       ([-yafl_r,yafl_r(end-1:-1:1)]*VCHRDTP*VAT)],...
                      'w','Parent',topviewaxis);
        end
        vtv_front=fill([XV+([xafl_f(end:-1:2),xafl_f]*VCHRDR),...
                        XVTIP+([xafl_f(end:-1:2),xafl_f]*VCHRDTP)],...
                       [([-yafl_f(end:-1:2),yafl_f]*VCHRDR*VAT),...
                        ([yafl_f(end:-1:2),-yafl_f]*VCHRDTP*VAT)],...
                       'w','Parent',topviewaxis);
        if XV>=XVTIP
        vtv_rear=fill([XV+([xafl_r,xafl_r(end-1:-1:1)]*VCHRDR),...
                       XVTIP+([xafl_r,xafl_r(end-1:-1:1)]*VCHRDTP)],...
                      [([yafl_r,-yafl_r(end-1:-1:1)]*VCHRDR*VAT),...
                       ([-yafl_r,yafl_r(end-1:-1:1)]*VCHRDTP*VAT)],...
                      'w','Parent',topviewaxis);
        end
        vtv_top=fill(XVTIP+([xafl_f,xafl_r,...
                             xafl_r(end-1:-1:1),xafl_f(end-1:-1:1)]*...
                            VCHRDTP),...
                     ([yafl_f,yafl_r,...
                       -yafl_r(end-1:-1:1),-yafl_f(end-1:-1:1)]*...
                      VCHRDTP*VAT),...
                     'w','Parent',topviewaxis);
    end
    end
    %Equalizing axis scale
    axis(topviewaxis,'equal')
    %Unholding axis
    hold(topviewaxis,'off')
%Drawing aircraft's sideview
    %Holding axis
    hold(sideviewaxis,'on')
    %Drawing vertical tail and ventral fin
    if vfpstat==1
    if drawvfp==1
        vftv=fill([xvfp,xvfp(1)],[zvfp,zvfp(1)],'w','Parent',sideviewaxis);
    end
    end
    if vtpstat==1
    if drawvtp==1
        vtv=fill([xvtp,xvtp(1)],[zvtp,zvtp(1)],'w','Parent',sideviewaxis);
    end
    end
    %Drawing fuselage
    if bodystat==1
    if drawfuselage==1
        if exist('ZU','var')&&exist('ZL','var')
            fsv=fill([X,X(end:-1:1),X(1)],...
                     [ZU,ZL(end:-1:1),ZU(1)],...
                     'w','Parent',sideviewaxis);
        else
            fsv=fill([X(1),X,X(end:-1:1),X(1)],...
                     [0,-R,R(end:-1:1),0],...
                     'w','Parent',sideviewaxis);
        end
    end
    end
    %Drawing wing
    if wingstat==1
    if drawwing==1
        if WTYPE==1
            WCHRDBPtemp=WCHRDTP;
        elseif (WTYPE==2)||(WTYPE==3)
            WCHRDBPtemp=WCHRDBP;
        end
        %Drawing inboard wing
        if (WDHDADI>=0)
            wsv1_t=fill([xwing(1)+([xafl_f,xafl_r]*WCHRDR),...
                         xwing(2)+([xafl_r(end:-1:1),...
                                    xafl_f(end:-1:1)]*WCHRDBPtemp)],...
                        [zwing(1)+([yafl_f,yafl_r]*WCHRDR*WAT),...
                         zwing(2)+([yafl_r(end:-1:1),...
                                    yafl_f(end:-1:1)]*...
                                   WCHRDBPtemp*WAT)],...
                        'w','Parent',sideviewaxis);
        end
        wsv1_b=fill([xwing(1)+([xafl_f,xafl_r]*WCHRDR),...
                     xwing(2)+([xafl_r(end:-1:1),...
                                xafl_f(end:-1:1)]*WCHRDBPtemp)],...
                    [zwing(1)-([yafl_f,yafl_r]*WCHRDR*WAT),...
                     zwing(2)-([yafl_r(end:-1:1),...
                                yafl_f(end:-1:1)]*...
                               WCHRDBPtemp*WAT)],...
                    'w','Parent',sideviewaxis);
        if (WDHDADI<=0)
            wsv1_t=fill([xwing(1)+([xafl_f,xafl_r]*WCHRDR),...
                         xwing(2)+([xafl_r(end:-1:1),...
                                    xafl_f(end:-1:1)]*WCHRDBPtemp)],...
                        [zwing(1)+([yafl_f,yafl_r]*WCHRDR*WAT),...
                         zwing(2)+([yafl_r(end:-1:1),...
                                    yafl_f(end:-1:1)]*...
                                   WCHRDBPtemp*WAT)],...
                        'w','Parent',sideviewaxis);
        end
        %Drawing inboard wing if any
        if (WTYPE==2)||(WTYPE==3)
        if (WDHDADI>=0)
            wsv2_t=fill([xwing(2)+([xafl_f,xafl_r]*WCHRDBPtemp),...
                         xwing(3)+([xafl_r(end:-1:1),...
                                    xafl_f(end:-1:1)]*WCHRDTP)],...
                        [zwing(2)+([yafl_f,yafl_r]*WCHRDBPtemp*WAT),...
                         zwing(3)+([yafl_r(end:-1:1),...
                                    yafl_f(end:-1:1)]*...
                                   WCHRDTP*WAT)],...
                        'w','Parent',sideviewaxis);
        end
        wsv2_b=fill([xwing(2)+([xafl_f,xafl_r]*WCHRDBPtemp),...
                     xwing(3)+([xafl_r(end:-1:1),...
                                xafl_f(end:-1:1)]*WCHRDTP)],...
                    [zwing(2)-([yafl_f,yafl_r]*WCHRDBPtemp*WAT),...
                     zwing(3)-([yafl_r(end:-1:1),...
                                yafl_f(end:-1:1)]*...
                               WCHRDTP*WAT)],...
                    'w','Parent',sideviewaxis);
        if (WDHDADI<=0)
            wsv2_t=fill([xwing(2)+([xafl_f,xafl_r]*WCHRDBPtemp),...
                         xwing(3)+([xafl_r(end:-1:1),...
                                    xafl_f(end:-1:1)]*WCHRDTP)],...
                        [zwing(2)+([yafl_f,yafl_r]*WCHRDBPtemp*WAT),...
                         zwing(3)+([yafl_r(end:-1:1),...
                                    yafl_f(end:-1:1)]*...
                                   WCHRDTP*WAT)],...
                        'w','Parent',sideviewaxis);
        end
        end
    end
    end
    %Drawing horizontal tail
    if htpstat==1
    if drawhtp==1
        if HTYPE==1
            HCHRDBPtemp=HCHRDTP;
        elseif (HTYPE==2)||(HTYPE==3)
            HCHRDBPtemp=HCHRDBP;
        end
        %Drawing inboard wing
        if (HDHDADI>=0)
            hsv1_t=fill([xhtp(1)+([xafl_f,xafl_r]*HCHRDR),...
                         xhtp(2)+([xafl_r(end:-1:1),...
                                   xafl_f(end:-1:1)]*HCHRDBPtemp)],...
                        [zhtp(1)+([yafl_f,yafl_r]*HCHRDR*HAT),...
                         zhtp(2)+([yafl_r(end:-1:1),...
                                   yafl_f(end:-1:1)]*...
                                  HCHRDBPtemp*HAT)],...
                        'w','Parent',sideviewaxis);
        end
        hsv1_b=fill([xhtp(1)+([xafl_f,xafl_r]*HCHRDR),...
                     xhtp(2)+([xafl_r(end:-1:1),...
                               xafl_f(end:-1:1)]*HCHRDBPtemp)],...
                    [zhtp(1)-([yafl_f,yafl_r]*HCHRDR*HAT),...
                     zhtp(2)-([yafl_r(end:-1:1),...
                               yafl_f(end:-1:1)]*...
                              HCHRDBPtemp*HAT)],...
                    'w','Parent',sideviewaxis);
        if (HDHDADI<=0)
            hsv1_t=fill([xhtp(1)+([xafl_f,xafl_r]*HCHRDR),...
                         xhtp(2)+([xafl_r(end:-1:1),...
                                   xafl_f(end:-1:1)]*HCHRDBPtemp)],...
                        [zhtp(1)+([yafl_f,yafl_r]*HCHRDR*HAT),...
                         zhtp(2)+([yafl_r(end:-1:1),...
                                   yafl_f(end:-1:1)]*...
                                  HCHRDBPtemp*HAT)],...
                        'w','Parent',sideviewaxis);
        end
        %Drawing inboard wing if any
        if (HTYPE==2)||(HTYPE==3)
        if (HDHDADI>=0)
            hsv2_t=fill([xhtp(2)+([xafl_f,xafl_r]*HCHRDBPtemp),...
                         xhtp(3)+([xafl_r(end:-1:1),...
                                   xafl_f(end:-1:1)]*HCHRDTP)],...
                        [zhtp(2)+([yafl_f,yafl_r]*HCHRDBPtemp*WAT),...
                         zhtp(3)+([yafl_r(end:-1:1),...
                                   yafl_f(end:-1:1)]*...
                                  HCHRDTP*WAT)],...
                        'w','Parent',sideviewaxis);
        end
        hsv2_b=fill([xhtp(2)+([xafl_f,xafl_r]*HCHRDBPtemp),...
                     xhtp(3)+([xafl_r(end:-1:1),...
                               xafl_f(end:-1:1)]*HCHRDTP)],...
                    [zhtp(2)-([yafl_f,yafl_r]*HCHRDBPtemp*WAT),...
                     zhtp(3)-([yafl_r(end:-1:1),...
                               yafl_f(end:-1:1)]*...
                              HCHRDTP*WAT)],...
                    'w','Parent',sideviewaxis);
        if (HDHDADI<=0)
            hsv2_t=fill([xhtp(2)+([xafl_f,xafl_r]*HCHRDBPtemp),...
                         xhtp(3)+([xafl_r(end:-1:1),...
                                   xafl_f(end:-1:1)]*HCHRDTP)],...
                        [zhtp(2)+([yafl_f,yafl_r]*HCHRDBPtemp*WAT),...
                         zhtp(3)+([yafl_r(end:-1:1),...
                                   yafl_f(end:-1:1)]*...
                                  HCHRDTP*WAT)],...
                        'w','Parent',sideviewaxis);
        end
        end
    end
    end
    %Equalizing axis scale
    axis(sideviewaxis,'equal')
    %Unholding axis
    hold(sideviewaxis,'off')
%Drawing aircraft's frontview
    %Holding axis
    hold(frontviewaxis,'on')
    %Drawing ventral fin and vertical tail
    if vtpstat==1
    if drawvtp==1
        vfv=fill([0,yvtp,0],[ZV,zvtp,ZV],'w',...
                 'Parent',frontviewaxis);
    end
    end
    %Drawing horizontal tail
    if htpstat==1
    if drawhtp==1
        hfv=fill([yhtp,-yhtp(end:-1:1)],[zhtpf,zhtpf(end:-1:1)],'w',...
                 'Parent',frontviewaxis);
    end
    end
    %Drawing wing
    if wingstat==1
    if drawwing==1
        wfv=fill([ywing,-ywing(end:-1:1)],[zwingf,zwingf(end:-1:1)],'w',...
                 'Parent',frontviewaxis);
    end
    end
    %Drawing fuselage
    if bodystat==1
    if drawfuselage==1
        if exist('ZU','var')&&exist('ZL','var')
            ffv=rectangle('Position',[-max(R),min(ZL)...
                                      2*max(R),max(ZU)-min(ZL)],...
                          'Curvature',[1,1],...
                          'FaceColor','w',...
                          'Parent',frontviewaxis);
        else
            ffv=rectangle('Position',[-max(R),-max(R),...
                                      2*max(R),2*max(R)],...
                          'Curvature',[1,1],...
                          'FaceColor','w',...
                          'Parent',frontviewaxis);
        end
    end
    end
    %Equalizing axis scale
    axis(frontviewaxis,'equal')
    %Unholding axis
    hold(frontviewaxis,'off')
%Drawing wing's airfoil
    %Holding axis
    hold(wingaflaxis,'on')
    %Drawing airfoil
    if waflstat==1
    if drawwingafl==1
        waflu=plot(WAFLX,WAFLYU,'Parent',wingaflaxis);
        wafll=plot(WAFLX,WAFLYL,'Parent',wingaflaxis);
    end
    end
    %Equalizing axis scale
    axis(wingaflaxis,'equal')
    %Unholding axis
    hold(wingaflaxis,'off')
%Drawing horizontal tail's airfoil
    %Holding axis
    hold(htpaflaxis,'on')
    %Drawing airfoil
    if haflstat==1
    if drawhtpafl==1
        haflu=plot(HAFLX,HAFLYU,'Parent',htpaflaxis);
        hafll=plot(HAFLX,HAFLYL,'Parent',htpaflaxis);
    end
    end
    %Equalizing axis scale
    axis(htpaflaxis,'equal')
    %Unholding axis
    hold(htpaflaxis,'off')
%Drawing vertical tail's airfoil
    %Holding axis
    hold(vtpaflaxis,'on')
    %Drawing airfoil
    if vaflstat==1
    if drawvtpafl==1
        vaflu=plot(VAFLX,VAFLYU,'Parent',vtpaflaxis);
        vafll=plot(VAFLX,VAFLYL,'Parent',vtpaflaxis);
    end
    end
    %Equalizing axis scale
    axis(vtpaflaxis,'equal')
    %Unholding axis
    hold(vtpaflaxis,'off')
%CodeEnd-------------------------------------------------------------------

end


%--------------------------------------------------------------------------
%LocalFunction
%--------------------------------------------------------------------------
function [AFLX,AFLYU,AFLYL]=generateNACAairfoil(NACATYPE,NACA)
    if NACATYPE==1
        [xu,yu,xl,yl,~,~]=GenerateNACASeries16Airfoil(NACA,20,'Uniform');
    elseif NACATYPE==4
        [xu,yu,xl,yl,~,~]=GenerateNACASeries4Airfoil(NACA,20,'Uniform');
    elseif NACATYPE==5
        [xu,yu,xl,yl,~,~]=GenerateNACASeries5Airfoil(NACA,20,'Uniform');
    elseif NACATYPE==6
        [xu,yu,xl,yl,~,~]=GenerateNACASeries6Airfoil(NACA,20,'Uniform');
    end
    xu(1)=0;
    xu(end)=1;
    xl(1)=0;
    xl(end)=1;
    AFLX=0:0.05:1;
    AFLYU=interp1(xu',yu',AFLX);
    AFLYL=interp1(xl',yl',AFLX);
end
%--------------------------------------------------------------------------
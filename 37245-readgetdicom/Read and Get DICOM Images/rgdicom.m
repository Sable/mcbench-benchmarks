function rgdicom
%
%This Program designed to read DICOM images and save it as MAT file.

Images_Path='';
Images_Name='';

ceIndx=0;

CDr=pwd; %used with getbuttonlogo

%---------------------------------------------------
%Colors Used
colr1=[0 0 0];
colr2=[1 1 1];
colr3=[1 1 0]; %#ok<NASGU>
colr4=[0.3 0.7 0.7];
colr5=[0.7 0.7 0.7];
colr6=[0.9 0.1 0.1]; %#ok<NASGU>
colr7=colr1; %#ok<NASGU>
colr8=[1 1 0.7];
colr9=[1 0.1 0.1]; %#ok<NASGU>
colr10=[0.7 1 0.5]; %#ok<NASGU>
colr11=[1 1 0.9]; %#ok<NASGU>
colr12=[0.1 0.1 0.8];
colr13=[0.5 0.5 0.1]; %#ok<NASGU>
colr14=[0.7 1 1];
colr15=[1 0.5 0.5]; %#ok<NASGU>
colr16=[0.2 0.8 0.2]; %#ok<NASGU>

fsiz=get(0,'screensize');
pos=posXY(fsiz,0.2,0.2,2);
GDCMf=figure('unit','pixels','Name','Get & Store DICOM Images','numbertitle','off','menubar','none',...
    'resize','off','dockcontrols','off','position',pos,'color',colr8,'visible','on');
movegui(GDCMf,'center');

pos=posXY(GDCMf,2/3,0,1);
PLf=uipanel('unit','pixels','Backgroundcolor',colr2,'parent',GDCMf,'position',pos,...
    'BorderType','beveledin','Shadowcolor',colr4,'Highlightcolor',colr4);

%Panel which show the save proccess
pos=posXY(GDCMf,1/8,4.04/5,1.3/3,1/50);
SpP=uipanel('unit','pixels','Backgroundcolor',colr1,'parent',GDCMf,'position',pos,...
    'visible','on','BorderType','etchedout');
pos=posXY(SpP,0,1/50,0.001,35/50);
SpP1=uipanel('unit','pixels','Backgroundcolor',colr14,'parent',SpP,'position',pos,...
    'visible','on','BorderType','etchedin');

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%show the saving proccess rate
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
pos=posXY(GDCMf,1/8,4.14/5,(1.3/3)/2,1/20);
SpPt1=uicontrol('unit','pixels','style','text','parent',GDCMf,'position',pos,...
    'backgroundcolor',colr8,'foregroundcolor',colr12,'string','0','HorizontalAlignment','Right');
pos=posXY(GDCMf,(1/8+(1.3/3)/2),4.14/5,(1.3/3)/2,1/20);
SpPt2=uicontrol('unit','pixels','style','text','parent',GDCMf,'position',pos,...
    'backgroundcolor',colr8,'foregroundcolor',colr12,'string',' %','HorizontalAlignment','Left'); %#ok<NASGU>
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%--------------------------------------------------------------------------
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%Panel which contain the photo
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
pos=posXY(GDCMf,1/8,1/5,1.3/3,3/5);
AxfP=uipanel('unit','pixels','Backgroundcolor',colr1,'parent',GDCMf,'position',pos,...
    'visible','on','BorderType','etchedin');
Axf=subplot(1,1,1,'parent',AxfP,'color',colr1);
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%--------------------------------------------------------------------------
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%Save & Exit buttons
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
pos=posXY(PLf,0, 0, 1, 0.08);
PLfES=uipanel('unit','pixels','Backgroundcolor','r','parent',PLf,'position',pos,...
    'BorderType','beveledout','Shadowcolor',colr5,'Highlightcolor',colr5);

pos=posXY(PLfES,0.03, 0.1, 0.46, 0.8);
PLfSp=uipanel('unit','pixels','Backgroundcolor',colr2,'parent',PLfES,'position',pos,...
    'BorderType','beveledout','Shadowcolor',colr5,'Highlightcolor',colr5);
pos=posXY(PLfSp,0, 0, 2);
PLfS=uicontrol('unit','pixels','style','pushbutton','position',pos,'string',...
    'Save','Parent',PLfSp,'callback',@PLfS_p,'FONTSIZE',10,'FontWeight','normal',...
    'fontname','Times New Roman','enable','off');

pos=posXY(PLfES,0.515, 0.1, 0.46, 0.8);
PLfEp=uipanel('unit','pixels','Backgroundcolor',colr2,'parent',PLfES,'position',pos,...
    'BorderType','beveledout','Shadowcolor',colr5,'Highlightcolor',colr5);
pos=posXY(PLfEp,0, 0, 2);
PLfE=uicontrol('unit','pixels','style','pushbutton','position',pos,'string',...
    'Exit','Parent',PLfEp,'callback',@PLfE_p,'FONTSIZE',10,'FontWeight','normal',...
    'fontname','Times New Roman'); %#ok<NASGU>
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%--------------------------------------------------------------------------
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%Get Images buttons
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
pos=posXY(GDCMf,1/6, 1/16, 2/6, 1/10);
PLfGep=uipanel('unit','pixels','Backgroundcolor',colr1,'parent',GDCMf,'position',pos,...
    'BorderType','beveledout');

pos=posXY(PLfGep,0.05, 0.1, 2);
PLfGe=uicontrol('unit','pixels','style','pushbutton','position',pos,'string',...
    'Get Images','Parent',PLfGep,'callback',@PLfGe_p,'FONTSIZE',10,'FontWeight','normal',...
    'fontname','Times New Roman'); %#ok<NASGU>
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%--------------------------------------------------------------------------
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%Table which contain the Images Names
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
ImagesName=cell(16,1);
pos=posXY(PLf,0.05, 0.27, 0.9,0.71);
ImgNam=uitable('Units','pixels','ColumnName',{'Imag Name'},'parent',PLf,...
    'foregroundcolor',colr1,'position',pos,'Data',ImagesName,'enable','off',...
    'ColumnWidth',{0.788*pos(3),'auto'},'CellSelectionCallback',@ImgNam_p,'fontsize',10);
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%--------------------------------------------------------------------------
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%Loading Photos Manegment
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
pos=posXY(GDCMf,9.5/16, 11/16, 0.5/16, 0.9/16);
logo=getbuttonlogo(CDr,'Mup',[],[pos(4),pos(3)]);
MoveUpB=uicontrol('unit','pixels','style','pushbutton','position',pos,...
    'Parent',GDCMf,'callback',@MoveUpB_p,'cdata',logo); %#ok<NASGU>

    function MoveUpB_p(MoveUpB,eventdata) %#ok<INUSD>
        MoveImag(1);
    end

pos=posXY(GDCMf,9.5/16, 10/16, 0.5/16, 0.9/16);
logo=getbuttonlogo(CDr,'Del',[],[pos(4),pos(3)]);
DelB=uicontrol('unit','pixels','style','pushbutton','position',pos,...
    'Parent',GDCMf,'callback',@DelB_p,'cdata',logo); %#ok<NASGU>

    function DelB_p(DelB,eventdata) %#ok<INUSD>
        MoveImag(0);
    end

pos=posXY(GDCMf,9.5/16, 9/16, 0.5/16, 0.9/16);
logo=getbuttonlogo(CDr,'Mdo',[],[pos(4),pos(3)]);
MoveDoB=uicontrol('unit','pixels','style','pushbutton','position',pos,...
    'Parent',GDCMf,'callback',@MoveDoB_p,'cdata',logo); %#ok<NASGU>

    function MoveDoB_p(MoveDoB,eventdata) %#ok<INUSD>
        MoveImag(2);
    end
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    function ImgNam_p(ImgNam,eventdata)
        cel=eventdata.Indices;
        
        if isempty(cel)==0
            ImagesName=get(ImgNam,'Data');
            ImagesName=cell2mat(ImagesName(cel(1)));
            
            showDCMimages(ImagesName); %If Image's type was DICOM

            ceIndx=cel(1);
        end
    end

    function showDCMimages(ImagesName)
        FileName=sprintf('%s',Images_Path,ImagesName);
        [I,map]=dicomread(FileName);
        imshow(I,map,'parent',Axf);
    end

    function MoveImag(CIdx)
        
        if length(Images_Name)>2 && iscell(Images_Name)==1
            
        if CIdx~=0
            ImNP=cell(length(Images_Name),1);
        elseif CIdx==0;
            ImNP=cell(length(Images_Name)-1,1);
        end
        
        if CIdx==1  %MoveUp
            
            if ceIndx>2
                ImNP(1:ceIndx-2)=Images_Name(1:ceIndx-2);
                ImNP(ceIndx+1:end)=Images_Name(ceIndx+1:end);
                
                ImNP(ceIndx)=Images_Name(ceIndx-1);
                ImNP(ceIndx-1)=Images_Name(ceIndx);
                Images_Name=ImNP';
                
                set(ImgNam,'data',Images_Name');
                ceIndx=ceIndx-1;
            end
            
        elseif CIdx==2  %MoveDown
            
            if ceIndx<length(Images_Name)
                ImNP(1:ceIndx-1)=Images_Name(1:ceIndx-1);
                ImNP(ceIndx+2:end)=Images_Name(ceIndx+2:end);
                
                ImNP(ceIndx)=Images_Name(ceIndx+1);
                ImNP(ceIndx+1)=Images_Name(ceIndx);
                Images_Name=ImNP';
                
                set(ImgNam,'data',Images_Name');
                ceIndx=ceIndx+1;
            end
            
        elseif CIdx==0  %REMOVE
            
            if ceIndx==1
                ImNP=(Images_Name(2:end))';
            elseif ceIndx==length(Images_Name)
                ImNP=(Images_Name(1:end-1))';
            elseif ceIndx>1 && ceIndx<length(Images_Name)
                ImNP(1:ceIndx-1)=Images_Name(1:ceIndx-1);
                ImNP(ceIndx:end)=Images_Name(ceIndx+1:end);
            end
            
            Images_Name=ImNP';
            set(ImgNam,'data',Images_Name');
            
        end
        clear ImNP;
        
        end
    end

    function PLfGe_p(PLfGe,eventdata) %#ok<INUSD>
        [IN,IP]=uigetfile('*.dcm','multiselect','on');
        
        if isnumeric(IP)==1 || isnumeric(IN)==1
            
        elseif isnumeric(IP)==0 && isnumeric(IN)==0
            set([ImgNam,PLfS],'enable','on');
            
            if iscell(IN)==1   %%multible files selected
                set(ImgNam,'data',IN');
            elseif iscell(IN)==0   %one file selected
                set(ImgNam,'data',{IN});
            end
           Images_Name=IN;
           Images_Path=IP;
           clear('IN','IP');
        end
    end

    function PLfE_p(PLfE,eventdata) %#ok<INUSD>
        close(GDCMf);
    end

    function PLfS_p(PLfS,eventdata) %#ok<INUSD>
        if iscell(Images_Name)==1
            [a,NumberOfImages]=size(Images_Name);
        else
            NumberOfImages=1;
        end
        
        K=get(SpP,'position');
        
        D=saveoperation(NumberOfImages,K); %#ok<NASGU>
        
        [SDFname,SDFpath]=uiputfile('*.mat','Save as MAT File');
        
        if isequal(SDFname,0) || isequal(SDFpath,0)
            clear D;
        else
            StrDatFile=sprintf('%s',SDFpath,SDFname);
            save(StrDatFile,'D');
        
            uiwait(msgbox('The saving process completed','Complete'));
        end
        
        p=viewsavingresult(1,1000,K(3));
        set(SpPt1,'string',num2str(round(p)));
    end

    function D=saveoperation(m,K)
        
        if m>1
            for n=1:m
                pause(0.01);
                p=viewsavingresult(n,m,K(3));
                set(SpPt1,'string',num2str(p));
                
                FileName=sprintf('%s', Images_Path , cell2mat(Images_Name(n)) );
                D(:,:,n)=uint8(dicomread(FileName)); %#ok<AGROW>
            end
            
        elseif m==1
                set(SpPt1,'string','100');
                A=get(SpP1,'position');
                A(3)=K(3);
                set(SpP1,'unit','pixels','position',A);
                
                FileName=sprintf('%s', Images_Path , Images_Name );
                D=uint8(dicomread(FileName));
        end
    end

    function p=viewsavingresult(n,m,K)
        A=get(SpP1,'position');
        A(3)=(n/m)*K;
        set(SpP1,'unit','pixels','position',A);
        p=round((A(3)/K)*100);
    end

end
%Animate_Four_Bar_Polodes creates a GUI for viewing and animating arbitrary 
% four bar mechanisms and their corresponding polodes.  The GUI allows you
% to animate forwards and reverse, invert the mechanism, change the
% animation speed, and modify the link lengths. 
%
% A "Link Length Options" drop down box gives 15 predefined 
% mechanism variations to choose from.
%
% When the link lengths slider bar is changed, please press the "Change
% Links" button to recompute the polode and mechanism paths.
% 
% Note that this program does not give user control for change points.

%  _-_,,       ,,                _-_-                   ,,                  
% (  //        ||                  /,        _   ;      ||    '             
%   _||   /'\\ ||/\\ \\/\\         || __    < \, \\/\/\ ||/\ \\ \\/\\  _-_, 
%   _||  || || || || || ||        ~||-  -   /-|| || | | ||_< || || || ||_.  
%    ||  || || || || || ||         ||===|| (( || || | | || | || || ||  ~ || 
% -__-,  \\,/  \\ |/ \\ \\        ( \_, |   \/\\ \\/\\/ \\,\ \\ \\ \\ ,-_-  
%                _/                     `                           
%
% John Hawkins
% Kinematics
% Final Exam Project
% For professor Don Riley
% December 2009

function Animate_Four_Bar_Polodes

% Define the link lengths r with r(1) as ground
h.r=[ 2 4 6 3.5];
        
INITIALIZE;

    function INITIALIZE
        warning off;

        GRASHOFTEST;
        
        if ~h.isconstructible
            errordlg('Desired mechanism is not constructible or does not move.')
            return
        end
        
        ANIMATIONSETTINGS;
        
        CALCULATIONS;
        
        MAKEFIGURE;

        INITIALPLOTS;
    end

    function GRASHOFTEST

        [s,n]=min(h.r);

        h.inputLIndex=n;

        [l,x]=max(h.r);

        midInds=1:4; midInds([n,x])=[];
        p=h.r(midInds(1));
        q=h.r(midInds(2));

        if l>=s+p+q    %Test for constructability
            h.isconstructible=false;

        else           %Constructible
            h.isconstructible=true;

            if s+l<=p+q   %Test for Grashof mechanism
                h.isgrashof=true;
                
                %Determining of Mechanism Type
                ascending=sort(h.r);
                ExtraChangePoint=false;
                if s+l==p+q
                    if ascending(1)==ascending(4)
                        h.mechType='Triple Change Point Mechanism';
                        ExtraChangePoint=true;
                    elseif ascending(1)==ascending(2) && ascending(3)==ascending(4)
                        h.mechType='Double Change Point Mechanism';
                        ExtraChangePoint=true;
                    else
                        h.mechType='Change Point';
                    end
                else
                    h.mechType='Grashof';
                end
                
                if ~ExtraChangePoint
                    switch n
                        case 1
                            h.mechType=[h.mechType,' Crank-Rocker-Rocker Mechanism'];
                        case 2
                            h.mechType=[h.mechType,' Rocker-Crank-Rocker Mechanism'];
                        case 3
                            h.mechType=[h.mechType,' Rocker-Rocker-Crank Mechanism'];
                        case 4
                            h.mechType=[h.mechType,' Crank-Crank-Crank Mechanism'];
                    end
                end
                
                h.L=[h.r(n:end),h.r(1:n-1)];
                % The L matrix is simply a cyclical permutation of the link lengths 
                % which places the shortest link as the input.  This allows for easier
                % calculation of grashof mechanism positions.  The whole mechanism will
                % later be rotated for correct display.

                h.dtheta1=0:359;

            else   %Non-grashof
                h.isgrashof=false;
                h.L=h.r;
                h.inputLIndex=1;
                
                %Mechanism Classification
                switch n
                    case 1
                        h.mechType='Class 2 Rocker-Rocker-Rocker Non-Grashof Mechanism';
                    case 2
                        h.mechType='Class 3 Rocker-Rocker-Rocker Non-Grashof Mechanism';
                    case 3
                        h.mechType='Class 4 Rocker-Rocker-Rocker Non-Grashof Mechanism';
                    case 4
                        h.mechType='Class 1 Rocker-Rocker-Rocker Non-Grashof Mechanism';
                end

                if h.r(1) + h.r(4) < h.r(2) + h.r(3)   %Inward limited non-grashof
                    h.rtheta1prime=acos(( h.r(4)^2+h.r(1)^2-(h.r(3)-h.r(2))^2) / (2*h.r(4)*h.r(1)) );
                    h.dtheta1prime=180/pi*h.rtheta1prime;
                    h.dtheta1=linspace(h.dtheta1prime,360-h.dtheta1prime,360-2*h.dtheta1prime);

                else %Outward limited non-grashof
                    h.rtheta1prime=acos(( h.r(4)^2+h.r(1)^2-(h.r(3)+h.r(2))^2) / (2*h.r(4)*h.r(1)) );
                    h.dtheta1prime=180/pi*h.rtheta1prime;
                    h.dtheta1=linspace(-h.dtheta1prime,h.dtheta1prime,2*h.dtheta1prime);

                end

            end
        end   
    end

    function ANIMATIONSETTINGS
        h.cstep = find(h.dtheta1==70);
        if isempty(h.cstep)
            h.cstep = numel(h.dtheta1);
        end
        h.rstep = h.cstep;
        h.switched = false;
        h.increment = 1;
        h.animate = false;
        h.usercstep = '';
        h.basetime=.1;
        h.minSpeed=1;
        h.maxSpeed=6;
        val=h.maxSpeed;
        h.pause=.5/2^val;
        pause off;
    end

    function CALCULATIONS
        %Calculations for position of basic 4-bar
        h.rtheta1 = h.dtheta1*pi/180;
        h.xa = h.L(1)*cos(h.rtheta1); h.ya = h.L(1)*sin(h.rtheta1);
        d = sqrt(h.L(4)^2+h.L(1)^2-2*h.L(4)*h.L(1)*cos(h.rtheta1));
        rbeta = acos((h.L(2)^2-d.^2-h.L(3)^2)./(-2*d*h.L(3)));
        rdelta = atan2(h.ya,h.L(4)-h.xa);
        h.rtheta3 = pi-rbeta-rdelta;
        h.dtheta3 = h.rtheta3*180/pi;
        h.xb = h.L(4)+h.L(3)*cos(h.rtheta3); h.yb = h.L(3)*sin(h.rtheta3);
        h.rtheta2 = atan2(h.yb-h.ya,h.xb-h.xa);
        h.dtheta2 = h.rtheta2*180/pi;
        
        %Determine which IC to find
        if h.inputLIndex==1 || h.inputLIndex==3
            x1a=0; y1a=0;
            x1b=h.xa; y1b=h.ya;
            x2a=h.L(4); y2a=0;
            x2b=h.xb; y2b=h.yb;
        else
            x1a=h.xa; y1a=h.ya;
            x1b=h.xb; y1b=h.yb;
            x2a=0; y2a=0;
            x2b=h.L(4); y2b=0;
        end
                
        %Calculation of Fixed Polode
        m1=(y1b-y1a)./(x1b-x1a);
        m2=(y2b-y2a)./(x2b-x2a);
        h.xic=(m1.*x1a-m2.*x2a+y2a-y1a)./(m1-m2);
        h.yic=m1.*(h.xic-x1a)+y1a;

        %Build the position cell array
        h.PosArray = BUILDPOSITIONARRAY;
    end

    function MAKEFIGURE
        xmin=-2.2; xmax=5.2;
        ymin=-2.2; ymax=4.2;
        h.startAxis=[xmin xmax ymin ymax];

        %Units are in centimeters
        figL=1; figB=2; figR=1; figT=3;
        axL=2; axB=1.5; axT=2;
        panSpace=1; panW=6.5; panR=1.5;
        MarginT=.8; MarginL=.4; MarginB=.2; MarginR=.4;
        StartButtonH=1; InterButtonSpace=.2; InvertButtonH=.9;
        PreTitleSpace=.4; TitleH=.5; PostTitleSpace=.1;
        Indent=.5; ToolH=.5;
        PreEditSpace=.2; EditW=1.1;
        InterBoxSpace=0;
        LinkTextW=1.1; InterSliderSpace=.2; PreLinkButtonSpace=.2;
        PreZoomButtonSpace=.5; ZoomButtonH=.7; ZoomButtonW=2.7;
        PopupH=.6; PostPopupSpace=.2; PopupIndent=.8;
        SignatureH=.8; PreSignatureSpace=.3;
        PreHelpButtonSpace=.3; HelpButtonH=.7;

        BoxH=ToolH;
        panH=MarginB+4*BoxH+3*InterBoxSpace+4*(PostTitleSpace+TitleH+PreTitleSpace)+...
            6*ToolH+2*InvertButtonH+3*InterButtonSpace+StartButtonH+MarginT+...
            3*InterSliderSpace+PreZoomButtonSpace+2*ZoomButtonH+...
            PopupH+PostPopupSpace+SignatureH+PreSignatureSpace+...
            PreHelpButtonSpace+HelpButtonH; %-...
%             PreTitleSpace-PostTitleSpace-TitleH-ToolH; %Removal of SpeedSlider
        ButtonW=panW-MarginL-MarginR;
        ToolW=panW-MarginL-MarginR-Indent;
        %
        if isappdata(0,'base_unit')
            % leave it alone
        else
            setappdata(0,'base_unit',get(0,'units'));  
        end  % Remember base unit and reset at close.
        set(0,'Units','centimeters');
        ScreenDims = get(0,'ScreenSize');
        screenW=ScreenDims(3);
        screenH=ScreenDims(4);

        h.HWratio=(ymax-ymin)/(xmax-xmin);
        maxFigH=screenH-figB-figT;
        maxFigW=screenW-figL-figR;

        if maxFigH < h.HWratio*maxFigW
            figH=maxFigH;
            axH=figH-axB-axT;
            axW=axH/h.HWratio;
            figW=axL+axW+panSpace+panW+panR;
        else
            figW=maxFigW;
            axW=figW-axL-panSpace-panW-panR;
            axH=axW*h.HWratio;
            figH=axB+axH+axT;
        end
        
        if figH<panH+1
            dif=panH+1-figH;
            figH=panH+1;
            figB=figB-dif;
            axB=axB+dif;
        end 

        figL=(screenW-figW)/2;
        panB=(figH-panH)/2;
        panL=axL+axW+panSpace;
        
        h.fig = figure('Name','Four-Bar Mechanism with Polodes',...
            'Units','centimeters','Position',[figL figB figW figH],...
            'NumberTitle','off','ReSize','off','CloseRequestFcn',@close_fig);
        axes('Units','centimeters','position',[axL axB axW axH]);
        axis equal;
        axis([xmin xmax ymin ymax]);

        panel=uipanel('Units','centimeters','position',[panL panB panW panH],...
            'title','Control Panel','fontsize',12,'fontweight','bold',...
            'fontname','times');

        %StartStop Button
        currentB = panH-MarginT-StartButtonH;

        h.StartButton=uicontrol(panel,'units','centimeters',...
            'string','START','fontname','times','fontsize',28,...
            'position',[MarginL currentB ButtonW StartButtonH],...
            'callback',@STARTSTOP,'foregroundcolor',1/255*[42 121 17]);

        %Invert Button
        currentB = currentB-InterButtonSpace-InvertButtonH;

        h.InvertButton=uicontrol(panel,'units','centimeters',...
            'style','toggle','string','Invert Mechanism',...
            'fontname','times','fontsize',20,...
            'position',[MarginL currentB ButtonW InvertButtonH],...
            'callback',@INVERT);

        %Reverse Button
        currentB = currentB-InterButtonSpace-InvertButtonH;

        h.ReverseButton=uicontrol(panel,'units','centimeters',...
            'string','Reverse',...
            'fontname','times','fontsize',20,...
            'position',[MarginL currentB ButtonW InvertButtonH],...
            'callback',@REVERSE);

        %Speed Slider
        currentB = currentB-PreTitleSpace-TitleH;

        uicontrol(panel,'units','centimeters',...
            'style','text','string','Speed','fontname','times',...
            'fontsize',12,'fontweight','bold','fontangle','italic',...
            'position',[MarginL currentB ButtonW TitleH],...
            'horizontalalignment','left');

        currentB = currentB-PostTitleSpace-ToolH;

        h.SpeedSlider=uicontrol(panel,'units','centimeters',...
            'style','slider','min',h.minSpeed,'max',h.maxSpeed,'value',h.maxSpeed,...
            'sliderstep',1/(h.maxSpeed-h.minSpeed)*[1 1],'callback',@SPEED_SLIDER,...
            'position',[MarginL+Indent currentB ToolW ToolH]);

        %Input Angle Slider
        currentB = currentB-PreTitleSpace-TitleH;

        uicontrol(panel,'units','centimeters',...
            'style','text','string','Reference Link Angle','fontname','times',...
            'fontsize',12,'fontweight','bold','fontangle','italic',...
            'position',[MarginL currentB ButtonW TitleH],...
            'horizontalalignment','left');

        currentB = currentB-PostTitleSpace-ToolH;

        h.PositionSlider=uicontrol(panel,'units','centimeters',...
            'style','slider','min',min(h.dtheta1),'max',max(h.dtheta1),...
            'value',h.dtheta1(h.cstep),...
            'sliderstep',1/numel(h.dtheta1)*[1 5],'callback',@POSITION_SLIDER,...
            'position',[MarginL+Indent currentB ToolW-EditW-PreEditSpace ToolH]);

        h.PositionEdit=uicontrol(panel,'units','centimeters',...
            'style','edit','string',sprintf('%.1f',h.dtheta1(h.cstep)),...
            'callback',@POSITION_EDIT,...
            'fontname','times','fontsize',12,...
            'position',[panW-MarginR-EditW currentB EditW ToolH]);

        %Link Lengths
        minL=0.001; maxL=10;
        currentB = currentB-PreTitleSpace-TitleH;

        uicontrol(panel,'units','centimeters',...
            'style','text','string','Link Lengths','fontname','times',...
            'fontsize',12,'fontweight','bold','fontangle','italic',...
            'position',[MarginL currentB ButtonW TitleH],...
            'horizontalalignment','left');
        
        currentB = currentB-PostTitleSpace-PopupH;
        h.Popup=uicontrol(panel,'units','centimeters',...
            'style','popup','callback',@OPTIONS,'fontname','times',...
            'fontsize',11,...
            'string',['Link Length Options...|Current|Previous|',...
            'GCCC Example|GCRR Example|GRCR Example|GRRC Example|',...
            'RRR1 Example|RRR2 Example|RRR3 Example|RRR4 Example|',...
            'SCCC Example|SCRR Example|SRCR Example|SRRC Example|',...
            'Parallelogram (S2X)|Deltoid (S2X)|Square (S3X)'],...
            'position',[MarginL+PopupIndent currentB ButtonW-2*PopupIndent PopupH]);

        Links={'Input','Coupler','Output','Ground'};
        for k=1:4
            if k==1
	           currentB = currentB-PostPopupSpace-PopupH;
            else
	           currentB = currentB-InterSliderSpace-ToolH;
            end

            uicontrol(panel,'units','centimeters',...
                'style','text','string',Links{k},'fontname','times',...
                'fontsize',8,... %'fontweight','bold','fontangle','italic',...
                'position',[MarginL currentB LinkTextW ToolH],...
                'horizontalalignment','left');

            h.LinkSlider(k)=uicontrol(panel,'units','centimeters',...
                'style','slider','min',minL,'max',maxL,...
                'value',h.r(k),...
                'sliderstep',1/(maxL-minL)*[.05 1],'callback',@LINK_SLIDER,...
                'position',[MarginL+LinkTextW currentB ButtonW-EditW-PreEditSpace-LinkTextW ToolH]);

            h.LinkEdit(k)=uicontrol(panel,'units','centimeters',...
                'style','edit','string',num2str(h.r(k)),...
                'callback',@LINK_EDIT,...
                'fontname','times','fontsize',12,...
                'position',[panW-MarginR-EditW currentB EditW ToolH]);
        end

        currentB = currentB-PreLinkButtonSpace-ZoomButtonH;

        h.ChangeLinksButton=uicontrol(panel,'units','centimeters',...
            'string','Change Links',...
            'fontname','times','fontsize',14,...
            'position',[MarginL+Indent currentB ButtonW-2*Indent ZoomButtonH],...
            'callback',@CHANGELINKS);
        

        %Display Options
        currentB = currentB-PreTitleSpace-TitleH;

        uicontrol(panel,'units','centimeters',...
            'style','text','string','Display','fontname','times',...
            'fontsize',12,'fontweight','bold','fontangle','italic',...
            'position',[MarginL currentB ButtonW TitleH],...
            'horizontalalignment','left');

        currentB = currentB-PostTitleSpace-BoxH;

        h.PolodesCheckbox=uicontrol(panel,'units','centimeters',...
            'style','checkbox','value',1,'string','Polodes',...
            'fontname','times','fontsize',11,...
            'position',[MarginL+Indent currentB ToolW BoxH],...
            'Callback',@POLODES_CHECKBOX);
        
        currentB = currentB-InterBoxSpace-BoxH;

        h.JointPathsCheckbox=uicontrol(panel,'units','centimeters',...
            'style','checkbox','value',1,'string','Joint Paths',...
            'fontname','times','fontsize',11,...
            'position',[MarginL+Indent currentB ToolW BoxH],...
            'Callback',@JOINTPATHS_CHECKBOX);
        
        currentB = currentB-InterBoxSpace-BoxH;

        h.AnglesCheckbox=uicontrol(panel,'units','centimeters',...
            'style','checkbox','value',1,'string','Angles',...
            'fontname','times','fontsize',11,...
            'position',[MarginL+Indent currentB ToolW BoxH],...
            'Callback',@ANGLES_CHECKBOX);

        currentB = currentB-InterBoxSpace-BoxH;

        h.CoordsCheckbox=uicontrol(panel,'units','centimeters',...
            'style','checkbox','value',0,'string','Point Coordinates',...
            'fontname','times','fontsize',11,...
            'position',[MarginL+Indent currentB ToolW BoxH],...
            'Callback',@COORDS_CHECKBOX);

        
        %Zoom Controls

        currentB = currentB-PreZoomButtonSpace-ZoomButtonH;

        h.AutoZoomButton=uicontrol(panel,'units','centimeters',...
            'string','Auto Zoom',...
            'fontname','times','fontsize',14,...
            'position',[MarginL currentB ZoomButtonW ZoomButtonH],...
            'callback',@AUTOZOOM);

        h.AllZoomButton=uicontrol(panel,'units','centimeters',...
            'string','Zoom Fit',...
            'fontname','times','fontsize',14,...
            'position',[panW-MarginR-ZoomButtonW currentB ZoomButtonW ZoomButtonH],...
            'callback',@ZOOMALL);

        %Help Button
        currentB = currentB-PreHelpButtonSpace-HelpButtonH;

        h.HelpButton=uicontrol(panel,'units','centimeters',...
            'string','Instructions',...
            'fontname','times','fontsize',14,...
            'position',[MarginL+PopupIndent currentB ButtonW-2*PopupIndent HelpButtonH],...
            'callback',@HELPDIALOG);
        
        %Signature
        currentB = currentB-PreSignatureSpace-SignatureH;

        uicontrol(panel,'units','centimeters',...
            'style','text','string','Program by John Hawkins','fontname','times',...'Monotype Corsiva',...
            'fontsize',14,...'fontangle','italic',...
            'position',[MarginL currentB ButtonW SignatureH],...
            'horizontalalignment','center');

        drawnow
    end

    function INITIALPLOTS
        hold on;
        plot(0,0,'k');
        h.FigTitle=title(h.mechType,...
            'FontSize',20,'FontName','Times');
        
        AUTOZOOM(0,0,0);
%         axis(h.startAxis);

        [x,y,a] = COORDINATES;
        FixedXIC=[];
        FixedYIC=[];
        JointPathX1=[]; JointPathX2=[];
        JointPathY2=[]; JointPathY2=[];
        for k=1:numel(h.xa)
            FixedXIC(k)=h.PosArray(1,5,k,k);
            FixedYIC(k)=h.PosArray(2,5,k,k);
            JointPathX1(k)=h.PosArray(1,2,k,k);
            JointPathX2(k)=h.PosArray(1,3,k,k);
            JointPathY1(k)=h.PosArray(2,2,k,k);
            JointPathY2(k)=h.PosArray(2,3,k,k);
        end
        h.FixedICMatrix=[FixedXIC;FixedYIC;ones(1,numel(FixedXIC))];

        h.JointPath1=plot(JointPathX1,JointPathY1,'.','color',[.7,.7,1]);
        h.JointPath2=plot(JointPathX2,JointPathY2,'.','color',[.7,.7,1]);
        h.FixedPolode = plot(FixedXIC,FixedYIC,'.k');
        h.ic = plot(x.ic,y.ic,'-.b');
        h.MovingPolode = plot(x.MovingPolode,y.MovingPolode,'.b');

        h.h.L(4) = plot(x.h.L4,y.h.L4,'r-.');
        h.fourbar = plot(x.fourbar,y.fourbar,'r');
        h.dots = plot(x.fourbar,y.fourbar,'ro');
        h.base = plot(x.h.L4,y.h.L4,'r^','LineWidth',3);

        h.coordO = text(x.coordO,y.coordO,sprintf('(%.2f,%.2f)',0,0),...
            'horizontalalignment','right','visible','off');
        h.coordA = text(x.coordA,y.coordA,sprintf('(%.2f,%.2f)',h.xa(h.cstep),h.ya(h.cstep)),...
            'HorizontalAlignment','right','visible','off');
        h.coordB = text(x.coordB,y.coordB,sprintf('(%.2f,%.2f)',...
            h.xb(h.cstep),h.yb(h.cstep)),'visible','off');
        h.coordE = text(x.coordE,y.coordE,sprintf('(%.2f,%.2f)',h.L(4),0),...
            'visible','off');

        h.angleO = text(x.angleO,y.angleO,sprintf('%.1f^o',a.angleO),...
            'horizontalalignment','center');
        h.angleA = text(x.angleA,y.angleA,sprintf('%.1f^o',a.angleA),...
            'horizontalalignment','center');
        h.angleB = text(x.angleB,y.angleB,sprintf('%.1f^o',a.angleB),...
            'horizontalalignment','center');
        h.angleE = text(x.angleE,y.angleE,sprintf('%.1f^o',a.angleE),...
            'horizontalalignment','center');
    end

    function PosArray = BUILDPOSITIONARRAY
        %Builds a 3-by-5-by-numel(dtheta1)-by-numel(dtheta1) matrix, 
        %which can most easily be viewed as a 2D matrix of 2D
        %'FirstValues' matrices.  The 'rows and columns' of the outer
        %matrix (indices 3 and 4), correspond to rotations the coordinate
        %system will have to go through to generate the moving polode.  The
        %diagonal of this matrix comprises the case when the two rotations
        %are the same, canceling each other out.  Hence, the non-inverted
        %mechanism is the diagonal of this matrix.  The moving polode
        %corresponds to all the IC values of whichever row is currently being
        %viewed.

        FirstValues = zeros(3,5,numel(h.dtheta1));
        for k = 1:numel(h.dtheta1)
            FirstValues(:,:,k) = [  0   h.xa(k)   h.xb(k)   h.L(4)  h.xic(k);
                                    0   h.ya(k)   h.yb(k)   0       h.yic(k);
                                    1   1         1         1       1       ];
        end
        
        switch h.inputLIndex
            case 1
                InvTheta=h.rtheta2;
                XA=h.xa;
                YA=h.ya;
                
            h.rtheta1Real=h.rtheta1;
            h.rtheta2Real=h.rtheta2;
            h.rtheta3Real=h.rtheta3;
            
            h.dtheta1Real=h.dtheta1;
            h.dtheta2Real=h.dtheta2;
            h.dtheta3Real=h.dtheta3;
            case 2
                Px=h.L(4)*ones(numel(h.xa),1);
                Py=zeros(numel(h.xa),1);
                theta=h.rtheta3;

                FirstValues=[FirstValues(:,4,:),FirstValues(:,1,:),FirstValues(:,2,:),...
                    FirstValues(:,3,:),FirstValues(:,5,:)];
                
            case 3
                Px=h.xb; Py=h.yb;
                theta=-(pi-h.rtheta2);
                
                FirstValues=[FirstValues(:,3,:),FirstValues(:,4,:),FirstValues(:,1,:),...
                    FirstValues(:,2,:),FirstValues(:,5,:)];

            case 4
                Px=h.xa; Py=h.ya;
                theta=-(pi-h.rtheta1);
                
                FirstValues=[FirstValues(:,2,:),FirstValues(:,3,:),FirstValues(:,4,:),...
                    FirstValues(:,1,:),FirstValues(:,5,:)];
        end
        
        if h.inputLIndex>1
            for k=1:numel(h.xa)
                %FirstValues(:,:,k) = inv(TMAT2D(Px(k),Py(k),theta(k)))*FirstValues(:,:,k);
                FirstValues(:,:,k) = (TMAT2D(Px(k),Py(k),theta(k)))\FirstValues(:,:,k);                
            end
            
            InvTheta=atan2(FirstValues(2,3,:)-FirstValues(2,2,:),...
                FirstValues(1,3,:)-FirstValues(1,2,:));
            XA=FirstValues(1,2,:);
            YA=FirstValues(2,2,:);
            XB=FirstValues(1,3,:);
            YB=FirstValues(2,3,:);
            XE=FirstValues(1,4,:);

            h.rtheta1Real=atan2(YA,XA);
            h.rtheta2Real=atan2(YB-YA,XB-XA);
            h.rtheta3Real=atan2(YB,XB-XE);
            
            h.dtheta1Real=180/pi*h.rtheta1Real;
            h.dtheta2Real=180/pi*h.rtheta2Real;
            h.dtheta3Real=180/pi*h.rtheta3Real;
        end
        
        PosArray = zeros(3,5,numel(h.dtheta1),numel(h.dtheta1));
        TMatrix=[];
        for k = 1:numel(h.dtheta1)
            TMatrix(:,:,k)=TMAT2D(XA(k),YA(k),InvTheta(k));
            InvTMatrix(:,:,k)=inv(TMatrix(:,:,k));
        end
        for k = 1:numel(h.dtheta1)
            for q = 1:numel(h.dtheta1)
                PosArray(:,:,k,q) = TMatrix(:,:,k)*InvTMatrix(:,:,q)*FirstValues(:,:,q);
            end
        end
    end
        
    function T = TMAT2D(x,y,theta)
        %Theta in radians
        ctheta = cos(theta);
        stheta = sin(theta);
        
        T = [ctheta -stheta x;
            stheta ctheta y;
            0 0 1];
    end

    function [x,y,a] = COORDINATES
        if ~h.switched
            h.rstep = h.cstep;
        end
        
        CurPos = h.PosArray(:,:,h.rstep,h.cstep);
        
        XO = CurPos(1,1); YO = CurPos(2,1);
        XA = CurPos(1,2); YA = CurPos(2,2);
        XB = CurPos(1,3); YB = CurPos(2,3);
        XE = CurPos(1,4); YE = CurPos(2,4);
        XIC = CurPos(1,5); YIC = CurPos(2,5);
        
        if ~h.switched
            x.h.L4 = [XO,XE]; y.h.L4 = [YO,YE];
            x.fourbar = [XO,XA,XB,XE];
            y.fourbar = [YO,YA,YB,YE];
        else
            x.h.L4 = [XA,XB]; y.h.L4 = [YA,YB];
            x.fourbar = [XA,XO,XE,XB];
            y.fourbar = [YA,YO,YE,YB];
        end
            
        x.ic = [XO,XA,XIC,XB,XE];
        y.ic = [YO,YA,YIC,YB,YE];
        
        x.MovingPolode = squeeze(h.PosArray(1,5,h.rstep,:));
        y.MovingPolode = squeeze(h.PosArray(2,5,h.rstep,:));

        x.coordO = XO-.2; y.coordO = YO;
        x.coordA = XA-.2; y.coordA = YA;
        x.coordB = XB+.2; y.coordB = YB;
        x.coordE = XE+.2; y.coordE = YE;
        
        a.angleO=h.dtheta1Real(h.cstep);
        a.angleA=h.dtheta2Real(h.cstep)+180-h.dtheta1Real(h.cstep);
        if a.angleA>360
            a.angleA=a.angleA-360;
        end
        a.angleE=180-h.dtheta3Real(h.cstep);
        a.angleB=360-a.angleO-a.angleA-a.angleE;
        if a.angleB>360
            a.angleB=a.angleB-360;
        end
        
        a.offset=atan2(YE-YO,XE-XO);
        
        dis=.1*max(h.r);
        x.angleO=XO+dis*cos(a.offset+h.rtheta1Real(h.cstep)/2); 
        y.angleO=YO+dis*sin(a.offset+h.rtheta1Real(h.cstep)/2);
        x.angleA=XA+dis*cos(a.offset+h.rtheta2Real(h.cstep)-pi/180*a.angleA/2);
        y.angleA=YA+dis*sin(a.offset+h.rtheta2Real(h.cstep)-pi/180*a.angleA/2);
        x.angleB=XB+dis*cos(a.offset+pi+h.rtheta3Real(h.cstep)-pi/180*a.angleB/2);
        y.angleB=YB+dis*sin(a.offset+pi+h.rtheta3Real(h.cstep)-pi/180*a.angleB/2);
        x.angleE=XE+dis*cos(a.offset+h.rtheta3Real(h.cstep)+pi/180*a.angleE/2);
        y.angleE=YE+dis*sin(a.offset+h.rtheta3Real(h.cstep)+pi/180*a.angleE/2);
    end
            
    function REDRAW
        if h.isgrashof
            if h.cstep > numel(h.xa)
                h.cstep = 1;
            elseif h.cstep < 1
                h.cstep = numel(h.xa);
            end
        else
            if h.cstep > numel(h.xa)
                h.cstep = numel(h.xa);
                h.increment = -1*h.increment;
            elseif h.cstep < 1
                h.cstep = 1;
                h.increment = -1*h.increment;
            end
        end
        
        [x,y,a] = COORDINATES;
        set(h.h.L(4),'XData',x.h.L4,'YData',y.h.L4);
        set(h.fourbar,'XData',x.fourbar,'YData',y.fourbar);
        set(h.dots,'XData',x.fourbar,'YData',y.fourbar);
        set(h.ic,'XData',x.ic,'YData',y.ic);
        
        CurPos = h.PosArray(:,:,h.rstep,h.cstep);
        
        XO = CurPos(1,1); YO = CurPos(2,1);
        XA = CurPos(1,2); YA = CurPos(2,2);
        XB = CurPos(1,3); YB = CurPos(2,3);
        XE = CurPos(1,4); YE = CurPos(2,4);
        XIC = CurPos(1,5); YIC = CurPos(2,5);
        
        set(h.coordO,'Position',[x.coordO,y.coordO],...
            'String',sprintf('(%.2f,%.2f)',XO,YO));
        set(h.coordA,'Position',[x.coordA,y.coordA],...
            'String',sprintf('(%.2f,%.2f)',XA,YA));
        set(h.coordB,'Position',[x.coordB,y.coordB],...
            'String',sprintf('(%.2f,%.2f)',XB,YB));
        set(h.coordE,'Position',[x.coordE,y.coordE],...
            'String',sprintf('(%.2f,%.2f)',XE,YE));
        
        set(h.angleO,'position',[x.angleO,y.angleO],'string',sprintf('%.1f^o',a.angleO));
        set(h.angleA,'position',[x.angleA,y.angleA],'string',sprintf('%.1f^o',a.angleA));
        set(h.angleB,'position',[x.angleB,y.angleB],'string',sprintf('%.1f^o',a.angleB));
        set(h.angleE,'position',[x.angleE,y.angleE],'string',sprintf('%.1f^o',a.angleE));
        
        set(h.MovingPolode,'XData',x.MovingPolode,'YData',y.MovingPolode);
        
        set(h.PositionSlider,'value',h.dtheta1(h.cstep));
        set(h.PositionEdit,'string',sprintf('%.1f',h.dtheta1(h.cstep)));
        
        if h.switched
            rotTheta=atan2(YE-YO,XE-XO);
            CurrentFixedIC=TMAT2D(XO,YO,rotTheta)*h.FixedICMatrix;
            set(h.FixedPolode,'xdata',CurrentFixedIC(1,:),...
                'ydata',CurrentFixedIC(2,:));
        end
        
        drawnow
    end

    function ANIMATE
        while h.animate
            h.cstep = h.cstep+h.increment;
            REDRAW;
            pause(h.pause)
        end
    end

    function STARTSTOP(src,event,c)
        if h.animate
            h.animate = false;
            set(h.StartButton,'string','START','foregroundcolor',1/200*[42 121 17]);
        else
            h.animate = true;
            set(h.StartButton,'string','STOP','foregroundcolor',1/255*[230 0 0]);
            ANIMATE;
        end
    end

    function INVERT(src,event,c)
        if h.switched
            direction = sign(h.rstep-h.cstep);
            if direction
                set(h.InvertButton,'string','Inverting...');
                h.increment = direction*abs(h.increment);
                while sign(h.rstep-h.cstep) == direction
                    h.cstep = h.cstep+h.increment;
                    REDRAW;
                end
                h.cstep = h.rstep;
                set(h.InvertButton,'string','Invert Mechanism');
            end
            h.switched = false;
            set(h.FixedPolode,'xdata',h.FixedICMatrix(1,:),...
                'ydata',h.FixedICMatrix(2,:));
            REDRAW;

            JointPathX1=[]; JointPathX2=[];
            JointPathY2=[]; JointPathY2=[];
            for k=1:numel(h.xa)
                JointPathX1(k)=h.PosArray(1,2,k,k);
                JointPathX2(k)=h.PosArray(1,3,k,k);
                JointPathY1(k)=h.PosArray(2,2,k,k);
                JointPathY2(k)=h.PosArray(2,3,k,k);
            end
            set(h.JointPath1,'xdata',JointPathX1,'ydata',JointPathY1);
            set(h.JointPath2,'xdata',JointPathX2,'ydata',JointPathY2);

        else
            h.switched = true;
            REDRAW;
            set(h.JointPath1,'xdata',squeeze(h.PosArray(1,1,h.rstep,:)),...
                'ydata',squeeze(h.PosArray(2,1,h.rstep,:)));
            set(h.JointPath2,'xdata',squeeze(h.PosArray(1,4,h.rstep,:)),...
                'ydata',squeeze(h.PosArray(2,4,h.rstep,:)));
            
        end
    end

    function REVERSE(src,event,c)
        h.increment=-h.increment;
    end

    function SPEED_SLIDER(src,event)
        val=round(get(h.SpeedSlider,'value'));
        set(h.SpeedSlider,'value',val);
        h.pause=.5/2^val;
        if val==h.maxSpeed
            pause off;
        else
            pause on;
        end
    end

    function POSITION_SLIDER(src,event)
        val=get(h.PositionSlider,'value');
        [minVal,minPos]=min(abs(h.dtheta1-val));
        set(h.PositionSlider,'value',minVal);
        set(h.PositionEdit,'string',num2str(minVal));
        h.cstep = minPos;
        REDRAW;
    end

    function POSITION_EDIT(src,event)
        val=str2num(get(h.PositionEdit,'string'));
        [minVal,minPos]=min(abs(h.dtheta1-val));
        
        set(h.PositionEdit,'string',minVal);
        set(h.PositionSlider,'value',minVal);
        h.cstep = minPos;
        REDRAW;
    end

    function POLODES_CHECKBOX(src,event)
        checked=get(h.PolodesCheckbox,'value');
        if checked
            set([h.FixedPolode h.MovingPolode h.ic],'visible','on');
        else
            set([h.FixedPolode h.MovingPolode h.ic],'visible','off');
        end
    end

    function JOINTPATHS_CHECKBOX(src,event)
        checked=get(h.JointPathsCheckbox,'value');
        if checked
            set([h.JointPath1 h.JointPath2],'visible','on');
        else
            set([h.JointPath1 h.JointPath2],'visible','off');
        end
    end

    function ANGLES_CHECKBOX(src,event)
        checked=get(h.AnglesCheckbox,'value');
        if checked
            set([h.angleO,h.angleA,h.angleB,h.angleE],'visible','on');
        else
            set([h.angleO,h.angleA,h.angleB,h.angleE],'visible','off');
        end
    end

    function COORDS_CHECKBOX(src,event)
        checked=get(h.CoordsCheckbox,'value');
        if checked
            set([h.coordO,h.coordA,h.coordB,h.coordE],'visible','on');
        else
            set([h.coordO,h.coordA,h.coordB,h.coordE],'visible','off');
        end
    end

    function OPTIONS(src,event)
        val=get(h.Popup,'value');
        switch val
            case 2 %Revert to Current
                rNew=h.r;
            case 3 %Previous
                rNew=h.rOld;
            case 4 %GCCC Example
                rNew=[ 3 4 3 1.5];
            case 5 %GCRR Example
                rNew=[ 1.5 3 4 3];
            case 6 %GRCR Example
                rNew=[ 3 1.5 3 4];
            case 7 %GRRC Example
                rNew=[ 4 3 1.5 3];
            case 8 %RRR1 Example
                rNew=[ 2 4 2 1];
            case 9 %RRR2 Example
                rNew=[ 1 2 4 2];
            case 10 %RRR3 Example
                rNew=[ 2 1 2 4];
            case 11 %RRR4 Example
                rNew=[ 4 2 1 2];
            case 12 %SCCC Example
                rNew=[ 3 4 3 2];
            case 13 %SCRR Example
                rNew=[ 2 3 4 3];
            case 14 %SRCR Example
                rNew=[ 3 2 3 4];
            case 15 %SRRC Example
                rNew=[ 4 3 2 3];
            case 16 %Parallelogram
                rNew=[ 2 3 2 3];
            case 17 %Deltoid
                rNew=[ 2 2 3 3];
            case 18 %Square
                rNew=[ 2 2 2 2];
        end
        
        if val>1
            for k=1:4
                set(h.LinkSlider(k),'value',rNew(k));
                set(h.LinkEdit(k),'string',num2str(rNew(k)));
            end
        end
    end

    function LINK_SLIDER(src,event) 
        index=find(h.LinkSlider==src);
        set(h.LinkEdit(index),'string',num2str(get(h.LinkSlider(index),'value')));
        
        set(h.Popup,'value',1);
    end

    function LINK_EDIT(src,event)
        index=find(h.LinkEdit==src);
        val=str2num(get(h.LinkEdit(index),'string'));
        if val>10
            val=10;
        elseif val<=0
            val=.001;
        end
        set(h.LinkSlider(index),'value',val);
        set(h.LinkEdit(index),'string',num2str(val));
        
        set(h.Popup,'value',1);
    end
   
    function CHANGELINKS(src,event,c)
        animatestatus=h.animate;
        
        tempLinks=transpose(cell2mat(get(h.LinkSlider,'value')));
        
        if isequal(tempLinks,h.r)
            return;
        else
            rOld=h.r;
            h.r=tempLinks;
        end
        
        GRASHOFTEST;
        
        if ~h.isconstructible
            h.r=rOld;
            errordlg('Desired mechanism is not constructible or does not move.')
            return
        else
            h.rOld=rOld;
        end
              
        set(h.ChangeLinksButton,'string','Calculating...');
        
        drawnow;
        
        CALCULATIONS;
        
        FixedXIC=[];
        FixedYIC=[];
        JointPathX1=[]; JointPathX2=[];
        JointPathY2=[]; JointPathY2=[];
        for k=1:numel(h.xa)
            FixedXIC(k)=h.PosArray(1,5,k,k);
            FixedYIC(k)=h.PosArray(2,5,k,k);
            JointPathX1(k)=h.PosArray(1,2,k,k);
            JointPathX2(k)=h.PosArray(1,3,k,k);
            JointPathY1(k)=h.PosArray(2,2,k,k);
            JointPathY2(k)=h.PosArray(2,3,k,k);
        end
        h.FixedICMatrix=[FixedXIC;FixedYIC;ones(1,numel(FixedXIC))];
        set(h.FixedPolode,'xdata',FixedXIC,'ydata',FixedYIC);
        
        if ~h.switched
            set(h.JointPath1,'xdata',JointPathX1,'ydata',JointPathY1);
            set(h.JointPath2,'xdata',JointPathX2,'ydata',JointPathY2);
        else
            set(h.JointPath1,'xdata',squeeze(h.PosArray(1,1,h.rstep,:)),...
                'ydata',squeeze(h.PosArray(2,1,h.rstep,:)));
            set(h.JointPath2,'xdata',squeeze(h.PosArray(1,4,h.rstep,:)),...
                'ydata',squeeze(h.PosArray(2,4,h.rstep,:)));
        end
        
        set(h.base,'xdata',[0,h.r(4)]);
        
        REDRAW;
        set(h.FigTitle,'string',h.mechType);

        set(h.ChangeLinksButton,'string','Change Links');
        set(h.PositionSlider,'min',min(h.dtheta1),'max',max(h.dtheta1));
        
        AUTOZOOM(0,0,0);
        
        h.animate=animatestatus;
    end

    function AUTOZOOM(src,event,c)
        maxlink=max(h.r);
        xmin=-1.5*maxlink; xmax=1.5*maxlink+h.r(4);
        ymin=xmin; ymax=-ymin;
        LocHWratio=(ymax-ymin)/(xmax-xmin);
        if LocHWratio < h.HWratio
            Height=h.HWratio*(xmax-xmin);
            ymax=1/2*Height; ymin=-1/2*Height;
        elseif LocHWratio > h.HWratio
            Width=(ymax-ymin)/h.HWratio;
            xmax=1/2*h.r(4)+1/2*Width; xmin=1/2*h.r(4)-1/2*Width;
        end
        axis([xmin xmax ymin ymax]);
    end

    function ZOOMALL(src,event,c)
        numpoints=numel(h.PosArray(1,:,:,:));
        xPoints=reshape(h.PosArray(1,:,:,:),1,numpoints);
        yPoints=reshape(h.PosArray(2,:,:,:),1,numpoints);
        xPoints(xPoints==Inf)=[];
        yPoints(yPoints==Inf)=[];
        
        xmin=min(xPoints);
        xmax=max(xPoints);
        ymin=min(yPoints);
        ymax=max(yPoints);
        
        LocHWratio=(ymax-ymin)/(xmax-xmin);
        if LocHWratio < h.HWratio
            Height=h.HWratio*(xmax-xmin);
            ymax=1/2*Height+1/2*(ymax+ymin); ymin=-1/2*Height+1/2*(ymax+ymin);
        elseif LocHWratio > h.HWratio
            Width=(ymax-ymin)/h.HWratio;
            xmax=1/2*(xmax+xmin)+1/2*Width; xmin=1/2*(xmax+xmin)-1/2*Width;
        end
        axis([xmin xmax ymin ymax]);
    end

    function HELPDIALOG(src,event,c)
        dlgname = 'Instructions';
        
        helpstring = {...
            'For a quick start, just press "START."'                 ;...
            ' '                                                      ;...
            'To change mechanisms: '                                 ;...
            ' '                                                      ;...
            '  1) use the drop down box for "Link Length" options, ' ;...
            '     or  '                                              ;...
            '  2) use the length slider bars, '                      ;...
            '     and '                                              ;...
            '  3) hit "Change Links" button.'                        ;...
            ' '                                                      ;...
            'Interesting mechanisms to try: GCCC, GRCR, & SRCR examples.' ; ...
            ' '                                                      ;...
            'You may change link lengths, during the animation, if you press' ;...
            'the "Change Links" button '                             ;...
            ' '                                                      ;...
            'The 4-bar is in red, the polodes are in blue and black.';...
            ' '                                                      ;...
            'What is this all about? '                               ;...
            ' '                                                      ;...
            'The two polodes are the plots of the coupler link''s instant center (IC).' ; ...
            'The IC is where the input link and output link intersect.'                 ;...
            'The polode plot is shown for the mechanism and its inversion.'             ; ...
            'The inversion changes the moving coupler link to be the ground'            ;...
            'The IC is where the coupler link ''instantly'' rotates around.'            ;...
            'The two polode curves, when they roll on each other, '                      ; ...
            'produce the same motion as the 4-bar.'                                     ; ...
            ' '                                                                         ;...
            'The 4-bar may be easily seen by unchecking all boxes under "display." '    ;...
            ' '                                                                         ;...
            'The notation follows Barker''s classification of planar 4-bar mechanisms:'  ;...
            'Gxxx = Grashof, RRRx = non-Grashof, Sxx = special case '                   ;...
            'C = crank, R = rocker, thus a GRCR is a Grashof rocker-crank-rocker.'       ;...
            ' '                                                                         ;...
            'See Norton''s Design of Machinery (4th ed, pg 61) for more details.'   ; ...
            };
        helpdlg(helpstring,dlgname)
    end

    function close_fig(src,event,c)
        if isappdata(0,'base_unit')
            set(0,'Units',getappdata(0,'base_unit')); % Units set to original value
            rmappdata(0,'base_unit'); % remove the knowledge of org value
        end
        h.animate = false;  % Hit "stop" if running, for a clean exit.
        delete(gcbf)
    end
        
end
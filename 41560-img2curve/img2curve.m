function fig_hdl = img2curve
% img2curve
%-------------------------------------------------------------------------------
% File name   : img2curve.m        
% Generated on: 11-Mar-2013 10:54:18          
% Description :
% 
% img2curve helps import data from a graph in a photo file, received from a
% scan, catalog, pdf etc. by marking points on the curve.
% Output will include the marked points and a polynomial fit.
% Work flow:
% 1. Load image file.
% 2. Mark scale size for X and Y axis.
% 3. Set a value for a point on the image (0,0 or other) to locate CS.
% 4. Mark curve points.
% 5. Export to mat file, excel or work space.
% 
% Good Luck,
% Amihay Blau

%-------------------------------------------------------------------------------


% Initialize handles structure
handles = struct();

% Create all UI controls
build_gui();

% Assign function output
fig_hdl = handles.img2curve_figure;

%% ---------------------------------------------------------------------------
	function build_gui()
% Creation of all uicontrols

		% --- FIGURE -------------------------------------
		handles.img2curve_figure = figure( ...
			'Tag', 'img2curve_figure', ...
			'Units', 'centimeters', ...
			'Position', [4.9968253125 8.46023333333333 8.38091864583333 12.2673383333333], ...
			'Name', 'img2curve', ...
			'MenuBar', 'none', ...
			'NumberTitle', 'off', ...
			'Color', [0.804 0.878 0.969], ...
			'Resize', 'on');

		% --- PANELS -------------------------------------
		handles.import_uipanel = uipanel( ...
			'Parent', handles.img2curve_figure, ...
			'Tag', 'import_uipanel', ...
			'UserData', zeros(1,0), ...
			'Units', 'centimeters', ...
			'Position', [0.264382291666667 7.34982770833334 8.0107834375 4.70600479166667], ...
			'FontSize', 12, ...
			'BackgroundColor', [0.839 0.91 0.851], ...
			'Title', 'Import Image');

		handles.curve_uipanel = uipanel( ...
			'Parent', handles.img2curve_figure, ...
			'Tag', 'curve_uipanel', ...
			'UserData', zeros(1,0), ...
			'Units', 'centimeters', ...
			'Position', [0.264382291666667 3.7277903125 8.0107834375 3.48984625], ...
			'FontSize', 12, ...
			'BackgroundColor', [0.839 0.91 0.851], ...
			'Title', 'Define Curve');

		handles.save_uipanel = uipanel( ...
			'Parent', handles.img2curve_figure, ...
			'Tag', 'save_uipanel', ...
			'UserData', zeros(1,0), ...
			'Units', 'centimeters', ...
			'Position', [0.264382291666667 0.211505833333333 8.0107834375 3.35765510416667], ...
			'FontSize', 12, ...
			'BackgroundColor', [0.839 0.91 0.851], ...
			'Title', 'Save Curve Data');

		% --- STATIC TEXTS -------------------------------------
		handles.import_xScale_text = uicontrol( ...
			'Parent', handles.import_uipanel, ...
			'Tag', 'import_xScale_text', ...
			'Style', 'text', ...
			'Units', 'normalized', ...
			'Position', [0.381270903010033 0.33116883116883 0.535117056856187 0.246753246753247], ...
			'FontSize', 10, ...
			'BackgroundColor', [0.839 0.91 0.851], ...
			'String', {'X Scale','Y Scale'}, ...
			'HorizontalAlignment', 'left');

		handles.curve_PolOrder_text = uicontrol( ...
			'Parent', handles.curve_uipanel, ...
			'Tag', 'curve_PolOrder_text', ...
			'Style', 'text', ...
			'Units', 'normalized', ...
			'Position', [0.468227424749164 0.722222222222222 0.337792642140468 0.175925925925926], ...
			'FontSize', 10, ...
			'BackgroundColor', [0.839 0.91 0.851], ...
			'String', 'Polynom Order');

		handles.curve_Pol_text = uicontrol( ...
			'Parent', handles.curve_uipanel, ...
			'Tag', 'curve_Pol_text', ...
			'Style', 'text', ...
			'Units', 'normalized', ...
			'Position', [0.0602006688963211 0.0740740740740741 0.82943143812709 0.527777777777778], ...
			'FontSize', 10, ...
			'BackgroundColor', [0.839 0.91 0.851], ...
			'String', 'Curve Equation');

		% --- PUSHBUTTONS -------------------------------------
		handles.import_loadImg_pushbutton = uicontrol( ...
			'Parent', handles.import_uipanel, ...
			'Tag', 'import_loadImg_pushbutton', ...
			'UserData', zeros(1,0), ...
			'Style', 'pushbutton', ...
			'Units', 'normalized', ...
			'Position', [0.0735785953177258 0.669194186256364 0.247491638795987 0.25974025974026], ...
			'FontSize', 10, ...
			'String', 'Load Image', ...
			'TooltipString', 'Load curve image', ...
			'CData', zeros(1,0), ...
			'Callback', @import_loadImg_pushbutton_Callback);

		handles.import_getScaleFile_pushbutton = uicontrol( ...
			'Parent', handles.import_uipanel, ...
			'Tag', 'import_getScaleFile_pushbutton', ...
			'Style', 'pushbutton', ...
			'Units', 'normalized', ...
			'Position', [0.377926421404682 0.668831168831169 0.324414715719064 0.25974025974026], ...
			'FontSize', 10, ...
			'String', 'Get Scale File', ...
			'TooltipString', 'Get a previous scale file', ...
			'Enable', 'off', ...
			'Callback', @import_getScaleFile_pushbutton_Callback);

		handles.import_scale_pushbutton = uicontrol( ...
			'Parent', handles.import_uipanel, ...
			'Tag', 'import_scale_pushbutton', ...
			'Style', 'pushbutton', ...
			'Units', 'normalized', ...
			'Position', [0.0735785953177258 0.363999381061558 0.240802675585284 0.201298701298701], ...
			'FontSize', 10, ...
			'String', 'Set Scale', ...
			'TooltipString', 'Set image scale by marking points on axes and writing the difference between these points', ...
			'Enable', 'off', ...
			'Callback', @import_scale_pushbutton_Callback);

		handles.import_MarkRef_pushbutton = uicontrol( ...
			'Parent', handles.import_uipanel, ...
			'Tag', 'import_MarkRef_pushbutton', ...
			'Style', 'pushbutton', ...
			'Units', 'normalized', ...
			'Position', [0.0769230769230769 0.0977656148277906 0.471571906354515 0.201298701298701], ...
			'FontSize', 10, ...
			'String', 'Mark Reference Point', ...
			'TooltipString', 'set the C.S. by marking a point in the image. point value is set on the right', ...
			'Enable', 'off', ...
			'Callback', @import_MarkRef_pushbutton_Callback);

		handles.curve_markPoints_pushbutton = uicontrol( ...
			'Parent', handles.curve_uipanel, ...
			'Tag', 'curve_markPoints_pushbutton', ...
			'Style', 'pushbutton', ...
			'Units', 'normalized', ...
			'Position', [0.0635451505016723 0.675925925925926 0.404682274247492 0.305555555555555], ...
			'FontSize', 10, ...
			'String', 'Mark Curve Points', ...
			'TooltipString', 'Mark points on the curve', ...
			'Enable', 'off', ...
			'Callback', @curve_markPoints_pushbutton_Callback);

		handles.save_pushbutton = uicontrol( ...
			'Parent', handles.save_uipanel, ...
			'Tag', 'save_pushbutton', ...
			'Style', 'pushbutton', ...
			'Units', 'centimeters', ...
			'Position', [5.49915166666667 2.08862010416666 2.1414965625 0.846023333333334], ...
			'String', 'Save to mat', ...
			'TooltipString', 'Save results', ...
			'Enable', 'off', ...
			'Callback', @save_pushbutton_Callback);

		handles.save_excel_pushbutton = uicontrol( ...
			'Parent', handles.save_uipanel, ...
			'Tag', 'save_excel_pushbutton', ...
			'Style', 'pushbutton', ...
			'Units', 'centimeters', ...
			'Position', [5.49915166666667 1.16328208333333 2.1414965625 0.846023333333334], ...
			'String', 'Save to excel', ...
			'TooltipString', 'Save results', ...
			'Enable', 'off', ...
			'Callback', @save_excel_pushbutton_Callback);

		handles.save_ws_pushbutton = uicontrol( ...
			'Parent', handles.save_uipanel, ...
			'Tag', 'save_ws_pushbutton', ...
			'Style', 'pushbutton', ...
			'Units', 'centimeters', ...
			'Position', [5.49915166666667 0.237944062499997 2.1414965625 0.846023333333334], ...
			'String', 'Save to WS', ...
			'TooltipString', 'Save results', ...
			'Enable', 'off', ...
			'Callback', @save_ws_pushbutton_Callback);

		% --- EDIT TEXTS -------------------------------------
		handles.import_MarkRefX_edit = uicontrol( ...
			'Parent', handles.import_uipanel, ...
			'Tag', 'import_MarkRefX_edit', ...
			'Style', 'edit', ...
			'Units', 'normalized', ...
			'Position', [0.648829431438127 0.123739640801817 0.0869565217391304 0.155844155844156], ...
			'FontSize', 10, ...
			'BackgroundColor', [1 1 1], ...
			'String', '0', ...
			'TooltipString', 'Reference point X value', ...
			'Callback', @import_MarkRefX_edit_Callback, ...
			'CreateFcn', @import_MarkRefX_edit_CreateFcn);

		handles.import_MarkRefY_edit = uicontrol( ...
			'Parent', handles.import_uipanel, ...
			'Tag', 'import_MarkRefY_edit', ...
			'Style', 'edit', ...
			'Units', 'normalized', ...
			'Position', [0.749163879598662 0.123739640801817 0.0869565217391304 0.155844155844156], ...
			'FontSize', 10, ...
			'BackgroundColor', [1 1 1], ...
			'String', '0', ...
			'TooltipString', 'Reference point Y value', ...
			'Callback', @import_MarkRefY_edit_Callback, ...
			'CreateFcn', @import_MarkRefY_edit_CreateFcn);

		handles.curve_PolOrder_edit = uicontrol( ...
			'Parent', handles.curve_uipanel, ...
			'Tag', 'curve_PolOrder_edit', ...
			'Style', 'edit', ...
			'Units', 'normalized', ...
			'Position', [0.832775919732442 0.703703703703704 0.130434782608696 0.203703703703704], ...
			'FontSize', 10, ...
			'BackgroundColor', [1 1 1], ...
			'String', '3', ...
			'TooltipString', 'Polynom order', ...
			'Callback', @curve_PolOrder_edit_Callback, ...
			'CreateFcn', @curve_PolOrder_edit_CreateFcn);

		handles.save_fName_edit = uicontrol( ...
			'Parent', handles.save_uipanel, ...
			'Tag', 'save_fName_edit', ...
			'Style', 'edit', ...
			'Units', 'centimeters', ...
			'Position', [0.502326354166667 1.00465270833333 4.78531947916666 1.08396739583333], ...
			'FontSize', 10, ...
			'BackgroundColor', [1 1 1], ...
			'String', 'Curve', ...
			'TooltipString', 'Save file name', ...
			'Callback', @save_fName_edit_Callback, ...
			'CreateFcn', @save_fName_edit_CreateFcn);


	end

%% ---------------------------------------------------------------------------
	function import_loadImg_pushbutton_Callback(hObject,evendata) %#ok<INUSD>
        
        [picName, dirNm] = uigetfile('*');
        if picName == 0
            return
        end
        
        if ~strcmp(dirNm, cd)
            picName = [dirNm picName];
        end
        img = imread(picName);
        
        handles.disp_fig = figure;
        
        imagesc([], [], flipdim(img,1));
        set(gca,'ydir','normal', 'XTick', [], 'YTick', []);
        
        % set(handles.disp_fig, 'Pointer', 'fullcrosshair')
        
        handles.disp_ax = gca;
        
        setappdata(handles.img2curve_figure, 'img', img);
        
        pushbutton_activate('import');

	end

%% ---------------------------------------------------------------------------
	function import_getScaleFile_pushbutton_Callback(hObject,evendata) %#ok<INUSD>
        
        [fName, dirNm] = uigetfile('scale.mat');
        if fName == 0
            return
        end
        
        S = load([dirNm fName]);
        try
            setappdata(handles.img2curve_figure, 'scale', S.scale);
            setappdata(handles.img2curve_figure, 'oo', S.oo);
            setappdata(handles.img2curve_figure, 'ooVal', S.ooVal);
            
            plotImBackground;
            
            pushbutton_activate;
        catch
            errordlg('Previous scale file loading failed!', 'Load error');
        end

	end

%% ---------------------------------------------------------------------------
    function import_scale_pushbutton_Callback(hObject,evendata) %#ok<INUSD>
        
        pushbutton_deactivate;
        
        scale = getAppD('scale', [1 1]);
        
        scale(1) = getAxisScale(1, scale(1));
        scale(2) = getAxisScale(2, scale(2));
        setappdata(handles.img2curve_figure, 'scale', scale);
        
        set(handles.import_xScale_text, 'String', {...
            ['X Scale 1:' num2str(scale(1), 3)],...
            ['Y Scale 1:' num2str(scale(2), 3)]});
        
        checkSaveScale;
        
        pushbutton_activate;
        
    end

%% ---------------------------------------------------------------------------
    function import_MarkRef_pushbutton_Callback(hObject,evendata) %#ok<INUSD>
        
        pushbutton_deactivate;
        
        scale = getAppD('scale', [1  1]);
        oo = getAppD('oo',[]);
        ooVal = getAppD('ooVal', [0  0]);
        
        axes(handles.disp_ax);
        t = title(handles.disp_ax, ['Mark (' num2str(ooVal) ') point'],...
            'FontSize', 16, 'Color', 'r');
        
        if isempty(oo)
            oo = ginput(1);
        else
            oo = ( ginput(1) ) ./scale + oo - ooVal ./ scale;
        end
        
        delete(t);
        
        pushbutton_activate;
        
        setappdata(handles.img2curve_figure, 'oo', oo);
        setOoVal;
        
        checkSaveScale;
        
    end

%% ---------------------------------------------------------------------------
    function curve_markPoints_pushbutton_Callback(hObject,evendata) %#ok<INUSD>
        
        scale = [];
        oo = [];
        ooVal = [];
        names = {'scale' 'oo' 'ooVal'};
        for i = 1:length(names)
            if isappdata(handles.img2curve_figure, names{i})
                eval([names{i} ' = getappdata(handles.img2curve_figure, ''' names{i} ''');']);
            else
                errordlg('Set scale and oo first!', 'Error');
                return
            end
        end
        
        pushbutton_deactivate;
        
        axes(handles.disp_ax);
        
        tit = title(handles.disp_ax, {'Mark as many curve points as you want' 'Press Enter when done'},...
            'FontSize', 16, 'Color', 'r');
        po = ginput;
        if isempty(po)
            try
                load('curvePoints.mat');
            catch %#ok<*CTCH>
                return
            end
        else
            save('curvePoints.mat', 'po');
        end
        
        setappdata(handles.img2curve_figure, 'po', po);
        
        calcPol;
        
        pushbutton_activate;
        
    end

%% ---------------------------------------------------------------------------
    function save_pushbutton_Callback(hObject,evendata) %#ok<INUSD>
        
        po = getappdata(handles.img2curve_figure, 'po');
        oo = getappdata(handles.img2curve_figure, 'oo');
        ooVal = getappdata(handles.img2curve_figure, 'ooVal');
        scale = getappdata(handles.img2curve_figure, 'scale');
        pol = getappdata(handles.img2curve_figure, 'pol');
        img = getappdata(handles.img2curve_figure, 'img');
        
        fName = [get(handles.save_fName_edit, 'String') '.mat'];
        
        save(fName, 'po', 'oo', 'ooVal', 'scale', 'pol', 'img');
        
        msgbox([fName ' saved successfully!'], 'Save Fit', 'help');
        
    end

%% ---------------------------------------------------------------------------
    function save_excel_pushbutton_Callback(hObject,evendata) %#ok<INUSD>
        
        po = getAppD('po', []);
        pol = getAppD('pol', []);
        
        if isempty(po) || isempty(pol)
            errordlg('Mark curve point first!', 'Excel export error');
        else
            fName = [get(handles.save_fName_edit, 'String') '.xls'];
            headStr = {'Polynomial fit:' '';
                poly2str(pol, 'x') '';
                'Polynomial coefficients:' '';
                '' '';
                '' '';
                'X' 'Y'};
            try
                xlswrite(fName, headStr, 'Sheet1', 'A1');
                xlswrite(fName, reshape(pol', 1, []) , 'Sheet1', 'A4');
                xlswrite(fName, po, 'Sheet1', 'A7');
                
                msgbox([fName ' saved successfully!'], 'Save Fit', 'help');
            catch
                errordlg({'Could not save to excel' 'Is excel file open?'}, 'Excel export error')
            end
        end
        
    end

%% ---------------------------------------------------------------------------
    function save_ws_pushbutton_Callback(hObject,evendata) %#ok<INUSD>
        
        names = {'po', 'oo', 'ooVal', 'scale', 'pol', 'img'};
        for i = 1:length(names)
            assignin( 'base', names{i}, getappdata(handles.img2curve_figure, names{i}) );
        end
        
        msgbox('Results exported to WS successfully!', 'WS export Fit', 'help');
        
    end

%% ---------------------------------------------------------------------------
	function import_MarkRefX_edit_Callback(hObject,evendata) %#ok<INUSD>

	end

%% ---------------------------------------------------------------------------
	function import_MarkRefX_edit_CreateFcn(hObject,evendata) %#ok<INUSD>

	end

%% ---------------------------------------------------------------------------
	function import_MarkRefY_edit_Callback(hObject,evendata) %#ok<INUSD>

	end

%% ---------------------------------------------------------------------------
	function import_MarkRefY_edit_CreateFcn(hObject,evendata) %#ok<INUSD>

	end

%% ---------------------------------------------------------------------------
	function curve_PolOrder_edit_Callback(hObject,evendata) %#ok<INUSD>

	end

%% ---------------------------------------------------------------------------
	function curve_PolOrder_edit_CreateFcn(hObject,evendata) %#ok<INUSD>

	end

%% ---------------------------------------------------------------------------
	function save_fName_edit_Callback(hObject,evendata) %#ok<INUSD>

	end

%% ---------------------------------------------------------------------------
	function save_fName_edit_CreateFcn(hObject,evendata) %#ok<INUSD>

    end

%% Service Functions

    function scale = getAxisScale(ax, scale)
        
        directionStr = {'x \rightarrow'   'y \uparrow'};
        
        axes(handles.disp_ax);
        t = title(handles.disp_ax,{ ['Get ' directionStr{ax} ' scale'], 'Mark 2 points, from small to large'}, ...
            'FontSize', 16, 'Color', 'r');
        Po = ginput(2);
        if isempty(Po)
            %     load('scale.mat')
            %     scale = scale(ax);
            return
        else
            PoSize = ( Po(2,ax)-Po(1,ax) ) / scale;
        end
        
        Answer = inputdlg('Difference between the 2 points:', 'Get Scale');
        Me = str2num(Answer{1}); %#ok<*ST2NM>
        scale = Me/PoSize;
        delete(t);
    end


    function setOoVal
        
        ooVal(1) = str2num(get(handles.import_MarkRefX_edit, 'String'));
        ooVal(2) = str2num(get(handles.import_MarkRefY_edit, 'String'));
        setappdata(handles.img2curve_figure, 'ooVal', ooVal);
    end


    function checkSaveScale
        
        if isappdata(handles.img2curve_figure, 'scale') && isappdata(handles.img2curve_figure, 'oo')
            scale = getappdata(handles.img2curve_figure, 'scale'); %#ok<*NASGU>
            oo = getappdata(handles.img2curve_figure, 'oo');
            ooVal = getappdata(handles.img2curve_figure, 'ooVal');
            
            save('scale.mat', 'scale', 'oo', 'ooVal');
            
            plotImBackground;
        end
        
    end

    function pol = calcPol
        
        po = getappdata(handles.img2curve_figure, 'po');
        oo = getappdata(handles.img2curve_figure, 'oo');
        ooVal = getappdata(handles.img2curve_figure, 'ooVal');
        scale = getappdata(handles.img2curve_figure, 'scale');
        
        polOrder = str2num(get(handles.curve_PolOrder_edit, 'String'));
        pol = Fitting(po(:,1), po(:,2), polOrder+1);
        
        setappdata(handles.img2curve_figure, 'pol', pol);
        
        set(handles.curve_Pol_text, 'String', poly2str(pol, 'x'));
        showRes;
        
    end


    function showRes
        
        po = getappdata(handles.img2curve_figure, 'po');
        oo = getappdata(handles.img2curve_figure, 'oo');
        ooVal = getappdata(handles.img2curve_figure, 'ooVal');
        scale = getappdata(handles.img2curve_figure, 'scale');
        pol = getappdata(handles.img2curve_figure, 'pol');
        
        if isappdata(handles.img2curve_figure, 'lin')
            try %#ok<TRYNC>
                lin = getappdata(handles.img2curve_figure, 'lin');
                delete(lin);
            end
        end
        
        x = po(:,1);
        y = po(:,2);
        yP = polyval( pol, po(:,1) );
        
        axes(handles.disp_ax);
        
        hold on
        % imagesc(scale(1), scale(2), img);
        lin = plot(x,y, 'o', x,yP,'--', 'linewidth', 2);
        hold off
        tit = title( poly2str(pol, 'x'), 'FontSize', 12, 'Color', 'k' );
        
        setappdata(handles.img2curve_figure, 'lin', lin);
        
    end

    function plotImBackground
        
        po = getappdata(handles.img2curve_figure, 'po');
        oo = getappdata(handles.img2curve_figure, 'oo');
        ooVal = getappdata(handles.img2curve_figure, 'ooVal');
        scale = getappdata(handles.img2curve_figure, 'scale');
        pol = getappdata(handles.img2curve_figure, 'pol');
        img = getappdata(handles.img2curve_figure, 'img');
        
        if isempty(ooVal)
            ooVal = [0 0];
        end
        
        oo = oo - ooVal./scale;
        
        minX = -1 * scale(1) * oo(1);
        maxX = scale(1) * (length(img(1,:,1)) - oo(1));
        
        minY = -1 * scale(2) * oo(2);
        maxY = scale(2) * (length(img(:,1,1)) - oo(2));
        
        imagesc([minX maxX], [minY maxY], flipdim(img,1), 'Parent', handles.disp_ax);
        set(handles.disp_ax,'ydir','normal');
        
    end

    function pushbutton_activate(indicat)
        
        pb = findobj(handles.img2curve_figure, 'Style', 'pushbutton');
        
        if nargin<1   % activate all
            set(pb, 'Enable', 'on');
        else
            pbb = [];
            for i = 1:length(pb)
                if strfind(get(pb(i), 'Tag'), indicat)
                    pbb(end+1) = pb(i); %#ok<AGROW>
                end
            end
            set(pbb, 'Enable', 'on');
        end
        
    end

    function pushbutton_deactivate
        
        pb = findobj(handles.img2curve_figure, 'Style', 'pushbutton');
        
        set(pb, 'Enable', 'off');
        
    end

    function val = getAppD(name, def)
        
        if isappdata(handles.img2curve_figure, name)
            val = getappdata(handles.img2curve_figure, name);
        else
            val =def;
        end
        
    end

end


function Pol = Fitting(x, y, m)

if nargin<3
    m = 2;
end

x = MakeColomVec(x);
y = MakeColomVec(y);

for q=1:m
    A=[];
    for p=1:q
        A=[A x.^(p-1)]; %#ok<AGROW>
    end
    d(1:q,q) =A\y; %#ok<AGROW>
    % plot(x, y, x,A*d(1:q,q),'--')
    % hold on
end

Pol = d(1:q,q);
Pol = Pol(end:-1:1);

    function v = MakeColomVec(v)
        
        v = reshape(v, length(v), 1);
    end
end
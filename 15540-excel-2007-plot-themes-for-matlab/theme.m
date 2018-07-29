function theme(H, themeID, useMarkers, lineWidth, markerSize, titleFontSize, axesFontSize)
%THEME applies a color theme to the specified figure or sets the
%   default theme of new plots as best it is able.
%
%   Author: Stephen E. Conover
%
%   Version: 1.1
%   Date: June 19, 2007
%   MATLAB Version: MATLAB Version 7.1.0.124 (R14) Service Pack 3 (STUDENT)
%   License: MIT License (see below)
%
%   PARAMETERS:
%
%       H - the handl to an axis, figure, or 0 to specify 'default for all future
%               plots' (default = 0)
%       themeID - a string indicating the name of the theme to use, or a
%               number indicating its index. (Default = 'Office')
%       useMarkers - whether to display markers at data points. Not
%               supported for defaults (H = 0).
%       lineWidth - sets the width of the lines to a certain value
%               (default = 3)
%       markerSize - the size of the marker, if shown. (default = 5)
%       titleFontSize - font size of the title (default = 12)
%
%   USAGE:
%
%       THEME(H, 'Name',true) - applies the theme with given name to the figure with
%                               handle H.
%       THEME(H, Index,true)  - same as above only it applies the theme with a given
%                               index to the handle given.
%       THEME(H, Index, true) - makes the theme use markers at data points.
%       THEME(0, 'Name',false)- makes the default theme of all future plots to be
%                               the theme of the given name. Note: not all
%                               options are supported in for defaults.
%
%
%       THEME currently supports the following themes based on the Office 2007
%       Excel Color Schemes as applied to a line graph:
%            (1) Apex
%            (2) Aspect
%            (3) Civic
%            (4) Concourse
%            (5) Equity
%            (6) Flow
%            (7) Foundry
%            (8) Grayscale
%            (9) Office
%            (10) Median
%            (11) Metro
%            (12) Module
%            (13) Opulent
%            (14) Oriel
%            (15) Origin
%            (16) Paper
%            (17) Solstice
%            (18) Technic
%            (19) Trek
%            (20) Urban
%            (21) Verve
%
%   IMPORTANT NOTES:
%
%       Just like the usual MATLAB themes, a call must be made for all
%       plots at once, and not individual plots with HOLD ON. To use
%       individual plots in this way, the THEME function should be called
%       afterwards with the axis handle as as the first argument instead of
%       0 as the first argument.
%
%       Also, default values cannot be applied to the markers due to a
%       limitation in MATLAB R14.
%
%       This code is not distributed by nor endorsed by Microsoft. 
%       Microsoft and MS Excel 2007 are registered and independent
%       trademarks of Microsoft Corporation.
%
%   EXAMPLE:
%
%       To change the current axis to look similar to the Microsoft Excel
%       2007 plot and color scheme "Origin", execute the following line:
%
%           theme(gcf, 'Origin');
%
%       or, equivalently:
%
%           theme(gcf, 15);
%
%   EXAMPLE:
%
%       This example displays are large number of lines from the Solstice
%       theme:
%
%         for ind = 1:14
%             yval = ((1:10) + ind).^.5 - ((1:10) + (14 - ind)).^.5;
%             y(ind,:) =  yval;
%         end
%         title({'MATLAB Plot Themes', 'Solstice'}, 'fontsize', 16);
%         plot(y')
%         theme(gca, 'Solstice', true);
%
%   HISTORY
%
%   07-09-2007  Moved theme colors into function for readability.
%   06-18-2007  Conover Initial file created with 21 Excel 2007 Themes.
%
%   MIT LICENSE
%
%       Copyright (c) 2007 Steve Conover.
%
%       Permission is hereby granted, free of charge, to any person
%       obtaining a copy of this software and associated documentation
%       files (the "Software"), to deal in the Software without
%       restriction, including without limitation the rights to use,
%       copy, modify, merge, publish, distribute, sublicense, and/or sell
%       copies of the Software, and to permit persons to whom the
%       Software is furnished to do so, subject to the following
%       conditions:
%
%       The above copyright notice and this permission notice shall be
%       included in all copies or substantial portions of the Software.
%
%       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
%       EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
%       OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
%       NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
%       HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
%       WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
%       FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
%       OTHER DEALINGS IN THE SOFTWARE.


defaultMarkers =    ['d' 's', '^', 'x', '*', 'o', '+', '.', '.', 'd', 's', '^', 'x', '*', 'o', '+'];
axisColor = [134 134 134]/255;

if ~exist('useMarkers', 'var')
    useMarkers = false;
end
if ~exist('themeID', 'var')
    themeID = 'Office';
end
if ~exist('lineWidth', 'var')
    lineWidth = 3;
end
if ~exist('markerSize', 'var')
    markerSize = 5;
end
if ~exist('H', 'var')
    H =0;
end
if ~exist('titleFontSize', 'var')
    titleFontSize = 12;
end
if ~exist('axesFontSize', 'var')
    axesFontSize =12;
end

myTheme = getTheme(themeID);

% Check to see if the user is asking to set the defaults to be a certain
% theme, or to set the axis specified toa  certain theme:
if H == 0
    % if it's zero then we set "defaults" for all future work:
    set(0, 'defaultfigurecolor', 'white');
    set(0, 'defaultaxescolororder', myTheme);
    set(0, 'defaultfigurecolormap', myTheme);
    set(0,'defaultlinelinewidth',lineWidth)
    set(0, 'defaultaxescolor',  'white');
    set(0, 'defaultaxesFontWeight', 'bold')
    set(0, 'defaultaxesygrid', 'on');
    set(0, 'defaultaxesGridLineStyle', '-');
    set(0, 'defaultaxesycolor', axisColor);
    set(0, 'defaultaxesxcolor', axisColor);
    set(0, 'defaultaxeszcolor', axisColor);
    set(0, 'defaultaxesfontsize', axesFontSize);
    set(0, 'defaulttextfontsize', titleFontSize);
elseif ishandle(H)
    % if it's a real handle, then apply the theme directly:

    % If we were passed a figure, then we will apply the theme to all the
    % axes inside it. But if we were passed a single axes, then just apply
    % to that one axes:

    if strcmp(get(H, 'type'),'figure')
        axesHandles = get(H, 'children');
        set(H, 'color', 'white');
    elseif strcmp(get(H, 'type'),'axes')
        axesHandles = H;
    end

    % loop through every axis and apply style:
    for indAxes = 1:length(axesHandles)

        thisAxes = axesHandles(indAxes);

        % Assume the children should all be plots:
        axisPlotHandles = get(thisAxes, 'children');
        axisPlotHandles = axisPlotHandles(end:-1:1);

        % Loop through ever line and apply the appropriate style:
        for ind = 1:length(axisPlotHandles)
            if strcmp(get(axisPlotHandles, 'type'), 'line')
                if ind > size(myTheme,1)
                    warning('More plots than there are colors in the theme.');
                else
                    lineColorToUse = myTheme(ind,:);
                    set(axisPlotHandles(ind), 'color', lineColorToUse)

                    if useMarkers
                        dimAmt = 22/255; % amt to dim all the color by
                        markerColorToUse = max(lineColorToUse - [dimAmt,dimAmt,dimAmt], [0,0,0]);
                        set(axisPlotHandles(ind), 'markersize', markerSize,'marker', defaultMarkers(ind), 'markeredgecolor', markerColorToUse, 'markerfacecolor', markerColorToUse)
                    else
                        set(axisPlotHandles(ind), 'marker', 'none');
                    end
                end
            end

        end

        set(axisPlotHandles(:),'linewidth',lineWidth)

        % set all the other misc properties:
        set(get(thisAxes, 'title'), 'fontsize', titleFontSize);
        set(get(thisAxes, 'title'), 'color', 'black');
        set(get(thisAxes, 'title'), 'fontweight', 'bold');
        set(thisAxes, 'color',  'white');
        set(thisAxes, 'FontWeight', 'bold')
        set(thisAxes, 'ygrid', 'on');
        set(thisAxes, 'GridLineStyle', '-');
        set(thisAxes, 'ycolor', axisColor);
        set(thisAxes, 'xcolor', axisColor);
        set(thisAxes, 'zcolor', axisColor);
        set(thisAxes, 'fontsize', axesFontSize);
    end
else
    error('H should be 0 or a handle to an axis.');
end


end

function retTheme = getTheme(themeID)
% Function returns the RGB color codes (0..1) for the theme
% Parameters
%   id - the name of the theme as a string or the name of the theme as an
%           index into the array.

themes = {
    'Apex' ,   [   168 150 079;
    125 142 105;
    083 143 164;
    078 105 169;
    099 083 164;
    131 095 152;
    204 182 097;
    153 173 128;
    102 174 199;
    096 129 205;
    122 102 199;
    160 117 184;
    221 209 171;
    194 204 183];
    'Aspect' , [   198 101 001;
    130 029 040;
    018 070 101;
    060 108 050;
    076 055 097;
    157 122 068;
    240 124 003;
    158 037 050;
    024 086 123;
    075 132 063;
    094 069 118;
    191 149 084;
    242 180 154;
    196 158 160];
    'Civic' ,  [   171 077 054;
    168 148 000;
    111 140 140;
    113 098 088;
    114 142 111;
    171 115 054;
    208 095 068;
    204 180 000;
    136 170 171;
    137 120 109;
    139 173 136;
    208 141 068;
    223 170 163;
    220 206 154];
    'Concourse',[  031 132 157;
    180 019 027;
    194 078 015;
    042 078 128;
    055 058 097;
    101 045 057;
    040 160 190;
    218 025 035;
    235 096 021;
    053 096 156;
    068 072 118;
    124 057 071;
    158 197 213;
    228 156 157];
    'Equity' , [   174 055 012;
    127 032 020;
    131 114 083;
    121 77 062;
    116 105 106;
    107 073 073;
    211 068 018;
    154 041 027;
    160 139 102;
    147 095 077;
    142 129 130;
    131 090 090;
    224 163 155;
    194 159 157];
    'Flow',    [   006 088 163;
    000 128 179;
    003 171 179;
    007 171 126;
    098 165 075;
    134 159 055;
    010 109 198;
    000 159 217;
    005 208 217;
    011 207 154;
    120 200 093;
    163 193 068;
    155 175 217;
    154 194 228];
    'Foundry', [   090 132 093;
    141 165 141;
    134 166 174;
    155 153 140;
    167 159 120;
    188 146 146;
    110 160 114;
    171 200 171;
    163 201 211;
    188 186 171;
    203 193 146;
    228 178 178;
    176 198 177;
    203 219 203];
    'Grayscale',[  178 178 178;
    143 143 143;
    120 120 120;
    102 102 102;
    075 075 075;
    060 060 060;
    216 216 216;
    174 174 174;
    147 147 147;
    125 125 125;
    093 093 093;
    075 075 075;
    228 228 228;
    205 205 205];
    'Median',[     117 146 171;
    181 101 052;
    133 138 102;
    177 144 070;
    097 135 126;
    120 112 112;
    143 178 207;
    220 124 066;
    162 168 125;
    214 175 087;
    119 164 157;
    147 136 136;
    189 207 223;
    230 181 162];
    'Metro', [     101 171 043;
    193 010 097;
    210 150 001;
    000 141 182;
    090 110 163;
    016 147 130;
    124 208 054;
    234 015 119;
    254 182 004;
    000 172 220;
    110 134 198;
    021 179 158;
    181 223 160;
    238 155 178];
    'Module' ,  [   199 141 000;
    074 147 167;
    188 083 098;
    083 149 085;
    190 106 061;
    162 054 053;
    240 172 000;
    091 178 202;
    228 102 120;
    103 181 105;
    230 130 075;
    197 067 066;
    242 202 154;
    169 207 220];
    'Office', [    060 103 154;
    157 061 058;
    125 152 068;
    102 078 131;
    056 140 162;
    203 120 051;
    074 126 187;
    190 075 072;
    152 185 084;
    125 096 160;
    070 170 197;
    246 146 064;
    165 182 211;
    213 165 164];
    'Opulent',  [   150 045 082;
    139 079 152;
    182 085 038;
    205 148 040;
    169 085 132;
    206 112 043;
    183 056 101;
    169 097 185;
    221 104 048;
    248 179 051;
    205 104 161;
    249 137 055;
    209 161 172;
    202 171 210];
    'Oriel' ,   [   209 106 038;
    091 121 177;
    147 031 012;
    202 168 030;
    139 149 172;
    095 099 106;
    253 130 049;
    112 148 215;
    179 040 017;
    244 203 039;
    169 181 209;
    116 121 129;
    251 183 159;
    176 191 227];
    'Origin', [     090 098 132;
    127 148 166;
    171 178 095;
    205 177 095;
    149 105 089;
    114 091 083;
    110 120 160;
    154 180 201;
    207 215 117;
    248 215 116;
    182 128 110;
    140 112 103;
    176 180 198;
    195 208 220];
    'Paper',  [     132 146 116;
    200 132 052;
    190 153 027;
    169 116 134;
    125 105 156;
    101 127 157;
    161 178 142;
    242 161 065;
    230 186 035;
    205 141 163;
    152 128 189;
    123 154 191;
    198 207 189;
    244 197 162];
    'Solstice', [   041 117 136;
    210 150 001;
    160 031 032;
    106 139 037;
    123 052 000;
    054 070 114;
    052 143 166;
    254 182 004;
    194 040 041;
    130 169 047;
    150 065 001;
    067 087 139;
    160 189 200;
    251 208 154];
    'Technic',[     086 129 143;
    168 143 002;
    112 109 132;
    092 107 075;
    128 117 091;
    100 105 113;
    106 157 174;
    204 174 005;
    137 133 161;
    113 131 093;
    155 143 111;
    123 129 138;
    174 196 204;
    220 204 155];
    'Trek',  [      198 131 031;
    134 078 059;
    147 111 101;
    159 122 085;
    130 120 091;
    158 093 028;
    239 159 040;
    163 097 074;
    178 135 124;
    193 148 104;
    158 146 112;
    192 114 036;
    242 196 158;
    199 171 165];
    'Urban', [      064 065 111;
    051 103 108;
    130 059 133;
    161 079 031;
    113 073 046;
    071 117 147;
    080 081 136;
    064 126 133;
    158 073 161;
    195 098 040;
    138 090 058;
    088 143 179;
    166 167 186;
    163 182 185]
    'Verve', [      210 039 111;
    189 000 069;
    128 000 103;
    084 000 104;
    000 071 174;
    000 039 130;
    154 050 136;
    228 000 086;
    156 000 126;
    103 000 127;
    000 088 211;
    000 049 158;
    252 159 186;
    234 154 167]};

% To Display All Themes here, uncomment:
%figure(55);for ind = 1:21; subplot(11,2,ind); cla; title(themes{ind, 1});axis off;image(reshape(themes{ind,2}/255, [1,size(themes{ind,2},1),3]));end;

% Check to see if the user specified the theme as a number or a string and
% pull out the correct entry either way:
if(isnumeric(themeID))
    themeToUse = themeID;
else
    themeToUse = find(strcmp(upper({themes{:,1}}), upper(themeID)), 1);
    if isempty(themeToUse)
        warning('Unknown theme speficied, using default (Office).');
        themeToUse = find(strcmp({themes{:,1}}, 'Office'), 1);
    end
end 

retTheme = themes{themeToUse,2}/255;

end
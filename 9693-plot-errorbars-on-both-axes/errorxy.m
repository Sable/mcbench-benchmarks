function errorxy(Data,varargin);
%----------------------------------------------------------------------------
% errorxy function           Plot graphs with error bars on both axes.
%                          (This is an improved version of errorxy_o.m).
% Input  : - Data matrix.
%          * an arbitrary pairs of keyword and value parameters, where
%            keyword is one of the followings:
%            (In case that the second parameter is a number then call the
%             old version errorxy_o).
%            'ColX'     - Column number containing X values, default is 1.
%            'ColY'     - Column number containing Y values, default is 2.
%            'ColXe'    - Column number containing error X values.
%                         If one parameter is given then assume upper
%                         and lower errors are the same, if two values
%                         are given then the first is the left and the
%                         second is the right errors,
%                         default is NaN (no X errors).
%            'ColYe'    - Column number containing error Y values.
%                         If one parameter is given then assume right
%                         and left errors are the same, if two values
%                         are given then the first is the lower and the
%                         second is the upper errors,
%                         default is 3.
%            'Marker'   - Marker type, see plot for options, default is 'o'.
%            'MarkSize' - Marker size, default is 6.
%            'EdgeColor'- Marker edge color, default is 'b'.
%            'FaceColor'- Marker face color, default is NaN.
%            'ColorEB'  - Error bars color, default is the same as 'EdgeColor'.
%            'LineEB'   - Error bars line type, default is '-'.
%            'WidthEB'  - Error bars line width, default is 0.5.
%            'EdgeEB'   - Length [ticks] of error bar edge, default is 0.
%            'Con'      - Connect data points {'y' | 'n'}, default is 'n'.
%            'ConColor' - Color of Connecting line, default is the
%                         same as 'EdgeColor'
%            'ConLine'  - Type of connecting line, default is '-'.
%            'ConWidth' - Width of connecting line, default is 0.5.
%            'Hist'     - Plot histogram {'y' | 'n'}, default is 'n'.
%            'HistFaceColor'- Histogram face color, default is the same as 'EdgeColor'.
%            'HistEdgeColor'- Histogram edge color, default is the same as 'EdgeColor'.
%            'ScaleX'   - X scale {'linear' | 'log'}, default is 'linear'.
%            'ScaleY'   - Y scale {'linear' | 'log'}, default is 'linear'.
%            'DirX'     - X direction {'normal' | 'reverse'}, default is 'normal'.
%            'DirY'     - Y direction {'normal' | 'reverse'}, default is 'normal'.
% Plot   : errorxy plot
% Example: errorxy(Data,'ColYe',[5 6],'Marker','^');
% Tested : Matlab 5.3
%     By : Eran O. Ofek               March 2004
%    URL : http://wise-obs.tau.ac.il/~eran/matlab.html
%----------------------------------------------------------------------------
Ndots = 450;    % approximate number of dots in paper

if (nargin>1 & ischar(varargin{1})==0),
   %--- call old erroxy_o ---
   errorxy_o(Data,varargin{:});
else
   %--- new version of errorxy ---

   Nvarg = length(varargin);
   if (0.5.*Nvarg~=floor(0.5.*Nvarg)),
      error('Illegal number of input arguments');
   end

   %--- set default values ---
   ColX         = 1;
   ColY         = 2;
   ColXe        = [NaN, NaN];
   ColYe        = [3, 3];
   Marker       = 'o';
   MarkSize     = 6;
   EdgeColor    = 'b';
   FaceColor    = 'n';
   ColorEB      = NaN;
   LineEB       = '-';
   WidthEB      = 0.5;
   EdgeEB       = 0;
   Con          = 'n';
   ConColor     = NaN;
   ConLine      = '-';
   ConWidth     = 0.5;
   Hist         = 'n';
   HistFaceColor= NaN;
   HistEdgeColor= NaN;
   ScaleX       = 'linear';
   ScaleY       = 'linear';
   DirX         = 'normal';
   DirY         = 'normal';
   
   for I=1:2:Nvarg-1,
      switch varargin{I}
       case 'ColX'
          ColX        = varargin{I+1};
       case 'ColY'
          ColY        = varargin{I+1};
       case 'ColXe'
          ColXe       = varargin{I+1};
       case 'ColYe'
          ColYe       = varargin{I+1};
       case 'Marker'
          Marker      = varargin{I+1};
       case 'MarkSize'
          MarkSize    = varargin{I+1};
       case 'EdgeColor'
          EdgeColor   = varargin{I+1};
       case 'FaceColor'
          FaceColor   = varargin{I+1};
       case 'ColorEB'
          ColorEB     = varargin{I+1};
       case 'LineEB'
          LineEB      = varargin{I+1};
       case 'WidthEB'
          WidthEB     = varargin{I+1};
       case 'EdgeEB'
          EdgeEB      = varargin{I+1};
       case 'Con'
          Con         = varargin{I+1};
       case 'ConColor'
          ConColor    = varargin{I+1};
       case 'ConLine'
          ConLine    = varargin{I+1};
       case 'ConWidth'
          ConWidth   = varargin{I+1};
       case 'Hist'
          Hist       = varargin{I+1};
       case 'HistFaceColor'
          HistFaceColor  = varargin{I+1};
       case 'HistEdgeColor'
          HistEdgeColor  = varargin{I+1};
       case 'ScaleX'
          ScaleX     = varargin{I+1};
       case 'ScaleY'
          ScaleY     = varargin{I+1};
       case 'DirX'
          DirX       = varargin{I+1};
       case 'DirY'
          DirY       = varargin{I+1};
       otherwise
          error('Unknown keyword option');
      end
   end
   
   %--- set NaN colors ---
   if (isnan(ColorEB)==1),
      ColorEB = EdgeColor;
   end
   if (isnan(ConColor)==1),
      ConColor = EdgeColor;
   end
   if (isnan(HistFaceColor)==1),
      HistFaceColor = EdgeColor;
   end
   if (isnan(HistEdgeColor)==1),
      HistEdgeColor = EdgeColor;
   end
   
   if (length(ColXe)==1),
      ColXe = [ColXe, ColXe];
   end
   if (length(ColYe)==1),
      ColYe = [ColYe, ColYe];
   end
   
   %---------------------
   %--- Hold handling ---
   %---------------------
   NextPlot = get(gcf,'NextPlot');
   hold on;
   box on;
   
   %-----------------------------------
   %--- Data span for edge plotting ---
   %-----------------------------------
   SpanX = max(Data(:,ColX)) - min(Data(:,ColX));
   SpanY = max(Data(:,ColY)) - min(Data(:,ColY));
   EdgeX = SpanX.*EdgeEB./Ndots;
   EdgeY = SpanY.*EdgeEB./Ndots;
   
   
   %----------------------
   %--- plot histogram ---
   %----------------------
   switch Hist
    case 'n'
       % do nothing
    case 'y'
       Hhist = bar(Data(:,ColX),Data(:,ColY));
       set(Hhist,'FaceColor',HistFaceColor,...
                 'EdgeColor',HistEdgeColor);
    otherwise
       error('Unknown Hist option');
   end
   
   %------------------------
   %--- plot data points ---
   %------------------------
   N = size(Data,1);
   
   for I=1:1:N,
      H         = plot(Data(I,ColX),Data(I,ColY),'o');
      Hpoint(I) = H;
      set(Hpoint,'Marker',Marker,...
            'MarkerSize',MarkSize,...
            'MarkerEdgeColor',EdgeColor,...
            'MarkerFaceColor',FaceColor);
      %--- plot Y error bars ---
      if (isnan(ColYe(1))==0),
         H        = plot([Data(I,ColX); Data(I,ColX)],...
                         [Data(I,ColY)-Data(I,ColYe(1)); Data(I,ColY)+Data(I,ColYe(2))],...
                         '-');    
         Hyerr(I) = H;
         set(Hyerr,'Color',ColorEB,...
     	        'LineStyle',LineEB,...
   	        'LineWidth',WidthEB);
   
         %--- Error bar edge ---
         if (EdgeEB>0),
            %--- Y error bar lower edge ---
    	 H        = plot([Data(I,ColX)-EdgeX; Data(I,ColX)+EdgeX],...
                            [Data(I,ColY)-Data(I,ColYe(1)); Data(I,ColY)-Data(I,ColYe(1))],...
   		         '-');
            Heyel(I) = H;
   	 set(Heyel,'Color',ColorEB,...
     	           'LineStyle',LineEB,...
   	           'LineWidth',WidthEB);
            %--- Y error bar upper edge ---
    	 H        = plot([Data(I,ColX)-EdgeX; Data(I,ColX)+EdgeX],...
                            [Data(I,ColY)+Data(I,ColYe(2)); Data(I,ColY)+Data(I,ColYe(2))],...
   		         '-');
            Heyeu(I) = H;
   	 set(Heyeu,'Color',ColorEB,...
     	           'LineStyle',LineEB,...
   	           'LineWidth',WidthEB);
         end
      end
      %--- plot X error bars ---
      if (isnan(ColXe(1))==0),
         H        = plot([Data(I,ColX)-Data(I,ColXe(1)); Data(I,ColX)+Data(I,ColXe(2))],...
                         [Data(I,ColY); Data(I,ColY)],...
                         '-');    
         Hxerr(I) = H;
         set(Hxerr,'Color',ColorEB,...
     	        'LineStyle',LineEB,...
   	        'LineWidth',WidthEB);
   
         %--- Error bar edge ---
         if (EdgeEB>0),
            %--- X error bar lower edge ---
    	 H        = plot([Data(I,ColX)-Data(I,ColXe(1)); Data(I,ColX)-Data(I,ColXe(1))],...
                            [Data(I,ColY)-EdgeY; Data(I,ColY)+EdgeY],...
   		         '-');
            Hexel(I) = H;
   	 set(Hexel,'Color',ColorEB,...
     	           'LineStyle',LineEB,...
   	           'LineWidth',WidthEB);
            %--- X error bar upper edge ---
    	 H        = plot([Data(I,ColX)+Data(I,ColXe(2)); Data(I,ColX)+Data(I,ColXe(2))],...
                            [Data(I,ColY)-EdgeY; Data(I,ColY)+EdgeY],...
   		         '-');
            Hexer(I) = H;
   	 set(Hexer,'Color',ColorEB,...
     	           'LineStyle',LineEB,...
   	           'LineWidth',WidthEB);
         end
      end
   
   
   end
   
   %---------------------------
   %--- connect data points ---
   %---------------------------
   switch Con
    case 'n'
       % do nothing
    case 'y'
       Hcon = plot(Data(:,ColX),Data(:,ColY),'-');
       set(Hcon,'Color',ConColor,...
    	     'LineStyle',ConLine,...
      	     'LineWidth',ConWidth);
    otherwise
       error('Unknown Con option');
   end
   
   %---------------------------
   %--- set scale/direction ---
   %---------------------------
   set(gca,'XScale',ScaleX,...
           'YScale',ScaleY,...
           'XDir',DirX,...
           'YDir',DirY);
   
   %--- return hold to riginal state ---
   set(gcf,'NextPlot',NextPlot);
end

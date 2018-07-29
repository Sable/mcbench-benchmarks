function h = figcopy(fc,fm)
% FIGCOPY - copies one figure into another figure and lets the
% users move and  resize the copied figure. This utility is great
% if you need a figure in a figure and still would like to use
% MATLAB's export function.
%
% h = FIGCOPY the user selects both figures by mouse clicks. Please
% follow the instructions in the command window. First activate the
% figure to be copied. Second activate the "master" figure and
% select the lower left and upper right corner, where the copied
% figure should appear in the "master" figure. Click on the copied
% figure to move or resize it. (Don't worry, the resize markers
% will not be printed!) h is the handle of the copied figure.
%
% h = FIGCOPY(fc) fc specifies the figure number (handle) to be
% copied. The master figure is selected by mouse click. 
%
% h = FIGCOPY(fc,fm) specifies the figure number to be copied and
% the figure number of the master figure.
  
% Dirk Tenne 
% CoDE (Control Dynamics and Estimation)
% web:      "http://code.eng.buffalo.edu"
% created:  "long time ago"
% modified: "December 12. 2002"
%

% input handling
  % is the figure number given or should it be clicked?
  if nargin < 3
    select_fc = 0;
    select_fm = 0;
    if nargin < 2
      select_fc = 0;
      select_fm = 1; 
      if nargin < 1
	select_fc = 1;
	select_fm = 1;
      end
    end
  end
  
  
%activate the figure to copy

  if select_fc
    disp('Click on the figure which you''d like to copy!')
    waitforbuttonpress;
    fc = gcf;
    disp(' ')
    disp(['Figure ',num2str(gcf),' copied into the clipboard.'])
  end
  hcfig = get(fc,'Children');
  
  if select_fm
    disp('Activate master figure! (Try clicking the frame.)')
    waitforbuttonpress;
    fm = gcf;
  end
  
% specify the position of the figure
  figure(fm);
  disp(['Click to indicate the LOWER LEFT and UPPER RIGHT'])
  disp(['corners, where the copied figure should appear!'])
  [xi,yi] = ginput(2);

%normalizing x and y
   m_axis = axis;
   m_ax_pos = get(gca,'position');
   alphax = m_ax_pos(3); % rescaling the units
   alphay = m_ax_pos(4);
   x_max = diff(m_axis(1:2)); y_max = diff(m_axis(3:4));
   x = (xi-m_axis(1))/x_max*alphax;
   y = (yi-m_axis(3))/y_max*alphay;
   
   % placing the figure
   pos(1) = m_ax_pos(1) + x(1);
   pos(2) = m_ax_pos(2) + y(1);
   siz(1) = abs(x(1)-x(2));
   siz(2) = abs(y(1)-y(2));
   newhcfig = copyobj(hcfig,fm);
   for j = 1:length(newhcfig)
     set(newhcfig(j),'Position',[pos siz])
   end
   set(newhcfig(1),'ButtonDownFcn','selectmoveresize')
   %disable:set(gco,'ButtonDownFcn','','Selected','off')

% output handling
   if nargout > 0
     h = newhcfig;
   end


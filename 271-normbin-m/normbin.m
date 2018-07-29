function normbin(option)
%NORMBIN  Interactive normal approximations to the binomial

%Peter Dunn
%28 May 1998

if nargin == 0,

   option=0;
   figure('Name','Interactive Normal Approximation to Binomial',...
          'Resize','off');

   %SET UP THE CANVAS

   uicontrol('Style','Frame','Units','normalized',...
             'Position',[0.02 0.02 1-2*0.02 0.2-0.02]);

   %parameter buttons
   pbborder = 0.02;
   pbwidth = ( 1 - (2 * 0.02) - 6*pbborder ) / 4;

   uicontrol('Style','text','String','Probability, p','Units','normalized',...
             'Position',[0.02+pbborder 0.14 pbwidth 0.05]);
   uicontrol('Style','Slider',  'Max',0.99,  'Min',0.01,  ...
             'Callback','normbin(1);','value',0.2,...
             'tag','hprob', 'Units','normalized',  ...
             'Position',[0.02+pbborder 0.04 pbwidth 0.05]);
   uicontrol('Style','Edit','String','0.2','Units','normalized',...
             'Position',[0.02+pbborder 0.09 pbwidth 0.05],...
             'tag','hprobedit','Callback','normbin(2);');

   uicontrol('Style','text','String','Sample Size, n','Units','normalized',...
             'Position',[0.02+2*pbborder+pbwidth 0.14 pbwidth 0.05]);
   uicontrol('Style','Slider',  'Max',100,  'Min',3,  ...
             'Callback','normbin(1);','value',10,...
             'tag','hssize', 'Units','normalized',  ...
             'Position',[0.02+2*pbborder+pbwidth 0.04 pbwidth 0.05]);
   uicontrol('Style','Edit','String','10','Units','normalized',...
             'Position',[0.02+2*pbborder+pbwidth 0.09 pbwidth 0.05],...
             'tag','hssizeedit','Callback','normbin(2);');

   uicontrol('Style','text','String','Mean: 1.0','Units','normalized',...
             'Position',[0.02+3*pbborder+2*pbwidth 0.14 pbwidth 0.05],...
             'tag','hmeantext','HorizontalAlignment','left');
   uicontrol('Style','text','String','Variance: 0.8','Units','normalized',...
             'Position',[0.02+3*pbborder+2*pbwidth 0.04 pbwidth 0.05],...
             'tag','hvartext','HorizontalAlignment','left');

   uicontrol('Style','Popup','String','pdf|cdf',...
             'Callback','normbin(5);','Units','normalized',...
             'tag','htypedist',...
             'Position',[0.02+4*pbborder+3*pbwidth 0.12 pbwidth 0.07]);

   uicontrol('Style','Pushbutton','String','Close',...
             'Callback','close(gcf);','Units','normalized',...
             'Position',[0.02+4*pbborder+3*pbwidth 0.04 pbwidth 0.07]);

   axes('Position',[0.10 0.27 0.85 0.70],'tag','haxes');

   normbin(5);

end;

if (option==1), %Parameters slid

   prob = get(findobj('tag','hprob'),'value');
   set( findobj('tag','hprobedit'),  ...
        'string', prob );
   ssize =  round(get(findobj('tag','hssize'),'value'));
   set( findobj('tag','hssizeedit'),  ...
        'string', ssize );

   set( findobj('tag','hmeantext'), ...
        'String',['Mean: ',num2str(ssize*prob)]);
   set( findobj('tag','hvartext'), ...
        'String',['Variance: ',num2str(ssize*prob*(1-prob))]);

   normbin(5);

elseif (option==2), %parameters editted

   prob = str2num( get(findobj('tag','hprobedit'),'string') );
   if (prob < 0.01 )
      set( findobj('tag','hprobedit'),'string', '0.01');
      prob = 0.01;
   elseif (prob > 0.99)
      set( findobj('tag','hprobedit'),'string', '0.99');
      prob = 0.99;
   end
   set( findobj('tag','hprob'), 'value', prob );

   ssize = round( str2num( get(findobj('tag','hssizeedit'),'string') ) );
   if (ssize < 3 )
      ssizel = 3;
   elseif (ssize > 100)
      ssize = 100;
   end
   set( findobj('tag','hssize'), 'value', ssize );
   set( findobj('tag','hssizeedit'),'string', ssize);

   set( findobj('tag','hmeantext'), ...
        'String',['Mean: ',num2str(ssize*prob)]);
   set( findobj('tag','hvartext'), ...
        'String',['Variance: ',num2str(ssize*prob*(1-prob))]);

   normbin(5);

elseif (option==5), %plot

   delete(gca);  %delete current plot
   axes('Position',[0.10 0.27 0.85 0.70],'tag','haxes');

   prob = get(findobj('tag','hprob'),'value');
   ssize =  round(get(findobj('tag','hssize'),'value'));
   mn = ssize*prob;
   std = sqrt( ssize*prob*(1-prob) );

   %binomial distribution
   xb = [0:1:ssize];
   ncr = exp( gammaln(ssize+1) - gammaln(xb+1) - gammaln(ssize-xb+1) );
   ybinomial = ncr .* prob.^xb .* (1-prob) .^ (ssize - xb);

   %normal distribution
   xn=linspace(-0.5,ssize+0.5);

   if get(findobj('tag','htypedist'), 'value') == 1, %pdf

      hbin = bar(xb,ybinomial,1,'w'); hold on;
      ep = -0.5*( (xn-mn)/std ).^2;
      ynorm = 1/(std*sqrt(2*pi)) * exp( ep );
      hnorm = plot(xn, ynorm, 'r-');

      axis( [-0.5 ssize+0.5 0 max([ybinomial, ynorm])]);

   else %cdf

      sumy = cumsum(ybinomial);
      xbc = [-0.5 xb(1)];
      ybc = [0 0];

      for i=1:length(xb)-1
         xbc = [xbc xb(i) xb(i+1) ];
         ybc = [ybc sumy(i) sumy(i)];
      end

      xbc = [xbc xb(i+1) ssize+0.5];
      ybc = [ybc 1 1];

      ynorm = ( erf( (xn - mn)/(sqrt(2)*std) ) + 1 ) / 2;
      hnorm = plot(xbc, ybc, 'k-', xn,ynorm,'r-');

      axis( [-0.5 ssize+0.5 0 1]);

   end

   set(gca, 'HandleVisibility','Callback');
   set(gcf, 'HandleVisibility','Callback');
   
end


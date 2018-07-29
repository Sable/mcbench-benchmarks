function D0(In,varargin)
%D0 plots the data from scope
%     D0(ScopeData) plots the data from simulink scope,
%     and the data format must be "Structure with time".
%
%     Various line types, plot symbols and colors may be obtained with
%     D0(ScopeData,S) where S is a character string like the "S" 
%     in commond "plot(X,Y,S)";
%
%     D0(ScopeData,S,'PropertyName1',PropertyValue1,'PropertyName2',PropertyValue2,...)
%     sets multiple property values in the figure with a single statement.
%     Note that if the PropertyName is a handle's name, the PropertyValue 
%     should be a value of the "String" of this handle.
%     You needn't to specify the second input "S" if you want the line 
%     style to be default.
%
%     For example, D0(ScopeData,'title','I love simwe') plots a figure
%     whose title is¡°I love simwe¡±.
%     D0(ScopeData,'r','title','I Love Matlab','xtick',[0 5 10],'xticklabel',{'I','Love','Simwe'})
%     is so complex, you should try it by yourselt£¬hehe...
%
%     See also PLOT, SET.

%    Copyright 2008 kokyo52
%    $Revision: 0.3 $
%    http://kokyo52.blogspot.com

LengthVarargin = length(varargin);

%%%%%%%%%%%%%%%%%%%
% Draw the picture
%%%%%%%%%%%%%%%%%%%
if mod(LengthVarargin,2) == 0					% Without the information of line style
	plot(In.time, In.signals(1).values);
	TheBegin = 1;
else											% With the information of line style
	plot(In.time, In.signals(1).values, varargin{1});
	TheBegin = 2;
end
xlim([In.time(1) In.time(length(In.time))]);	% Default value
xlabel('t(s)');									% Default value
title('Scope Figure');							% Default value
for i = TheBegin:2:LengthVarargin
	PropertyName = varargin{i};
	Value = varargin{i+1};
	h = get(gca,PropertyName);
	if ishandle(h)
		set(h,'String',Value);
	else
		set(gca,PropertyName,Value);
	end
end
grid on;
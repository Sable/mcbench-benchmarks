function ge2ma_demo
% This function is an example on how to integrate GoogleEarth in a Matlab figure or GUI. 
% You need the GoogleEarth plugin to be installed. Therefore just visit a website, where the plugin is needed
% and install it, e.g.:  http://code.google.com/intl/de-DE/apis/earth/ 
% 
% Next step you'll need an api-key-see:http://code.google.com/intl/de-DE/apis/earth/documentation/index.html
% Take the jey and put it in the head of the ge_ma.html while replacing ABCDEF" -->
% src="https://www.google.com/jsapi?key=ABCDEF"></script>  
% Maybe the abcdef-key also work - try it.
%
% The rest is more simple:
%
% The workaround for integrating GE in Matlab GUI is simple to embed a Microsoft Internet ActiveX-Control in
% the GUI (ge_html --> line 56); You need the activex: shell.explorer.2 (see Matlab Help)
%
% Then you can import any website or a in our case a local html-document with your programmed GoogleEarth
% functionality (ge_ma.html). For further function-examples see the Google Code Playground:
% http://code.google.com/apis/ajax/playground/?exp=earth#hello,_earth 
%
% At the Playground you can toogle to "Edit HTML" and save the code on local machine. The functions inside you
% can call from Matlab as shown in the pushbuttons of the GUI.
% 
% Further Readings:
%   http://code.google.com/intl/de-DE/apis/earth/
%   http://code.google.com/intl/de-DE/apis/earth/documentation/reference/index.html
% see in Matlab Help: actx_explore for integrating Shell-Explorer
 
% run the demo
ge_html;
% After starting open the ge_ma.html
function start_LearnSimulink(varargin)
%{ 
This function simply opens an HTML document to guide you in this way to
learn Simulink.
Created by Roni Peer, Dec-2011.
%}

cd(fullfile(pwd, 'files'));
open(fullfile(pwd,'html','LearnSimulinkScript.html')); % Open the HTML.
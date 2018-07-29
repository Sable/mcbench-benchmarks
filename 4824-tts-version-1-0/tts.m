function tts(textIn)
% tts  Text To Speech function, version 1.0
% 
%   tts(textString) reads the textString string.
%   The tts function calls the Microsoft(r) Win32 Speech API (SAPI).

ha = actxserver('SAPI.SpVoice');
invoke(ha,'speak',textIn);
delete(ha);
clear ha;
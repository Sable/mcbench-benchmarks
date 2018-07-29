%Javier A. Ruiz Cabrera
%John Brown University, Digital Signal Processing
%Lab 3.


function tone = note(key,octave,dur)
% NOTE Produces a sinousoiudal waveform corresponding to a
% given piano key number
%
% usage: tone = note(key, octave, dur)
%       tone = the output sinudoidal waveform
%       key = a string with the name of the note (i.e. 'do' 'sol#' 'sib')
%       octave = the octave of the note to play using the piano keyboard
%               as reference
%       dur = the duration of the output note (1,1/2,1/4,1/8,1/16, etc)
%       In addition, a parameter corresponding to the gain (strength) of the note
%       could be added
%sample freq
fs = 11025;
holeDur = 1; %duration of the hole note

%Checking the duration of the note
Truedur = dur * holeDur;         

tt= 0:(1/fs):Truedur;  %depending on fs and the duration of the note, the vector tt is created

%getting the correct offset for the keys (ex: do = C is a 4 in the octave 1)
if (strcmpi(key,'do') || strcmpi(key,'si#'))        %C
    offset = 4;
elseif (strcmpi(key,'do#') || strcmpi(key,'reb') )  %C#
    offset = 5;
elseif (strcmpi(key,'re'))                          %D
    offset = 6;
elseif (strcmpi(key,'re#') || strcmpi(key,'mib'))   %D#
    offset = 7;
elseif (strcmpi(key,'mi') || strcmpi(key,'fab') )   %E
    offset = 8;
elseif (strcmpi(key,'fa'))                          %F
    offset = 9;
elseif (strcmpi(key,'fa#') || strcmpi(key,'solb'))  %F#
    offset = 10;
elseif (strcmpi(key,'sol'))                         %G                  
    offset = 11;
elseif (strcmpi(key,'sol#') || strcmpi(key,'lab'))  %G#
    offset = 12;    
elseif (strcmpi(key,'la'))                          %A
    offset = 13;
elseif (strcmpi(key,'la#') || strcmpi(key,'sib'))   %Bb
    offset = 14;
elseif (strcmpi(key,'si') || strcmpi(key,'dob') )   %B
    offset = 15;
end;  

if (key == 0)                     %silence
    tone = zeros(1,dur*fs);
else
    keynum = (octave-1) * 12 + offset; %getting the correspondent key number
    freq = 440*2^((keynum-49)/12); %obtaining the corresponding frequency using the middle C 440Hz frequency in a piano 
    tone = 0.1 * cos(2*pi*freq*tt) + 0.1/2 * cos(2*pi*2*freq*tt)+ 0.1/3 * cos(2*pi*3*freq*tt);%tone with 1, 2 and 3 harmonics
end;

end

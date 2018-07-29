function [final_sound] = im2sound(filename, ext, f_sample, f_low, ...
    f_high, amp_mod, sample_t)

%INPUTS:
%'filename' - Name of the image to be encoded (not including extension
%ext' - Extension of the image (not including "." at the beginning).  
%'f_sample' - Sampling frequency (Hz)
%'f_low' - Lowest frequency (Hz) (e.g. 40)
%'f_high' - Highest frequency (Hz) (e.g. 6000)
%'amp_mod' - Multiplication factor for the amplitude.  Decrease until 
%image is clear. Too high and the waveform clips.  Too low and the image 
%is very dark (e.g. 0.00002)
%'sample_t' - Duration of the sample in seconds.  Longer samples have
%better quality (e.g. 10)

%OUTPUTS:
%'final_sound' - the final sound containing the image.  This is
%automatically saved to a .wav file with the original image filename


%INITIALISING VARIABLES:
%The waveform at each time point.  This is reset at the beginning of each
%time point
temp_sound = 0; 
%The final waveform
final_sound = 0; 


%MAIN BODY
%Loading the sample image and calculating the image size
raw_im = imread(strcat(filename,'.',ext));
size_raw_im = size(raw_im);

%Making a frequency table for the height of the image.  Each row of the
%image is assigned a particular frequency from the corresponding row of 
%this table.  The frequencies are linearly distributed between the highest and
%lowest user-definied frequencies.  "f_step" is the increment between each
%adjacent frequency
f_step = (f_high - f_low)/size_raw_im(1,1);
f_table = (f_high:-f_step:f_low);

%The final sound will dwell on each column of the image for a specific
%time.  This time is defined by "t_start" and "t_end".  It depends on how
%long the user determined the sound-clip should be and how wide (how many
%columns) the image is.  
t_step = (sample_t/size_raw_im(1,2));

%Initial values for the start and end times.  These will be increased at
%the end of each loop iteration (when the script moves onto the next column
%of the image).
t_start = 0;
t_end = t_step;

%The loop which generates the sound file.  At each iteration it generates a
%segment of the final sound file, which is temporarily saved to 
%"temp_sound".  This segment is built up of frequencies from that
%particular column of the image.
for j = 1:size_raw_im(1,2)
    %Initialising the variable (the sound for each frequency (row) is added
    %to the existing sound)
    temp_sound = 0;
    
    %Setting the time in matrix format
    t = t_start:1/f_sample:(t_end);
    
    %For each iteration of this loop, the script goes down the current
    %column of the image and generates a waveform of the frequency
    %specified in "f_table".  The amplitude of the waveform is determined
    %by the pixel intensity.  This generated waveform is added to all the
    %previously generated waveforms in that particular column
    for i = size_raw_im(1,1):-1:1
        temp_sound = temp_sound+ sin(2*pi*t*f_table(i))*...
            double(raw_im(i,j))*amp_mod;
        
    end
       
    %At the end of each column the segment of sound generated is added to
    %the end of the existing sound file ("final_sound").
    final_sound = cat(2,final_sound,temp_sound);
    
    %The temporary sound is cleared ready for the start of the next column
    clear temp_sound
    
    %Moving to the next time frame
    t_start = t_start + t_step;
    t_end = t_end + t_step;
    
end

%This saves "final_sound" to the '.wav' file of the same name as the input
%file
wavwrite(final_sound, f_sample, strcat(filename, '.wav'));
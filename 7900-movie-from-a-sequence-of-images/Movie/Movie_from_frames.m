%This function makes a simple avi movie from a sequence of frames
%The user can control the display time of each frame. The movie is created
%in the same folder where this function is run.
%
%Usage:
%      Inputs:          
%             name: root name of the framse 
%         filetype: '.bmp'   ,  '.jpg'  , '.jpeg' , '.tif'  ,,,,
% number_of_frames: number of the frames
% display_time_of_frame: it is the display time of each frame  
%           
%           Output:
%  it creates a file named as Movie.avi in the same folder of this function
%           
%            Usage: Try the simple provided example
%   Movie_from_frames('image','.bmp',4,10)
%This function is written by :
%                             Nassim Khaled
%                             American University of Beirut
%                             Research Assistant and Masters Student


function Movie_from_frames(name,filetype,number_of_frames,display_time_of_frame)
mov = avifile('MOVIE.avi');
count=0;
for i=1:number_of_frames
    name1=strcat(name,num2str(i),filetype);
    a=imread(name1);
    while count<display_time_of_frame
        count=count+1;
        imshow(a);
        F=getframe(gca);
        mov=addframe(mov,F);
    end
    count=0;
end
close all
mov=close(mov);
    
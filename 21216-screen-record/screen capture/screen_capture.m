function screen_capture(movie_name,recording_time)
%Can be used to record any screen activity and output
%the recorded actions as video file (MOVIE.avi). It also saves the frames used to
%create the movie in a jpg format frames. The images are named as
%scrcapture -frame number- .jpg
%For example the first frame is named scrcapture1.jpg
%The recording time is almost identical to the actual cpu time.
%The quality of the video is excellent, but the size is big. One is advised
%to record short videos(order of minutes).For even better quality, one could replace the
% png format to jpg(simply uncomment the respective commands).
%                      to call the function, one types:
%
%                                            screen_capture(movie_name,recording_time)
%                     where
%   movie_name: is a string representing the name of  the movie
%   recording_time: is the length of the capturing (in seconds)
%To try, one might use the following example:
%                                                                 screen_capture('movie',30)
%When the code is done writing the movie, a gong sound will be played
%to inform the user that the movie is finished.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function is written by :
%                             Nassim Khaled
%                             Wayne State University
%                             Phd Candidate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

movie_name1=strcat(movie_name,'.avi')
mov = avifile(movie_name1);
count=0;
robo = java.awt.Robot;
t = java.awt.Toolkit.getDefaultToolkit();
rectangle = java.awt.Rectangle(t.getScreenSize());
 number_of_frames=round(recording_time/0.65);
 display_time_of_frame=10;
 for i=1:number_of_frames
    name1=strcat('scrcapture',num2str(i),'.png');
    %     name1=strcat('scrcapture',num2str(i),'.jpg');
    image = robo.createScreenCapture(rectangle);
    filehandle = java.io.File(name1);
    javax.imageio.ImageIO.write(image,'png',filehandle); 
%     javax.imageio.ImageIO.write(image,'jpg',filehandle); 
end

for i=1:number_of_frames
name1=strcat('scrcapture',num2str(i),'.png');
%     name1=strcat('scrcapture',num2str(i),'.jpg');
    a=imread(name1);
    while count<display_time_of_frame
        count=count+1;
        F = im2frame(a);
        mov=addframe(mov,F);
    end
    count=0;
end
close all
mov=close(mov);
load gong;
wavplay(y,Fs)   

    
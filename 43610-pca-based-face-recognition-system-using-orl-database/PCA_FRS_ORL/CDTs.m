function [T,irow,icol,DS]=CDTs(TrNum);
DatabasePath='ORL\s'; % - Path of the testing database
T=[];
DS=0;

escImages=1:TrNum; % Escape Images
for td = 1:40
       Files = dir(strcat(DatabasePath,int2str(td)));
for i = 1:size(Files,1)
  x=0;
  y=1;
    for j=1:length(escImages)
        if  strcmp(Files(i).name,strcat(int2str(escImages(j)),'.pgm'))
            x=1;
        else
            x=x;
        end
    end
    if not(strcmp(Files(i).name,'.')|strcmp(Files(i).name,'..')|strcmp(Files(i).name,'Thumbs.db')|x)
        DS = DS + 1; % Number of all images in the training database
        img = imread(strcat(DatabasePath,int2str(td),'/',Files(i).name));
        [irow icol dim] = size(img);
        if dim>1
            img=rgb2gray(img);
        end
        temp = reshape(img,irow*icol,1);   % Reshaping 2D images into 1D image vectors
    T = [T temp];
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Developed By:           Syed Yasser Arafat                           %
%                           MS(CS), 177 MS/CS/F04(CS)                    %
%                           IIU-Islamabad                                % 
%                           (International Islamic University)           %
%                           Pakistan                                     %
%                           mirpurian@gmail.com                          % 
%   Dated:                  April  2007                                  %
%                                                                        %
%   Thanks to: Mathworks.com and various  authors for their              %
%   various examples and tutorials regarding computer vision &           %
%   imageProcessing on internet                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
%  USAGE:   can be used as a part of CBIR system or for local threholding
%           methods , only limited your imagination
% 
% 
%  INPUT:
%  Here  NHBlocks are Number of blocks you required Horizontaly
%  Here  NVBlocks are Number of blocks you required Vertically
% 
% 
% 
%  OUTPUT:
% 
%         ImgYContainer contains then name & tiled parts of orignal picture
% 
% 
% 
%   Please feel free to give suggestions & corrections
% 

function ImgYContainer=YTiler(NHBlocks,NVBlocks,typeOfImages)
LogoSDir=pwd;
vImgNames = dir(fullfile(LogoSDir,typeOfImages));
fileCount = length(vImgNames);

NumOfHorizontalBlocks=NHBlocks
NumOfVerticalBlocks=NVBlocks


ImageContainer=struct('imageName',{},'imageData',{} )

imgReadLimit=fileCount  ;
for fileIt = 1:imgReadLimit  %fileCount  
                  fName=vImgNames(fileIt).name;
                  [Img ImgMap]=imread(fName);
                  figure,imshow(Img,ImgMap);        
                  
                  X=floor(   size(Img,2)/NumOfHorizontalBlocks );
                  Y=floor(   size(Img,1)/NumOfVerticalBlocks   );
 
                  HorizontalBlockSize=X;
                  VerticalBlockSize=Y;
                  HiX=1;
                  VjY=1;
                  SubImageNumbers=0;
                  iMgNo=1;
                  figure,
                  for Hi=1:NumOfHorizontalBlocks
                      for Vj=1:NumOfVerticalBlocks
                          SubImageNumbers=SubImageNumbers+Vj;
                          xlimit=(HiX+HorizontalBlockSize)-1;
                          ylimit=(VjY+VerticalBlockSize)-1 ;
                          

                          NewSubImg =Img(  VjY:ylimit ,HiX:xlimit );
                         
                          subplot(NumOfVerticalBlocks,NumOfHorizontalBlocks,iMgNo);

                          imshow(NewSubImg,ImgMap);
                          VjY=VjY+VerticalBlockSize;
                          ImageContainer(fileIt).imageName=fName;
                          ImageContainer(fileIt).imageData(iMgNo).iNo=NewSubImg;

                        iMgNo=iMgNo+1;
                      end
                      HiX=HiX+HorizontalBlockSize;
                      VjY=1;
                  end

end;

% keyboard

% size(ImageContainer(1).imageData(1).iNo);
iMgNoLimit=length(ImageContainer(1).imageData);
for fileIt = 1:imgReadLimit %fileCount  
                        for iMgNo=1:iMgNoLimit  
                        subplot(NumOfHorizontalBlocks,NumOfVerticalBlocks,iMgNo);
                        imshow(ImageContainer(fileIt).imageData(iMgNo).iNo,ImgMap);
                        end

end


ImgYContainer=ImageContainer;

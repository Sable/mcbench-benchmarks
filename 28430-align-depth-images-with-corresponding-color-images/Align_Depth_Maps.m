%-------------------------These are the input parameters----------------%
Input_Depth     = 'Ballet40.yuv';       %This is the input depth video
Output_Depth    = 'Output_Ballet.yuv';  %Give a name to the output file
Color           = 'Ballet.yuv';         %Corresponding color video
Width           = 1024;                 %Width in pixels
Height          = 768;                  %Height in pixels
Frame_Num       = 1;                    %Number of Frames to process
%------------------------End of the Input Parameters--------------------%

%-------------------------Key Performance Parameters--------------------%
w               = 15;                   %Half width of the kernel (odd)
sigma_range     = 0.025                 %Standard Deviation of the range 
                                        %filter, change this suitably.
%------------------------End of key perf. parameters--------------------%


sigma = [3*w sigma_range]; % bilateral filter standard deviations

% Apply Joint Bilateral Filter
filename_in = Input_Depth;
fid_in = fopen(filename_in, 'rb');
[Yd, Ud, Vd] = yuv_import(filename_in,[Width Height],Frame_Num);
fclose(fid_in);

filename_in = Color;
fid_in = fopen(filename_in, 'rb');
[Yc, Uc, Vc] = yuv_import(filename_in,[Width Height],Frame_Num);
fclose(fid_in);

fid = fopen(Output_Depth, 'w');

for s = 1:Frame_Num,
    Ad = Yd{s};
    Ac = Yc{s};
    Ax = jbfilter2(double(Ad)/255,double(Ac)/255,w,sigma);
    image = round(Ax*255);
    FramesOut.Luma = image;
    FramesOut.Chroma1 = Ud{s};
    FramesOut.Chroma2 = Vd{s};
    figure, imshow(uint8(FramesOut.Luma));
    fwrite(fid, FramesOut.Luma', 'uint8');
    fwrite(fid, FramesOut.Chroma1', 'uint8');
    fwrite(fid, FramesOut.Chroma2', 'uint8');
end

fclose(fid);
function BMPtoCOE(image_name)
%Converts a 16 color bitmap image to a Xilinx .COE file
%Was written so students could use a FPGA to display images on a VGA
%monitor

%read bmp data in and display it to the screen
[imdata,immap]=imread(image_name);
image(imdata);
colormap(immap);
numpixels=numel(imdata);

%create .COE file
COE_file=image_name;
COE_file(end-2:end)='coe';
fid=fopen(COE_file,'w');

%write header information
fprintf(fid,';******************************************************************\n');
fprintf(fid,';****                 BMP file in .COE Format                 *****\n');
fprintf(fid,';******************************************************************\n');
fprintf(fid,'; This .COE file specifies initialization values for a\n');
fprintf(fid,'; block memory of depth= %d, and width=4. In this case,\n',numpixels);
fprintf(fid,'; values are specified in hexadecimal format.\n');

%start writing data to the file
fprintf(fid,'memory_initialization_radix=16;\n');
fprintf(fid,'memory_initialization_vector=\n');
%convert image data to row major
newimdata=transpose(double(imdata));
%write image data to file
for j=1:(numpixels-1)
    fprintf(fid,'%s,\n',dec2hex(newimdata(j)));
end
%last data value supposed to have a semicolon instead of a comma
fprintf(fid,'%s;\n',dec2hex(newimdata(numpixels)));
%clean shutdown
fclose(fid)

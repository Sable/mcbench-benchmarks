function [vis, ir, meta1, meta2] = read_is2(filename)
%function [vis, ir, meta1, meta2] = read_is2(filename)
%filename   - (FLUKE Ti10 .IS2-file)
%vis        - visual spectrum image (Grayscale 640x450 16-bit)
%ir         - themal ir image (Grayscale 160x120 16-bit)
%meta1      - metadata at start of file 
%meta2      - metadata before IR-data
%
%Example:
% [vis, ir] = read_is2('IR000001.IS2');
% figure(1);imagesc(vis);colormap gray;figure(2);imagesc(ir);colormap hot;



f = fopen(filename);
d = uint8(fread(f,'uint8'));
fclose(f);

%Everything before 510 seems to be some header
%Probably a lot of usefull information here:-)
meta1_start = 1;
meta1_len = 509;
meta1_end = meta1_start+meta1_len-1;
meta1 = uint8(d(meta1_start:meta1_end));


%This seems to be the visual spectrum image.
% Grayscale (shouldn't it be in colors?) 640x450 pixels
vis_start = meta1_end+1;
vis_dim = [640 450];
vis_datatype = 'uint16';
vis_datatype_size = 2;
vis_end = vis_start+prod(vis_dim)*vis_datatype_size-1;
ix = vis_start:vis_end;
vis = typecast(d(ix),vis_datatype);
vis = reshape(vis,vis_dim(1), vis_dim(2))';

%The remainig pixels (to make it 640x480) seems to be zero-padding
vis_pad_start = vis_end+1;
vis_pad_dim = [640 30];
vis_pad_datatype = 'uint16';
vis_pad_datatype_size = 2;
vis_pad_end = vis_pad_start+prod(vis_pad_dim)*vis_pad_datatype_size-1;
ix = vis_pad_start:vis_pad_end;
vis_pad = typecast(d(ix),vis_pad_datatype);
vis_pad = reshape(vis_pad,vis_pad_dim(1), vis_pad_dim(2))';

%88 bytes of metadata here
meta2_start = vis_pad_end+1;
meta2_len = 88;
meta2_end = meta2_start+meta2_len-1;
meta2 = uint8(d(meta2_start:meta2_end));

%Ir-data 160x120 16-bit picture (Is it signed or unsigned?)
ir_start = meta2_end+1;
ir_dim = [160 120];
ir_datatype = 'uint16';
ir_datatype_size = 2;
ir_end = ir_start+prod(ir_dim)*ir_datatype_size-1;
ix = ir_start:ir_end;
ir = typecast(d(ix),ir_datatype);
ir = reshape(ir,ir_dim(1), ir_dim(2))';

%Char 47 as termination
leftover = d(ir_end+1:end);
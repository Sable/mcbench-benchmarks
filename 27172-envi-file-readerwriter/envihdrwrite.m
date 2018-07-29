function envihdrwrite(info,hdrfile)
% ENVIHDRWRITE read and return ENVI image file header information.
%   INFO = ENVIHDRWRITE(info,'HDR_FILE') writes the ENVI header file
%   'HDR_FILE'. Parameter values are provided by the fields of structure
%   info.
%
%   Example:
%   >> info = envihdrread('my_envi_image.hdr')
%   info =
%          description: [1x101 char]
%              samples: 658
%                lines: 749
%                bands: 3
%        header_offset: 0
%            file_type: 'ENVI Standard'
%            data_type: 4
%           interleave: 'bsq'
%          sensor_type: 'Unknown'
%           byte_order: 0
%             map_info: [1x1 struct]
%      projection_info: [1x102 char]
%     wavelength_units: 'Unknown'
%           pixel_size: [1x1 struct]
%           band_names: [1x154 char]
%     info = enviwrite('my_envi_image2.hdr');
%
% Felix Totir

params=fieldnames(info);

fid = fopen(hdrfile,'w');
fprintf(fid,'%s\n','ENVI');

for idx=1:length(params)
    param = params{idx};
    value = getfield(info,param);
    param(findstr(param,'_')) = ' '; %automatic name
    
    line=[param,' = ',num2str(value)];
    
    fprintf(fid,'%s\n',line);
    
end

fclose(fid);


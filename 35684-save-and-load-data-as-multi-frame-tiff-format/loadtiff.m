function oimg = loadtiff(path)
% Copyright (c) 2012, YoonOh Tak
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of the Gwangju Institute of Science and Technology (GIST), Republic of Korea nor the names 
%       of its contributors may be used to endorse or promote products derived 
%       from this software without specific prior written permission.
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.

s = warning('off', 'all'); % To ignore unknown TIFF tag.

% Frame number
tiff = Tiff(path, 'r');
frame = 0;
while true
    frame = frame + 1;
    if tiff.lastDirectory(), break; end;
    tiff.nextDirectory();
end

k_struct = 0;
tiff.setDirectory(1);
for kf = 1:frame
    if kf == 1
        n1 = tiff.getTag('ImageWidth');
        m1 = tiff.getTag('ImageLength');
        spp1 = tiff.getTag('SamplesPerPixel');
        sf1 = tiff.getTag('SampleFormat');
        bpp1 = tiff.getTag('BitsPerSample');
        if kf ~= frame
            tiff.nextDirectory();
        end
        continue;
    end
    
    n2 = tiff.getTag('ImageWidth');
    m2 = tiff.getTag('ImageLength');
    spp2 = tiff.getTag('SamplesPerPixel');
    sf2 = tiff.getTag('SampleFormat');
    bpp2 = tiff.getTag('BitsPerSample');
    
    if n1 ~= n2 || m1 ~= m2 || spp1 ~= spp2 || sf1 ~= sf2 || bpp1 ~= bpp2
        k_struct = k_struct + 1;
        tifstruct(k_struct).m = m1;
        tifstruct(k_struct).n = n1;
        tifstruct(k_struct).spp = spp1;
        tifstruct(k_struct).frame = kf-1;
        tifstruct(k_struct).data_type = DataType(sf1, bpp1);
    end
   
    if kf ~= frame
        tiff.nextDirectory();
    else
        if k_struct > 0
            k_struct = k_struct + 1;
            tifstruct(k_struct).m = m2;
            tifstruct(k_struct).n = n2;
            tifstruct(k_struct).spp = spp2;
            tifstruct(k_struct).frame = kf;
            tifstruct(k_struct).data_type = DataType(sf2, bpp2);
        end
    end
    n1 = n2; m1 = m2; spp1 = spp2; sf1 = sf2; bpp1 = bpp2;
end

if k_struct == 0
    if spp1 == 1
        oimg = zeros(m1, n1, frame, DataType(sf1, bpp1)); % grayscle
        for kf = 1:frame
            tiff.setDirectory(kf);
            oimg(:, :, kf) = tiff.read();
        end
    else
        oimg = zeros(m1, n1, spp1, frame, DataType(sf1, bpp1)); % color
        for kf = 1:frame
            tiff.setDirectory(kf);
            oimg(:, :, :, kf) = tiff.read();
        end
    end
else
    k_cell = 1;
    kf_start = 1;
    for kc=1:k_struct
        if tifstruct(kc).spp == 1
            temp = zeros(tifstruct(kc).m, tifstruct(kc).n, tifstruct(kc).frame-kf_start+1, tifstruct(kc).data_type);
            for kf=1:tifstruct(kc).frame-kf_start+1
                tiff.setDirectory(kf+kf_start-1);
                temp(:, :, kf) = tiff.read();
            end
            oimg{k_cell} = temp; k_cell = k_cell+1;
        else
            temp = zeros(tifstruct(kc).m, tifstruct(kc).n, 3, tifstruct(kc).frame-kf_start+1, tifstruct(kc).data_type);
            for kf=1:tifstruct(kc).frame-kf_start+1
                tiff.setDirectory(kf+kf_start-1);
                temp(:, :, :, kf) = tiff.read();
            end
            oimg{k_cell} = temp; k_cell = k_cell+1;
        end
        kf_start = tifstruct(kc).frame + 1;
    end
end

tiff.close();

warning(s);
end

function out = DataType(sf, bpp)
switch sf
    case 1
        switch bpp
            case 8
                out = 'uint8';
            case 16
                out = 'uint16';
            case 32
                out = 'uint32';
        end
    case 2
        switch bpp
            case 8
                out = 'int8';
            case 16
                out = 'int16';
            case 32
                out = 'int32';
        end
    case 3
        switch bpp
            case 32
                out = 'single';
            case 64
                out = 'double';
        end
end
end
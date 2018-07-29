%  Mex code here based on GrabBitmaps.cpp in DirectShow samples
%

MS_platform_sdk = 'C:\Program Files\Microsoft Platform SDK for Windows Server 2003 R2\';

include_dirs = [' -DMSWIN -I''', MS_platform_sdk, '\Samples\Multimedia\DirectShow\BaseClasses'' '];
include_dirs = [include_dirs, ' -I''', MS_platform_sdk, '\Include'''];
include_dirs = [include_dirs, ' -I''C:\Program Files (x86)\Microsoft DirectX SDK (November 2007)\Include'''];

libraries = [' ''', MS_platform_sdk, '\Samples\Multimedia\DirectShow\BaseClasses\Release\strmbase.lib'''];
libraries = [libraries, ' zlib.lib winmm.lib'];
libraries = [libraries, ' Filters.cpp VidHeader.cpp showErrMsgBox.cpp read-frame.cpp'];

mex_cpps = {'dxAviOpenMex.cpp', 'dxConvertToAviMex.cpp', 'dxAviReadMex.cpp', 'dxAviCloseMex.cpp'};
for mexi = 1:length(mex_cpps);
    eval(['mex -O ', mex_cpps{mexi}, ' ', include_dirs, libraries]);
end



%function of "voicingDetector_zero_crossing_detector__hamza"

function ZC = func_vd_zc (y)

ZC=0;

for n=1:length(y),
    if n+1>length(y)
        break
    end
    ZC=ZC + (1./2) .* abs(sign(y(n+1))-sign(y(n)));
end

ZC;

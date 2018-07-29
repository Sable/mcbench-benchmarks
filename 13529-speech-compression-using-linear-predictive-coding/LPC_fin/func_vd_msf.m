%function of "voicingDetector_magnitude_sum_function__hamza"

function m_s_f = func_vd_msf (y)

clear m_s_f;

[B,A] = butter(9,.33,'low');  %.5 or .33?
y1 = filter(B,A,y);

m_s_f=sum(abs(y1));

% (msf>((.5).*(sum(msf)./length(msf))))

% if s>13
%     msf=1;
% else
%     msf=0;
% end
% 

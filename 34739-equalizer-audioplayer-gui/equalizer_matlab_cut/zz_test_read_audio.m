fln='C:\freelance\tmp\equalizer_C\tea_24bit_96kHz_short.wav';
fln='C:\freelance\tmp\equalizer_C\15 NTCRACKER_TEA_HFON.wma';
fln='C:\My Music\a1-united_soul_feat_dempress-paradise__main_mix-ute--www.recs.ru--.mp3';

ainfo=mmfileinfo(fln);
frmt=ainfo.Audio.Format;
if strcmpi(ainfo.Audio.Format,'PCM')
    [s Fs]=wavread(fln);
else

    [video, audio] = mmread(fln);
    clear video;
    Fs=audio.rate;

    
    s=audio.data;
end

dt=1/Fs;
clear audio;

sound(s,Fs);

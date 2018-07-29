function Randomsong()

global points


%=======================================================================
%if you score a bad score it will play a clip that mocks you if good
%score a clip that praises you
%=======================================================================
if points<=200
    randloosesong=floor(2.9999999*rand +1);
    if randloosesong==1
        awful = wavread('mostawful.wav');
        wavplay(awful,15025)
    elseif randloosesong==2
            nothing = wavread('getnothing.wav');
            wavplay(nothing,15025)
    else
            weakest = wavread('weakestlink.wav');
            wavplay(weakest,20025)
    end
else
    %gets a random song number to play
    randwinsong=floor(2.9999999*rand +1);
    if randwinsong==1
        champ = wavread('champions.wav');
        wavplay(champ,45025)
    elseif randwinsong==2
        num1 = wavread('number1.wav');
        wavplay(num1,45025)
    else 
        shook = wavread('shookme.wav');
        wavplay(shook,45025)
    end
end

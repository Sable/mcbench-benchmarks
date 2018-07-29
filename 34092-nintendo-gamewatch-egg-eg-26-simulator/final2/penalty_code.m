if penalty>6
    penalty=6;
end
score1=mod(score,1000);
if ((score1==200)||(score1==500)||(score1==999))&&(penalty~=0)&&pcac
    % for penalty clearning
    nm=ceil(penalty/2); % number of symbols
    if pcbs
        for nma=1:nm;
            set_visible(hia,miss_symbs{4-nma});
        end
    end
else

    if penalty==1
        if bmes
            set_visible(hia,miss_symbs{3});
        end
    end


    bl=logical(mod(penalty,2)); % is blinking
    nm=ceil(penalty/2); % number of symbols
    nm0=floor(penalty/2); % number not blinking symbols of symbols

    % not blinking:
    for nm0a=1:nm0;
        set_visible(hia,miss_symbs{4-nm0a});
    end
    % blinking:
    if bl
        if bmes
            set_visible(hia,miss_symbs{4-nm});
        end
    end
end



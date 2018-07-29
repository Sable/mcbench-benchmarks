function keyfig(src,evnt)
global wp
global game_over resett
global score penalty
global game_type
global eggsp
global voll volt
global peg1 peg2 peg3 peg4  pfall pgo pgot
global eg1 eg2 eg3 eg4  fall go got
global Fs
global qt
global sound_mode
global notebook_keys
global ul_key  dl_key  ur_key  dr_key  a_key  b_key  r_key  q_key
global game_a_start_score game_b_start_score no_penalty

c=evnt.Character;


switch c
    case ul_key
        wp=[1 1];
    case dl_key
        wp=[2 1];
    case ur_key
        wp=[1 2];
    case dr_key
        wp=[2 2];
end

if notebook_keys
    switch c
        case 'a'
            wp=[1 1];
        case 'z'
            wp=[2 1];
        case ''''
            wp=[1 2];
        case '/'
            wp=[2 2];
   end
end

if resett||game_over
    if c==a_key
        game_over=false;
        resett=false;
        score=game_a_start_score;
        penalty=0;
        eggsp=false(size(eggsp));
        game_type=1;
    end
end

if resett||game_over
    if c==b_key
        game_over=false;
        resett=false;
        score=game_b_start_score;
        penalty=0;
        eggsp=false(size(eggsp));
        game_type=2;
    end
end

if c==r_key
    game_over=true;
    resett=true;
end

lrk=false;        
if strcmpi(evnt.Key,'rightarrow')
    lrk=true;
    voll=voll+1;
    if voll>5
        voll=5;
    end
    set(volt,'string',['sound volume: ' num2str(voll)  '   left arrow, right arrow']);
end

if strcmpi(evnt.Key,'leftarrow')
    lrk=true;
    voll=voll-1;
    if voll<0
        voll=0;
    end
    set(volt,'string',['sound volume: ' num2str(voll) '   left arrow, right arrow']);
end

if sound_mode==1;
    if lrk
        peg1 = audioplayer(eg1*voll/5, Fs);

        peg2 = audioplayer(eg2*voll/5, Fs);


        peg3 = audioplayer(eg3*voll/5, Fs);


        peg4 = audioplayer(eg4*voll/5, Fs);


        pgot = audioplayer(got*voll/5, Fs);

        pfall = audioplayer(fall*voll/5, Fs);

        pgo = audioplayer(go*voll/5, Fs);
    end
end

if c==q_key
    qt=true;
end
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
global ul_key  dl_key  ur_key  dr_key  a_key  b_key  r_key q_key 
global game_a_start_score game_b_start_score no_penalty

sound_mode=2;
% sound mode:
% sound_mode=0 - no sound
% sound_mode=1 - sound using audioplayer function
% sound_mode=2 - sound using sound function 

notebook_keys=false; % if notebook_keys=true then wolf control keys doubled with:
% up-left: a 
% down-left: z 
% up-right: ' 
% down-right: /

% keys:
ul_key='4'; % wolf to up-left
dl_key='1'; % wolf to down-left
ur_key='6'; % wolf to up-right
dr_key='3'; % wolf to down-right
a_key='a'; % start game a
b_key='b'; % start game b
r_key='r'; % reset
q_key='q';  % quit

% cheats:
game_a_start_score=0;
game_b_start_score=0;
no_penalty=false;


load('segments');
load('wolf_1_1');
load('wolf_1_2');
load('wolf_2_1');
load('wolf_2_2');
%save('score','si_s','bw_s','x1_s','x2_s','y1_s','y2_s');
load('score');
Ie=imread('background_wolf_empty_no_score.jpg');

qt=false; % quit

%Fs=44100;
voll=3;
vol=0.2;

if sound_mode~=0
    [eg1 Fs]=wavread('eg1.wav');
    eg1=eg1*vol;


    [eg2 Fs]=wavread('eg2.wav');
    eg2=eg2*vol;


    [eg3 Fs]=wavread('eg3.wav');
    eg3=eg3*vol;


    [eg4 Fs]=wavread('eg4.wav');
    eg4=eg4*vol;


    [got Fs]=wavread('got.wav');
    got=got*vol;


    [fall Fs]=wavread('fall.wav');
    fall=fall*vol*voll/5;


    [go Fs]=wavread('game_over.wav');
    go=1.5*go;
    go(abs(go)>1)=sign(go(abs(go)>1));
    go=go*vol;
end


if sound_mode==1
    peg1 = audioplayer(eg1*voll/5, Fs);
    peg2 = audioplayer(eg2*voll/5, Fs);
    peg3 = audioplayer(eg3*voll/5, Fs);
    peg4 = audioplayer(eg4*voll/5, Fs);
    pgot = audioplayer(got*voll/5, Fs);
    pfall = audioplayer(fall*voll/5, Fs);
    pgo = audioplayer(go*voll/5, Fs);
end

close all;
figure('KeyPressFcn',@keyfig);

imshow(Ie);
hold on;


% wolf:
hiaw=zeros(1,4);
for c=1:4
    switch c
        case 1
            x1=x1_w_1_1;
            x2=x2_w_1_1;
            y1=y1_w_1_1;
            y2=y2_w_1_1;
            
            sit=si_w_1_1;
            sibwt=bw_w_1_1(y1:y2,x1:x2);
        case 2
            x1=x1_w_2_1;
            x2=x2_w_2_1;
            y1=y1_w_2_1;
            y2=y2_w_2_1;
            
            sit=si_w_2_1;
            sibwt=bw_w_2_1(y1:y2,x1:x2);
        case 3
            x1=x1_w_1_2;
            x2=x2_w_1_2;
            y1=y1_w_1_2;
            y2=y2_w_1_2;
            
            sit=si_w_1_2;
            sibwt=bw_w_1_2(y1:y2,x1:x2);
        case 4
            x1=x1_w_2_2;
            x2=x2_w_2_2;
            y1=y1_w_2_2;
            y2=y2_w_2_2;
            
            sit=si_w_2_2;
            sibwt=bw_w_2_2(y1:y2,x1:x2);
            
            
            
    end
    
    
    bg0=Ie(y1:y2,x1:x2,:);
    for cc=1:3
        sit1=sit(:,:,cc);
        bg1=bg0(:,:,cc);
        sit1(~sibwt)=bg1(~sibwt);
        sit(:,:,cc)=sit1;
        
    end

    hi=imshow(sit,'XData',[x1 x2],'YData',[y1 y2]);
    %hi=imshow(sit,'XData',[six(c) six2(c)],'YData',[siy(c) siy2(c)]);
    %set(hi,'AlphaDataMapping','direct');
    %set(hi,'AlphaData',double(sibw{c}));
    hiaw(c) =hi;
end


ns=length(si); % number of segments

hia=zeros(1,ns);
for c=1:ns
    %si{c}=It(y1:y2,x1:x2,:);
    %sibw{c}=bwt(y1:y2,x1:x2);
    %six(c)=x1;
    %siy(c)=y1;
    %six2(c)=x2;
    %siy2(c)=y2;
    
    sit=si{c};
    sibwt=sibw{c};
    bg0=Ie(siy(c):siy2(c),six(c):six2(c),:);
    for cc=1:3
        sit1=sit(:,:,cc);
        bg1=bg0(:,:,cc);
        sit1(~sibwt)=bg1(~sibwt);
        sit(:,:,cc)=sit1;
        
    end

    hi=imshow(sit,'XData',[six(c) six2(c)],'YData',[siy(c) siy2(c)]);
    %hi=imshow(sit,'XData',[six(c) six2(c)],'YData',[siy(c) siy2(c)]);
    %set(hi,'AlphaDataMapping','direct');
    %set(hi,'AlphaData',double(sibw{c}));
    hia(c) =hi;
end


% score:
nss=length(si_s); % number of segments

his=zeros(1,nss);
for c=1:nss

    sit=si_s{c};
    sibwt=bw_s{c};
    bg0=Ie(y1_s(c):y2_s(c),x1_s(c):x2_s(c),:);
%     for cc=1:3
%         sit1=sit(:,:,cc);
%         bg1=bg0(:,:,cc);
%         sit1(~sibwt)=bg1(~sibwt);
%         sit(:,:,cc)=sit1;
%         
%     end

    for cc=1:3
        sit(:,:,cc)=(~sibwt)*100;
    end

    hi=imshow(sit,'XData',[x1_s(c)  x2_s(c)],'YData',[y1_s(c)  y2_s(c)]);
    %hi=imshow(sit,'XData',[six(c) six2(c)],'YData',[siy(c) siy2(c)]);
    %set(hi,'AlphaDataMapping','direct');
    %set(hi,'AlphaData',double(sibw{c}));
    %set(hi,'visible','off');
    his(c) =hi;
end

[szy szx t3]=size(Ie);

text(1.03*szx,szy*0.12,'a');
text(1.03*szx,szy*0.24,'b');
text(1.05*szx,szy*0.3,'r');

text(1.03*szx,szy*0.68,'6');
text(1.03*szx,szy*0.85,'3');

text(-0.03*szx,szy*0.68,'4');
text(-0.03*szx,szy*0.85,'1');


volt=text(0.45*szx,1.05*szy,['sound volume: ' num2str(voll) '   left arrow, right arrow']);

text(0.45*szx,-0.03*szy,'quit: q');





% groups of segments:

chicken=[17 18];

eggs=cell(2,2);
eggs{1,1}=[7  10  15 19 23];
eggs{2,1}=[6 9 14 20 24];
eggs{1,2}=[71 67 61 60 54];
eggs{2,2}=[70 65 62 59 53];

miss_symbs=cell(1,3);
miss_symbs{1}=[41 42];
miss_symbs{2}=[44];
miss_symbs{3}=[51];

brocken_eggs=cell(1,2);
brocken_eggs{1}=[21 34];
brocken_eggs{2}=[49 56];

chickens=cell(5,2);
chickens{1,1}=[29];
chickens{2,1}=[16 25 26];
chickens{3,1}=[12];
chickens{4,1}=[4];
chickens{5,1}=[1];

chickens{1,2}=[52];
chickens{2,2}=[58 55 57];
chickens{3,2}=[63];
chickens{4,2}=[68];
chickens{5,2}=[73 75];

digs=cell(1,3); % digits
digs{1}=[5 8 3 6 9 4 7];
digs{2}=[12 15 10 13 16 11 14];
digs{3}=[19 22 17 20 23 18 21];

game_a=[2 3 5 8 11 13];
game_b=[64  66  69  72  74];

set_invisible(hia);
set_wolf_invisible;



% for tr=1:500
%     tic;
%     set_invisible(hia);
%     set_wolf_invisible;
%     set_wolf(hiaw,randi(2),randi(2),true);
%     
%     set_visible(hia,eggs{1,1}(rand(1,5)>0.5));
%     set_visible(hia,eggs{2,1}(rand(1,5)>0.5));
%     set_visible(hia,eggs{1,2}(rand(1,5)>0.5));
%     set_visible(hia,eggs{2,2}(rand(1,5)>0.5));
%     
%     drawnow;
%     toc
% end    


% game loop:

%ht=title(' ');

%pr=0.3; % probability of egg insertion 
nse=7; % number of simultanius eggs
dnse=1; % randomization level of nse



nsw=5; % number of simultaniuse ways
dnsw=0; % randomization of nsw

game_type=1;

wp=[1 2]; % wolf position
%wd=7; % way length
wd=7; % way length
eggsp=false(wd,4); % eggs positions
or=[]; % order to move
orv=[]; % orders
orv_old=[];
tic;
t_last=toc;
score=0;
penalty=0;
penalty_ps=false; % pinalty pause
ppd=2.34; % pinality pause duration
tpp=toc-10;
flps=0.4; % fall pause, no control pause 
edr=2:6; % what eggs position is for display
iap=7; % in air position
ncps=false; % no catch pause
ncp=0.04; % no catch pause
t_ncp=toc-10;
move=false;
aw=logical([1 0 1 1]); % allowed ways
chonT=6; % chicken on period
choffT=6;  % chicken off period
chT=chonT+choffT;
chs=2; % chicken shift time
chst=true; % chicken state
bmes=false; % blinking miss eagg state
game_over=true;
resett=true; % starts from reset
chcs=false(1,5); % chicken state
chclr=1; % chiscen left or right
whp=false; % was half pinalty
ccs_old=0;
css=0;
lcw=false; % last chicken was
t_bl=0; % time for blinking
blT=0.5;
sbc=3; % special behaviur counter
pcfe=true; % pinalty clearing first enterence
pcp=false; % pinalty clearing pause
pct=toc-10; % pinalty clearing time
pcbs=true; % pinalty clearing blinking state
pcac=true; % pinalty clear aditional condition
nset=0;
nsetr=0;
while true

    
    
    % posponed penalty display:
    if lcw
        if ~no_penalty
            if whp
                penalty=penalty+1;
            else
                penalty=penalty+2;
            end
        end
        lcw=false;
    end
    
    % in game a awaliable locations is defined by penalty:
    p2= ceil(penalty/2);
    if game_type==1
        switch p2
            case 0
                aw=logical([1 0 1 1]); 
            case 1
                aw=logical([1 1 1 0]); 
            case 2
                aw=logical([0 1 1 1]); 
            case 3
                aw=logical([1 1 0 1]); 
        end
    else
        aw=logical([1 1 1 1]); 
    end
    
    if (penalty>=6)&&(~game_over)
        game_over=true;
        if sound_mode==1
            play(pgo);
        end
        if sound_mode==2
            sound(go*voll/5,Fs);
        end
        
    end
    
    if ~game_over
        score1=mod(score,1000);
        if ((score1==200)||(score1==500)||(score1==999))&&(penalty~=0)&&pcac
            % clearing penalty
            if pcfe
                % here is first time
                pcc=0; % penalty clearing counter
                pcp=true; % penalty clearing pause
                pcfe=false;
                pct=toc; % time
            end
            
            score2=score1;
            if score2==999
                score2=1000;
            end
            pcdt=score2speed(score2,game_type);
            if (toc-pct)>pcdt
                if pcbs
                    if sound_mode==1
                        play(pfall);
                    end
                    if sound_mode==2
                        sound(fall*voll/5,Fs);
                    end
                    pcc=pcc+1;
                end
                pcbs=~pcbs;
                pct=toc; % time
            end
            
            if pcc>=7
                % finish clearing:
                penalty=0;
                pcc=0;
                pcfe=true;
                pcac=false;
            end
            
            
        else
            if (toc-tpp)<ppd
                ccs=ceil(4*(toc-tpp)/ppd); % curent chicken step
                if ccs_old~=ccs
                    bmes=~bmes; % change for blinking of miss eggs
                    if whp
                        if sound_mode==1
                            play(peg3);
                        end
                        if sound_mode==2
                            sound(eg3*voll/5,Fs);
                        end
                    end
                 end
                ccs_old=ccs;

                if whp
                    chcs=false(1,5);
                    chcs(ccs+1)=true;
                else
                    chcs=false(1,5);
                    chcs(1)=true;
                end
                % fall pause

            else
                chcs=false(1,5); % remove chicken

                if penalty_ps
                    lcw=true;
                end

                penalty_ps=false;

                tp=score2speed(score,game_type); % pause time
                aggspa=any(eggsp); % busy ways
                if sum(double(aggspa))<=1
                    % if only one way bisy then pause is doubled
                    va=eggsp(2:iap,:); % visible and in air
                    if (score<5)&&all(~va(:))
                        tp1=tp;
                    else
                        tp1=2*tp;
                    end
                else
                    tp1=tp;
                end
                fi=find(eggsp(iap,:));
                if ~isempty(fi)

                    tp1=tp; % if step to fall then pause not doubled
                end

                % if all eggs in chickens then no wait:
                %vise=eggsp(2:end,:); % visible eggs, not in chicken positions
                if isempty(orv_old)
                    vise=eggsp(2:end,1);
                else
                    vise=eggsp(2:end,orv_old(end));
                end
                if all(~vise(:))
                    if ~move
                        tp1=0;
                    end
        %             if isempty(orv)
        %                 tp1=0;
        %             else
        %                 
        %                 orv1=orv(1);
        % 
        %                 if eggsp(1,orv1)
        %                     % exclude last step, egg that go from chichen has pause
        %                     
        %                 else
        %                     
        %                 end
        %             end
                end
                if (toc-t_last)>=tp1
                    % pausing
                    t_last=toc;

                    % check fall:
                    fi=find(eggsp(iap,:));
                    if ~isempty(fi)
                        % then fall step:
                        % length(fi) must be 1
                        % fi(1) fall way
                        if chst
                            %penalty=penalty+1;
                            whp=true;
                        else
                            %penalty=penalty+2;
                            whp=false;
                        end

                        chcs=logical([1 0 0 0 0]); % start chicken
                        chclr=ceil(fi(1)/2); % chicken left or right
                        set_chicken(hia,chickens,chclr,chcs,brocken_eggs); % update brockeng egg before pause
                        if sound_mode==1
                            play(pfall);
                        end
                        if sound_mode==2
                            sound(fall*voll/5,Fs);
                        end
                        drawnow; 


                        pause(flps); % fall pause, no control

                        eggsp=false(wd,4); % clear eggs
                        penalty_ps=true;
                        tpp=toc; % time of pause start
                        move=false;

                    else
                        if (toc-t_bl)>blT
                            bmes=~bmes; % change for blinking of miss eggs
                            t_bl=toc;
                        end

                        if score>=5

                            if all(~eggsp(:)) % if no eggs
                                % then insert necessarily
                                iaw=find(aw);
                                ri=randi(length(iaw));
                                r=iaw(ri);
                                eggsp(1,r)=true;
                                orv=[r];
                                or=1;
                                move=false;
                            else
                                %nse=4; % number of simultanius eggs
                                %nset=nse+round(randn*dnse); % number of requested quantity of eggs
                                nset=score2simultanious(score,game_type);
                                nset=nset-round(rand*dnse);
                                eggsp1=eggsp(edr,:);
                                eggsp11=eggsp(1:7,:);
                                nsetr=double(sum(eggsp11(:))); % current number of simultaniuse eggs

                                aggspa=any(eggsp); % busy ways
                                %aggspa(~aw)=true; % not alowed ways considered as busy

                                nswt=nsw+round(randn*dnsw); % number of alowed simultaniuse ways
                                nuw=sum(aggspa); % number of used ways
                                if (nsetr<nset)&&(nuw<nswt)
                                    % insert egg

                                    orv1=orv(1); % current way- can be moved (+insertion or not) or insert to some empty way
                                    %cwf=~eggsp(1,orv1); % current way free
                                    %if rand<0.5
                                        %egp2=(~eggsp(1,orv1))&&(~eggsp(2,orv1));
                                    %else
                                        egp2=~eggsp(1,orv1);
                                    %end
                                    %cwf=~eggsp(1,orv1); % current way free
                                    cwf=egp2;
                                    wea=~aggspa; % what ways is empty
                                    weae=wea&(orv1~=(1:4)); % exclude current
                                    weae=weae&aw; % exclude not alowed
                                    ewe=any(weae); % empty way exist

                                    if cwf
                                        % curretn is free
                                        if ewe
                                            % empty way exist
                                            if rand<50
                                                % insert to current
                                                insert_to_current;
                                            else
                                                % ensert to empty way
                                                ensert_to_empty_way;
                                            end
                                        else
                                            % empty way not exist
                                            % insert to current
                                            insert_to_current;
                                        end
                                    else
                                        % current is not free
                                        if ewe
                                            % empty way exist
                                            % ensert to empty way
                                            ensert_to_empty_way;
                                        else
                                            % empty way not exist
                                            %not insert just move
                                            just_move;
                                        end
                                    end


                                else
                                    %not insert just move
                                    just_move;
                                end


                            end

                        else
                            % special behaviour for score<5
                            if all(~eggsp(:)) % if no eggs
                                % find closest position ~=0 at aw, starting
                                % from counter sbc
                                % search for next ~=0
                                while true
                                    if aw(sbc)
                                        ew1=sbc;
                                        sbc=sbc+1;
                                        if sbc>4
                                            sbc=1;
                                        end
                                        break;
                                    else
                                        sbc=sbc+1;
                                        if sbc>4
                                            sbc=1;
                                        end
                                    end
                                end

                                eggsp(1,ew1)=true;
                                orv=[orv  ew1];
                                move=false;

                            else
                                just_move;
                            end
                        end

                        aggspa=any(eggsp); % busy ways
                        orvl=false(size(orv)); % what way is leave in order list, (empty ways will be deleted)
                        for orvc=1:length(orv)
                            %aggspa(orv(orvc)) true this way is busy
                            orvl(orvc)=aggspa(orv(orvc));
                        end
                        orv_old=orv;
                        orv=orv(orvl); % delete empty ways from order list

                        % there are some logical error in the code that can make
                        % lead to repeated numbers in orv, soexclude repeated
                        % sequencies:
                        orv=no_repeat(orv);





                        % sound
                        % if all eggs in chickens then no sound:
                        %vise=eggsp(2:end,:); % visible eggs, not in chicken positions
                        vise=eggsp(2:end,orv_old(end));
                        if all(~vise)

                        else

                            if sound_mode==1
                                switch orv_old(end)
                                    case 1
                                        play(peg1);
                                    case 2
                                        play(peg4);
                                    case 3
                                        play(peg3);
                                    case 4
                                        play(peg2);

                                end
                            end
                            if sound_mode==2
                                switch orv_old(end)
                                    case 1
                                        sound(eg1*voll/5,Fs);
                                    case 2
                                        sound(eg4*voll/5,Fs);
                                    case 3
                                        sound(eg3*voll/5,Fs);
                                    case 4
                                        sound(eg2*voll/5,Fs);

                                end
                                
                            end
                        end

                    end

                else
                    % pause in egg motion

                end
            end

            % catch eggs:
            %ncps=false; % no catch pause
            %ncp=0.05; % no catch pause
            %t_ncp=toc-10;
            fi=find(eggsp(iap,:)); % expected that length(fi)=1
            if (~isempty(fi))&&(~ncps)
                ncps=true;
                t_ncp=toc;
            end
            ncp1=min([tp  ncp]);
            wpi=wp(1)+(wp(2)-1)*2;
            if ~isempty(fi)
                if (fi==wpi)&&(((toc-t_ncp)>=ncp1)&&ncps)
                    score=score+1; % increase score
                    eggsp(iap,fi)=false; % delete egg
                    if sound_mode==1
                        play(pgot);
                    end
                    if sound_mode==2
                        sound(got*voll/5,Fs);
                    end

                    ncps=false;

                    %t_last=toc-ncp; % shift global pausing
                    t_last=t_last+ncp;
                    
                    pcac=true; % pinalty clear aditional condition
                end
            end

            % chicken:
            if (~penalty_ps)&&(penalty<6)&&(~lcw)
                if mod(toc+chs,chT)<chonT
                    chst=true;
                else
                    chst=false;
                end
            end
        end
        
    end % end of game over condition
    
    
    


    % update graphics:
    if ~resett
        set_invisible(hia);
        set_wolf_invisible;
        set_invisible(his);
        digits_code;
        if chst
            set_visible(hia,chicken);
        end
        if game_type==1
            set_visible(hia,game_a);
        else
            set_visible(hia,game_b);
        end
        penalty_code;
        set_wolf(hiaw,wp(1),wp(2),true);
        set_eggs(hia,eggs,eggsp,edr);  
        set_chicken(hia,chickens,chclr,chcs,brocken_eggs);
    else
        set_all_visible(hia,hiaw,his);
    end
    
    
    
    %set(ht,'string',[num2str(orv)  '   move=' num2str(move)  '   nset=' num2str(nset) '   nsetr='  num2str(nset)   '  score=' num2str(score) ]);
    
    drawnow;
    %pause(0.25);
    
    if qt
        break;
    end
    
end
close all;

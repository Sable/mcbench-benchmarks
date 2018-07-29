function open_device
% open sound device, prepare , and start
global po pso pco
global Fs s
global ao
global pla
global hdls
global vol
global hd1 hd2
if ~pla
    % po=0.1; % for output
    pso=round(po*Fs);
    ao = analogoutput('winsound');
    ch = addchannel(ao,1:2);
    set(ao,'SampleRate',Fs);
    set(ao,'BufferingConfig',[pso 4]);
    set(ao,'SamplesOutputFcn','add_to_buffer');
    set(ao,'SamplesOutputFcnCount',pso);
    for mc=1:3 % 3 pieces margin
        d1=vol*s(1+pso*(mc-1):pso*mc,:);
        d1=[filter(hd1,d1(:,1))  filter(hd2,d1(:,2)) ];
        putdata(ao,d1);
        pco=mc; % piece counter
    end
    display_time_script;
    pco=pco+1;
    pla=true;
    
    
    
    start(ao);
end
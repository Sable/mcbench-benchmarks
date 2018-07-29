% The “ECG Waveform Simulator” program gives users the ability to easily create custom ECG waveforms.
% The program stores the waveform data in a Matlab array and plots the waveform. It then provides 
% the user the ability to send the ECG waveform to an arbitrary waveform generator or to store the 
% ECG waveform in a CSV file. The arbitrary waveform generator feature allows you to easily recreate 
% a real world ECG signals for testing ECG measurement equipment. The CSV file storage allows you to 
% store the custom ECG waveform you created for later analysis and use. It also allows you to 
% analyze and manipulate the ECG waveform using Excel tools. 
% The ECG Waveform Simulator uses Fourier Series to create the various parts of an ECG waveform. 
% This approach makes it simple to manipulate and customize the waveform by specifying the amplitude 
% and duration of the various parts of the ECG waveform such as the P, QRS, T, and U portions of 
% the waveform. This program highly leverages the “ECG simulation using MATLAB” program created by 
% karthik raviprakash for creating the ECG waveforms. For more information on how the waveforms are 
% created and how to customize the waveforms refer to the enclosed PDF file entitled “ECG.”
% The program can remotely send and store the waveforms on the 33521A Function / Arbitrary Waveform 
% Generator and the 33522A 2-Channel Function / Arbitrary Waveform Generator for testing ECG 
% measurement equipment. Besides providing the ability to continuously output any stored ECG 
% waveform, the 33521A and 33522A also have a feature known as waveform sequencing that allows you 
% to create long complex patterns of waveforms stored in memory. The sequencing feature is analogous 
% to creating a playlist on your MP3 player. You can piece together multiple ECG waveforms in memory 
% to create a long complex pattern of ECG waveforms for creating real world ECG patterns. For more 
% information on using the 33521A and 33522A sequencing feature refer to the following link: 
% http://gpete-neil.blogspot.com/2011/03/creating-arbitrary-waveform-sequences.html. The program 
% uses Ethernet to remotely connect to a 33521A or 33522A using just the instrument’s IP address. 
% The instrument must be connected to the computer running the program via a LAN cable or to the 
% same Ethernet network that the computer is connect to. You must have the Matlab “Instrument” 
% toolbox to run this program.
% Questions, comments, suggestions: neil underscore forcier at agilent dot com

run = 1;

while (run == 1)%while loop allows user to run the program again if they want to

%build x axis array
x=0.60008:0.00008:1.4;

%query user to see if want to create a defualt typical ECG or custom ECG
default=input('Press 1 if u want default ecg signal else press 2:\n'); 
if(default==1)
    %default waveform values
      li=30/72;  
    
      %P wave and PR interval default settings 
      a_pwav=0.25; %P wave amplitude
      d_pwav=0.09; %P wave duration
      t_pwav=0.16; %PR interval. This combined with P wave duration defines PR segment
     
      %Q wave default settings
      a_qwav=0.025; %Q wave amplitude
      d_qwav=0.066; %Q wave duration
      t_qwav=0.166; %not adjustable in program
      
      %R wave default settings
      a_qrswav=1.6; %R wave amplitude
      d_qrswav=0.11; %R wave duration
      
      %S wave default settings
      a_swav=0.25; %S wave amplitude
      d_swav=0.066; %S wave duration
      t_swav=0.09; %not adjustable in program
      
      %T wave default settings
      a_twav=0.35; %T wave amplitude
      d_twav=0.142; %T wave duration
      t_twav=0.2; %ST Interval
      
      %U wave default settings
      a_uwav=0.035; %U wave amplitude
      d_uwav=0.0476; %U wave duration
      t_uwav=0.433; %not adjustable in program
else
    rate=input('\n\nenter the heart beat rate :');
    li=30/rate;
    
    %p wave specifications
    fprintf('\n\np wave specifications\n');
    d=input('Enter 1 for default specification else press 2: \n');
    if(d==1)
        a_pwav=0.25;
        d_pwav=0.09;
        t_pwav=0.16;
    else
       a_pwav=input('amplitude = ');
       d_pwav=input('duration = ');
       t_pwav=input('p-r interval = ');
       d=0;
    end    
    
    
    %q wave specifications
    fprintf('\n\nq wave specifications\n');
    d=input('Enter 1 for default specification else press 2: \n');
    if(d==1)
        a_qwav=0.025;
        d_qwav=0.066;
        t_qwav=0.166;
    else
       a_qwav=input('amplitude = ');
       d_qwav=input('duration = ');
       t_qwav=0.166;
       d=0;
    end    
    
    
    
    %qrs wave specifications
    fprintf('\n\nqrs wave specifications\n');
    d=input('Enter 1 for default specification else press 2: \n');
    if(d==1)
        a_qrswav=1.6;
        d_qrswav=0.11;
    else
       a_qrswav=input('amplitude = ');
       d_qrswav=input('duration = ');
       d=0;
    end    
    
    
    
    %s wave specifications
    fprintf('\n\ns wave specifications\n');
    d=input('Enter 1 for default specification else press 2: \n');
    if(d==1)
        a_swav=0.25;
        d_swav=0.066;
        t_swav=0.09;
    else
       a_swav=input('amplitude = ');
       d_swav=input('duration = ');
       t_swav=0.09;
       d=0;
    end    
    
    
    %t wave specifications
    fprintf('\n\nt wave specifications\n');
    d=input('Enter 1 for default specification else press 2: \n');
    if(d==1)
        a_twav=0.35;
        d_twav=0.142;
        t_twav=0.2;
    else
       a_twav=input('amplitude = ');
       d_twav=input('duration = ');
       t_twav=input('s-t interval = ');
       d=0;
    end    
    
    
    %u wave specifications
    fprintf('\n\nu wave specifications\n');
    d=input('Enter 1 for default specification else press 2: \n');
    if(d==1)
        a_uwav=0.035;
        d_uwav=0.0476;
        t_uwav=0.433;
    else
       a_uwav=input('amplitude = ');
       d_uwav=input('duration = ');
       t_uwav=0.433;
       d=0;
    end    
    
       
    
end

 pwav=p_wav(x,a_pwav,d_pwav,t_pwav,li);

 
 %qwav output
 qwav=q_wav(x,a_qwav,d_qwav,t_qwav,li);

    
 %qrswav output
 qrswav=qrs_wav(x,a_qrswav,d_qrswav,li);

 %swav output
 swav=s_wav(x,a_swav,d_swav,t_swav,li);

 
 %twav output
 twav=t_wav(x,a_twav,d_twav,t_twav,li);

 %uwav output
 uwav=u_wav(x,a_uwav,d_uwav,t_uwav,li);

 %ecg output
 ecg=pwav+qrswav+twav+swav+qwav+uwav;
 figure(1)
 %ecg
 plot(x,ecg);
 
 %Query the user to see what they want to do with the ECG waveform
 fprintf('Enter 1 to send to 33521A or 33522A\n');
 fprintf('Enter 2 to send to .CSV file\n');
 fprintf('Enter anything else to exit\n');
 whereTo=input('Enter: '); 

if(whereTo==1)
    %query user for waveform name
    arbName = input('Enter a name for the waveform: ','S'); 
    ecgScaled = ampScale(ecg); %scale waveform amplitude for AWG
    arbTo33500(ecgScaled,arbName); %send arb to a 33521A or 33522A
elseif(whereTo==2)
   %query user for name of CSV file where waveform will be stored
    csvName= input('Enter a name for the waveform: ','S'); 
    csvName = [csvName '.csv'];
    dlmwrite(csvName, ecg', 'coffset', 0, 'roffset', 0);
else
    %fprintf('do nothing\n');
end

%Query the user to see if they want to run the program again or exit
run = input('Enter 1 to run program again or any other number to exit: ');

if(run ~= 1)
    run = 69;
end
end
fprintf('Done and outta here.......\n');
    
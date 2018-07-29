function flanger( file )
%[Function description]
%Creates a flanging effect on the input music file and plays it
%[Input]
%file - A wav file
%[Output]
%None. it plays the music

%Reading the file
[y, fs, nbits] = wavread(file);

%Creating the vector according to which delay is varied
low_n = round(0.0*fs);
high_n = round(0.0057*fs);

delay_vary_p = 8;
delay_step = (delay_vary_p/4)/(1/fs);

delay_1 = round(linspace(low_n,high_n,delay_step));
delay_2 = round(linspace(high_n,low_n,delay_step));
delay = [delay_1 delay_2];
no_points = length(y(:,1));

n_rep = round(no_points/length(delay));
delay = repmat(delay,1,n_rep);

delay = [delay delay(1:no_points-length(delay))];

%Apply the dealy
out_wav(:,1) = zeros(1,no_points);
out_wav(:,2) = zeros(1,no_points);

for i=1:no_points
    n = i-delay(i);
    if n>0
        out_wav(i,1) = y(i,1)+y(n,1);
        out_wav(i,2) = y(i,2)+y(n,2);
    else
        out_wav(i,1) = y(i,1);
        out_wav(i,2) = y(i,2);
    end
end

%Play
p = audioplayer(out_wav,fs,nbits);
play(p);
pause;

end


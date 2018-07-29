function sevec = figresize(bw2)
% This function take the cropped binary image and resize it to 5 x 7
% char representation as single vector.

bw_7050=imresize(bw2,[70,50]);
for cnt=1:7
    for cnt2=1:5
        Atemp=sum(bw_7050((cnt*10-9:cnt*10),(cnt2*10-9:cnt2*10)));
        sevec((cnt-1)*5+cnt2)=sum(Atemp);
    end
end

sevec=((100-sevec)/100);
sevec=sevec';
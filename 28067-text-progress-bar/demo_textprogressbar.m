%demo_textprogressbar
%This a demo for textprogressbar script
textprogressbar('calculating outputs: ');
for i=1:100,
    textprogressbar(i);
    pause(0.1);
end
textprogressbar('done');


textprogressbar('saving data:         ');
for i=1:0.5:80,
    textprogressbar(i);
    pause(0.05);
end
textprogressbar('terminated');
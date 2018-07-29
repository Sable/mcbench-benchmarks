function shark()

% (the function shark adds the needed folders to the matlab path)

sharkpath=which('shark');

path(path,[ sharkpath(1:length(sharkpath)-8) ]);
path(path,[ sharkpath(1:length(sharkpath)-7) 'Demos' ]);

v=ver('Matlab');n=fix(str2num(v.Version(1)));

p5=[ sharkpath(1:length(sharkpath)-7) 'mex5' ];
p6=[ sharkpath(1:length(sharkpath)-7) 'mex6' ];

pt=path;
le=length(p5);
lp=length(pt);

if n==5,
    
    i6=findstr(pt,p6);
    if ~isempty(i6), 
        path([pt(1:i6-1) pt(i6+le:lp)]);
    end
    path(path,p5);
    
else
    
    i5=findstr(pt,p5);
    if ~isempty(i5), 
        path([pt(1:i5-1) pt(i5+le:lp)]);
    end
    path(path,p6);
    
end

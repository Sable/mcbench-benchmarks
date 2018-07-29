function Spice = ReadRawSpice(filename)
%   SPICE = READRAWSPICE(FILENAME)
%     This function reads a SPICE raw file into a structure indexed by the 
%     node name
%
%filename is the SPICE raw file
%
%Spice is data structure with the following structure:
%  Spice.name => A cell of strings, with the node names inside
%  Spice.type => A cell of strings, with the variable type (i.e. voltage, current etc.)
%  Spice.time => A vector of the SPICE simulation time points
%  Spice.data => A cell of vectors, containing data matching up to name, type and time
%  For example,
%    Spice = ReadRawSpice('test.cir')
%    Spice.name{10}, returns "node23"
%    Spice.type{10}, returns "voltage"
%    plot(Spice.time,Spice.data.node23)
%    title(['Data for node name: ' Spice.name{10}])
%    ylabel(Spice.type{10})
%    xlabel('Time, in seconds');
%    ==>  This would plot out "NODE23", and appropriately label the Y-AXIS as a voltage
%
% This script is optimized to be *very* fast.
% Note that to speed things up even more, you might want to set 
%  the following variable in SPICE:
%     set rawfileprec=5
%  This can make the script about many times faster, at the cost of little 
%  less precision.  SPICE defaults the raw file to have 15 digits of 
%  precision, which makes it huge.  Setting it to 3 makes the read 8 times 
%  faster.
%  If you are using WinSpice (http://www.winspice.com/),
%   you can use the following command line option to get a rawfile:
%   wspice3 -b -i "rawfile.txt" "spice_deck.cir"
%
%   Brett Bymaster 7/27/05
%

tic;
s=importdata(filename);

n=5;
number_variables=str2num(s.textdata{n}(findstr(s.textdata{n},': ')+2:end))
n=6;
number_points=str2num(s.textdata{n}(findstr(s.textdata{n},': ')+2:end))

header=sprintf('%s\n%s\n%s\n%s\n%s\n%s\n',s.textdata{1},s.textdata{2},s.textdata{3},s.textdata{4},s.textdata{5},s.textdata{6});

nn=1;
for n=9:length(s.textdata)-1;
    a=regexp(s.textdata{n},'(\d+)\s+(\S+)\s+(\S+)','tokens');
    name{nn} = a{1}{2};
    type{nn} = a{1}{3};
    nn=nn+1;
end

time=s.data(1:number_variables:(length(s.data)-number_variables+1),2);


    n=2;
    name_edit = strrep(name{n-1},'#','_pd_');
    data=struct(name_edit,s.data(n:number_variables:(length(s.data)-number_variables+n),2));

for n=3:length(name),
    name_edit = strrep(name{n-1},'#','_pd_');
    data=setfield(data,name_edit,s.data(n:number_variables:(length(s.data)-number_variables+n),2));
end

    
%Spice = struct {'name',name,'type',type,'time',time,'data',data};
Spice.header=header;
Spice.name = name;
Spice.type = type;
Spice.time = time;
Spice.data = data;

toc






function Spice = ReadRawSpice2(filename)
%   SPICE = READRAWSPICE(FILENAME)
%     This function reads a SPICE raw file into a structure indexed by the 
%     node number
%
%filename is the SPICE raw file
%Spice is data structure with the following structure:
%  Spice.name => A cell of strings, with the node names inside
%  Spice.type => A cell of strings, with the variable type (i.e. voltage, current etc.)
%  Spice.time => A vector of the SPICE simulation time points
%  Spice.data => A cell of vectors, containing data matching up to name, type and time
%  For example,
%    Spice = rawspice('test.cir')
%    Spice.name{10}, returns "NODE23"
%    Spice.type{10}, returns "voltage"
%    plot(Spice.time,Spice.data{10})
%    title(['Data for node name: ' Spice.name{10}])
%    ylabel(Spice.type{10})
%    xlabel('Time, in seconds');
%    ==>  This would plot out "NODE23", and appropriately label the Y-AXIS as a voltage
%
% This script is optimized to be *very* fast.
% Note that to speed things up even more, you might want to set 
%  the following variable in SPICE:
%     set rawfileprec=5
%  This can make the script about many times faster, at the cost of little 
%  less precision.  SPICE defaults the raw file to have 15 digits of 
%  precision, which makes it huge.  Setting it to 3 makes the read 8 times 
%  faster.
%  If you are using WinSpice (http://www.winspice.com/),
%   you can use the following command line option to get a rawfile:
%   wspice3 -b -i "rawfile.txt" "spice_deck.cir"

tic;
s=importdata(filename);

n=5;
number_variables=str2num(s.textdata{n}(findstr(s.textdata{n},': ')+2:end))
n=6;
number_points=str2num(s.textdata{n}(findstr(s.textdata{n},': ')+2:end))

header=sprintf('%s\n%s\n%s\n%s\n%s\n%s\n',s.textdata{1},s.textdata{2},s.textdata{3},s.textdata{4},s.textdata{5},s.textdata{6});

nn=1;
for n=9:length(s.textdata)-1;
    a=regexp(s.textdata{n},'(\d+)\s+(\S+)\s+(\S+)','tokens');
    name{nn} = a{1}{2};
    type{nn} = a{1}{3};
    nn=nn+1;
end

time=s.data(1:number_variables:(length(s.data)-number_variables+1),2);

for n=2:length(name),
    data{n-1}=s.data(n:number_variables:(length(s.data)-number_variables+n),2);
end

    
%Spice = struct {'name',name,'type',type,'time',time,'data',data};
Spice.header=header;
Spice.name = name;
Spice.type = type;
Spice.time = time;
Spice.data = data;

toc
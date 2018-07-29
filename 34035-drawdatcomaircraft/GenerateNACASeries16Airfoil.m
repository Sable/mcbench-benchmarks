function [xu,yu,xl,yl,xc,yc]=GenerateNACASeries16Airfoil(afid,dotcount,...
                                                         xmod)

%--------------------------------------------------------------------------
%GenerateNACASeries16Airfoil
%Version 1.10
%Created by Stepen (zerocross_raptor@yahoo.com)
%Created 21 November 2010
%Last modified 1 December 2011
%--------------------------------------------------------------------------
%GenerateNACASeries16Airfoil generates the airfoil vertexes' coordinate of
%the given NACA Series 16 Airfoil (commonly for propeller). The math
%equation used to generates the airfoil coordinates is based on Theory of
%Wing Section Chapter 6 by Abbott and Doenhoff.
%--------------------------------------------------------------------------
%Syntax:
%[xu,yu,xl,yl,xc,yc]=GenerateNACASeries16Airfoil(afid,dotcount,xmod)
%Input argument:
%- afid (1 x 4 str) specifies NACA Series 16 Airfoil identifier.
%- dotcount (1 x 1 int) specifies the number of vertexes to be generated on
%  the airfoil's camber/mean line.
%- xmod (str) specifies the mode of airfoil vertex distribution. Enter
%  'Uniform' to create uniform vertex distribution or 'Cosine' to create
%  vertex distribution based on cosine function (More vertex on the leading
%  edge region).
%Output argument:
%- xu (i x 1 num) specifies the x axis location of airfoil's upper surface
%  vertexes in fraction of chord. The airfoil's upper surface vertex are
%  arranged from leading edge (the first element of xu) to the trailing
%  edge (the last element of xu).
%- yu (i x 1 num) specifies the y axis location of airfoil's upper surface
%  vertexes in fraction of chord. The airfoil's upper surface vertex are
%  arranged from leading edge (the first element of yu) to the trailing
%  edge (the last element of yu).
%- xl (i x 1 num) specifies the x axis location of airfoil's lower surface
%  vertexes in fraction of chord. The airfoil's lower surface vertex are
%  arranged from leading edge (the first element of xl) to the trailing
%  edge (the last element of xl).
%- yl (i x 1 num) specifies the y axis location of airfoil's lower surface
%  vertexes in fraction of chord. The airfoil's lower surface vertex are
%  arranged from leading edge (the first element of yl) to the trailing
%  edge (the last element of yl).
%- xc (i x 1 num) specifies the x axis location of airfoil's camber line
%  vertexes in fraction of chord. The airfoil's camber line vertex are
%  arranged from leading edge (the first element of xc) to the trailing
%  edge (the last element of xc).
%- yc (i x 1 num) specifies the y axis location of airfoil's camber line
%  vertexes in fraction of chord. The airfoil's camber line vertex are
%  arranged from leading edge (the first element of yc) to the trailing
%  edge (the last element of yc).
%--------------------------------------------------------------------------

%CodeStart-----------------------------------------------------------------
%Checking input afid
    if ~ischar(afid)
        error('Airfoil identifier must be a string!')
    end
    if numel(afid)~=5
        error('Airfoil identifier must be a 5 digit number!')
    end
    if isempty(str2double(afid))
        error('Airfoil identifier must be a 5 digit number!')
    end
    id=str2double(afid([1,2]));
    if id~=16
        error('Airfoil identifier must start with 16!')
    end
%Checking input dotcount
    if numel(dotcount)~=1
        error('Number of vertex must be scalar!')
    end
    if (mod(dotcount,1~=0))||(dotcount<0)
        error('Number of vertex must be positive integer!')
    end
%Checking input xmod
    if nargin<3
        xmod='Cosine';
    end
    if (~strcmpi(xmod,'Uniform'))&&(~strcmpi(xmod,'Cosine'))
        error('Vertex distribution input must be Uniform or Cosine!')
    end
%Declaring look-up table
    xctable=[0,1.25,2.5,5,7.5,10,15,20,30,40,50,60,70,80,90,95,100]/100;
    yctable=[0,0.646,0.903,1.255,1.516,1.729,...
             2.067,2.332,2.709,2.927,3,2.917,...
             2.635,2.099,1.259,0.707,0.060]/600;
%Assigning identifier to equation coefficient
    id1=str2double(afid(3));
    id2=str2double(afid([4,5]));
    cl=id1*(10/100);            %Design lift coefficient
    t=id2*(1/100);              %Maximum thickness
    if t==0
        warning(['Zero thickness airfoil!',...
                 ' Airfoil will be just a camber line!'])
    end
%Calculating x-axis location of camber line vertexes
    panelcount=dotcount-1;
    if strcmpi(xmod,'Uniform')
        panellength=1/panelcount;
        xc=(0:panellength:1)';
    elseif strcmpi(xmod,'Cosine')
        deltadeg=90/panelcount;
        xc=1-cosd(0:deltadeg:90)';
    end
%Preallocating array for speed
    yc=zeros(dotcount,1);
    gc=zeros(dotcount,1);
    yt=zeros(dotcount,1);
    xu=zeros(dotcount,1);
    xl=zeros(dotcount,1);
    yu=zeros(dotcount,1);
    yl=zeros(dotcount,1);
%Calculating y-axis location of camber line vertexes and camber gradient
    for i=2:1:dotcount-1
        yc(i)=(-cl/(4*pi()))*(((1-xc(i))*log(1-xc(i)))+(xc(i)*log(xc(i))));
        gc(i)=(cl/(4*pi()))*(log(1-xc(i))-log(xc(i)));
    end
%Converting camber gradient to camber slope and normal
    sc=atand(gc);
%Calculating thickness distribution
    for i=1:1:dotcount
        yt(i)=interp1q(xctable',yctable',xc(i))*(100*t);
    end
%Generating airfoil vertexes
    for i=1:1:dotcount
        xu(i)=xc(i)-yt(i)*sind(sc(i));
        yu(i)=yc(i)+yt(i)*cosd(sc(i));
        xl(i)=xc(i)+yt(i)*sind(sc(i));
        yl(i)=yc(i)-yt(i)*cosd(sc(i));
    end
%CodeEnd-------------------------------------------------------------------

end
function [] = RUS()
%RUS.m A GUI for use in Resonant Ultrasound Spectroscopy.  Given a sample's 
% geometry and material properties, calculates a set of resonant modes.
% This is used in Material Science as a way to get elastic properties of
% a variety of materials, starting from an educated guess.  See the
% accompanying pdf for a more detailed explanation of how this works.
% 
% Author: Matt Fig
% Contact: popkenai@yahoo.com
% Note:  I would be interested in feedback about this program and your
% experiences with it.  Credit should be given where appropriate.
h_fig = figure('units','pixels','position',[30 450 550 465],...
               'menubar','none','name','Resonant Ultrasound Spectroscopy'...
               ,'resize','off');

try           
DIR = what('Material_Files');                    % Look for material files.
LIST = DIR.mat;
catch
    delete(h_fig)
    error(['All of the material data files (.mat) must be stored in a',...
           ' subfolder named ''Material_Files''.'])       
end       
% Now create the uicontrols.            
uicontrol(h_fig,'style','frame','position',[30 60 200 110]);
uicontrol(h_fig,'style','text','position',[35 163 135 15],...
          'string','Calculation and Plotting','fontweight','bold',...
          'backgroundcolor',[.988 .804 .988]);
uicontrol(h_fig,'style','text','position',[40 128 100 20],...
          'string','Polynomial Order:','fontweight','bold');
uicontrol(h_fig,'style','frame','position',[325 60 200 365]);      
lst1 = uicontrol(h_fig,'style','listbox','position',[330 75 190 300],...
                 'backgroundcolor','w','FontSize',12,'callback',...
                 {@Listcall},'tooltipstring',[' Click on a frequency ',...
                 'to plot the corresponding mode shape']);      
edt4 = uicontrol(h_fig,'style','edit','position',[160 130 50 20],...
                 'string','6','backgroundcolor','w','callback',...
                 {@Clr,lst1},'tooltipstring',[' Minimum of 3, ',...
                 '10 is usually sufficient. ']);              
txt10 = uicontrol(h_fig,'style','text','position',[40 97 105 20],...
                 'string','Disp. Exaggeration:','fontweight','bold',...
                 'enable','off');  
edt5 = uicontrol(h_fig,'style','edit','position',[160 100 50 20],...
                 'string','.02','backgroundcolor','w','enable','off',...
                 'tooltipstring','Enter exageration level for plot.');             
chk6 = uicontrol(h_fig,'style','checkbox','position',[65 70 140 20],...
                 'string',' Create New Figure','fontweight','bold',...
                 'enable','off','tooltipstring',[' Check so each new ',...
                 'plot is made in a new figure. ']);           
uicontrol(h_fig,'style','frame','position',[30 190 260 235]);
uicontrol(h_fig,'style','text','position',[35 418 110 15],...
          'string','Sample Properties','fontweight','bold',...
          'backgroundcolor',[.988 .804 .988]);
uicontrol(h_fig,'style','text','position',[40 373 67 20],...
          'string','Material:','fontweight','bold');
pop1 = uicontrol(h_fig,'style','popupmenu','position',[120 375 140 20],...
                 'string',LIST,'backgroundcolor','w','callback',...
                 {@Clr,lst1});             
uicontrol(h_fig,'style','text','position',[40 335 55 20],...
          'string','Shape:','fontweight','bold');            
txt4 = uicontrol(h_fig,'style','text','position',[40 258 120 20],...
                 'string','Side 1 length (cm):','fontweight','bold');                           
txt5 = uicontrol(h_fig,'style','text','position',[40 228 120 20],...
                 'string','Side 2 length (cm):','fontweight','bold');             
edt2 = uicontrol(h_fig,'style','edit','position',[180 230 80 20],...
                 'string','1','backgroundcolor','w','callback',...
                 {@Clr,lst1},'tooltipstring','Enter length in cm.');
txt6 = uicontrol(h_fig,'style','text','position',[40 198 120 20],...
                 'string','Side 3 length (cm):','fontweight','bold');             
edt3 = uicontrol(h_fig,'style','edit','position',[180 200 80 20],...
                 'string','1','backgroundcolor','w','callback',...
                 {@Clr,lst1},'tooltipstring','Enter length in cm.');             
chk1 = uicontrol(h_fig,'style','checkbox','position',[50 305 70 15],...
                 'string','Cube','fontweight','bold','callback',...
                 {@Simple,edt2,edt3,1,lst1});
chk2 = uicontrol(h_fig,'style','checkbox','position',[120 305 70 15],...
                 'string','Circular','fontweight','bold','enable','off',...
                 'callback',{@Simple,edt2,edt3,2,lst1});
chk3 = uicontrol(h_fig,'style','checkbox','position',[205 305 70 15],...
                 'string','Sphere','fontweight','bold','enable','off',...
                 'callback',{@Simple,edt2,edt3,1,lst1});
edt1 = uicontrol(h_fig,'style','edit','position',[180 260 80 20],...
                 'string','1','backgroundcolor','w',...
                 'tooltipstring','Enter length in cm.','callback',...
                 {@Simple2,chk1,chk2,chk3,edt2,edt3,lst1});             
pop2 = uicontrol(h_fig,'style','popupmenu','position',[100 340 160 20],...
                 'backgroundcolor','w','callback',{@Shape,chk1,chk2,chk3,...
                 txt4,txt5,txt6,edt2,edt3,lst1},'string',...
                 'Rectangular Parallelepiped|Cylinder|Ellipsoid');                          
txt7 = uicontrol(h_fig,'style','text','position',[330 417 105 15],...
                 'string','Frequencies (MHz)','fontweight','bold',...
                 'backgroundcolor',[.988 .804 .988]);            
chk4 = uicontrol(h_fig,'style','checkbox','position',[375 390 100 15],...
                 'string','Display in kHz','fontweight','bold','enable',...
                 'off','callback',{@Scale,lst1,txt7},'tooltipstring',...
                 ' Toggle list between kHz and MHz');
uicontrol(h_fig,'style','pushbutton','position',[30 15 495 35],...
          'string','Calculate','fontweight','bold','fontsize',...
          12,'backgroundcolor',[.65 .75 .65],'callback',...
          {@Push,DIR,pop1,pop2,edt1,edt2,edt3,edt4,edt5,lst1,...
          chk4,chk6,txt10});              
              
 
function [] = Shape(hand,eventdata,chk1,chk2,chk3,txt4,txt5,txt6,...
                    edt2,edt3,lst1)             
%Callback for shape choice.  Simplifies options after a choice is made.               
choice = get(hand,'value');

switch choice
    case 1
        set(chk1,'enable','on');                       % Allow a cube only.
        Simple(chk1,eventdata,edt2,edt3,1,lst1)          % Clean up others. 
        set(chk2,'enable','off','value',0);
        set(chk3,'enable','off','value',0);
        set(txt4,'string','Side 1 length (cm):')
        set(txt5,'string','Side 2 length (cm):')
        set(txt6,'string','Side 3 length (cm):')
    case 2
        set(chk1,'enable','off','value',0); % Allow circular cylinder only.        
        set(chk2,'enable','on');
        Simple(chk2,eventdata,edt2,edt3,2,lst1)
        set(chk3,'enable','off','value',0);
        set(txt4,'string','1st Diameter (cm):')
        set(txt5,'string','2nd Diameter (cm):')
        set(txt6,'string','Enter height (cm):')
                                            
    case 3
        set(chk1,'enable','off','value',0);            % Allow sphere only.
        set(chk2,'enable','off','value',0);
        set(chk3,'enable','on');
        Simple(chk3,eventdata,edt2,edt3,1,lst1)
        set(txt4,'string','Major axis 1. (cm):')
        set(txt5,'string','Major axis 2. (cm):')
        set(txt6,'string','Major axis 3. (cm):')
end

Clr(hand,eventdata,lst1)                        % See comments in function.


function [] = Simple(hand,eventdata,edt2,edt3,num,lst1)
%Callback for easier data entry with simpler geometry.
edt1 = findobj('position',[180 260 80 20]);          % Need to find string. 
vl = get(hand,'value');
str1 = get(edt1,'string');

switch num
    case 1                                                % Cube or Sphere.
         if vl                                                   % Checked.
            set(edt2,'enable','off','string',str1)
            set(edt3,'enable','off','string',str1)
         else                                                  % Unchecked.
            set(edt2,'enable','on')
            set(edt3,'enable','on')
         end
    case 2                                             % Circular cylinder.
        if vl                                                    % Checked.
            set(edt2,'enable','off','string',str1)
            set(edt3,'enable','on')
        else                                                   % Unchecked.
            set(edt3,'enable','on')
            set(edt2,'enable','on')
        end
end

Clr(hand,eventdata,lst1)                        % See comments in function.


function [] = Push(hand,eventdata,DIR,pop1,pop2,edt1,edt2,edt3,edt4,...
                   edt5,lst1,chk4,chk6,txt10)  %#ok
%Callback for pushbutton.  Calls calculator and sets other optioins.             
set([chk4,chk6,edt5,txt10],'enable','on') % Uicontrols that have a use now.
str = get(pop1,'string');  str2 = get(pop2,'string');
RUSdata.SolidName = str2(get(pop2,'value'),:);
matname = str(get(pop1,'value'));
RUSdata.Material = matname{1}(1:end-4);            % Get rid of the '.mat'.
choice = str(get(pop1,'value'),:);                       % Material Choice.
pth = DIR.path;           % Find the folder with the material files folder.
MatParmsy = load([pth '\' choice{1}]);       % This is the chosen material.
Ncalc = str2double(get(edt4,'string'));
if Ncalc<3,  Ncalc = 3; set(edt4,'string','3');  end% Minimum of 3 allowed.
RUSdata.dims(1) = str2double(get(edt1,'string')); % The objects dimensions.
RUSdata.dims(2) = str2double(get(edt2,'string'));
RUSdata.dims(3) = str2double(get(edt3,'string'));
RUSdata = CalcRUS(MatParmsy.MaterialParms,RUSdata,Ncalc);% Call calculator.
str3 = num2str((1:RUSdata.rank-6)');      % This next is to make list neat.
str4 = ':        ';
str4 = repmat(str4,RUSdata.rank-6,1);
str5 = [str3,str4,num2str(RUSdata.freqs(7:end),'%.6f')];
set(lst1,'string',str5)
set(get(hand,'parent'),'userdata',RUSdata)     % Store results in userdata.
delete(get(hand,'userdata'));                 % Make easy way to save data.
sv = uimenu('label','Save Data','callback',{@Saver,RUSdata});
set(hand,'userdata',sv)


function [] = Listcall(hand,eventdata)  %#ok
%Callback for the listbox that displays frequencies and does plotting.
chk4 = findobj('position',[375 390 100 15]);
edt5 = findobj('position',[160 100 50 20]);
chk6 = findobj('position',[65 70 140 20]);
modenumber = get(hand,'value');              % Find out which mode to plot.
amplitude = str2double(get(edt5,'string'));  % Amount of exaggeration used.
RUS = get(hand,'parent');
RUSdata = get(RUS,'userdata');
vlu = get(chk6,'value');            % Make a new figure or plot on old one.

switch vlu
    case 1                                % User wants a new figure window.
         figure('name',RUSdata.Material)
    case 0                                          % User wants to replot.
         if isempty(get(chk6,'userdata'))
            plt = figure('name',RUSdata.Material);
            set(chk6,'userdata',plt)
         else
            figure(get(chk6,'userdata'))
            clf
         end       
end

vl = get(chk4,'value')';                        % Needed for title of plot.
Plotter(RUSdata,modenumber+6,amplitude,vl)    % Call the plotting function.


function [] = Scale(hand,eventdata,lst1,txt7)  %#ok
% Callback to switch from kilo to mega hertz.
RUS = get(hand,'parent');
RUSdata = get(RUS,'userdata');
str1 = num2str((1:RUSdata.rank-6)');             % Make the list look neat.
str2 = ':        ';  str2 = repmat(str2,RUSdata.rank-6,1);

if get(hand,'value')                                      % User wants kHz.
   str3 = [str1,str2,num2str(RUSdata.freqs(7:end)*1000,'%.3f')];
   set(lst1,'string',str3);
   set(txt7,'string','Frequencies (kHz)')
else                                                      % User wants MHz.
   str3 = [str1,str2,num2str(RUSdata.freqs(7:end),'%.6f')]; 
   set(lst1,'string',str3);
   set(txt7,'string','Frequencies (MHz)')     
end


function [] = Simple2(hand,eventdata,chk1,chk2,chk3,edt2,edt3,lst1)
% Callback for the simplifying checkbox choice.
if get(chk1,'value') || get(chk3,'value')
   set([edt2,edt3],'string',get(hand,'string'))     % Set simplificatioins.
elseif get(chk2,'value')
    set(edt2,'string',get(hand,'string'))
end

Clr(hand,eventdata,lst1)                        % See comments in function.


function [] = Saver(hand,eventdata,RUSdata)  %#ok
% Allows one to save the data used in the calculation.
uisave('RUSdata','RUSdata')


function [] = Clr(hand,eventdata,lst1)  %#ok
set(lst1,'string',[])    % Clear the old frequency list to avoid confusion.
chk4 = findobj('position',[375 390 100 15]);
set(chk4,'value',0,'enable','off');                         % Reset to MHz.


function RUSdata = CalcRUS(MaterialParms,RUSdata,Ncalc)
rho = MaterialParms.MassDensity;          
Ciajb0 = CreateMatrix(MaterialParms.Cmatrix);

if strcmp({MaterialParms.ElasticSymmetry},'isotropic')
   [Basis,group] = CreateBasis(Ncalc);
else
   [Basis,group] = CreateBasis(Ncalc,MaterialParms);
end

ngrp(1:8) = cellfun('length',group);                      % Preallocations.                                       
[igrp{1:8}] = deal(zeros(1,max(ngrp))); 
FRQ = zeros(sum(ngrp),1);                                 
grps = FRQ;
[Vect{1:8}] = deal(zeros(max(ngrp)));                       
[LB{1:8}] = deal(zeros(1,max(ngrp))); 
[MB{1:8}] = deal(zeros(1,max(ngrp))); 
[NB{1:8}] = deal(zeros(1,max(ngrp)));
[IC{1:8}] = deal(zeros(1,max(ngrp)));
cols = zeros(1,Basis.Nmodes);

for jj=1:8                               % Use block matrices to find eigs.
    igrp{jj} = sum(ngrp(1:jj-1)) + (1:ngrp(jj));
    LB{jj} = Basis.LB(group{jj});  MB{jj} = Basis.MB(group{jj});
    NB{jj} = Basis.NB(group{jj});  IC{jj} = Basis.IC(group{jj});
    [Gs,Es] = CreateMatrices(RUSdata,Basis.IC(group{jj}),... 
			                 Basis.LB(group{jj}),Basis.MB(group{jj}),...
                             Basis.NB(group{jj}),Ciajb0);
    [FRQ(igrp{jj}),Vect{jj}] = CalcEigs(rho,Gs,Es);
	grps(igrp{jj}) = jj;
    cols(igrp{jj}) = 1:length(group{jj});
end

[FRQs,idx] = sort(FRQ); % Put the freqs together.
RUSdata.eigvct = cell(1,length(FRQs));
% Pick a freq from sorted list, look at corresponding index for idx.  grps
% tells you which group and cols tells you which column in that group.
for kk = 1:length(FRQs)
    RUSdata.eigvct{kk} = Vect{grps(idx(kk))}(:,cols(idx(kk)));
end

RUSdata.rank = Basis.Nmodes;                     % Build the output struct.
RUSdata.freqs = FRQs;  RUSdata.Basis = {LB MB NB IC};
RUSdata.grps = grps;  RUSdata.cols = cols;  RUSdata.idx = idx;


function [Basis,g] = CreateBasis(Ncalc,MatPars)
%CreateBasis(Ncalc,MatPars).  Creates the group basis for polynomials.	
Nmodes = 3*nchoosek(Ncalc+3,3);   % This is the number of modes calculated.
NNx = Ncalc;  NNy = NNx;  NNz = NNx;                    % Each direction...
% Next create the polynomial powers.
IG = 0;  IC0 = zeros(1,Nmodes/3);  LB0 = IC0;  MB0 = IC0;  NB0 = IC0;

for L=1:NNx+1
    for M=1:NNy+1
        for N=1:NNz+1
            if (L+M+N>Ncalc+3),break,end
                IG = IG+1;  IC0(IG) = 1;
                LB0(IG) = L-1;  MB0(IG) = M-1;  NB0(IG) = N-1;
         end
     end
end
    
LB = [LB0,LB0,LB0];   MB = [MB0,MB0,MB0];   NB = [NB0,NB0,NB0];
IC = [1*IC0,2*IC0,3*IC0];
g = Symmbasis(IC,LB,MB,NB);       % Identify the basis vects in each group.

if nargin==2                     % Only passed in when there is anisotropy.
    fprintf('\n\n %s \n','            Material is anisotropic.')
	C = MatPars(:).Cmatrix;
		if any([C(1:3,4)' C(5,6)])
			g = {union(g{[1 4]}) union(g{[2 3]}) union(g{[3 2]})...
                union(g{[4 1]}) union(g{[5 8]}) union(g{[6 7]})...
                union(g{[7 6]}) union(g{[8 5]})};
		end
		if any([C(1:3,5)' C(4,6)])
			g = {union(g{[1 6]}) union(g{[2 5]}) union(g{[3 8]})...
                union(g{[4 7]}) union(g{[5 2]}) union(g{[6 1]})...
                union(g{[7 4]}) union(g{[8 3]})};
		end
		if any([C(1:3,6)' C(4,5)])
			g = {union(g{[1 7]}) union(g{[2 8]}) union(g{[3 5]})...
                union(g{[4 6]}) union(g{[5 3]}) union(g{[6 4]})...
                union(g{[7 1]}) union(g{[8 2]})};
		end
		j = 1;
		for i=2:8
			new = 1;
			for k=1:j
				if g{k}(1)==g{i}(1),  new = 0;  break; end
			end
			if new,  j = j+1;  g{j} = g{i};  end
		end
		g = {g{1:j}};
end

Basis = struct('IC',IC,'LB',LB,'MB',MB,'NB',NB,'Nmodes',Nmodes);
               

function group = Symmbasis(IC,LB,MB,NB)
%Subfunction to CreateBasis.  Decides which group each mode is in.
npts = length(IC)/3;
gX = cell(1,8);

for jj=1:npts
	kk = Ksymm(LB(jj),MB(jj),NB(jj));	       % Belongs in group kk for X.
	gX{kk} = [gX{kk} jj];					             % Append to group.
end

group{1} = [gX{1} gX{7}+npts gX{6}+2*npts];
group{2} = [gX{2} gX{8}+npts gX{5}+2*npts];
group{3} = [gX{3} gX{5}+npts gX{8}+2*npts];
group{4} = [gX{4} gX{6}+npts gX{7}+2*npts];
group{5} = [gX{5} gX{3}+npts gX{2}+2*npts];
group{6} = [gX{6} gX{4}+npts gX{1}+2*npts];
group{7} = [gX{7} gX{1}+npts gX{4}+2*npts];
group{8} = [gX{8} gX{2}+npts gX{3}+2*npts];


function k = Ksymm(l,m,n)
%Subfunction to CreateBasis.  Determines symmetry groups. 
% k=1 {eee}, 2 {eeo}, 3 {eoe}, 4 {eoo}, 5 {oee}, 6 {oeo}, 7 {ooe}, 8 {ooo}
k = 1 + mod(n,2) + 2*mod(m,2) + 4*mod(l,2);


function [Gsym,Esym] = CreateMatrices(RUS,IC,LB,MB,NB,Ciajb)
%CreateEigenMatricesVectorized Creates the matrices used to solve the
% eigenvalue problems.
N = size(LB,2);                                       % Size of the matrix.
FLAG12 = Ciajb.Ci1j2 | Ciajb.Ci2j1;       % Used for sorting indeces below.
FLAG13 = Ciajb.Ci1j3 | Ciajb.Ci3j1;
FLAG23 = Ciajb.Ci2j3 | Ciajb.Ci3j2;
ag = find(tril(ones(N))) ;         % Indicies in the matrix lower triangle.
Nag = length(ag);
ig = 1+fix((ag-1)/N);  jg = 1+rem(ag-1,N);  ij = IC(ig)+3*(IC(jg)-1);
LS = (LB(ig)+LB(jg))';  MS = (MB(ig)+MB(jg))';  NS = (NB(ig)+NB(jg))';       
Gx = zeros(1,Nag);
flag =  all(~odd([LS,MS,NS])');    % All either NOT symmetric or NOT odd.
ind = find(flag&LB(ig)&LB(jg)&Ciajb.Ci1j1(ij));
% Now fill in the E and Gamma matrices by calculating the f integral.
F = CalcF(RUS.SolidName,RUS.dims,LS(ind)-2,MS(ind),NS(ind));
Gx(ind) = Gx(ind)+(Ciajb.Ci1j1(ij(ind)).*LB(ig(ind)).*LB(jg(ind))).*F;
ind = find(flag&MB(ig)&MB(jg)&Ciajb.Ci2j2(ij));
F = CalcF(RUS.SolidName,RUS.dims,LS(ind),MS(ind)-2,NS(ind));
Gx(ind) = Gx(ind)+(Ciajb.Ci2j2(ij(ind)).*MB(ig(ind)).*MB(jg(ind))).*F;
ind = find(flag&NB(ig)&NB(jg)&Ciajb.Ci3j3(ij));
F = CalcF(RUS.SolidName,RUS.dims,LS(ind),MS(ind),NS(ind)-2);
Gx(ind) = Gx(ind)+(Ciajb.Ci3j3(ij(ind)).*NB(ig(ind)).*NB(jg(ind))).*F;
flag =all(~odd([LS-1,MS-1,NS])');
ind = find(flag&FLAG12(ij)&((MB(ig)&LB(jg))|(MB(jg)&LB(ig))));
F = CalcF(RUS.SolidName,RUS.dims,LS(ind)-1,MS(ind)-1,NS(ind));
Gx(ind) = Gx(ind)+(Ciajb.Ci1j2(ij(ind)).*LB(ig(ind)).*MB(jg(ind))+...
          Ciajb.Ci2j1(ij(ind)).*MB(ig(ind)).*LB(jg(ind))).*F;
flag = all(~odd([LS-1,MS,NS-1])');
ind = find(flag&FLAG13(ij)&((NB(ig)&LB(jg))|(NB(jg)&LB(ig))));
F = CalcF(RUS.SolidName,RUS.dims,LS(ind)-1,MS(ind),NS(ind)-1);
Gx(ind) = Gx(ind)+(Ciajb.Ci1j3(ij(ind)).*LB(ig(ind)).*NB(jg(ind))+...
          Ciajb.Ci3j1(ij(ind)).*NB(ig(ind)).*LB(jg(ind))).*F;
flag = all(~odd([LS,MS-1,NS-1])');
ind = find(flag&FLAG23(ij)&((NB(ig)&MB(jg))|(NB(jg)&MB(ig))));
F = CalcF(RUS.SolidName,RUS.dims,LS(ind),MS(ind)-1,NS(ind)-1);
Gx(ind) = Gx(ind)+(Ciajb.Ci2j3(ij(ind)).*MB(ig(ind)).*NB(jg(ind))+...
          Ciajb.Ci3j2(ij(ind)).*NB(ig(ind)).*MB(jg(ind))).*F;
ind = find(IC(ig)==IC(jg)); 
LS = LS(ind);  MS = MS(ind);  NS = NS(ind);       % No need for all values.
clear ig jg ij flag F                                    % Free the memory.
irem = setdiff(find(triu(ones(N))),ag);  % Indeces for remainder of matrix.
Gsym(ag) = Gx;                              % Gx is upper triangle of Gsym.
Gsym = reshape(Gsym,N,N);                       % Reshape to square matrix.
Gx = Gsym';                         % Need transpose to fill in lower half.
Gsym(irem)=Gx(irem);                                     % Complete matrix.
clear Gx
Ex = zeros(1,Nag) ;              % The LS MS & NS indeces have been sorted.
Ex(ind) = CalcF(RUS.SolidName,RUS.dims,LS,MS,NS);
Esym(ag) = Ex;                                 % Follow as for the Gsym....
Esym = reshape(Esym,N,N); 
Ex = Esym';         
Esym(irem) = Ex(irem);


function value = odd(i)
% Just determines if the value is odd or not.
value = rem(i,2);
if isempty(value)
    value = [];    % Will not work just to return zero in some ML versions.
end


function [Ciajb] = CreateMatrix(Cnm)
%CreateMatrix(Cnm) Creates the elast. structure from the elast. matrix.
Ci1j1 = [Cnm(1,1),Cnm(1,6),Cnm(1,5);Cnm(6,1),Cnm(6,6),Cnm(6,5);Cnm(5,1),...
         Cnm(5,6),Cnm(5,5)];
Ci2j2 = [Cnm(6,6),Cnm(6,2),Cnm(6,4);Cnm(2,6),Cnm(2,2),Cnm(2,4);Cnm(4,6),...
         Cnm(4,2),Cnm(4,4)];
Ci3j3 = [Cnm(5,5),Cnm(5,4),Cnm(5,3);Cnm(4,5),Cnm(4,4),Cnm(4,3);Cnm(3,5),...
         Cnm(3,4),Cnm(3,3)];
Ci1j2 = [Cnm(1,6),Cnm(1,2),Cnm(1,4);Cnm(6,6),Cnm(6,2),Cnm(6,4);Cnm(5,6),...
         Cnm(5,2),Cnm(5,4)];
Ci1j3 = [Cnm(1,5),Cnm(1,4),Cnm(1,3);Cnm(6,5),Cnm(6,4),Cnm(6,3);Cnm(5,5),...
         Cnm(5,4),Cnm(5,3)];
Ci2j3 = [Cnm(6,5),Cnm(6,4),Cnm(6,3);Cnm(2,5),Cnm(2,4),Cnm(2,3);Cnm(4,5),...
         Cnm(4,4),Cnm(4,3)];
Ci2j1 = [Cnm(6,1),Cnm(6,6),Cnm(6,5);Cnm(2,1),Cnm(2,6),Cnm(2,5);Cnm(4,1),...
         Cnm(4,6),Cnm(4,5)];
Ci3j1 = [Cnm(5,1),Cnm(5,6),Cnm(5,5);Cnm(4,1),Cnm(4,6),Cnm(4,5);Cnm(3,1),...
         Cnm(3,6),Cnm(3,5)];
Ci3j2 = [Cnm(5,6),Cnm(5,2),Cnm(5,4);Cnm(4,6),Cnm(4,2),Cnm(4,4);Cnm(3,6),...
         Cnm(3,2),Cnm(3,4)];
Ciajb = struct('Ci1j1',Ci1j1,'Ci1j2',Ci1j2,'Ci1j3',Ci1j3,'Ci2j1',Ci2j1,...
               'Ci2j2',Ci2j2,'Ci2j3',Ci2j3,'Ci3j1',Ci3j1,'Ci3j2',Ci3j2,...
               'Ci3j3',Ci3j3);
          
           
function value = CalcF(SolidName,dims,p,q,r)
%CalculateFsolidVector(SolidName,dims,p,q,r)
% Calculates the values of the E and Gamma Matrices.
len_p = length(p);
ind = find(any([p q r]'<0)'|...   % Symmetric shape and odd polynomial = 0.
    any( ( ones(len_p,1)*[ 0 0 0 ] & odd([p q r]) )' )' ); 
ir = setxor(ind,1:len_p);  value(ind) = 0;	
	
if strfind(SolidName,'Rectangular Parallelepiped')
   value(ir) = 8*((dims(1)/2).^(p(ir)+1)).*((dims(2)/2).^...
               (q(ir)+1)).*((dims(3)/2).^(r(ir)+1))./((p(ir)+1).*...
               (q(ir)+1).*(r(ir)+1));
else
     imax = max(p+q+r);
     fact2 = zeros(imax + 5,1);
	 for i = 1:imax+5, fact2(i,1) = prod(i-2:-2:2); end  % fact2(i)=(i-2)!!
     if strfind(SolidName,'Cylind')==1
        value(ir) = (4*pi)*((dims(1)/2).^(p(ir)+1)).*...
                    ((dims(2)/2).^(q(ir)+1)).*...
                    ((dims(3)/2).^(r(ir)+1)).*fact2(p(ir)+1).*...
                    fact2(q(ir)+1)./...
                    ((r(ir)+1).*fact2(p(ir)+q(ir)+4));                   
	  elseif strfind(SolidName,'Ellipsoid')==1
             vx = (dims(1)/2).^(p(ir)+1);
	         vy = (dims(2)/2).^(q(ir)+1);
	         vz = (dims(3)/2).^(r(ir)+1); 
	         vxyz = vx.*vy.*vz;
			   value(ir) = vxyz.*fact2(p(ir)+1).*fact2(q(ir)+1).*...
                   fact2(r(ir)+1)./fact2(p(ir)+q(ir)+r(ir)+5);
     end
end    


function [FRQ,Vcts] = CalcEigs(rho,G,E)
%CalculateEigenvalues.m Calculate eigenvalues and eigenvectors
[Vcts,D] = eig(G,E);
FRQ = abs(sqrt(10/rho)/(2*pi)*sqrt(diag(D)));


function [] = Plotter(RUSdata,mdnm,amp,vl)
% The amp is basically a measure of how exagerated the surface
% displacements are to be drawn.  The mdnm is the mode number you are
% trying to plot.

if strmatch('Cylinder',RUSdata.SolidName)
   RUSwv = Plot_cyl(RUSdata,mdnm,amp);
elseif strmatch('Rectangular Parallelepiped',RUSdata.SolidName)
       RUSwv = Plot_rppd(RUSdata,mdnm,amp);   
elseif strmatch('Ellipsoid',RUSdata.SolidName)
       RUSwv = Plot_ellipse(RUSdata,mdnm,amp);
end
% Plotting...Surface also produces nice graphs.
mesh(real(RUSwv.surf{1}.X'),real(RUSwv.surf{1}.Y'),real(RUSwv.surf{1}.Z'),...
     real(RUSwv.surf{1}.A'),'facecolor',[.3 .40 .2]);
hold on

for i=2:length(RUSwv.surf)
mesh(real(RUSwv.surf{i}.X'),real(RUSwv.surf{i}.Y'),real(RUSwv.surf{i}.Z'),...
     real(RUSwv.surf{i}.A'),'facecolor',[.3 .40 .2]);                     
end

try 
    axis equal  % If user is trying to plot a 'thin plate', this may error.
catch
    fprintf(['\nDimensions are radically different, cannot set axis ',...
             'equal. Adjust exaggeration if plot looks wrong.\n'])
end

[xl yl zl] = deal(RUSdata.dims(1),RUSdata.dims(2),RUSdata.dims(3));
xlim(.75*[-xl xl]);  ylim(.75*[-yl yl]);  zlim(.75*[-zl zl]);  rotate3d on
if vl,  fct = 1000; str = ' kHz';  else  fct = 1;  str = ' MHz';  end 
title(['Resonant Mode at ', num2str(RUSdata.freqs(mdnm)*fct), str  ],...
    'fontweight','bold','fontsize',14)
xlabel('X');  ylabel('Y');  zlabel('Z'); colorbar


function RUSwv = Plot_rppd(RUSdata,mdnm,amp)
%Subfunction for Plotter.  Creates the vectors for the RPPD. 
[dx dy dz] = deal(RUSdata.dims(1),RUSdata.dims(2),RUSdata.dims(3)); 
Ns = 24;   % How many spaces per face.  For large N, plot time increases.
% Build the sides.
x = linspace(-dx/2,dx/2,Ns);  y = linspace(-dy/2,dy/2,Ns);  
z = linspace(-dz/2,dz/2,Ns);
[xr,yr] = meshgrid(x,y);
zr = ones(size(xr))*dz/2;
[xs,zs] = meshgrid(x,z);
ys = ones(size(xs))*dy/2;
[yt,zt] = meshgrid(y,z);
xt = ones(size(yt))*dx/2;
grpnm = RUSdata.grps(RUSdata.idx(mdnm));                % The mode's group.
[x1,y1,z1,ux1,uy1,uz1] = ...
                  CalcWvft(RUSdata,xr,yr,-zr,mdnm,amp,grpnm);
[x2,y2,z2,ux2,uy2,uz2] = ...
                  CalcWvft(RUSdata,xr,yr,zr,mdnm,amp,grpnm);
[x3,y3,z3,ux3,uy3,uz3] = ...
                  CalcWvft(RUSdata,xs,-ys,zs,mdnm,amp,grpnm);
[x4,y4,z4,ux4,uy4,uz4] = ...
                  CalcWvft(RUSdata,xs,ys,zs,mdnm,amp,grpnm);
[x5,y5,z5,ux5,uy5,uz5] = ...
                  CalcWvft(RUSdata,-xt,yt,zt,mdnm,amp,grpnm);
[x6,y6,z6,ux6,uy6,uz6] = ...
                   CalcWvft(RUSdata,xt,yt,zt,mdnm,amp,grpnm);               
A = {-uz1 uz2 -uy3 uy4 -ux5 ux6};
xy1.X = x1;  xy1.uX = ux1;  xy1.Y = y1;  xy1.uY = uy1;  xy1.Z = z1;  
xy1.uZ = uz1;  xy1.A = A{1};
xy2.X = x2;  xy2.uX = ux2;  xy2.Y = y2;  xy2.uY = uy2;  xy2.Z = z2;  
xy2.uZ = uz2;  xy2.A = A{2};
xz1.X = x3;  xz1.uX = ux3;  xz1.Y = y3;  xz1.uY = uy3;  xz1.Z = z3;  
xz1.uZ = uz3;  xz1.A = A{3};
xz2.X = x4;  xz2.uX = ux4;  xz2.Y = y4;  xz2.uY = uy4;  xz2.Z = z4;  
xz2.uZ = uz4;  xz2.A = A{4};
yz1.X = x5;  yz1.uX = ux5;  yz1.Y = y5;  yz1.uY = uy5;  yz1.Z = z5;  
yz1.uZ = uz5;  yz1.A = A{5};
yz2.X = x6;  yz2.uX = ux6;  yz2.Y = y6;  yz2.uY = uy6;  yz2.Z = z6;  
yz2.uZ = uz6;  yz2.A = A{6};
RUSwv.surf={xy1 xy2 xz1 xz2 yz1 yz2};


function RUSwv = Plot_cyl(RUSdata,mdnm,amp)
%Subfnction for Plotter.  Creates the vectors for the cylinder.
% First create the basic shape:
[dx dy dz] = deal(RUSdata.dims(1),RUSdata.dims(2),RUSdata.dims(3)); 
spc = 50;         % Must be even: Number of spaces up the side of cylinder.
if rem(spc,2),  spc = spc+1;  end
spc2 = 56;               % Must be even: spacing on edge of cap: roundness.
if rem(spc2,2),  spc2 = spc2+1;  end
spc3 = round((((spc2-4)/2)-1)/2+2);   % Allows grid on tops to match sides.                       
[Xc,Yc,Zc] = cylinder([1 1],spc2);
Xc = repmat(Xc,spc/2,1)*dx/2;  Yc = repmat(Yc,spc/2,1)*dy/2;
Zc = repmat(linspace(-dz/2,dz/2,spc)',1,length(Zc));
% I tried to pack Xt1 and Xt2 together in one matrix, but the plot had
% anomolies.  This works just as well...
Xt = triu(repmat(Xc(1,1:spc3),spc3,1))+...             % Now make the tops.
     tril(repmat(Xc(1,1:spc3),spc3,1)',-1);
Xt1 = [Xt -fliplr(Xt)];   
Xt2 = flipud([Xt -fliplr(Xt)]);  
Yt1 = repmat(Yc(1,1:spc3)',1,2*spc3);  
Yt2 = flipud(-repmat(Yc(1,1:spc3)',1,2*spc3));  
Zt = ones(size(Xt1))*dz/2;
% Now create suface displacements.  One pass for each surface.
grpnm = RUSdata.grps(RUSdata.idx(mdnm));                % The mode's group.
[Xc,Yc,Zc,uXc,uYc] = CalcWvft(RUSdata,Xc,Yc,Zc,mdnm,amp,grpnm);                 
[Xzp1,Yzp1,Zp1,uXzp1,uYzp1,uZp1] = ...
                               CalcWvft(RUSdata,Xt1,Yt1,Zt,mdnm,amp,grpnm);
[Xzp2,Yzp2,Zp2,uXzp2,uYzp2,uZp2]=...
                               CalcWvft(RUSdata,Xt2,Yt2,Zt,mdnm,amp,grpnm);
[Xzm1,Yzm1,Zm1,uXzm1,uYzm1,uZm1]=...
                              CalcWvft(RUSdata,Xt1,Yt1,-Zt,mdnm,amp,grpnm);
[Xzm2,Yzm2,Zm2,uXzm2,uYzm2,uZm2]=...
                              CalcWvft(RUSdata,Xt2,Yt2,-Zt,mdnm,amp,grpnm);
% Cylinder: tan = (dx,dy), normal = (-dy,dx), unit norm = -uX.dy+uY.dx.     
dXc0 = Yc*(dx/2)^2;	 dYc0 = -Xc*(dx/2)^2; 
A= {-uZm1 -uZm2 (-uXc.*dYc0+uYc.*dXc0)./sqrt(dXc0.^2+dYc0.^2) uZp1 uZp2};	       
Sm1 = struct('X',Xzm1,'Y',Yzm1,'Z',Zm1,'A',A{1});
Sm2 = struct('X',Xzm2,'Y',Yzm2,'Z',Zm2,'A',A{2});
Sc = struct('X',Xc,'Y',Yc,'Z',Zc,'A',A{3});
Sp1 = struct('X',Xzp1,'Y',Yzp1,'Z',Zp1,'A',A{4});
Sp2 = struct('X',Xzp2,'Y',Yzp2,'Z',Zp2,'A',A{5});
RUSwv.surf = {Sm1 Sm2 Sc Sp1 Sp2};


function RUSwv = Plot_ellipse(RUSdata,mdnm,amp)
%Subfunction for Plotter.  Creates the vectors for the ellipsoid.
[a b c] = deal(RUSdata.dims(1),RUSdata.dims(2),RUSdata.dims(3)); 
grpnm = RUSdata.grps(RUSdata.idx(mdnm));                % The mode's group.
spc2 = 68;                     % Must be even: spacing on edge; roundness.
if rem(spc2,2),  spc2 = spc2+1;  end
spc3 = round((((spc2-4)/2)-1)/2+2);   % Allows grid on caps to match sides.                       
[Xc,Yc] = cylinder([1,1],spc2);
Xt = triu(repmat(Xc(1,1:spc3),spc3,1))+...             
     tril(repmat(Xc(1,1:spc3),spc3,1)',-1);
Xt1 = [Xt -fliplr(Xt)]*a/2;  Xt1(:,spc3+1) = [];   
Xt2 = flipud([Xt -fliplr(Xt)])*a/2;  Xt2(:,spc3+1) = []; 
Yt1 = repmat(Yc(1,1:spc3)',1,2*spc3)*b/2;  Yt1(:,spc3+1) = [];      
Yt2 = flipud(-repmat(Yc(1,1:spc3)',1,2*spc3))*b/2;  Yt2(:,spc3+1) = [];  
Zt = sqrt(1.^2-(2*Xt1/a).^2-(2*Yt1/b).^2)*c/2;
[Xs1,Ys1,Zs1,uXs1,uYs1,uZs1] = CalcWvft(RUSdata,Xt1,Yt1,Zt,mdnm,amp,grpnm);
[Xs2,Ys2,Zs2,uXs2,uYs2,uZs2] = CalcWvft(RUSdata,Xt2,Yt2,flipud(Zt),mdnm,...
                                        amp,grpnm);
[Xs3,Ys3,Zs3,uXs3,uYs3,uZs3] = CalcWvft(RUSdata,Xt1,Yt1,-Zt,mdnm,amp,grpnm);
[Xs4,Ys4,Zs4,uXs4,uYs4,uZs4] = CalcWvft(RUSdata,Xt2,Yt2,-flipud(Zt),...
                                        mdnm,amp,grpnm);
% normal at (x,y,z) is (x/rx^2, y/ry^2, z/rz^2) normalized
sX = 1/(a/2)^2;  sY=1/(b/2)^2;  sZ=1/(c/2)^2;
A = {(uXs1.*Xt1*sX + uYs1.*Yt1*sY + uZs1.*Zt*sZ)./...
     sqrt((Xt1*sX).^2+(Yt1*sY).^2+(Zt*sZ).^2) ...
     (uXs2.*Xt2*sX + uYs2.*Yt2*sY + uZs2.*flipud(Zt)*sZ)./...
     sqrt((Xt2*sX).^2+(Yt2*sY).^2+(flipud(Zt)*sZ).^2) ...
     (uXs3.*Xt1*sX + uYs3.*Yt1*sY + uZs3.*-Zt*sZ)./...
     sqrt((Xt1*sX).^2+(Yt1*sY).^2+(Zt*sZ).^2) ...
     (uXs4.*Xt2*sX + uYs4.*Yt2*sY + uZs4.*-flipud(Zt)*sZ)./...
     sqrt((Xt2*sX).^2+(Yt2*sY).^2+(flipud(Zt)*sZ).^2) };
S1 = struct('X',Xs1,'Y',Ys1,'Z',Zs1,'uX',uXs1,'uY',uYs1,'uZ',uZs1,'A',A{1});
S2 = struct('X',Xs2,'Y',Ys2,'Z',Zs2,'uX',uXs2,'uY',uYs2,'uZ',uZs2,'A',A{2});
S3 = struct('X',Xs3,'Y',Ys3,'Z',Zs3,'uX',uXs3,'uY',uYs3,'uZ',uZs3,'A',A{3});
S4 = struct('X',Xs4,'Y',Ys4,'Z',Zs4,'uX',uXs4,'uY',uYs4,'uZ',uZs4,'A',A{4});
RUSwv.surf = {S1 S2 S3 S4};

    
function [X,Y,Z,uX,uY,uZ] = CalcWvft(RUSdata,Xab,Yab,Zab,mdnm,amp,grpnm)                                 
% This subfunction creates the surface displacement vectors.
[LB MB NB IC] = deal(RUSdata.Basis{:});
V = RUSdata.eigvct{mdnm};
uX = zeros(size(Xab));  uY = zeros(size(Yab));  uZ = zeros(size(Zab));

for jj=1:length(LB{grpnm})
    us = V(jj)*Xab.^LB{grpnm}(jj).*Yab.^MB{grpnm}(jj).*Zab.^NB{grpnm}(jj);
    if IC{grpnm}(jj)==1
       uX = uX+us;
    elseif IC{grpnm}(jj)==2
           uY = uY+us;
    elseif IC{grpnm}(jj)==3
           uZ = uZ+us;
    end
end

uX = real(uX)*amp;  uY = real(uY)*amp;  uZ = real(uZ)*amp;      
X = Xab+uX;  Y = Yab+uY;  Z = Zab+uZ;
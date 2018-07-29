% this is the site configuration screen wich shows you an approximate location of the site

function project()
fig=figure('name','Cellular Project','menubar','none','numbertitle','off',...
	'units','normalized','position',[0.01 0.01 0.95 0.95],'color',[1 1 1]);
movegui(gcf,'north')
x=axes('units','normalized','position',[.25 .25 .6 .6]);
t=uicontrol('style','pushbutton','units','normalized','position',[0.01 .5 .2 .1],'string','Press','callback',@push);
e=uicontrol('style','edit','units','normalized','position',[0.01 .3 .2 .1]);
p1=uicontrol('style','pushbutton','units','normalized','position',[0.01 .6 .2 .1],'string','control Pannel','callback',@control);
p2=uicontrol('style','pushbutton','units','normalized','position',[0.01 .8 .2 .1],'string','Pr table','callback',@Pr);

t1=uicontrol('style','text','units','normalized','position',[0.01 .4 .2 .1],'string','Enter number of base stations');
s=imread('ju.jpg');
imshow(s);
hold on
sam=load('model.mat','nce')
sam=sam.nce;
set(e,'string',num2str(sam))
for ii=0:19;
	ssa=54.10*ii;
	plot([ssa ssa],[0 703]) ;
end
for jj=0:6;
	ssb=100.428*jj;
	plot([0 1028],[ssb ssb]);
end
	function control(varargin)
		figure('name','Control','menubar','none','numbertitle','off','units','normalized','color','w','position',[0 0 0.3 0.3]);
		ee=uicontrol('style','edit','units','normalized','position',[0.01 .9 .15 .1]);
		ee1=uicontrol('style','edit','units','normalized','position',[0.01 .75 .15 .1]);
		ee2=uicontrol('style','edit','units','normalized','position',[0.01 .6 .15 .1]);
		ee3=uicontrol('style','edit','units','normalized','position',[0.01 .45 .15 .1]);
		pp1=uicontrol('style','pushbutton','units','normalized','position',[0.3 .7 .15 .1],'callback',@p);
		text=uicontrol('style','text','units','normalized','position',[0.165 .4 .12 .6]);
		str1=sprintf(['Pt\n \n \n',...
			'Gt\n \n',...
			'Gr \n \n',...
			'L']);
		set(text,'string',str1);
		movegui(gcf,'center');
		function p(varargin)
			Pt=str2num(get(ee,'string'));
			Gt=str2num(get(ee1,'string'));
			Gr=str2num(get(ee2,'string'));
			L=str2num(get(ee3,'string'));
			

			save('var.mat','Pt','Gt','Gr');
			close(gcf)



		end
	end
	function push(varargin)

		load('var.mat','Pt','Gt','Gr');


		vv=[1 2];
		as=get(e,'string');
		as=str2num(as);
		jj=0;
		ssb=0;
		for ii=0:19
			ssa=54.10*ii;
			vv=[vv;ssa ssb];
			for jj=0:6
				ssb=100.428*jj;
				vv(end+1,:)=[ssa ssb];
				if jj==6
					ssb=0;
				end
			end
		end
		vv(1,:)=[];
		areat=(1028*703)/as;
		yy1=((703/2)/2);
		imshow(s);
		hold on
		yy2=yy1+(703/2);
		ba=where(round(as/2));
		
		for jahs=1:(as/2)

			r=sqrt(areat/(pi));
			circle([ba yy1],r,10000,'*');
			hold on
			circle([ba yy2],r,10000,'*');
			hold on
			ba=ba+2*r;
			if ba>1028
				break
			end
			axis equal
		end
		axis equal

		vv;
		height=[3260;3260;3255;3249;3246;3246;3249;3249;3251;3251;3251;3250;3251;3255;3262;3262;3266;3266;3271;3274;3275;3277;3260;3260;3262;3255;3249;3246;3246;3302;3302;3280;3265;3254;3251;3250;3248;3245;3245;3246;3254;3260;3264;3270;3272;3329;3329;3336;3334;3324;3310;3291;3286;3286;3279;3273;3271;3268;3263;3263;3261;3261;3263;3269;3273;3278;3281;3289;3319;3319;3319;3315;3308;3302;3296;3295;3295;3289;3291;3293;3290;3286;3281;3278;3278;3273;3271;3271;3276;3281;3289;3298;3298;3301;3299;3301;3298;3304;3304;3307;3307;3303;3293;3287;3279;3276;3276;3274;3274;3276;3277;3285;3292;3283;3283;3297;3306;3314;3323;3326;3330;3330;3322;3314;3308;3297;3288;3283;3277;3277;3274;3274;3275;3278;3286;3293;3280;3280;3290;3298;3310;3320;3328;3331;3331;3338;3334;3320;3309;3300;3290;3283;3283;3272;3276;3276;3283;3294;3294;3294];
		length(height);
		length(vv);
		bb=cat(2,vv,height);
		ssss=round(bb);
		pr1=[];
		for iji=1:160;
			Pr=Pt+Gr+Gt-30*log(ssss(iji,3));
			pr1(end+1)=[Pr];
		end
		save('pr.mat','pr1');
	end
	function Pr(varargin)
		pppr=load('pr.mat','pr1');
		pppr=pppr.pr1;
		figure('name','Pr','numbertitle','off','menubar','none','units','normalized','position',[0.01 0.01 0.9 .9]);
		tex=uicontrol('style','text','units','normalized','position',[0.01 0.01 0.9 .9],'fontname','comicsansms','fontsize',15);
		set(tex,'string',num2str(pppr));

	end


end
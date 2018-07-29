%RCSSM		read CSSM statistics from google group
%		RCSSM extracts CSSM's posting activity
%		since its inauguration on jan 8, 1993
%		from google's group site and
%		- returns the data in a table
%		- plots an activity surface [abs/gradient]
%
%		CSSM = MATLAB's newsgroup: comp.soft-sys.matlab
%
%SYNTAX
%		T = RCSSM;
%
%OUTPUT
% T		output table with fields
%		.y	years: 1993 - current
%		.m	month: 1:12
%		.d	activity table
%			rows = year	[1=1993]
%			cols = month	[1= jan]
%
%EXAMPLE
%		tbl=rcssm;

% created:
%	us	10-Jan-2007 us@neurol.unizh.ch
% modified:
%	us	20-Feb-2008 13:14:18

function	t=rcssm

% currently valid google web address and rex templates
% - 20feb08	us

		url='http://groups.google.com/group/comp.soft-sys.matlab/about';
		rex='(?<=month/)\d+-\d+">\d+';
		fmt='%d-%d">%d';

		t=get_html(url,rex);
		t=get_tbl(t,fmt);
	if	~isempty(t)
		t=plt_tbl(t);
	end
end
%-------------------------------------------------------------------------------
function	t=get_html(url,rex)

		import com.mathworks.mde.desk.*;
		wb=com.mathworks.mde.webbrowser.WebBrowser.createBrowser;
		wb.setCurrentLocation(url(8:end));
		pause(1);

		t={};
	while	isempty(t)
		s=char(wb.getHtmlText);
		t=regexp(s,rex,'match').';
% make sure we can bail-out with CTR-C
		pause(.1);
	end
		desk=MLDesktop.getInstance;
		desk.removeClient(wb);
end
%-------------------------------------------------------------------------------
function	tbl=get_tbl(t,fmt)

		[t,n]=cellfun(@(x) sscanf(char(x),fmt),t,'uni',false);
	if	~all([n{:}]==3)
		disp(sprintf('RCSSM> error reading table'));
		tbl=[];
		return;
	end
		t=cat(2,t{:});
		iy=t(1,:)-t(1,1)+1;
		im=t(2,:);

		tbl.y=unique(t(1,:));
		tbl.iy=unique(iy);
		tbl.m=1:12;
		tbl.d=accumarray([iy.',im.'],t(3,:),[],[],nan);
end
%-------------------------------------------------------------------------------
function	tbl=plt_tbl(tbl)

		m={
			'jan',	'feb',	'mar',...
			'apr',	'may',	'jun',...
			'jul',	'aug',	'sep',...
			'oct',	'nov',	'dec'
		};

% surfaces
		surf(tbl.d.');
		colormap(jet(256));
		shading interp;
		hold on;
		surf(gradient(tbl.d).');
		shading interp;

		mh=mesh(tbl.d.'+10);
		set(mh,...
			'facecolor','none',...
			'edgecolor',[0,0,0]);

		brighten(.6);
		view(22,25);

% labels
		y=tbl.y;
		iy=1:2:max(tbl.iy);
	if	iy(end) ~= max(tbl.iy)
		iy=[iy,max(tbl.iy)];
		y=[y(1:2:end),y(end)];
	else
		y=y(1:2:end);
	end
		y=strread(sprintf('%2.2d\n',rem(y-1900,100)),'%s');

		set(gca,...
			'xlim',[1,iy(end)],...
			'xtick',iy,...
			'xticklabel',y,...
			'ylim',[1,12],...
			'ytick',1:12,...
			'yticklabel',m,...
			'fontsize',10,...
			'fontname','arial');

		lh(1)=xlabel('year');
		lh(2)=ylabel('month');
		lh(3)=zlabel('entries   [absolute / gradient]');
		set(lh,...
			'fontweight','bold',...
			'fontsize',12,...
			'fontname','arial');

		title('CSSM activity',...
			'fontweight','bold',...
			'fontsize',16,...
			'fontname','arial');

		shg;
		rotate3d on;
end
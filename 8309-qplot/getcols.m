function getcols (col)
global A leg opt

if size(A) == 0 	helpdlg('No data. You must read a file first','Error'); return, end

switch col
	case 'x'
		[opt.xc,value] = listdlg('PromptString','Choose X column','SelectionMode','single','ListString',leg);
	case 'y'
		[opt.yc,value] = listdlg('PromptString','Choose Y column','SelectionMode','multiple','ListString',leg);
	case 'z'
		[opt.zc,value] = listdlg('PromptString','Choose Z column','SelectionMode','multiple','ListString',leg);
	case 'e'
		[opt.ec,value] = listdlg('PromptString','Choose Errors column','SelectionMode','multiple','ListString',leg);
end

return

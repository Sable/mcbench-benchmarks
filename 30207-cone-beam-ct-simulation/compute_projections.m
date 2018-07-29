function compute_projections(xs,ys,zs,data3d,mode,output_folder)
%
%	compute_projections(xs,ys,zs,data3d,mode,output_folder)
%
%   Deshan Yang, PhD
%	Department of radiation oncology
%	Washington University in Saint Louis
%   01/16/2011, Saint Louis, MO, USA

if ~exist(output_folder,'dir')
	mkdir(output_folder);
end

% Detector setting, according to Varian Trilogy OBI
su = 300;	% in mm
sv = 400;	% in mm

% nu = 768;		%The real detector panel pixel density
% nv = 1024;
nu = 384;		%Under-sample by 2
nv = 512;

% X-ray source and detector setting
SDD = 500;	% Detector to axis distance = 50 cm
SAD = 1000;	%  X-ray source to axis distance = 100 cm


switch mode
	case 1	% Single circle CBCT
		% Projection setting
		Nprj = 360;		% 360 projections
% 		Nprj = 180;		% 180 projections
		start_angle = 0;
		delta_deg = 360/Nprj;
		
		
		for n = 1:Nprj
			angle = start_angle + (n-1)*delta_deg;
			angle_rad = angle/360*2*pi;
			psrc = [cos(angle_rad)*SAD sin(angle_rad)*SAD 0];
			pcdet = [cos(angle_rad+pi)*SDD sin(angle_rad+pi)*SDD 0];
			fprintf('Computing project %d (total = %d), angle = %.1f\n',n,Nprj,angle);
			proj2d = compute_one_projection(xs,ys,zs,data3d,psrc,pcdet,su,sv,nu,nv);
			filename = [output_folder filesep sprintf('proj_%d_%d.mat',n,angle)];
			save(filename,'proj2d','angle','angle_rad','su','sv','nu','nv','SDD','SAD','delta_deg','start_angle','psrc','pcdet');
		end
	case 2	% Double circle
		% Projection setting
		Nprj = 360;		% 360 projections
		start_angle = 0;
		delta_deg = 360/Nprj;
		lng_offset = 80;	% offset by 80 mm
		
		
		for n = 1:Nprj
			angle = start_angle + (n-1)*delta_deg;
			angle_rad = angle/360*2*pi;
			psrc = [cos(angle_rad)*SAD sin(angle_rad)*SAD lng_offset];	% Offset in positive
			pcdet = [cos(angle_rad+pi)*SDD sin(angle_rad+pi)*SDD lng_offset];
			fprintf('Computing project %d (total = %d), angle = %.1f\n',n,Nprj*2,angle);
			proj2d = compute_one_projection(xs,ys,zs,data3d,psrc,pcdet,su,sv,nu,nv);
			filename = [output_folder filesep sprintf('proj_%d_%d.mat',n,angle)];
			save(filename,'proj2d','angle','angle_rad','su','sv','nu','nv','SDD','SAD','delta_deg','start_angle','psrc','pcdet');
		end

		for n = 1:Nprj
			angle = start_angle - (n-1)*delta_deg;
			angle_rad = angle/360*2*pi;
			psrc = [cos(angle_rad)*SAD sin(angle_rad)*SAD -lng_offset];	% Offset in negative
			pcdet = [cos(angle_rad+pi)*SDD sin(angle_rad+pi)*SDD -lng_offset];
			fprintf('Computing project %d (total = %d), angle = %.1f\n',n+Nprj,Nprj*2,angle);
			proj2d = compute_one_projection(xs,ys,zs,data3d,psrc,pcdet,su,sv,nu,nv);
			filename = [output_folder filesep sprintf('proj_%d_%d.mat',n,angle)];
			save(filename,'proj2d','angle','angle_rad','su','sv','nu','nv','SDD','SAD','delta_deg','start_angle','psrc','pcdet');
		end

	case 3	% Single helical
		% Projection setting
		Nprj = 360;		% 360 projections
		start_angle = 0;
		delta_deg = 360/Nprj;
		pitch = 0.5;
		table_move_360 = su*pitch/(SAD+SDD)*SAD;	% offset by 100 mm
		lng_offset = table_move_360/2;
		
		for n = 1:Nprj
			angle = start_angle + (n-1)*delta_deg;
			angle_rad = angle/360*2*pi;
			offset = -lng_offset+table_move_360/Nprj*(n-1);
			psrc = [cos(angle_rad)*SAD sin(angle_rad)*SAD offset];	% Offset in positive
			pcdet = [cos(angle_rad+pi)*SDD sin(angle_rad+pi)*SDD offset];
			fprintf('Computing project %d (total = %d), angle = %.1f\n',n,Nprj,angle);
			proj2d = compute_one_projection(xs,ys,zs,data3d,psrc,pcdet,su,sv,nu,nv);
			filename = [output_folder filesep sprintf('proj_%d_%d.mat',n,angle)];
			save(filename,'proj2d','angle','angle_rad','su','sv','nu','nv','SDD','SAD','delta_deg','start_angle','psrc','pcdet');
		end
		
	case 4	% Double helical
		% Projection setting
		Nprj = 720;		% 360 projections
		start_angle = 0;
		delta_deg = 720/Nprj;
		pitch = 0.5;
		table_move_720 = su*pitch*2/(SAD+SDD)*SAD;	% offset by 100 mm
		lng_offset = table_move_720/2;
		
		for n = 1:Nprj
			angle = start_angle + (n-1)*delta_deg;
			angle_rad = angle/360*2*pi;
			offset = -lng_offset+table_move_720/Nprj*(n-1);
			psrc = [cos(angle_rad)*SAD sin(angle_rad)*SAD offset];	% Offset in positive
			pcdet = [cos(angle_rad+pi)*SDD sin(angle_rad+pi)*SDD offset];
			fprintf('Computing project %d (total = %d), angle = %.1f\n',n,Nprj,angle);
			proj2d = compute_one_projection(xs,ys,zs,data3d,psrc,pcdet,su,sv,nu,nv);
			filename = [output_folder filesep sprintf('proj_%d_%d.mat',n,angle)];
			save(filename,'proj2d','angle','angle_rad','su','sv','nu','nv','SDD','SAD','delta_deg','start_angle','psrc','pcdet');
		end
end

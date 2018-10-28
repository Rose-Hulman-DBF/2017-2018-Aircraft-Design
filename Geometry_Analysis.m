function [Report_Geometry_Table] = Geometry_Analysis(N_missiles,S)  

load Geometric_Design.mat AR taper Lambda_LE S_h__S S_v__S D_fuse L_fuse loc_max_t


S_h = S*S_h__S;
S_v = S*S_v__S;

b = sqrt(S*AR);

c_r = 2*S/b/(1+taper);
c_t = c_r*taper;

Lambda_TE = 180/pi*atan(tan(Lambda_LE*pi/180)+2*(c_t-c_r)/b);

S_wet_fuse__S = (pi*D_fuse*L_fuse)/S;
S_wet_missiles__S = 0.53083333*N_missiles/S; %ft (assume ellipsoid of 10x1.5x1.5 in)
S_wet__S = 2 + S_wet_fuse__S + 2*S_h/S + 2*S_v/S;
S_wet__S_no_missile = 2 + S_wet_fuse__S + 2*S_h/S + 2*S_v/S;


lambda_t_max = 180/pi*atan((-b/2*tan(Lambda_LE*pi/180)-loc_max_t*c_t-(-loc_max_t*c_r))/(-b/2));

save('Geometry.mat','S_h','S_v','b','c_r','c_t','Lambda_TE','S_wet__S',...
    'lambda_t_max','S_wet_fuse__S','L_fuse','S_wet_missiles__S','S_wet__S_no_missile')

Names = {'S';'AR';'Lambda_LE';'taper';'loc_max_t';'b';'Lambda_TE';'c_t';'c_r';'S_wet__S'...
    ;'L_fuse';'D_fuse';'S_v__S';'S_h__S'};

Values = [S;AR;Lambda_LE;taper;loc_max_t;b;Lambda_TE;c_t;c_r;S_wet__S...
    ;L_fuse;D_fuse;S_v__S;S_h__S];

Report_Geometry_Table = table(Values,'RowNames',Names);

end
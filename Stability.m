function [Report_Stability_Table,Report_Trim_Table] = Stability(S)

load Geometry.mat S_h L_fuse c_r b c_t
load Aerodynamics.mat a a_t
load Stability.mat AR AR_t taper_t Lambda_LE_t SM z_h l_h Lambda_LE taper

c_avg = (c_r+c_t)/2;

%tail sizing
b_t = sqrt(S_h*AR_t);
c_r_t = 2*S_h/b_t/(1+taper_t);

%Analysis
MAC = (2/3)*c_r*(1+taper+taper^2)/(1+taper);
x_ac = (b*(1+2*taper))/(6*(1+taper))*tan(Lambda_LE*pi/180)+.25*MAC;

MAC_t = (2/3)*c_r_t*(1+taper_t+taper_t^2)/(1+taper_t);
x_ac_t = (b_t*(1+2*taper_t))/(6*(1+taper_t))*tan(Lambda_LE_t*pi/180)+.25*MAC_t;

de__da = 21*a/(AR^.5)*(c_avg/l_h)^.25*(10-3*taper)/7*(1-z_h/b);

A = a_t/a*(1-de__da)*S_h/S;
x_n = A/(1+A)*l_h+x_ac;

x_cg = x_n - SM*MAC;

Param = [de__da;S_h/S;L_fuse;l_h;A;x_n;x_cg];
Param_w = [Lambda_LE;taper;a;b;c_r;MAC;x_ac;0;Param];
Param_t = [Lambda_LE_t;taper_t;a_t;b_t;c_r_t;MAC_t;x_ac_t;0;0;0;0;0;0;0;0];

Report_Stability_Table = table(Param_w,Param_t);
Report_Stability_Table.Properties.RowNames = {'Lambda_LE' 'taper' 'a'...
    'b' 'c_r' 'MAC' 'x_ac' '0' 'de__de' 'S_h__S' 'L_fuse' 'l_h' 'A' 'x_n' 'x_cg'};
Report_Stability_Table.Properties.VariableNames = {'Wing' 'Tail'};

alpha = [2;4;6;8];
i_t = alpha*(1-de__da)*(1-(x_cg-x_ac)/(A*(l_h-(x_cg-x_ac))));

Report_Trim_Table = table(alpha,i_t);


end


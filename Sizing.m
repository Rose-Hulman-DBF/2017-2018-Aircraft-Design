function [Report_Weight_Table] = Sizing(W__S_design,P__W_design,W_batt__W_TO,N_missiles)

%Weights
W_missile   = 3/16;    %Missile weight (lbf)
W_servo     = .4/16;   %Servo weight (lbf
N_servos    = 6;       %Number of servos

[~] = Geometry_Analysis(N_missiles);
    Aerodynamic_Analysis
    
load Aerodynamics.mat S_wet__S S_h S_v S

%Sizing
W_missiles = N_missiles*W_missile;

W_batt__S = W_batt__W_TO*W__S_design; %lbs (battery density and missions)
W_wing__S = (7.7/16)/(2.333); %lbs/ft^2 (old wing weight over area)
W_struct__S = 0.15*S_wet__S + .2*(S_h+S_v); %lbs (from aero design)
W_eng__S = (P__W_design*W__S_design + 23.38/S) / 1337.1; % Only valid for lbs, ft-lbs/s, 150<P<1300, 0.1<W_eng<1
W_sys__S = N_servos*W_servo/S + .057*W__S_design + .05*W__S_design; %lbs (from aero design)

S_computed = W_missiles/(W__S_design - W_batt__S - W_struct__S - W_wing__S - W_eng__S - W_sys__S)

W__S_computed = W_batt__S+W_wing__S+W_struct__S+W_eng__S+W_sys__S+W_missiles/S;

%Table
Names = {'battery';'Wing';'Structure';'Engine';'Systems';'Missiles';...
    'Total, computed';'Total, guess';'0';'S, computed';'S, guess';};

Value = [W_batt__S*S;W_wing__S*S;W_struct__S*S;W_eng__S*S;W_sys__S*S;W_missiles;...
    W__S_computed*S;W__S_design*S;0;S_computed;S];

Percent = Value/S/W__S_design*100;
Percent(9:length(Value)) = 0;

Report_Weight_Table = table(Value,Percent,'RowNames',Names);

end
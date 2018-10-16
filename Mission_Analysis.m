function [W_batt__W_TO] = Mission_Analysis(rho,g,eta_prop,c_batt,...
    P__W_design,W__S_design,N_missiles)

%Factors of Safety
FOS_takeoff_s = 1.2;
FOS_cruise_s  = 1.2;

%Mission parameters
takeoff_s  = 10;          %takeoff distance (ft)
lap_s      = 2000;        %lap distance (ft)
N_laps     = N_missiles;  %Number of missils
mu_TO      = 0.02;        %Takeoff rolling resistance

load Aerodynamics.mat C_L_maxTO C_D_0

%Missions

%Takeoff
S_TO = takeoff_s*FOS_takeoff_s;
W_batt__W_Takeoff=1/eta_prop*1/c_batt*(1.2^2*W__S_design/(rho*g*C_L_maxTO)+1.2^2*C_D_0*S_TO/(2*C_L_maxTO)+mu_TO*S_TO);

%Cruise
for i = 1:N_laps
    
    [~] = Geometry_Analysis(N_missiles-(i-1)); %lose a missile each go around
    Aerodynamic_Analysis
    load Aerodynamics.mat C_L_star C_D_star
    
    R_cruise = lap_s*FOS_cruise_s;
%     C_L = C_L_star;
%     C_D = C_D_star;
%     v_cruise = sqrt(W__S_design/(.5*rho*C_L))*.5925;
    v = 10; %PLACEHOLDER NEED REAL VMAX FROM CONSTRAINT
    C_L = 2*W__S_design/rho/(v^2);
    C_D = 2*P__W_design*W__S_design/rho/(v^3);
    W_batt__W_Cruise_vec(i) = 1/eta_prop*1/c_batt*1/(C_L/C_D)*R_cruise;
end

W_batt__W_Cruise = sum(W_batt__W_Cruise_vec);

%Summation of Weights
W_batt__W_TO = W_batt__W_Cruise + W_batt__W_Takeoff;

end
function [Report_Mission_Table,W_batt__W_TO] = Mission_Analysis(W__S_design,P__W_design,...
    N_missiles,N_laps,S)

%Factors of Safety
FOS_takeoff_s = 1;
FOS_cruise_s  = 1;

%Mission parameters
takeoff_s  = 10;          %takeoff distance (ft)
lap_s      = 2000;        %lap distance (ft)
mu_TO      = 0.02;        %Takeoff rolling resistance

load Aerodynamics.mat C_L_maxTO C_D_0 k_1 k_2 C_L_max
load CA_MA.mat rho g eta_prop c_batt
load CA_MA.mat W_missile n_max_struct

%Missions

%Takeoff
S_TO = takeoff_s*FOS_takeoff_s;
W_batt__W_Takeoff=1/eta_prop*1/c_batt*(1.2^2*W__S_design/(rho*g*C_L_maxTO)+1.2^2*C_D_0*S_TO/(2*C_L_maxTO)+mu_TO*S_TO);

%Cruise & Turn
W__S_new = W__S_design;
P__W_new = P__W_design;

for i = 1:N_laps
    
    %Calculate Aerodynamic Paramers
    [~] = Geometry_Analysis(N_missiles,S);
    Aerodynamic_Analysis(N_missiles)
    load Aerodynamics.mat C_D_0
    
    %Cruise
    R_cruise = lap_s*FOS_cruise_s;
    
    syms v
    e1 = .5*rho*v^3*C_D_0/W__S_new;
    e2 = k_1*W__S_new/(.5*rho*v);
    e3 = k_2*v;
    eqn = P__W_new == 1/eta_prop*(e1+e2+e3);
    v_cruise = max(real(double(vpasolve(eqn,v))));
    
    C_L = 2*W__S_new/rho/(v_cruise^2);
    C_D = C_D_0 + k_1*C_L^2 + k_2*C_L;
    W_batt__W_Cruise_vec(i) = 1/eta_prop*1/c_batt*1/(C_L/C_D)*R_cruise;
    
    %Turn
    v_turn = sqrt(n_max_struct/(.5*rho*C_L_max)*W__S_new);
    Radius_turn = v_turn^2/(g*sqrt(n_max_struct^2-1));
    R_turn = 4*pi*Radius_turn; 
    C_L = C_L_max;
    C_D = C_D_0 + k_1*C_L^2 +k_2*C_L;
    W_batt__W_Turn_vec(i) = 1/eta_prop*1/c_batt*1/(C_L/C_D)*R_turn;
    
    Report_Mat(i,:) = [i, N_missiles, v_cruise, v_turn, Radius_turn, C_D_0];
    
    %lose a missile
    if N_missiles > 0
        N_missiles = N_missiles - 1;
        W__S_new = W__S_new - W_missile/S;
        P__W_new = P__W_new*(1 - W_missile/(W__S_design*S))^-1;
    end
end

W_batt__W_Cruise = sum(W_batt__W_Cruise_vec);
W_batt__W_Turn = sum(W_batt__W_Turn_vec);

%Summation of Weights
W_batt__W_TO = W_batt__W_Cruise + W_batt__W_Turn + W_batt__W_Takeoff;

%Report
Lap_N = Report_Mat(:,1);
N_missiles = Report_Mat(:,2);
v_cruise = Report_Mat(:,3);
v_turn = Report_Mat(:,4);
Radius_turn = Report_Mat(:,5);
C_D_0 = Report_Mat(:,6);

Report_Mission_Table = table(Lap_N,N_missiles,v_cruise,v_turn,Radius_turn,C_D_0);
end
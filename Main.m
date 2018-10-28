%**************************************************************************
%
%   Thomas Ryan & Angelique Hatch
%   Conceptual Aircraft Design
%   2018.10.28
%
%**************************************************************************
clear variables
%close all
clc

%Aiplane, air properties

%fixed
rho         = 0.00237; %density of air (Slugs/ft^3) (for SL)
g           = 32.2;    %acceleration of gravity (ft/s^2)

%Airfoil
alpha_L0    = -2;      %angle of attack for zero lift (0 to -4 degrees)
loc_max_t   = .5;      %location of max thickness / chord
alpha_stall = 15;      %angle of attack for stall
a_0         = 0.11;    %2D lift curve slope
a_0_t       = a_0;     %2D lift curve slope of tail 

%Wing
Lambda_LE   = 10;      %leading edge sweep angle (degrees)
AR          = 6;       %Aspect Ratio
taper       = 0.9;     %Taper ratio (0 is full taper 1 is no taper)
S_f__S      = 0.4;     %flap area / wing area

%tail
Lambda_LE_t = Lambda_LE; %leading edge sweep angle of tail (degrees)
AR_t        = AR;      %Aspect Ratio of tail
taper_t     = taper;   %Taper ratio of tail
S_h__S      = 0.2;     %horizontal tail area / wing area
S_v__S      = 0.15;    %vertical tail area / wing area

%Stability
SM          = .3;      %Static Margin
z_h         = 0;       %Vertical height of horizontal tail (ft)
l_h         = 1.5;     %distance from front of plane to start of tail (ft)

%Fuselage
D_fuse      = 6/12;    %Diameter of fuselage (ft)(cylinder)
L_fuse      = 15/12;   %length of fuselage (ft) (cylinder)

%Misc.
eta_prop    = 0.75;    %Propellar efficiency
c_batt      = 92000;   %Battery energy density NMH (ft-lbf/lbf)
C_f_e       = 0.014;   %Skin friction coefficient
C_d_m       = 0.03;    %Missile drag coeffectient
n_max_struct= 2.5;     %maz

%Mission
N_missiles  = 4;       %Number of missiles 
N_laps  = N_missiles;  %Number of laps
W_missile = 3/16;      %Weight of missiles (lbf)

%Design Point
W__S_design = 2;       %Wing Loading
P__W_design = 90;      %Power Loading

save Geometric_Design.mat AR taper Lambda_LE S_h__S S_v__S D_fuse L_fuse loc_max_t
save Aerodynamic_Design.mat AR alpha_L0 a_0 a_0_t alpha_stall S_f__S C_f_e C_d_m
save Stability.mat AR AR_t taper_t Lambda_LE_t SM z_h l_h Lambda_LE taper
save CA_MA.mat rho g eta_prop c_batt W_missile n_max_struct

S           = 1.85;      %wing area (ft^2) (guess)
i           = 1;       %Initialization

% S = linspace(2,5,50);
% for S = S
    
    %Geometry
    Report_Geometry_Table = Geometry_Analysis(N_missiles,S);
    
    %Aerodynamic Analysis
    Aerodynamic_Analysis(N_missiles)
    
    %Constraint Analysis
    Constraint_Analysis(rho,g,eta_prop,W__S_design,P__W_design,S)
    
    %Mission Analysis
    [Report_Mission_Table,W_batt__W_TO] = Mission_Analysis(W__S_design,P__W_design,N_missiles,N_laps,S);
    
    %Sizing
    [Report_Weight_Table,S_computed] = Sizing(W__S_design,P__W_design,...
        W_batt__W_TO,N_missiles,S);
    
%     S_vec(i) = S;
%     S_c_vec(i) = S_computed;   
%     
%     i = i+1;
% end
% 
% figure(1)
% plot(S_vec,S_vec,'ob',S_vec,S_c_vec,'xr')
% xlabel('Wing Area guessed (ft^2)')
% ylabel('Wing Area (ft^2)')
% legend('S','S\_computed')
% ylim([-10 10])

%Stability
[Report_Stability_Table,Report_Trim_Table] = Stability(S);



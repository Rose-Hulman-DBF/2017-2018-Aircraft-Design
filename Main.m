%**************************************************************************
%
%   Thomas Ryan & Angelique Hatch
%   Conceptual Aircraft Design
%   2018.10.15
%
%**************************************************************************
clear variables
%close all
clc

%To-do
%Check with Tim
%Begin actual rough design (need overall concept first)
%add stability / trim analysis (later)

%Aiplane, air properties

%fixed
rho         = 0.00238; %density of air (Slugs/ft^3) (for SL)
g           = 32.2;    %acceleration of gravity (ft/s^2)

%Airfoil
alpha_L0    = -2;      %angle of attack for zero lift (0 to -4 degrees)
loc_max_t   = .5;      %location of max thickness / chord
a_0         = 0.11;    %lift curve slope
alpha_stall = 15;      %angle of attack for stall

%Wing
Lambda_LE   = 10;      %leading edge sweep angle
AR          = 4;       %Aspect Ratio
taper       = 0.9;     %Taper ratio (0 is full taper 1 is no taper)
S           = 3        %wing area (ft^2) (guess)
S_f__S      = 0.4;     %flap area / wing area

%tail
S_h__S      = 0.2;     %horizontal tail area / wing area
S_v__S      = 0.15;    %vertical tail area / wing area

%Fuselage
D_fuse      = 6/12;    %Diameter of fuselage (ft)(cylinder)
L_fuse      = 15/12;   %length of fuselage (ft) (cylinder)

%Misc.
eta_prop    = 0.75;    %Propellar efficiency
c_batt      = 92000;   %Battery energy density NMH (ft-lbf/lbf)
C_f_e       = 0.014;   %Skin friction coefficient

%Mission
N_missiles  = 4;       %Number of missiles / laps

%Design Point
W__S_design = 1.4;     %Wing Loading
P__W_design = 45;      %Power Loading

save Geometric_Design.mat S AR taper Lambda_LE S_h__S S_v__S D_fuse L_fuse loc_max_t
save Aerodynamic_Design.mat AR alpha_L0 a_0 alpha_stall S_f__S C_f_e

%Geometry
Report_Geometry_Table = Geometry_Analysis(N_missiles);  

%Aerodynamic Analysis
Aerodynamic_Analysis

%Constraint Analysis
Constraint_Analysis(rho,g,eta_prop,W__S_design,P__W_design)

%Mission Analysis
W_batt__W_TO = Mission_Analysis(rho,g,eta_prop,c_batt,W__S_design,...
    P__W_design,N_missiles);

%Sizing
Report_Weight_Table = Sizing(W__S_design,P__W_design,W_batt__W_TO,N_missiles);



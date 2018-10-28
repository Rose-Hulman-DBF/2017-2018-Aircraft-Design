function [] = Constraint_Analysis(rho,g,eta_prop,W__S_design,P__W_design,S)

load Aerodynamics.mat

W__S_vec = (0:.01:3);
W_missle = 3/16;

% Mission 1 100s lap
n_max_struc = 2.5;
rho = rho;
T_lap = 100;
        v_turn = sqrt(((n_max_struc)/(0.5*rho*C_L_max)).*W__S_vec); %ft/s
        w = ((g)*sqrt((n_max_struc.^2)-1))./v_turn; %rad/s
        v_cruise = 2000./(T_lap-((4*pi)./w)); %rad/s
        P__w_maxspeed_100 = (1/eta_prop)*(((1/2*rho.*v_cruise.^3*C_D_0_no_missile)./W__S_vec) + ((k_1.*W__S_vec)./(1/2*rho.*v_cruise)) + k_2.*v_cruise);
        P__w_sustainedload = 1/eta_prop*(1/2*rho.*v_turn.^3*C_D_0_no_missile./W__S_vec + k_1.*n_max_struc.^2.*W__S_vec./(1/2*rho.*v_turn) + k_2.*n_max_struc.*v_turn);

% Mission 3 4 Missles
n_max_struc = 2.5;
rho = rho;
N_missle = 2;
N_lap = 4;
W__S_vec_3=W__S_vec+((N_missle*W_missle))/S;
        v_turn = sqrt(((n_max_struc)/(0.5*rho*C_L_max)).*W__S_vec); %ft/s
        w = ((g)*sqrt((n_max_struc.^2)-1))./v_turn; %rad/s
        v_cruise = 2000./(T_lap-((4*pi)./w)); %rad/s
        P__w_maxspeed_4 = (1/eta_prop)*(((1/2*rho.*v_cruise.^3*C_D_0_no_missile)./W__S_vec_3) + ((k_1.*W__S_vec_3)./(1/2*rho.*v_cruise)) + k_2.*v_cruise);
        P__w_sustainedload_4 = 1/eta_prop*(1/2*rho.*v_turn.^3*C_D_0_no_missile./W__S_vec_3 + k_1.*n_max_struc.^2.*W__S_vec_3./(1/2*rho.*v_turn) + k_2.*n_max_struc.*v_turn);

        
% Take Off Distance
mu_R = .02;
rho = rho;
s_TO = 10; %ft
P__w_TO = 1.2^3/eta_prop*(W__S_vec./(rho*C_L_maxTO^3)).^(1/2).*(W__S_vec./(rho*g*s_TO) + C_D_0/2 + mu_R*C_L_maxTO/1.44);


plot(W__S_design,P__W_design,'xk',W__S_vec, P__w_maxspeed_100,'k-',W__S_vec,P__w_sustainedload,'b-',W__S_vec,P__w_maxspeed_4,'m-',W__S_vec,P__w_sustainedload_4,'-g',W__S_vec,P__w_TO,'r-')
title('Constraint Analysis')
xlabel('Wing Loading (lbf/ft^2)')
ylabel('Power loading (ft-lbf/s)/(lbf)')
legend('Design Point','M1 maxspeed', 'M1 sustained load', 'M3 maxspeed', 'M3 sustained load', 'Takeoff Distance')
axis([0 3 0 100])

N=2.5;

end
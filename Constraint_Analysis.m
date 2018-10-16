function [] = Constraint_Analysis(rho,g,eta_prop,W__S_design,P__W_design)

load Aerodynamics.mat

W__S_vec = (0:.01:150);

% Max Speed
n = 1.5;
T_lap = 300;
v_max = 10; %ft/s
while T_lap > 100
v_turn = 0.7*v_max; %ft/s
w = ((32.2)*sqrt((n^2)-1))/v_turn; %rad/s
T_lap = (2000/v_max)+((720*(pi/180))/w); %s
v_max = v_max + 10; %ft/s
end
P__w_maxspeed = 1/eta_prop*(1/2*rho*v_max^3*C_D_0./W__S_vec + k_1*n^2*W__S_vec./(1/2*rho*v_max) + k_2*n*v_max);

% Max Speed in Turn
v_turn = 0.7*v_max;
n=2.5;
P__w_maxturn = 1/eta_prop*(1/2*rho*v_turn^3*C_D_0./(n*W__S_vec) + k_1*n^3*W__S_vec./(1/2*rho*v_turn) + k_2*n*v_turn);

% Specific Excess Power - not needed
%n = 1;
%P_s_req = 3; %ft/s
%rho = rho;
%v = 240; %ft/s
%P__w_excesspower = 1/eta_prop*(1/2*rho*v^3*C_D_0./W__S_vec + k_1*n^2*W__S_vec./(1/2*rho*v) + k_2*n*v + P_s_req);

% Sustained Load Factor
n = 1.5;
P_s_req = 0;
v = 240; %ft/s
P__w_sustainedload = 1/eta_prop*(1/2*rho*v^3*C_D_0./W__S_vec + k_1*n^2*W__S_vec./(1/2*rho*v) + k_2*n*v);

% Landing Distance - not needed
%mu_R = .4;
%rho = rho;
%s_L = 4000; %ft
%W__S_landing = rho*g*s_L*(C_D_0/2 + C_L_maxlanding/1.69*mu_R);

% Take Off Distance
mu_R = .02;
s_TO = 10; %ft
P__w_TO = 1.2^3/eta_prop*(W__S_vec./(rho*C_L_maxTO^3)).^(1/2).*(W__S_vec./(rho*g*s_TO) + C_D_0/2 + mu_R*C_L_maxTO/1.44);

% Cruise - not needed
%C_L = C_L_star;
%C_D = C_D_star;
%v_cruise_vec = sqrt(W__S_vec/(.5*rho*C_L));
%P_R__w_cruise = v_cruise_vec./(C_L/C_D);

% Loiter - not needed
%C_L = C_L_starstar;
%C_D = C_D_starstar;
%v_loiter_vec = sqrt(W__S_vec/(.5*rho*C_L));
%P_R__w_loiter = v_cruise_vec./(C_L/C_D);

% Constraint Plot
figure(2)
plot(W__S_design,P__W_design,'xk',W__S_vec,P__w_maxspeed,'b-', W__S_vec,P__w_maxturn,'r-', W__S_vec,P__w_sustainedload,'m-',W__S_vec,P__w_TO,'k-')
%line([W__S_landing W__S_landing], [0 600])
title('Constraint Analysis')
xlabel('Wing Loading (lbf/ft^2)')
ylabel('Power loading (ft-lbf/s)/(lbf)')
legend('Design Point','Max Speed', 'Max Speed in Turn', 'Sustained Load Factor','Takeoff distance')
axis([0 3 0 160])

end
function [] = Constraint_Analysis(rho,g,eta_prop,W__S_design,P__W_design)

load Aerodynamics.mat

W__S_vec = (0:.1:150);

n = 1;
P_s_req = 0;
rho = rho;
v = 300; %ft/s
P__w_maxspeed = 1/eta_prop*(1/2*rho*v^3*C_D_0./W__S_vec + k_1*n^2*W__S_vec./(1/2*rho*v) + k_2*n*v);

n = 1;
P_s_req = 3; %ft/s
rho = rho;
v = 240; %ft/s
P__w_excesspower = 1/eta_prop*(1/2*rho*v^3*C_D_0./W__S_vec + k_1*n^2*W__S_vec./(1/2*rho*v) + k_2*n*v + P_s_req);

n = 1.5;
P_s_req = 0;
rho = rho;
v = 240; %ft/s
P__w_sustainedload = 1/eta_prop*(1/2*rho*v^3*C_D_0./W__S_vec + k_1*n^2*W__S_vec./(1/2*rho*v) + k_2*n*v);

mu_R = .4;
rho = rho;
s_L = 4000; %ft
W__S_landing = rho*g*s_L*(C_D_0/2 + C_L_maxlanding/1.69*mu_R);

mu_R = .02;
rho = rho;
s_TO = 10; %ft
P__w_TO = 1.2^3/eta_prop*(W__S_vec./(rho*C_L_maxTO^3)).^(1/2).*(W__S_vec./(rho*g*s_TO) + C_D_0/2 + mu_R*C_L_maxTO/1.44);

C_L = C_L_star;
C_D = C_D_star;
v_cruise_vec = sqrt(W__S_vec/(.5*rho*C_L));
P_R__w_cruise = v_cruise_vec./(C_L/C_D);

C_L = C_L_starstar;
C_D = C_D_starstar;
v_loiter_vec = sqrt(W__S_vec/(.5*rho*C_L));
P_R__w_loiter = v_cruise_vec./(C_L/C_D);

% Constraint Plot
figure(2)
plot(W__S_design,P__W_design,'xk',W__S_vec,P__w_maxspeed,'b-',W__S_vec,P__w_excesspower,'r-',W__S_vec,P__w_sustainedload,'m-',W__S_vec,P__w_TO,'k-',W__S_vec,P_R__w_cruise,'g-',W__S_vec,P_R__w_loiter,'y-')
line([W__S_landing W__S_landing], [0 600])
title('Constraint Analysis')
xlabel('Wing Loading (lbf/ft^2)')
ylabel('Power loading (lbf/ft^2)')
legend('Design Point','Max Speed','Specific Excess Power','Sustained Load Factor','Takeoff distance',...
   'Flight at min T_R','Flight at min P_R','Landing distance')
axis([0 10 0 50])

end
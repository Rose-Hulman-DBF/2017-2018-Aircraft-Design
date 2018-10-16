function [] = Aerodynamic_Analysis()

load Geometry.mat
load Aerodynamic_Design.mat

e = 2/(2 - AR + sqrt(4 + AR^2*(1+tan(lambda_t_max*pi/180)^2)));
e_0 = 1/(1/e + .0035*pi*AR);

a_wing = a_0/(1 + 57.3*a_0/(pi*e*AR));

C_L_minD = a_wing*(-alpha_L0/2);
C_L_max = a_wing*(alpha_stall - alpha_L0);

C_L_maxlanding = C_L_max + a_wing*15*S_f__S*cos(Lambda_TE*pi/180);
C_L_maxTO = C_L_max + a_wing*10*S_f__S*cos(Lambda_TE*pi/180);

k_1 = 1/(pi*e_0*AR);

C_D_0 = C_f_e*S_wet__S + k_1*C_L_minD^2;

k_2 = -2*k_1*C_L_minD;

C_L_polar = -C_L_max:.01:C_L_max;
C_D_polar = C_D_0 + k_1.*C_L_polar.^2 +k_2.*C_L_polar;

C_L_star = sqrt(C_D_0/k_1);
C_D_star = 2*C_D_0 + k_2*sqrt(C_D_0/k_1);

C_L__C_D_max = C_L_star/C_D_star;

C_L_starstar = 6/((12*k_1/C_D_0 +(k_2/C_D_0)^2)^(1/2) - k_2/C_D_0);
C_D_starstar = C_D_0 + k_1*C_L_starstar^2 + k_2*C_L_starstar;

save Aerodynamics.mat

% Drag polar plot
figure(1)
plot(C_L_polar,C_D_polar,C_L_polar(end),C_D_polar(end),'o');
axis([-0.55 1.8 0 0.12]);
xlabel('C_L');
ylabel('C_D');
legend('Drag Polar',['C_Lmax=',num2str(C_L_polar(end)), ' C_Dmax=',num2str(C_D_polar(end))]);
title('Plot of C_D vs C_L')

end
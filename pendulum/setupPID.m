close all
clear
clc

% system dynamics
J = 0.1;
B = 10;

% magnitude of the disturbance
D = 100;

% now, for a PD controller, use 2nd order
% system properties to determine Kp and Kd
z = 1;
omega = 2*pi*10;

% now give Kp, Kd, and Ki
Kp = omega^2*J
Kd = (2*z*omega*J-B)
Ki = 0.1*(B+Kd)*Kp/J


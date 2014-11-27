close all
clear
clc

% setup parameters for inverted pendulum control
m = 1;
L = 3;
amp = pi/6;
phi = pi/8;
omega = 10;
g = 9.8;
J = m*L^2;

A = [0 1;g/L 0];
b = [0;1/J];
c = [1 0];

% now determine where to place the poles
% if we want them at -2+/-i (i.e. characteristic
% polynomial is s^2 + 4s + 5:
K1 = 5*J+g*J/L
K2 = 4*J

% now we have placed the poles where we want them
% now we ahve to develop the input r to follow a 
% trajectory

% use a PID compensator
z = 1;
w = 100;

Kp = 85000
Kd = 1749
Ki = 0

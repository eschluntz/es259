%This script helps you construct an 'a' matrix trajectory for the CAT-5
clc
clear all
close all
%% Choose length and name of your trajectory:

tf = 45; %in seconds
fname = 'ERIK_SCHLUNTZ_PATH';

%%%%%%%%%%%%%%%%%%%%%%

dt = 0.1;
t_vect = 9.9:dt:tf;
a = zeros(6,length(t_vect)+1);
a(1,1:end-1) = t_vect;
a(1,end) = 100000;
a(2:6,end-1:end) = zeros(5,2);

disp('Each joint trajetory should be a row vector of length:')
disp(num2str(size(a,2)-3))


%% Crate your trajectories:
%Code for generating joint inputs goes here:

radius = 3;
t_delta = tf - 9.9;
w = .3;
thetas = lab_circle_trajectory(radius, dt, length(t_vect)-2, w*pi/t_delta);

theta1 = thetas(1,:);
theta2 = thetas(2,:);
theta3 = thetas(3,:);
theta4 = thetas(4,:);
theta5 = thetas(5,:);

%%%%%%%%%%%%%%%%%%%%%%

a(2,2:end-2) = theta1;
a(3,2:end-2) = theta2;
a(4,2:end-2) = theta3;
a(5,2:end-2) = theta4;
a(6,2:end-2) = theta5;

a(:,1:30)


%% Run this section to check the validity of your trajectory
load('ERIK_PICK.mat');
err = 0;

t1 = a(2,1:end-2); t1v = diff(t1)/dt; t1a = diff(diff(t1))/dt;
t2 = a(3,1:end-2); t2v = diff(t2)/dt; t2a = diff(diff(t2))/dt;
t3 = a(4,1:end-2); t3v = diff(t3)/dt; t3a = diff(diff(t3))/dt;
t4 = a(5,1:end-2); t4v = diff(t4)/dt; t4a = diff(diff(t4))/dt;
t5 = a(6,1:end-2); t5v = diff(t5)/dt; t5a = diff(diff(t5))/dt;


try
    if (mean(t1>180)>0 || mean(t1<-180)>0 )
        msg='Joint 1 Limits Exceeded';error(msg);
    elseif (mean(t2<0)>0 || mean(t2>90)>0)
        msg='Joint 2 Limits Exceeded';error(msg);
    elseif (mean(t3<-90)>0 || mean(t3>30)>0)
        msg='Joint 3 Limits Exceeded';error(msg);
    elseif (mean(t4<-90)>0 || mean(t4>90)>0)
        msg='Joint 4 Limits Exceeded';error(msg);
    elseif (mean(t5<-180)>0 || mean(t5>180)>0)
        msg='Joint 5 Limits Exceeded';error(msg);
    end
catch
    err = 1;
    disp(msg)
end



try
    if (mean(abs(t1v)>100)>0)
        msg='Joint 1 Velocity Limits Exceeded';error(msg);
    elseif (mean(abs(t2v)>100)>0 )
        msg='Joint 2 Velocity Limits Exceeded';error(msg);
    elseif (mean(abs(t3v)>100)>0 )
        msg='Joint 3 Velocity Limits Exceeded';error(msg);
    elseif (mean(abs(t4v)>500)>0 )
        msg='Joint 4 Velocity Limits Exceeded';error(msg);
    elseif (mean(abs(t5v)>250)>0)
        msg='Joint 5 Velocity Limits Exceeded';error(msg);
    end
catch
    err = 2;
    disp(msg)
end

try
    if (mean(abs(t1a)>100)>0)
        msg='Joint 1 Acceleration Limits Exceeded';error(msg);
    elseif (mean(abs(t2a)>100)>0 )
        msg='Joint 2 Acceleration Limits Exceeded';error(msg);
    elseif (mean(abs(t3a)>100)>0 )
        msg='Joint 3 Acceleration Limits Exceeded';error(msg);
    elseif (mean(abs(t4a)>500)>0 )
        msg='Joint 4 Acceleration Limits Exceeded';error(msg);
    elseif (mean(abs(t5a)>250)>0)
        msg='Joint 5 Acceleration Limits Exceeded';error(msg);
    end
catch
    err = 3;
    disp(msg)
end



%Plot the errors:

if err == 1
    colors = jet(5);
    figure
    a = plot(t1);hold on;set(a,'color',colors(1,:),'linewidth',2);
    b = plot(t2);set(b,'color',colors(2,:),'linewidth',2);
    c = plot(t3);set(c,'color',colors(3,:),'linewidth',2);
    d = plot(t4);set(d,'color',colors(4,:),'linewidth',2);
    e = plot(t5);set(e,'color',colors(5,:),'linewidth',2);
    title('Joint Angles','FontSize',12,'Interpreter','Latex')
    ll=legend('$\theta_1$','$\theta_2$','$\theta_3$','$\theta_4$','$\theta_5$');
    set(ll,'FontSize',12,'Interpreter','Latex');
    break
elseif err == 2
    colors = jet(5);
    figure
    a = plot(t1v);hold on;set(a,'color',colors(1,:),'linewidth',2);
    b = plot(t2v);set(b,'color',colors(2,:),'linewidth',2);
    c = plot(t3v);set(c,'color',colors(3,:),'linewidth',2);
    d = plot(t4v);set(d,'color',colors(4,:),'linewidth',2);
    e = plot(t5v);set(e,'color',colors(5,:),'linewidth',2);
    title('Joint Velocities','FontSize',12,'Interpreter','Latex')
    ll=legend('$\theta_1$','$\theta_2$','$\theta_3$','$\theta_4$','$\theta_5$');
    set(ll,'FontSize',12,'Interpreter','Latex');
    break
elseif err == 3
    colors = jet(5);
    figure
    a = plot(t1a);hold on;set(a,'color',colors(1,:),'linewidth',2);
    b = plot(t2a);set(b,'color',colors(2,:),'linewidth',2);
    c = plot(t3a);set(c,'color',colors(3,:),'linewidth',2);
    d = plot(t4a);set(d,'color',colors(4,:),'linewidth',2);
    e = plot(t5a);set(e,'color',colors(5,:),'linewidth',2);
    title('Joint Accelerations','FontSize',12,'Interpreter','Latex')
    ll=legend('$\theta_1$','$\theta_2$','$\theta_3$','$\theta_4$','$\theta_5$');
    set(ll,'FontSize',12,'Interpreter','Latex');
    break
elseif err == 0
    save(strcat(fname,'.mat'),'a')
    fprintf(strcat(fname,'.mat'))
    fprintf(' has been saved')
end

%Plot the trajectory:
TJ = [theta1;theta2;theta3;theta4;theta5;zeros(1,size(a,2)-3)];

pos = [];
hh = plot3(0,0,0,'b--','Linewidth',1.5);
for i =1:size(TJ,2)
    u = TJ(:,i);
    [x,~] = forwardKinematicsPlotting(u);
    pos = [pos x];
    set(hh,'XData',pos(1,:),'YData',pos(2,:),'ZData',pos(3,:))
end

legend('Trajectory','X','Y','Z')
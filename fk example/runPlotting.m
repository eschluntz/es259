%This function calls forwardKinematicsPlotting to plot the trajectory of
%the robot

clc;clear all;close all

q = 0:30;

TJ = [q;q;q;q;q;q];

pos = [];
hh = plot3(0,0,0,'b--','Linewidth',1.5);
for j = 1:10
for i =1:size(TJ,2)
    u = TJ(:,i);
    [x,~] = forwardKinematicsPlotting(u);
    pos = [pos x];
    set(hh,'XData',pos(1,:),'YData',pos(2,:),'ZData',pos(3,:))
    pause(.1);
end
for i =size(TJ,2):-1:1
    u = TJ(:,i);
    [x,~] = forwardKinematicsPlotting(u);
    pos = [pos x];
    set(hh,'XData',pos(1,:),'YData',pos(2,:),'ZData',pos(3,:))
    pause(.1);
end
end

% legend('Trajectory','X','Y','Z')


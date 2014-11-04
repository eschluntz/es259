function [  ] = draw_planar_scene( scale )
%draw_scene Opens a 3D plot and draws an origin with labelled axes.
%   Detailed explanation goes here
quiver(0,0,0,0);
hold on;
m = scale;
m2 = scale/3;
axis([-m,m, -m,m]);
axis square;
xlabel('X')
ylabel('Y')

line([-m2,m2,0,0,0],[0,0,0,m2,-m2],'LineStyle','--','color','green');

end
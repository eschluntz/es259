clear;
close all;

joints = zeros(1,6);

quiver3(0,0,0,0,0,0);
hold on;
m = 30;
axis([-m,m, -m,m, -m,m]);
axis square;
rotate3d on;
xlabel('X')
ylabel('Y')
zlabel('Z')




origin = [0,0,10];

a1 = -pi/8;
a2 = pi/8;
j = 5;
joints(4) = pi/2;
joints(1) = -pi/8;
joints(2) = -pi/4;
joints(3) = pi/4;

for th = a1:.1:a2
    % move joint
    joints(j) = th;
    [tool, T] = lab_fk(joints);
end


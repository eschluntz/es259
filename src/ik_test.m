clear;
%close all;

x = 12;
y = 0;
z = 20;

disp('STARTING -----------------------');
%for x = 5:.5:20
    %T = [-.2,-.8,.6,15.6; -.9,.4,.3,7.3; -.5,-.5,-.7,12.8; 0,0,0,1];
    T = [.8, .1, .6, 14; .1, .9, -.3, -6.5; -.6, .3, .7, 22.2; 0,0,0,1];
    %T = [0,0,1,x; 0,1,0,y; -1,0,0,z; 0,0,0,1];
    Q = lab_ik2(T)
    joints = [Q',0];
    lab_fk(deg2rad(joints),false);
    pause(.01);
    %cla;
%end


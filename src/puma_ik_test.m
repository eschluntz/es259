clear; close all;

x = 15;
y = -2;
z = 13;
T = [1,0,0,x; 0,1,0,y; 0,0,1,z; 0,0,0,1];

puma_ik
Q

for i = 1:10
    for sn = 1:8
        cla;
        puma_fk(Q(:,sn),false);
        %
    end
end
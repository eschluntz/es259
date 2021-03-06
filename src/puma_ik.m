function Q = puma_ik(T)
%puma_ik Calculates inverse kinematics of the puma arm
addpath('util/');
% desired configuration
R = T(1:3,1:3);
o_tool = T(1:3,4);

% return
Q = zeros(6,8);

% DH variables and arm information
shoulder_height = 13;
upper_arm = 8;
fore_arm = 8;
ds = 2;
de = 2;

% getting DH params
a = [0,upper_arm,0,0,0,0];
alpha = [pi/2, 0, pi/2, pi/2, pi/2, 0];
d = [shoulder_height,ds,0,fore_arm,0, de];

%{
    Step 1: Find wrist center
    o_tool = o_wrist + d5*R*[0,0,1]'
    o_wrist = o_tool - d5*R*[0,0,1]'
%}
o_wrist = o_tool - d(6)*R*[0,0,1]';

%{
    Step 2: find horizontal (x,y) distance from origin to wrist center
    the two right triangles (dh,ds) and (x,y) share a hypotenuse
%}
wx = o_wrist(1);
wy = o_wrist(2);
wz = o_wrist(3);
dh = sqrt(wx^2 + wy^2 - ds^2); % this will be imaginary if impossible

phi = atan2(wy,wx);
alph = atan2(d(2), dh);


%{
    Step 3: find rotation of the trunk using headings
    th1 = phi - alph
%}
theta1(1) = atan2(wy,wx) + atan2(-d(2), -dh) +pi;
theta1(2) = phi - alph + pi;

% saving
Q(1,1:4) = theta1(1);
Q(1,5:8) = theta1(2);

%{
    Step 4: look in the plane of theta1 (dh, z)
    pretend that's just x,y, and everything is normal

    from law of cosines: cos(th3) = D = (x^2 + y^2 - a2^2 - a3^2) /(2 a2 a3)
    th3 = atan2(D, +- sqrt(1-D^2)
%}
dz = wz - d(1);
dist2 = dh^2 + dz^2;
cos3 = (dist2 - a(2)^2 - d(4)^2) / (2 * a(2) * d(4));

% checking for unreachable position
if cos3 < -1 || cos3 > 1
    disp('impossible position');
    Q = zeros(6,8);
    return;
end

% pre allocating
theta2 = [0,0];
theta3 = [0,0];

% arm up, arm down
theta3(1) = atan2(sqrt(1-cos3^2),cos3);
theta3(2) = atan2(-sqrt(1-cos3^2),cos3);

% saving
Q(3,[1,2,5,6]) = theta3(1);
Q(3,[3,4,7,8]) = theta3(2);

direct = atan2(dz, dh);

% theta2s
other1 = atan2(d(4)*sin(theta3(1)), a(2) + d(4)*cos(theta3(1)));
other2 = atan2(d(4)*sin(theta3(2)), a(2) + d(4)*cos(theta3(2)));
theta2(1) = direct - other1;
theta2(2) = direct - other2;
Q3s = Q;
% right arm
for sn = 1:4
    other = atan2(d(4)*sin(Q(3,sn)), a(2) + d(4)*cos(Q(3,sn)));
    Q(2,sn) = direct - other;
end

% left arm
for sn = 5:8
    other = atan2(d(4)*sin(Q(3,sn)), a(2) + d(4)*cos(Q(3,sn)));
    Q(2,sn) = pi - (direct - other);
    Q(3,sn) = Q3s(3,sn-2);
end

%{
    Step 5: find the wrist orientation relative to arm
    R = R03 * R36
    R36 = (R03)^-1 R = R03' R
%}
for sn = 1:2:8
    % using DH to calculate R03
    A1 = rotz(Q(1,sn)) * transz(d(1)) * transx(a(1)) * rotx(alpha(1));
    A2 = rotz(Q(2,sn)) * transz(d(2)) * transx(a(2)) * rotx(alpha(2));
    A3 = rotz(Q(3,sn)) * transz(d(3)) * transx(d(4)) * rotx(alpha(3));
    T03 = A1*A2*A3;
    R03 = T03(1:3,1:3);
    R36 = R03' * R;
    
    % checking wrist centers
    assert(norm(T03(1:3,4) - o_wrist) < .01);

    %{
        Step 6: convert R36 into euler angles and then thetas
        Spong EQ (2.28) -> (2.33)
        We get another branching of solutions
    %}

    Q(5,sn) = atan2(sqrt(1-R36(3,3)^2), R36(3,3));
    Q(5,sn+1) = atan2(-sqrt(1-R36(3,3)^2), R36(3,3));

    Q(4,sn) = atan2(R36(2,3),R36(1,3));
    Q(4,sn+1) = atan2(-R36(2,3),-R36(1,3));

    Q(6,sn) = atan2(R36(3,2),-R36(3,1));
    Q(6,sn+1) = atan2(-R36(3,2),R36(3,1));
end

% return all solutions in Q

end


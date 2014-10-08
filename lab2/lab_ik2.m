function Q = lab_ik(T)
%lab_ik Calculates inverse kinematics of the lab arm
%     addpath('util/');
    Q=zeros(5,1);
    % desired configuration
    R = T(1:3,1:3);
    o_tool = T(1:3,4);

    % DH variables and arm information
    arm_length = 10;
    a = [0,arm_length,arm_length,0,0];
    alpha = [-pi/2, 0, 0, pi/2,0];
    d = [10,0,0,0,2];

    % joint limitations in degrees
    qlimits = [-180,180; 0, 45; -90, 30; -45, 45; -75, 75];

    %{
        Step 1: Find wrist center
        o_tool = o_wrist + d5*R*[0,0,1]'
        o_wrist = o_tool - d5*R*[0,0,1]'
    %}
    o_wrist = o_tool - d(5)*R*[0,0,1]';

    %{
        Step 2: use geometry to get first 3 joint angles
        th1 = atan2(yc,xc)
        from law of cosines: cos(th3) = D = (x^2 + y^2 - a2^2 - a3^2) /(2 a2 a3)
        th3 = atan2(D, +- sqrt(1-D^2)
    %}
    theta1 = atan2(o_wrist(2), o_wrist(1));

    dist2 = norm(o_wrist - [0,0,d(1)]')^2;
    
    cos3 = (dist2 - a(2)^2 - a(3)^2) / (2 * a(2) * a(3));
    
    % checking for unreachable position
    if cos3 < -1 || cos3 > 1
%         disp('impossible position');
        Q = zeros(5,1);
        return;
    end
    % pre allocating
    theta2 = [0,0];
    theta3 = [0,0];
    theta4 = [0,0];
    theta5 = [0,0];
    theta6 = [0,0];
    phi = [0,0];
    th = [0,0];
    psi = [0,0];
    
    theta3(1) = atan2(sqrt(1-cos3^2),cos3);
    theta3(2) = atan2(-sqrt(1-cos3^2),cos3);

    direct = atan2(o_wrist(3) - d(1), sqrt(o_wrist(1)^2 + o_wrist(2)^2));
    
    
    
    for sn = 1:2
        other = atan2(a(3)*sin(theta3(sn)), a(2) + a(3)*cos(theta3(sn)));
        theta2(sn) = direct - other;

        % correct for angle offsets
        theta2(sn) = pi/2 - theta2(sn);
        theta3(sn) = -pi/2 - theta3(sn);
        %{
            Step 3: find the wrist orientation relative to arm
            R = R03 * R36
            R36 = (R03)^-1 R = R03' R
        %}

        % using DH to calculate R03
        A1 = rotz(theta1) * transz(d(1)) * transx(a(1)) * rotx(alpha(1));
        A2 = rotz(theta2(sn)) * transz(d(2)) * transx(a(2)) * rotx(alpha(2));
        A3 = rotz(theta3(sn)) * transz(d(3)) * transx(a(3)) * rotx(alpha(3));
        T03 = A1*A2*A3;
        R03 = T03(1:3,1:3);
        R36 = R03' * R;

        %{
            Step 4: convert R36 into euler angles and then thetas
            Spong EQ (2.28) -> (2.33)
            We get another branching of solutions
        %}

        th(1) = atan2(sqrt(1-R36(3,3)^2), R36(3,3));
        th(2) = atan2(-sqrt(1-R36(3,3)^2), R36(3,3));

        phi(1) = atan2(R36(2,3),R36(1,3));
        phi(2) = atan2(-R36(2,3),-R36(1,3));

        psi(1) = atan2(R36(3,2),-R36(3,1));
        psi(2) = atan2(-R36(3,2),R36(3,1));

        theta4(sn,:) = phi;
        theta5(sn,:) = th;
        theta6(sn,:) = psi - pi/2;
    end

    %{
        Step 5: Pick the best solution
        first construct a vector of solutions
    %}
    slns = zeros(5,4);
    i = 1;
    for sn23 = 1:2
        for sn45 = 1:2
            slns(:,i) = [theta1, theta2(sn23), theta3(sn23),...
                    theta4(sn23,sn45), theta6(sn23,sn45)]';
            i= i+1;
        end
    end

    [Q, is_valid] = pick_solution(qlimits,slns);
    Q = r2d(Q);
% 
end


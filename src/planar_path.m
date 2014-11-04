clear;
close all;

%{
    given initial and final positions for a 3 link planar robot
    and a 3x1 vector of obstacles [x,y,r]', return a path
%}

% initial variables
Obst = [];
Qi = [0,0,0]';
Qf = [pi/2, pi/2, pi/2]';

Q = Qi;
alpha = .1;

for i = 1:100
    cla;
    [Osf, ~] = planar_fk(Qf,false);
    [Os, ~] = planar_fk(Q,false);
    

    % creating attractive forces Uatt,i = ||oi(q) - oi(qf)||
    % forces = Os(i) - Os(f)

    % converting forces into torques for each origin

    Fs = -(Os - Osf);
    f1 = Fs(1:2,2);
    f2 = Fs(1:2,3);
    f3 = Fs(1:2,4);
    [J1,J2,J3] = planar_jacobian(Q);

    t1 = J1'*f1;
    t2 = J2'*f2;
    t3 = J3'*f3;

    Tr = t1 + t2 + t3;
    
    Q = Q + alpha * Tr / norm(Tr)
    pause(.3);
end



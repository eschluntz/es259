function [wps] = path3link(ps, pf, Ob)
%{ 
    given initial and final angles for a 3 link planar robot
    and a 3x1 vector of obstacles [x,y,r]', return a path
%}
addpath util;

% initial variables
Obst = Ob;
Qi = ps;
Qf = pf;

Q = Qi;
alpha = 1;
beta = 3;
safety = 1;
step = .05;
delta =  .05;
stuck_counter_max = 50;

error = norm(Qi - Qf);
wps = Qi;
errors = error;
stuck = false;
stuck_counter = 0;


while (error > .02)
    cla;
    [Osf, ~] = planar_fk(Qf,false);
    [Os, ~] = planar_fk(Q,false);
    draw_obsts(Obst);
    

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
    Tr = alpha * Tr;
    
    % creating repulsive forces between each obstacle and origin
    for j = 1:size(Obst,2)
        d1 = Os(1:2,2) - Obst(1:2,j);
        d2 = Os(1:2,3) - Obst(1:2,j);
        d3 = Os(1:2,4) - Obst(1:2,j);
        
        % force = (close) * disp / normSq(disp)
        f1 = (norm(d1) < safety + Obst(3,j))...
            * d1 / (norm(d1)*norm(d1)) * (1/norm(d1) - 1/(safety + Obst(3,j))); 
        f2 = (norm(d2) < safety + Obst(3,j))...
            * d2 / (norm(d2)*norm(d2)) * (1/norm(d2) - 1/(safety + Obst(3,j))); 
        f3 = (norm(d3) < safety + Obst(3,j))...
            * d3 / (norm(d3)*norm(d3)) * (1/norm(d3) - 1/(safety + Obst(3,j))); 
        
        t1 = J1'*f1;
        t2 = J2'*f2;
        t3 = J3'*f3;

        Tr = Tr + beta * (t1 + t2 + t3);
    end
    
    if (stuck) 
        stuck_counter = stuck_counter + 1;
        if (stuck_counter > stuck_counter_max)
            stuck = false;
            beta = beta / 10;
            safety = safety / 10;
        end
    else
        % detecting local minima
        if (size(errors,2) > 10) 
            progress = max(errors(end-10:end)) - min(errors(end-10:end));
            if (progress < delta)
                % in a local min
                stuck = true;
                beta = beta * 10;
                safety = safety * 10;
                stuck_counter = 0;
            end
        end

        
    end
    Q = Q + step * Tr / norm(Tr);
    pause(.01);
    error = norm(Q - Qf);
    errors = [errors, error];
    
    
    wps = [wps, Q];
end



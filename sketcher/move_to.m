function [xyz, cur] = move_to(cur_pos, dest, z, mv_speed)
    %move_to creates a trajectory of mv_speed from cur_pos to dest
    d = sqrt(sum((cur_pos - dest).*(cur_pos - dest)));
    n = ceil(d / mv_speed);
    xyz = [linspace(cur_pos(1),dest(1),n); 
            linspace(cur_pos(2),dest(2),n);
            linspace(z,z,n)]';
    cur = dest;
end
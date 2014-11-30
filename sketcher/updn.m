function [xyz] = updn(cur_pos, z1, z2, n)
    %updn creates trajectory from z1 to z2
    xyz = [linspace(cur_pos(1),cur_pos(1),n); 
            linspace(cur_pos(2),cur_pos(2),n);
            linspace(z1,z2,n)]';
end
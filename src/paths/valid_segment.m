function [ valid ] = valid_segment(p1, p2, obsts, radSq)
%valid_path true if line between p1 and p2 doesn't hist obsts
%   p1, p2 = [x,y]
%   obsts = [x1, y1; ...; xn, yn]
%   rads = [r1; ...; rn]

    % create unit vector from p1 to p2
    l1 = p2 - p1;
    l1 = l1 / norm(l1);
    
    p1 = repmat(p1,size(obsts,1),1);
    p2 = repmat(p2,size(obsts,1),1);
    
    dist2s = point_line_seg_dist(p1,p2, obsts);
    
    collisions = dist2s < radSq;
    
    if (sum(collisions) == 0)
        valid = 1;
    else
        valid = 0;
    end
end
 


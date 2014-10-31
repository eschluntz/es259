function [ valid ] = valid_segment(p1, p2, obsts, radSq)
%valid_path true if line between p1 and p2 doesn't hist obsts
%   p1, p2 = [x,y]
%   obsts = [x1, y1; ...; xn, yn]
%   rads = [r1; ...; rn]

    % create unit vector from p1 to p2
    l1 = p2 - p1;
    l1 = l1 / norm(l1);
    
    for i = 1:size(obsts,1)
        
        % first checking distance between end points
        %if (normSq(p1 - obsts(i,:) < radSq(i) || normSq(p2 - obsts(i,:) < radSq(i))
        d = normSq(cross([l1,0], [obsts(i,:) - p1,0]));
        if (d < radSq(i))
            valid = 0;
            %disp('broken');
            return;
        end
    end
    valid = 1;
end
 


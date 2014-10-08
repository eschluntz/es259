q = zeros(6,1);
ind = 5;
for a = -.5:.05:.5
    cla;
    q(ind) = a;
    puma_fk2(q,false);
    pause(.1);
    
end
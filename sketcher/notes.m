

%{
BFS implementation: Done

Datastructure:
possible
> All pixels are nodes
two pixels have an edge if they are adjacent and both have edges
RI: G(p1,p2) p1 < p2

1. pick a random pixel and BFS from it
2. take all local maxima from search 
3. BFS from each of those pixels
4. take longest path returned by any of those searches
5. record and remove those nodes, repeat

TODO
<X> datastructures for graph
<X> generate edges from image
<X> BFS
<X> local maxima
<X> record, 
<X> remove, 
<X> repeat
%}

%{
Trajectory Planning
< > find workspace limits
< > find draw/move heights
< > inverse kinematics
< > save as A
< > try for all images
%}


% Abandoned:

%{
Tasks for Sketcher
<X> create all possible segments
<X> assign Fs for each segment
<X> t(s1, s2) function for curviness
<X> cost of curve function
    = sum(cost(segs)) + sum(transitions) + A
<X> dictionary implementation
<X> min heap implementation

<X> get best curve
    1. generate all curves of length 1, put in min-heap
    repeat:
        2. remove min from min-heap
        3. insert all possible extensions back into min-heap
    while (getting better)
<X> termination criteria
<X> debug best curve
<X> queue not working
<X> segments not lining up
<X> infinite default value
<?> neg weight
<X> add asserts everywhere
<X> no termination
<X> min heap vs max heap
<X> the +A being inside the parens, alg ln 13
<X> A effects curve termination
<X> incorrectly calculating density
<X> throw out useless segments
<X> longer first
< > better termination criteria
< > repeatedly get best curve

%}

%{ 
Datastructures for Sketcher

> Curve
    > [s1, s2, s3...]
    > array of adjacent segment ids

> Segment
    > Segs = [x1, y1, x2, y2, Fs, l]
    > starting pont, ending point, cost, uncovered
    > sorted by x1, y1, x2, y2

> best curve
    > W[s,l]
        > weight of lightest curve ending on seg s of length l
        > hash table for sparsity
        > starts at infinity
    > T[s,l]
        > predecessor of s in lightest curve ending here
        > hash table for sparsity
        > starts at -1 or something


%}
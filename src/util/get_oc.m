function [ oc ] = get_oc( T )
    %UNTITLED3 Summary of this function goes here
    oc = inhomog(T * [0,0,0,1]');
end


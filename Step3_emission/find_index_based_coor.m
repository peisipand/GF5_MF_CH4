function [index_lat,index_lon] = find_index_based_coor(lat,lon,point_lat,point_lon,num_lat,num_lon)
if nargin <= 4
    num_lat = length(lat);
    num_lon = length(lon);
end
min_lat = min(lat);
max_lat = max(lat);
min_lon = min(lon);
max_lon = max(lon);
step_lat = (max_lat - min_lat) / (num_lat - 1);
step_lon = (max_lon - min_lon) / (num_lon - 1);
index_lat = floor((max_lat - point_lat) / step_lat) + 1 ;
index_lon = floor((point_lon - min_lon) / step_lon) + 1;
end


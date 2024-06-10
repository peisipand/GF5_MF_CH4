function [wind_speed,mass_of_atmos,u10,v10] = get_wind_speed_from_EC(year,month,day,hour,point_lat,point_lon)
if strcmp(class(year), 'char')
    year = str2double(year);
    month = str2double(month);
    day = str2double(day);
    hour = str2double(hour);
end
filename_wind =['wind_data_EC\EC_200101_230906.nc']; % 下载：https://portal.nccs.nasa.gov/cgi-lats4d/webform.cgi?&i=GEOS-5/fp/0.25_deg/assim/tavg1_2d_slv_Nx
% 下载
% info = ncinfo(filename_wind);
mass_of_atmos = ncread(filename_wind,'p53.162');
passed_hours = ncread(filename_wind,'time');
passed_hours = double(passed_hours);
date1 = datetime(1900, 1, 1, 0, 0, 0); % 1900年1月1日0时
date2 = datetime(year, month, day, hour, 0, 0); % 某年某月某日某时
% 计算两个日期之间的小时差
hoursDifference = hours(date2 - date1);
% 计算每个元素与要查找的数字的差值的绝对值
difference = abs(passed_hours - hoursDifference);
% 找到最小差值的索引
index_time = find(difference == min(difference));
mass_of_atmos = mass_of_atmos(:,:,1,index_time)';
lon_coarse  = ncread(filename_wind,'longitude');
lat_coarse  = ncread(filename_wind,'latitude');
u10 = ncread(filename_wind,'u10');
u10 = u10(:,:,1,index_time)';
v10 = ncread(filename_wind,'v10');
v10 = v10(:,:,1,index_time)';
%% 用 find_index_based_coor 确定行列号的前提是：通过转置和颠倒实现 imagesc(u10)和 Panoply绘制的结果一样
[index_wind_lat,index_wind_lon] = find_index_based_coor(lat_coarse,lon_coarse,point_lat,point_lon);
wind_speed = sqrt( u10(index_wind_lat,index_wind_lon).^2 + v10(index_wind_lat,index_wind_lon).^2);
mass_of_atmos = mass_of_atmos(index_wind_lat,index_wind_lon);
end


function [wind_speed,u10,v10] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon)
%% 下载地址变了
% 过去的网址：https://portal.nccs.nasa.gov/cgi-lats4d/webform.cgi?&i=GEOS-5/fp/0.25_deg/assim/tavg1_2d_slv_Nx
% 现在的网址：https://portal.nccs.nasa.gov/datashare/gmao/geos-fp/das
if strcmp(class(year), 'double')
    year = num2str(year);
    month = num2str(month);
    if length(month) == 1
        month = ['0',month];
    end
    day = num2str(day);
    if length(day) == 1
        day = ['0',day];
    end
    hour = num2str(hour);
    if length(hour) == 1
        hour = ['0',hour];
    end
end
filename_wind =['wind_data_GEOS\GEOS_',year,'_',month,'_',day,'_',hour,'.nc4']; % 下载：https://portal.nccs.nasa.gov/cgi-lats4d/webform.cgi?&i=GEOS-5/fp/0.25_deg/assim/tavg1_2d_slv_Nx
if ~exist(filename_wind,'file')
    disp('正在下载GEOS-5风速数据...');
    URL = ['https://portal.nccs.nasa.gov/datashare/gmao/geos-fp/das/Y',year,'/M',month,'/D',day,'/GEOS.fp.asm.tavg1_2d_slv_Nx.',year,month,day,'_',hour,'30.V01.nc4'];
    disp(URL);
    system(['wget ',URL,' -O',filename_wind])
    %     urlwrite(URL, filename_wind);
    disp('下载完成');
end
% info = ncinfo(filename_wind);
lon_coarse  = ncread(filename_wind,'lon');
lat_coarse  = ncread(filename_wind,'lat');
u10 = ncread(filename_wind,'U10M');
u10 = flipud(u10');
v10 = ncread(filename_wind,'V10M');
v10 = flipud(v10');

[index_wind_lat,index_wind_lon] = find_index_based_coor(lat_coarse,lon_coarse,point_lat,point_lon);
wind_speed = sqrt( u10(index_wind_lat,index_wind_lon).^2 + v10(index_wind_lat,index_wind_lon).^2);
end


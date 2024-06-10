clc;clear;
kmz_file = 'test.kmz';
% 读取 KMZ file
kmz_data = kmz2struct(kmz_file);
emitter_file = 'F:\博士\高光谱甲烷识别\匹配滤波正规代码\subfolders.xlsx';
[~,~,emitter_data] = xlsread(emitter_file); % 第一列是数值 第二列是字符  第三列啥都有
emitter_data = emitter_data(1:159,:); % 159张影像
% 82个点源
%% 点源1 影像1
index_emitter = 1;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);
StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent());
year = StartTime(1:4);
month = StartTime(6:7);
day = StartTime(9:10);
hour = StartTime(12:13);
hour = num2str(str2double(hour) - 8);
if length(hour) == 1
    hour = ['0',hour];
end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,omega_a,~,~] = get_wind_speed_from_EC(year,month,day,hour,point_lat,point_lon);% omega_a 9.2e+03
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;
%% 点源1 影像2
index_emitter = 1;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源2 影像1
index_emitter = 2;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源3 影像1
index_emitter = 3;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源4 影像1
index_emitter = 4;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;
%% 点源4 影像2
index_emitter = 4;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 10 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 35 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源4 影像3
index_emitter = 4;
index_gf = 3;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 10 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 35 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源4 影像4
index_emitter = 4;
index_gf = 4;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 10 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 35 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源4 影像5
index_emitter = 4;
index_gf = 5;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 10 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源5 影像1
index_emitter = 5;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 15 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 40 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源5 影像2
index_emitter = 5;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 15 * 0.00028655;
left_top_point_lon = point_lon - 15 * 0.00028655;
right_bottom_point_lat = point_lat - 40 * 0.00028655;
right_bottom_point_lon = point_lon + 35 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源5 影像3
index_emitter = 5;
index_gf = 3;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 35 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源5 影像4
index_emitter = 5;
index_gf = 4;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 10 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 40 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源6 影像1
index_emitter = 6;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源6 影像2
index_emitter = 6;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源7 影像1
index_emitter = 7;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 10 * 0.00028655;
right_bottom_point_lat = point_lat - 55 * 0.00028655;
right_bottom_point_lon = point_lon + 35 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源7 影像2
index_emitter = 7;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 10 * 0.00028655;
right_bottom_point_lat = point_lat - 65 * 0.00028655;
right_bottom_point_lon = point_lon + 35 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源7 影像3
index_emitter = 7;
index_gf = 3;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 40 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 10 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源8 影像1
index_emitter = 8;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 40 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 40 * 0.00028655;
right_bottom_point_lon = point_lon + 100 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源8 影像2
index_emitter = 8;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 40 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源8 影像3
index_emitter = 8;
index_gf = 3;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 40 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 45 * 0.00028655;
right_bottom_point_lon = point_lon + 50 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源8 影像4
index_emitter = 8;
index_gf = 4;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 40 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源9 影像1
index_emitter = 9;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 160 * 0.00028655;
right_bottom_point_lon = point_lon + 100 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源9 影像2
index_emitter = 9;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 60 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源9 影像3
index_emitter = 9;
index_gf = 3;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 80 * 0.00028655;
right_bottom_point_lon = point_lon + 50 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源9 影像4
index_emitter = 9;
index_gf = 4;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 60 * 0.00028655;
left_top_point_lon = point_lon - 80 * 0.00028655;
right_bottom_point_lat = point_lat - 80 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源10 影像1
index_emitter = 10;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 40 * 0.00028655;
left_top_point_lon = point_lon - 15 * 0.00028655;
right_bottom_point_lat = point_lat - 70 * 0.00028655;
right_bottom_point_lon = point_lon + 80 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源10 影像2
index_emitter = 10;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 15 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源10 影像3
index_emitter = 10;
index_gf = 3;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源10 影像4
index_emitter = 10;
index_gf = 4;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 50 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源11 影像1
index_emitter = 11;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 50 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源11 影像2
index_emitter = 11;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 50 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源11 影像3
index_emitter = 11;
index_gf = 3;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 70 * 0.00028655;
right_bottom_point_lon = point_lon + 35 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源12 影像1
index_emitter = 12;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 70 * 0.00028655;
right_bottom_point_lon = point_lon + 35 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源12 影像2
index_emitter = 12;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 40 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 40 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源13 影像1
index_emitter = 13;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 60 * 0.00028655;
left_top_point_lon = point_lon - 60 * 0.00028655;
right_bottom_point_lat = point_lat - 40 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源13 影像2
index_emitter = 13;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 60 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 5 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源14 影像1
index_emitter = 14;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源15 影像1
index_emitter = 15;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源16 影像1
index_emitter = 16;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源16 影像2
index_emitter = 16;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 70 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源16 影像3
index_emitter = 16;
index_gf = 3;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 55 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源17 影像1
index_emitter = 17;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源17 影像2
index_emitter = 17;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源18 影像1
index_emitter = 18;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 20 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源19 影像1
index_emitter = 19;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 20 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源20 影像1
index_emitter = 20;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 50 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源20 影像2
index_emitter = 20;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 30 * 0.00028655;
right_bottom_point_lon = point_lon + 30 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源21 影像1
index_emitter = 21;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 30 * 0.00028655;
right_bottom_point_lon = point_lon + 50 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源22 影像1
index_emitter = 22;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 30 * 0.00028655;
right_bottom_point_lon = point_lon + 50 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源23 影像1
index_emitter = 23;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 35 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 30 * 0.00028655;
right_bottom_point_lon = point_lon + 20 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源24 影像1
index_emitter = 24;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 35 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 30 * 0.00028655;
right_bottom_point_lon = point_lon + 20 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源25 影像1
index_emitter = 25;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 35 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 30 * 0.00028655;
right_bottom_point_lon = point_lon + 20 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源26 影像1
index_emitter = 26;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 35 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 30 * 0.00028655;
right_bottom_point_lon = point_lon + 20 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源27 影像1
index_emitter = 27;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 20 * 0.00028655;
right_bottom_point_lon = point_lon + 20 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源28 影像1
index_emitter = 28;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 30 * 0.00028655;
right_bottom_point_lon = point_lon + 30 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源29 影像1
index_emitter = 29;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 5 * 0.00028655;
right_bottom_point_lon = point_lon + 30 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;
%% 点源30 影像1
index_emitter = 30;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 40 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 5 * 0.00028655;
right_bottom_point_lon = point_lon + 30 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源31 影像1
index_emitter = 31;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 5 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源32 影像1
index_emitter = 32;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 60 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源33 影像1
index_emitter = 33;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 40 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 20 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源34 影像1
index_emitter = 34;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 20 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源35 影像1
index_emitter = 35;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 35 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 20 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源36 影像1
index_emitter = 36;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 35 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 20 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源36 影像2
index_emitter = 36;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 35 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 20 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源37 影像1
index_emitter = 37;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 35 * 0.00028655;
left_top_point_lon = point_lon - 50 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 20 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源37 影像2
index_emitter = 37;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源38 影像1
index_emitter = 38;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 50 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;
%% 点源38 影像2
index_emitter = 38;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源39 影像1
index_emitter = 39;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 60 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源39 影像2
index_emitter = 39;
index_gf =2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;
%% 点源40 影像1
index_emitter = 40;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 30 * 0.00028655;
left_top_point_lon = point_lon - 60 * 0.00028655;
right_bottom_point_lat = point_lat - 20 * 0.00028655;
right_bottom_point_lon = point_lon + 30 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;
%% 点源40 影像2
index_emitter = 40;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 30 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 20 * 0.00028655;
right_bottom_point_lon = point_lon + 50 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源41 影像1
index_emitter = 41;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 30 * 0.00028655;
left_top_point_lon = point_lon - 60 * 0.00028655;
right_bottom_point_lat = point_lat - 20 * 0.00028655;
right_bottom_point_lon = point_lon + 30 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源41 影像2
index_emitter = 41;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 20 * 0.00028655;
right_bottom_point_lon = point_lon + 30 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源42 影像1
index_emitter = 42;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 30 * 0.00028655;
left_top_point_lon = point_lon - 60 * 0.00028655;
right_bottom_point_lat = point_lat - 20 * 0.00028655;
right_bottom_point_lon = point_lon + 30 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;
%% 点源42 影像2
index_emitter = 42;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 20 * 0.00028655;
right_bottom_point_lon = point_lon + 30 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源43 影像1
index_emitter = 43;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 30 * 0.00028655;
left_top_point_lon = point_lon - 60 * 0.00028655;
right_bottom_point_lat = point_lat - 20 * 0.00028655;
right_bottom_point_lon = point_lon + 30 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源43 影像2
index_emitter = 43;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 15 * 0.00028655;
left_top_point_lon = point_lon - 30 * 0.00028655;
right_bottom_point_lat = point_lat - 40 * 0.00028655;
right_bottom_point_lon = point_lon + 15 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源44 影像1
index_emitter = 44;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 30 * 0.00028655;
left_top_point_lon = point_lon - 60 * 0.00028655;
right_bottom_point_lat = point_lat - 30 * 0.00028655;
right_bottom_point_lon = point_lon + 100 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源44 影像2
index_emitter = 44;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 30 * 0.00028655;
left_top_point_lon = point_lon - 30 * 0.00028655;
right_bottom_point_lat = point_lat - 30 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源44 影像3
index_emitter = 44;
index_gf = 3;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 30 * 0.00028655;
left_top_point_lon = point_lon - 30 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源45 影像1
index_emitter = 45;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 30 * 0.00028655;
left_top_point_lon = point_lon - 30 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源45 影像2
index_emitter = 45;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 30 * 0.00028655;
left_top_point_lon = point_lon - 30 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 15 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;
%% 点源45 影像3
index_emitter = 45;
index_gf = 3;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 30 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 10 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源45 影像4
index_emitter = 45;
index_gf = 4;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 35 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 10 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;
%% 点源46 影像1
index_emitter = 46;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 35 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 10 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源46 影像2
index_emitter = 46;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源47 影像1
index_emitter = 47;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 40 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源47 影像2
index_emitter = 47;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;
%% 点源48 影像1
index_emitter = 48;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源48 影像2
index_emitter = 48;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 20 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 35 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源48 影像3
index_emitter = 48;
index_gf = 3;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 20 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 35 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源49 影像1
index_emitter = 49;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 35 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;
%% 点源50 影像1
index_emitter = 50;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 35 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源51 影像1
index_emitter = 51;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 30 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 1 * 0.00028655;
right_bottom_point_lon = point_lon + 45 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源51 影像2
index_emitter = 51;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 30 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 45 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源51 影像3
index_emitter = 51;
index_gf = 3;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 30 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源52 影像1
index_emitter = 52;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 30 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源53 影像1
index_emitter = 53;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源54 影像1
index_emitter = 54;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源55 影像1
index_emitter = 55;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源56 影像1
index_emitter = 56;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源57 影像1
index_emitter = 57;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源58 影像1
index_emitter = 58;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源59 影像1
index_emitter = 59;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 10 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源60 影像1
index_emitter = 60;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 10 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源61 影像1
index_emitter = 61;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 40 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 10 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源62 影像1
index_emitter = 62;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 10 * 0.00028655;
right_bottom_point_lat = point_lat - 10 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源63 影像1
index_emitter = 63;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 10 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源64 影像1
index_emitter = 64;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 35 * 0.00028655;
right_bottom_point_lon = point_lon + 35 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源65 影像1
index_emitter = 65;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 5 * 0.00028655;
left_top_point_lon = point_lon - 35 * 0.00028655;
right_bottom_point_lat = point_lat - 35 * 0.00028655;
right_bottom_point_lon = point_lon + 35 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源66 影像1
index_emitter = 66;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 70 * 0.00028655;
left_top_point_lon = point_lon - 20 * 0.00028655;
right_bottom_point_lat = point_lat - 35 * 0.00028655;
right_bottom_point_lon = point_lon + 15 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源67 影像1
index_emitter = 67;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 35 * 0.00028655;
right_bottom_point_lon = point_lon + 15 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源67 影像2
index_emitter = 67;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 35 * 0.00028655;
right_bottom_point_lon = point_lon + 15 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源67 影像3
index_emitter = 67;
index_gf = 3;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 35 * 0.00028655;
right_bottom_point_lon = point_lon + 15 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源67 影像4
index_emitter = 67;
index_gf = 4;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源68 影像1
index_emitter = 68;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 10 * 0.00028655;
right_bottom_point_lon = point_lon + 35 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源68 影像2
index_emitter = 68;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 10 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源68 影像3
index_emitter = 68;
index_gf = 3;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 10 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源68 影像4
index_emitter = 68;
index_gf = 4;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 10 * 0.00028655;
right_bottom_point_lon = point_lon + 80 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;
%% 点源69 影像1
index_emitter = 69;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源69 影像2
index_emitter = 69;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 80 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源70 影像1
index_emitter = 70;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 50 * 0.00028655;
right_bottom_point_lat = point_lat - 50 * 0.00028655;
right_bottom_point_lon = point_lon + 50 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源70 影像2  这个看着像和北边一个排放源掺在一起了
index_emitter = 70;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 200 * 0.00028655;
left_top_point_lon = point_lon - 150 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 15 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源71 影像1
index_emitter = 71;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 50 * 0.00028655;
left_top_point_lon = point_lon - 15 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 50 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源72 影像1
index_emitter = 72;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源73 影像1
index_emitter = 73;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 40 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 15 * 0.00028655;
right_bottom_point_lon = point_lon + 15 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

%% 点源74 影像1
index_emitter = 74;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 40 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 30 * 0.00028655;
right_bottom_point_lon = point_lon + 60 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源75 影像1
index_emitter = 75;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 40 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 30 * 0.00028655;
right_bottom_point_lon = point_lon + 60 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源76 影像1
index_emitter = 76;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源77 影像1
index_emitter = 77;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 40 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源77 影像2
index_emitter = 77;
index_gf = 2;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 40 * 0.00028655;
right_bottom_point_lat = point_lat - 40 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;



%% 点源78 影像1
index_emitter = 78;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 40 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 40 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源79 影像1
index_emitter = 79;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 100 * 0.00028655;
left_top_point_lon = point_lon - 60 * 0.00028655;
right_bottom_point_lat = point_lat - 25 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源80 影像1
index_emitter = 80;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 90 * 0.00028655;
right_bottom_point_lat = point_lat - 40 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;



%% 点源81 影像1
index_emitter = 81;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 90 * 0.00028655;
right_bottom_point_lat = point_lat - 40 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;


%% 点源82 影像1
index_emitter = 82;
index_gf = 1;
boolean = emitter_data(4 : end, 3 + index_emitter);
boolean = cell2mat(boolean);
boolean = boolean > 0;
point_lon = kmz_data(index_emitter).Lon; %点源i的经度
point_lat = kmz_data(index_emitter).Lat; %点源i的纬度
gf_names = emitter_data(4 : end, 1);
gf_names = gf_names(boolean); % 包含点源i的影像数量
gf_name = gf_names{index_gf};
xmlDoc = xmlread(['H:\裴志鹏\GF5B_shanxi\',gf_name,'\',gf_name,'.xml']);   StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); year = StartTime(1:4); month = StartTime(6:7); day = StartTime(9:10); hour = StartTime(12:13);  hour = num2str(str2double(hour) - 8);  if length(hour) == 1     hour = ['0',hour]; end
gf_filename = ['.\..\Step2_浓度增强反演\output_data\',gf_name,'_SW.tifGDAL_GCP校正.tif'];
[enhancement,R] = readgeoraster(gf_filename);
enhancement = enhancement(:,:,4);
[a,b] = size(enhancement);
lat_limits  = R.LatitudeLimits;
lon_limits  = R.LongitudeLimits;
left_top_point_lat = point_lat + 25 * 0.00028655;
left_top_point_lon = point_lon - 25 * 0.00028655;
right_bottom_point_lat = point_lat - 40 * 0.00028655;
right_bottom_point_lon = point_lon + 25 * 0.00028655;
[left_top_lat_index,left_top_lon_index] = find_index_based_coor(lat_limits,lon_limits,left_top_point_lat,left_top_point_lon,a,b);
[right_bottom_lat_index,right_bottom_lon_index] = find_index_based_coor(lat_limits,lon_limits,right_bottom_point_lat,right_bottom_point_lon,a,b);
box = enhancement(left_top_lat_index:right_bottom_lat_index,left_top_lon_index:right_bottom_lon_index);
imagesc(box)
caxis([0 500])
%%准备风速数据
[wind_speed,~,~] = get_wind_speed_from_GEOS(year,month,day,hour,point_lat,point_lon);
%%计算Q
%         inner_box = enhancement(max(lat_index - 50,1): min(lat_index+ 50,a), max(lon_index - 50,1): min(lon_index+ 50,b));
std_image = nanstd(enhancement(:));
[Q,Q_std] = func_IME(box,omega_a, wind_speed,std_image);
Q_total(index_gf,index_emitter) = Q;
Q_std_total(index_gf,index_emitter) = Q_std;

save('Q_shoudong_from_GEOS.mat','Q_total')
save('Q_std_shoudong_from_GEOS.mat','Q_std_total')
%%
mean_Q = Q_total;
mean_Q(mean_Q == 0) = nan;
mean_Q = nanmean(mean_Q);
histogram(mean_Q,20);
sum(mean_Q) % 结果是 3.2260e+05
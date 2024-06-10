%%  统计过境次数和探测频率
clc;clear;
satellite_name = 'detected_point_sources_from_GEOS.shp';
satellite = shaperead(satellite_name);
all_path = 'H:\裴志鹏\GF5B_shanxi\';
all_path_list = dir(all_path);
overpass_number = zeros(82,1);
for index_all_path_list = 3:length(all_path_list)
    filepath = [all_path,all_path_list(index_all_path_list).name,'\'];
    xml_name = dir([filepath,'*.xml']);
    xmlDoc = xmlread([filepath,xml_name(1).name]);   % 读取xml
    TopLeftLatitude = str2num(xmlDoc.getElementsByTagName('TopLeftLatitude').item(0).getTextContent());
    TopLeftLongitude = str2num(xmlDoc.getElementsByTagName('TopLeftLongitude').item(0).getTextContent());
    TopRightLatitude = str2num(xmlDoc.getElementsByTagName('TopRightLatitude').item(0).getTextContent());
    TopRightLongitude = str2num(xmlDoc.getElementsByTagName('TopRightLongitude').item(0).getTextContent());
    BottomRightLatitude = str2num(xmlDoc.getElementsByTagName('BottomRightLatitude').item(0).getTextContent());
    BottomRightLongitude = str2num(xmlDoc.getElementsByTagName('BottomRightLongitude').item(0).getTextContent());
    BottomLeftLatitude = str2num(xmlDoc.getElementsByTagName('BottomLeftLatitude').item(0).getTextContent());
    BottomLeftLongitude = str2num(xmlDoc.getElementsByTagName('BottomLeftLongitude').item(0).getTextContent());
    S(1).Geometry = 'Polygon';
    %     S(1).BoundingBox=[116,29; 117,28];
    S(1).X = [TopLeftLongitude,BottomLeftLongitude,BottomRightLongitude,TopRightLongitude,TopLeftLongitude, NaN]; % 经度 lon
    S(1).Y = [TopLeftLatitude,BottomLeftLatitude,BottomRightLatitude,TopRightLatitude,TopLeftLatitude, NaN]; % 纬度 lat
    S(1).Id = 1; %除了以上的几个关键字段，还得有至少一个额外的字段，不然不能生成dbf文件
    for index_point_sources_detected_by_satellite = 1:length(satellite) % 卫星点源的序号
        point_source_lon = satellite(index_point_sources_detected_by_satellite).X;
        point_source_lat = satellite(index_point_sources_detected_by_satellite).Y;
        [in,on] = inpolygon(point_source_lon,point_source_lat,S(1).X',S(1).Y');
        if in
            overpass_number(index_point_sources_detected_by_satellite,1) = overpass_number(index_point_sources_detected_by_satellite,1) + 1;
        end
    end
end

load('Q_shoudong_from_GEOS')
detected_number = sum(double(Q_total>0))';
plot([detected_number overpass_number])

persistence = detected_number ./ overpass_number;
save('persistence.mat','persistence')
save('overpass_number.mat','overpass_number')


%% 绘制过境图
clc;clear;
satellite_name = 'detected_point_sources_from_GEOS.shp';
satellite = shaperead(satellite_name);
all_path = 'H:\裴志鹏\GF5B_shanxi\';
all_path_list = dir(all_path);
for index_all_path_list = 3:length(all_path_list)
    filepath = [all_path,all_path_list(index_all_path_list).name,'\'];
    shp_name = dir([filepath,'*.shp']);
    shp_filepath = [filepath,shp_name(1).name];
    shp_boundry(index_all_path_list - 2 ,1) = shaperead(shp_filepath);
end
shapewrite(shp_boundry,'shp_boundry.shp'); %生成shp，dbf，shx三个文件


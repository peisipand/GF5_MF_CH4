clc;clear;
%% 更新python py文件
% cd('georpc')
% clear classes
% obj = py.importlib.import_module('geo_rpc_copy');
% py.importlib.reload(obj);
% cd('F:\博士\山西煤矿调查\代码\Step2_浓度增强反演')
emitter_file = 'F:\博士\高光谱甲烷识别\匹配滤波正规代码\subfolders.xlsx';
[~,~,emitter_data] = xlsread(emitter_file); % 第一列是数值 第二列是字符  第三列啥都有
emitter_data = emitter_data(4:156,:);
t=tic;
for i = 125:125 %5: size(emitter_data,1)
    if emitter_data{i,3} > 0
        sn = 'GF5B';
        method = 'MF'; % or ILMF
%         load('mat_data_GF5B\Esun'); % 用来制作云掩膜
        all_path = 'H:\裴志鹏\GF5B_shanxi\';
        out_path = 'F:\博士\山西煤矿调查\代码\Step2_浓度增强反演\output_data\';
        filepath = [all_path,emitter_data{i,1},'\'];
        % filepath = 'H:\裴志鹏\GF5B_shanxi\GF5B_AHSI_E113.2_N36.3_20221208_006658_L10000252104\';
        filelist_SWIR = dir([filepath,'\*SW.tif']);
        filelist_SWIR_rpb = dir([filepath,'\*SW.rpb']);
        filelist_VNIR = dir([filepath,'\*VN.tif']);
        filelist_xml = dir([filepath,'\*xml']);
        filelist_swir_fwhm = dir([filepath,'\*Spectralresponse_SWIR.raw']);
        filelist_swir_rad = dir([filepath,'\*RadCal_SWIR.raw']);
        filelist_vnir_fwhm = dir([filepath,'\*Spectralresponse_VNIR.raw']);
        filelist_vnir_rad = dir([filepath,'\*RadCal_VNIR.raw']);
        for s = 1:length(filelist_SWIR)
            filename_SWIR = [filepath,filelist_SWIR(s).name];
            filename_SWIR_rpb = [filepath,filelist_SWIR_rpb(s).name];
            filename_VNIR = [filepath,filelist_VNIR(s).name];
            xmlDoc = xmlread([filepath,filelist_xml(s).name]);   % 读取xml
            StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent());% 观测时间
            year = StartTime(1:4);
            month = StartTime(6:7);
            day = StartTime(9:10);
            hour = StartTime(12:13); %中国时间
            hour = num2str(str2double(hour) - 8); %转成UTC时间
            if length(hour) == 1
                hour = ['0',hour];
            end
            filename_swir_fwhm = [filepath,filelist_swir_fwhm(s).name];
            filename_swir_rad = [filepath,filelist_swir_rad(s).name];
            filename_vnir_fwhm = [filepath,filelist_vnir_fwhm(s).name];
            filename_vnir_rad = [filepath,filelist_vnir_rad(s).name];
            swir_rad_cal = read_GF_raw(filename_swir_rad);
            vnir_rad_cal = read_GF_raw(filename_vnir_rad);
            FWHM_SWIR = read_GF_raw(filename_swir_fwhm);
            FWHM_VNIR = read_GF_raw(filename_vnir_fwhm);
            %% 数据读取,并辐射定标
            [swir,R_SWIR] = readgeoraster(filename_SWIR);
            [vnir,R_VNIR] = readgeoraster(filename_VNIR);
            swir = double(swir);
            vnir = double(vnir);
            %     geotiffwrite('gdal.tif',swir(:,:,1),R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);
            [a,b,c] = size(swir); % 2106*2009*180
            swir = reshape(swir,a * b,c);
            [d,e,f] = size(vnir);
            vnir = reshape(vnir,d * e,f);
            %高分5 辐射定标
            swir = swir .* repmat(swir_rad_cal(:,1)',a * b,1);
            vnir = vnir .* repmat(vnir_rad_cal(:,1)',d * e,1);
            %% 算k
            wavelength_ch4 = [2122,2488];  %选取2110-2450 nm窗口进行匹配滤波器检索
            [~,wavelength_ch4_index] = min(abs(wavelength_ch4 - FWHM_SWIR(:,1)));
            band_start = min(wavelength_ch4_index);
            band_end = max(wavelength_ch4_index);
            cw = FWHM_SWIR(band_start:band_end,1);
            fwhm = FWHM_SWIR(band_start:band_end,2);
            cd('./../Step1_计算k')
            k = calc_k(cw,fwhm,sn);
%             plot(cw,k)
            cd('./../Step2_浓度增强反演')
%             if exist(['k_',sn,'.mat'],'file')
%                 load(['k_',sn]);
%                 disp(['读取k_',sn]);
%             end
%             if ~exist(['k_',sn,'.mat'],'file')
%                 k = calc_k(cw,fwhm,sn);
%                 disp(['生成k_',sn]);
%             end
            sza = str2num(xmlDoc.getElementsByTagName('SolarZenith').item(0).getTextContent());% 太阳天顶角
            amf = double(1 + 1 / cos(sza / 180 * pi));
            k = k / 2 * amf;
            %% 生成干扰地物掩膜
            % 生成云掩膜
            %引用“高分五号可见短波红外高光谱影像云检测研究”
            %D为儒略日期   间接来表示天文单位表示的日地平均距离
            %     date = datetime(char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()));
            %     D = juliandate(date);
            %     dist_sun_earth = (1 + 0.0167*sin(2*pi*(D-93.5)/365)); %日地平均距离
            %     Esun = repmat(Esun,1,a*b)';
            %     %合并为对应的一个宽波段数据
            %     %T1波段 433~471nm (第11~第20波段)
            %     p = (pi * vnir(:,11:20) * dist_sun_earth^2) ./ (Esun(:,11:20) * cos(pi * sza / 180));%p为大气顶层的表观反射率(各像素，各波段)
            %     T1 = (p * diff(FWHM_VNIR(11:21,1))) / (FWHM_VNIR(21,1) - FWHM_VNIR(11,1));
            %     %T2波段 510~640nm(第30~第60波段)
            %     p = (pi * vnir(:,30:60) * dist_sun_earth^2) ./ (Esun(:,30:60) * cos(pi * sza / 180));%p为大气顶层的表观反射率(各像素，各波段)
            %     T2 = (p * diff(FWHM_VNIR(30:61,1))) / (FWHM_VNIR(61,1) - FWHM_VNIR(30,1));
            %     %T3波段 1350~1360nm(第192波段)   卷云波段(1360~1390 nm)
            %     p = (pi * swir(:,192-150) * dist_sun_earth^2) ./ (Esun(:,192) * cos(pi * sza / 180));%p为大气顶层的表观反射率(各像素，各波段)
            %     T3 = p;
            %     %T4波段 2000nm(第270~第272波段)
            %     p = (pi * swir(:,270-150:272-150) * dist_sun_earth^2) ./ (Esun(:,270:272) * cos(pi * sza / 180));%p为大气顶层的表观反射率(各像素，各波段)
            %     T4 = (p * diff(FWHM_SWIR(270-150:272-150+1,1))) / (FWHM_SWIR(272-150+1,1) - FWHM_SWIR(270-150,1));
            %     mask_cloud = double(((T1 > 0.3) & (T2 > 0.3)) | (((T3 > 0.04) & (T1 > 0.15)) & ((T1 ./ T4 > 7.5) & (T4 ./ T3 < 1))));
            %     % mask = reshape(mask,a,b);
            %     % imagesc(mask)
            %     mask_cloud(mask_cloud == 1) = nan;
            %     mask_cloud(mask_cloud == 0) = 1;
            %     M = repmat(mask_cloud,1,180); %复制列
            %     swir = swir .* M;
%             swir = reshape(swir,a,b,c);
%             vnir = reshape(vnir,d,e,f);
%             %识别太阳能板
%             data = cat(3,vnir, swir);
%             swir = reshape(swir,a * b,c);
%             vnir = reshape(vnir,d * e,f);
%             [x,y,z] = size(data);
%             mask2 = ones(x,y);
%             NDTI = (data(:,:,211) - data(:,:,237)) ./ (data(:,:,211) + data(:,:,237));
%             NDTI_threshold = find_threshold(NDTI, 1, 1500);
%             mask2(find(NDTI > NDTI_threshold)) = 0;
%             mask2 = medfilt2(mask2, [3 3]);
%             mask2 = reshape(mask2,x*y,1);
%             %识别水体
%             mask3 = ones(x,y);
%             NDWI = (data(:,:,222) - data(:,:,38)) ./ (data(:,:,222) + data(:,:,38));
%             NDWI_threshold = find_threshold(NDWI, 2, 20000);
%             mask3(find(NDWI < NDWI_threshold & NDWI_threshold < -0.9)) = 0;
%             figure
%             imshow(reshape(mask3,a,b));
%             mask3 = reshape(mask3,x*y,1);
%             %识别阴影
%             red = data(:,:,60);
%             green = data(:,:,39);
%             blue = data(:,:,20);
%             nir = data(:,:,111);
%             C1 = atan(green ./ max(red, blue));
%             C2 = atan(red ./ max(green, blue));
%             C3 = atan(blue ./ max(red, green));
%             %阴影
%             mask4 = ones(x,y);
%             mask4(find(C1 < 0.7 & C2 < 0.6 & C3 > 0.8 & nir < 36 & red < 35 & blue < 55 & green < 45 & reshape(mask3,x,y,1) == 1)) = 0;
%             mask4 = medfilt2(mask4, [3 3]);
%             figure
%             imshow(reshape(mask4,a,b));
%             mask4 = reshape(mask4,x*y,1);
%             %识别大棚、人工草坪
%             mask5 = ones(x,y);
%             NDDPI = ((data(:,:,236) - data(:,:,237)) ./ (data(:,:,236) + data(:,:,237))) - ((data(:,:,237) - data(:,:,239)) ./ (data(:,:,237) + data(:,:,239)));
%             NDDPI_threshold = find_threshold(NDDPI, 3, 5000); %1500为直方图阈值
%             mask5(find(NDDPI > NDDPI_threshold)) = 0;
%             figure
%             imshow(reshape(mask5,a,b));
%             mask5 = reshape(mask5,x*y,1);
%             %图像掩膜
%             mask = ones(x*y,1);
%             mask(find(mask2 == 0 | mask3 == 0 | mask4 == 0 | mask5 == 0)) = 0;
%             figure
%             imshow(reshape(mask,a,b));
%             M_swir = repmat(mask,1,180); %复制列
%             swir = swir .* M_swir;
%             swir = reshape(swir,a,b,c);
%             mask = reshape(mask,x,y);
%             
            %%
            swir = reshape(swir,a,b,c);
            result = zeros(a,b);
            swir = swir(:,:,band_start:band_end);
            % MF和ILMF选一个
            switch method
                case 'MF'
                    disp('使用MF算法');
                    [result,likehold] = MF(swir,k); % MF
                case 'ILMF'
                    disp('使用ILMF算法');
                    [result,likehold] = ILMF(swir,k); % ILMF
                otherwise
                    disp('请检查method');
            end
            % mask = reshape(mask,a,b);
            % result = result .* mask;
            % result(result <= 0) = 0;
            
            mask_likehold = likehold > 5;
            unenhanced_std = nanstd(result(:)); % in ppb
     
            % imagesc(result .* mask_filter )
            % caxis([0 1200]);
            %
            % imagesc(result .* mask_filter .* mask_likehold)
            % caxis([0 1200]);
            disp('处理完成');
            
            %% 准备风速数据
%             StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent());% 观测时间
%             year_str = StartTime(1:4);
%             month_str = StartTime(6:7);
%             numMonth = str2double(month_str);
%             monthAbbrev = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', ...
%                 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
%             % 将数字月份转换为相应的月份缩写
%             monthAbbrevName = monthAbbrev{numMonth};
%             day_str = StartTime(9:10);
%             hour_str = StartTime(12:13);
%             % GF5B 是中国时间 utc+8
%             hour_int = str2double(hour_str) - 8;
%             hour_str = sprintf('%02d', hour_int);
%             %     disp([year_str,month_str,day_str,hour_str]);
%             filename_wind =['F:\博士\高光谱甲烷识别\匹配滤波正规代码\wind_data\',year_str,monthAbbrevName,day_str,hour_str,'.nc4']; % 下载：https://portal.nccs.nasa.gov/cgi-lats4d/webform.cgi?&i=GEOS-5/fp/0.25_deg/assim/tavg1_2d_slv_Nx
%             if ~exist(filename_wind,'file')
%                 disp('正在下载GEOS-5风速数据...');
%                 URL = ['https://portal.nccs.nasa.gov/cgi-lats4d/webform.cgi?i=GEOS-5%2Ffp%2F0.25_deg%2Fassim%2Ftavg1_2d_slv_Nx&vars=v10m&vars=u10m&',...
%                     'year=',year_str,'&month=',monthAbbrevName,'&day=',day_str,'&hour=',hour_str,...
%                     '&yearend=',year_str,'&monthend=',monthAbbrevName,'&dayend=',day_str,'&hourend=',hour_str,...
%                     '&ntimes=1&tincr=1&levsbegin=1&levsend=1&levsinput=&selectedBaseLayer=&OpenLayers.Control.LayerSwitcher_26_baseLayers=OpenLayers+WMS&interactionType=box&',...
%                     'NorthLatitude=90&WestLongitude=-180&EastLongitude=180.0&SouthLatitude=-90&West=&North=&East=&South=&area=&regridmask=geos0.25&regridmethod=&format=netcdf&service=Download'];
%                 %         urlwrite(URL, filename_wind);
%                 disp('下载完成');
%             end
            %% 红绿蓝波段导出
            wavelength_RGB = [460, 550,640]; % 红色640nm  绿色550nm   蓝色460nm
            [~,wavelength_RGB_index] = min(abs(wavelength_RGB - FWHM_VNIR(:,1)));
            vnir = reshape(vnir,d, e,f);
            rgb = vnir(:,:,wavelength_RGB_index);
            result(isnan(result)) = 0;
            result(isinf(result)) = 0;
            all = cat(3,rgb,result);
            alpha_fanzhuan = flipud(all);
            %% 几何精校正
            Ref=georasterref('RasterSize',[a,b],'Latlim',[-90,90],'Lonlim',[-180,180]);
            OutfileName = [out_path,filelist_SWIR(s).name,'temptif.tif'];
            OutputName = [out_path,filelist_SWIR(s).name,'GDAL_GCP校正.tif'];
            geotiffwrite(OutfileName,alpha_fanzhuan, Ref);
            cd('georpc')
            py.geo_GCP.geoGCP(OutfileName,OutputName,filename_SWIR_rpb)
            %     geotiffwrite(['G:\GF5B\result\',filelist_SWIR(s).name,'_',method,'_','u',num2str(u10_point),'_','v',num2str(v10_point),'几何校正4.tif'],alpha_fanzhuan,R);
%             delete(OutfileName);
            cd('F:\博士\山西煤矿调查\代码\Step2_浓度增强反演')
            disp('几何校正完成');
        end
    end
end
etime=toc(t);
disp(etime);


Q_11 = result(880:950,1540:1590);
Q_11(Q_11 < 0) = 0;
omega_a = 1.0374e4;
[wind_speed,u10,v10] = get_wind_speed_from_GEOS(year,month,day,hour,36.26286596,112.91910404);
[Q,mask] = func_IME(Q_11, omega_a, wind_speed,unenhanced_std)

[wind_speed,mass_of_atmos,u10,v10] = get_wind_speed_from_EC(year,month,day,hour,36.26286596,112.91910404);


%% 看光谱
imagesc(result)
caxis([0 800])
result(1079,991)
result(1072,999)
plot(cw,[permute(swir(1074,996,:),[3 2 1]) permute(swir(1072,999,:),[3 2 1])]);
plot(cw,permute(swir(1074,996,:),[3 2 1]) ./ permute(swir(1072,999,:),[3 2 1]));
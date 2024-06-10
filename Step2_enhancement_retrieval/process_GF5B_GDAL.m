clc;clear;
%% This part is for geometric correction
cd('georpc')
clear classes
obj = py.importlib.import_module('geo_rpc_copy');
py.importlib.reload(obj);
cd('..')
%% This part is for MF or ILMF
emitter_file = '.\..\subfolders.xlsx';
[~,~,emitter_data] = xlsread(emitter_file); 
emitter_data = emitter_data(4:156,:);
t = tic;
for i = 1:size(emitter_data,1)
    if emitter_data{i,3} > 0 % This image has point sources
        sn = 'GF5B';
        method = 'MF'; % or ILMF
        %       load('mat_data_GF5B\Esun'); % for cloud mask
        all_path = 'H:\裴志鹏\GF5B_shanxi\'; % my GF5B data path
        out_path = 'F:\博士\山西煤矿调查\GRL\code\GF5_MF_CH4\Step2_enhancement_retrieval\output_data\';
        filepath = [all_path,emitter_data{i,1},'\'];
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
            xmlDoc = xmlread([filepath,filelist_xml(s).name]);   % read xml
            StartTime = char(xmlDoc.getElementsByTagName('StartTime').item(0).getTextContent()); % observation time
            year = StartTime(1:4);
            month = StartTime(6:7);
            day = StartTime(9:10);
            hour = StartTime(12:13); % china time
            hour = num2str(str2double(hour) - 8); % change to utc
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
            %% radiometric calibration
            [swir,R_SWIR] = readgeoraster(filename_SWIR);
            [vnir,R_VNIR] = readgeoraster(filename_VNIR);
            swir = double(swir);
            vnir = double(vnir);
            [a,b,c] = size(swir); % 2106*2009*180
            swir = reshape(swir,a * b,c);
            [d,e,f] = size(vnir);
            vnir = reshape(vnir,d * e,f);
            swir = swir .* repmat(swir_rad_cal(:,1)',a * b,1);
            vnir = vnir .* repmat(vnir_rad_cal(:,1)',d * e,1);
            %% calc k
            wavelength_ch4 = [2122,2488];  % retrieval window
            [~,wavelength_ch4_index] = min(abs(wavelength_ch4 - FWHM_SWIR(:,1)));
            band_start = min(wavelength_ch4_index);
            band_end = max(wavelength_ch4_index);
            cw = FWHM_SWIR(band_start:band_end,1);
            fwhm = FWHM_SWIR(band_start:band_end,2);
            cd('./../Step1_calculate_k')
            k = calc_k(cw,fwhm,sn);
            %             plot(cw,k)
            cd('./../Step2_enhancement_retrieval')
            %             if exist(['k_',sn,'.mat'],'file')
            %                 load(['k_',sn]);
            %                 disp(['读取k_',sn]);
            %             end
            %             if ~exist(['k_',sn,'.mat'],'file')
            %                 k = calc_k(cw,fwhm,sn);
            %                 disp(['生成k_',sn]);
            %             end
            sza = str2num(xmlDoc.getElementsByTagName('SolarZenith').item(0).getTextContent());
            amf = double(1 + 1 / cos(sza / 180 * pi));
            k = k / 2 * amf;
            %% Mask designed for special surfaces
            % 生成云掩膜
            % 引用“高分五号可见短波红外高光谱影像云检测研究”
            % D为儒略日期   间接来表示天文单位表示的日地平均距离
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
            % MF or ILMF
            switch method
                case 'MF'
                    disp('using MF');
                    [result,likehold] = MF(swir,k); % MF
                case 'ILMF'
                    disp('using ILMF');
                    [result,likehold] = ILMF(swir,k); % ILMF
                otherwise
                    disp('please check method');
            end
            % mask = reshape(mask,a,b);
            % result = result .* mask;
            % result(result <= 0) = 0;
            
            mask_likehold = likehold > 5;
            unenhanced_std = nanstd(result(:)); % in ppb
            disp([method,' done']);
            %% export RGB
            wavelength_RGB = [460, 550,640]; % RED:640nm  GREEN:550nm  BLUE:460nm
            [~,wavelength_RGB_index] = min(abs(wavelength_RGB - FWHM_VNIR(:,1)));
            vnir = reshape(vnir,d, e,f);
            rgb = vnir(:,:,wavelength_RGB_index);
            result(isnan(result)) = 0;
            result(isinf(result)) = 0;
            all = cat(3,rgb,result);
            alpha_flipud = flipud(all);
            %% geometric correction
            Ref=georasterref('RasterSize',[a,b],'Latlim',[-90,90],'Lonlim',[-180,180]);
            OutfileName = [out_path,filelist_SWIR(s).name,'temptif.tif'];
            OutputName = [out_path,filelist_SWIR(s).name,'GDAL_GCP校正.tif'];
            geotiffwrite(OutfileName,alpha_flipud, Ref);
            cd('georpc')
            py.geo_GCP.geoGCP(OutfileName,OutputName,filename_SWIR_rpb)
            %     geotiffwrite(['G:\GF5B\result\',filelist_SWIR(s).name,'_',method,'_','u',num2str(u10_point),'_','v',num2str(v10_point),'几何校正4.tif'],alpha_fanzhuan,R);
            delete(OutfileName); % Delete temporary files
            cd('..')
            disp('geometric correction done');
        end
    end
end
etime=toc(t);
disp(etime); % print run time

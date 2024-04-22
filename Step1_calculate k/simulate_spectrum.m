%% 绘制PRISMA的光谱
clc;clear
load('radiance_in_wv_total') % modtran模拟，farm土地类型
load('wavenumber')
wavelength = 1e7 ./ wavenumber;
filename = 'F:\博士\高光谱甲烷识别\最开始的工作\数据\山西5\PRS_L1_STD_OFFL_20210206031837_20210206031842_0001.he5';
List_Cw_Swir = h5readatt(filename,'/','List_Cw_Swir');
List_Fwhm_Swir = h5readatt(filename,'/','List_Fwhm_Swir');
% 反演窗口
wavelength_ch4 = [2095,2450];
[~,wavelength_ch4_index] = min(abs(wavelength_ch4 - List_Cw_Swir));
band_start = min(wavelength_ch4_index);
band_end = max(wavelength_ch4_index);
cw = double(List_Cw_Swir(band_start:band_end,:));
fwhm = double(List_Fwhm_Swir(band_start:band_end,:));
%% 绘制高分辨率光谱
plot(wavelength,radiance_in_wv_total )
xlabel("nm")
ylabel("mW/m2/sr/nm")
%% 绘制PRISMA光谱，浓度分别是 1.9 2.9 3.9 4.9 ppm
for i = 1:4
    convolved_result(:,i) = convolv(wavenumber,radiance_in_wv_total(:,i),cw,fwhm);
end
plot(cw,convolved_result)
xlabel("nm")
ylabel("mW/m2/sr/nm")
%% 生成并绘制k
k = calc_k(cw,fwhm,'PRISMA');
plot(cw,k)
xlabel("nm")
ylabel("Unit absorption (ppb)-1")



%% 绘制GF5B的光谱
clc;clear
load('radiance_in_wv_total') % modtran模拟，farm土地类型
load('wavenumber')
wavelength = 1e7 ./ wavenumber;
filename_swir_fwhm = 'H:\裴志鹏\GF5B_shanxi\GF5B_AHSI_E110.5_N37.2_20220615_004094_L10000182401\GF5B_AHSI_Spectralresponse_SWIR.raw';
FWHM_SWIR = read_GF_raw(filename_swir_fwhm); % 第一列为中心波长，第二列为半宽
List_Cw_Swir = FWHM_SWIR(:,1);
List_Fwhm_Swir = FWHM_SWIR(:,2);
% 反演窗口
wavelength_ch4 = [2095,2450];
[~,wavelength_ch4_index] = min(abs(wavelength_ch4 - List_Cw_Swir));
band_start = min(wavelength_ch4_index);
band_end = max(wavelength_ch4_index);
cw = double(List_Cw_Swir(band_start:band_end,:));
fwhm = double(List_Fwhm_Swir(band_start:band_end,:));
%% 绘制高分辨率光谱
plot(wavelength,radiance_in_wv_total )
xlabel("nm")
ylabel("mW/m2/sr/nm")
%% 绘制PRISMA光谱，浓度分别是 1.9 2.9 3.9 4.9 ppm
for i = 1:4
    convolved_result(:,i) = convolv(wavenumber,radiance_in_wv_total(:,i),cw,fwhm);
end
plot(cw,convolved_result)
xlabel("nm")
ylabel("mW/m2/sr/nm")
%% 生成并绘制k
k = calc_k(cw,fwhm,'GF5B');
plot(cw,k)
xlabel("nm")
ylabel("Unit absorption (ppb)-1")

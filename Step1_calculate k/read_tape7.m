% 读MODTRAN的输入，生成 radiance_in_wv_total.mat
clc;clear;
start_wn = 3846;
end_wn = 6667;
radiance_in_wv_total = zeros(end_wn-start_wn +1,4);
for i = 1:4
    filename = ['tape7_',num2str(i),'.9ppm'];
    fid = fopen(filename,'r');
    all = {'FREQ','TOT TRANS','PTH THRML','THRML SCT','SURF EMIS','SOL SCAT','SING SCAT','GRND RFLT','DRCT RFLT','TOTAL RAD','REF SOL','SOL@OBS','DEPTH'};
    data = [];
    if fid<0
        warndlg('打开文件失败!');
        return;
    else
        FormatString=['%s ' repmat('%f ',1,12)]; %共13列，第一列是字符，后面12列是数字
        temp = textscan(fid,FormatString,end_wn-start_wn +1,'HeaderLines',11); %跳过前11行，读取
        a = cell2mat(temp(:,2:13));
        data = [data;a];
    end
    % msgbox('文件读取成功！');
    fclose(fid);
    data = [(3846:1:6667)' data];
    %
    % plot(data(:,1),[sum(data(:,8),2)-data(:,10)])  % 第10列是 TOTAL RADIANCE
    % plot(data(:,1),data(:,10))  % 第10列是 TOTAL RADIANCE
    
    %%
    % radiance 单位的变换，一开始的单位是 W/cm2/sr/cm-1,需要换成 mW/m2/sr/nm
    wavenumber = data(:,1);
    wavelength = 1e7 ./ wavenumber;
    radiance_in_wn = data(:,10);
    radiance_in_wv = radiance_in_wn .* wavenumber ./ wavelength;   % in W/cm2/sr/nm
    radiance_in_wv = radiance_in_wv .* 1e7; % in mW/m2/sr/nm
    radiance_in_wv_total(:,i) = radiance_in_wv;
end

%% 绘制高分辨的光谱
plot(wavelength,radiance_in_wv_total )
xlabel("nm")
ylabel("mW/m2/sr/nm")
save('wavenumber.mat','wavenumber')
save('radiance_in_wv_total.mat','radiance_in_wv_total')






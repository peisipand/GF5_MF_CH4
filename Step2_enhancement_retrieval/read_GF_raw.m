function [result] = read_GF_raw(filename)
% 函数说明
% 读GF卫星的中心波长、半宽、辐射校正系数
fid = fopen(filename,'r');
FormatString=repmat('%f ',1,2);
result = cell2mat(textscan(fid,FormatString,180,'HeaderLines',0,'Delimiter',','));
fclose(fid);
end


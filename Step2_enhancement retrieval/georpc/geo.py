import geo_rpc_copy

rpc = geo_rpc_copy.read_rpc_file("G:\BaiduNetdiskDownload\大庆高分五\GF5B_AHSI_E124.8_N46.6_20230111_007153_L10000270864.tar\GF5B_AHSI_E124.8_N46.6_20230111_007153_L10000270864\GF5B_AHSI_E124.8_N46.6_20230111_007153_L10000270864_SW.rpb")

#取一个在该rpc范围内的经纬度，并假定一个高程值
# lon, lat ,h  = 112.961403969,34.452284651 ,100
rows = 2009
cols = 2110
h = 0
#测试正投影
# rows ,cols = rpc.projection(lon, lat ,h )
# print (" rows and cols : ", rows ,cols )
#测试反投影
lon ,lat = rpc.localization(rows ,cols ,h )
print ( " lon and lat : ", lon, lat)
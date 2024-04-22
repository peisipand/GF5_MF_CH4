# def geoGCP(dataFilename, outGeoName, rpcFileName):
from osgeo import gdal
from osgeo import osr
import geo_rpc_copy

dataFilename = r'H:\裴志鹏\GF5B_shanxi\GF5B_AHSI_E110.5_N37.2_20220615_004094_L10000182401\GF5B_AHSI_E110.5_N37.2_20220615_004094_L10000182401_SW.tif'
# dataFilename = r'F:\迅雷下载\GF5A_AHSI_W103.3_N31.8_20230312_001372_L10000016405.tar\GF5A_AHSI_W103.3_N31.8_20230312_001372_L10000016405\GF5A_AHSI_W103.3_N31.8_20230312_001372_L10000016405_SW.tif'
outGeoName = dataFilename.strip('.tif') + 'GDAL几何校正2.tif'
# rpcFileName = dataFilename.strip('.tif') + '.rpb'
rpcFileName = r'H:\裴志鹏\GF5B_shanxi\GF5B_AHSI_E110.5_N37.2_20220615_004094_L10000182401\GF5B_AHSI_E110.5_N37.2_20220615_004094_L10000182401_SW.rpb'
dataset = gdal.Open(dataFilename, gdal.GA_Update)
# 实际控制点肯定要多的多，这里只写了四个点.
rpc = geo_rpc_copy.read_rpc_file(rpcFileName)

rows = dataset.RasterXSize
cols = dataset.RasterYSize
TLlon, TLlat = rpc.localization(0, 0, 0)
TRlon, TRlat = rpc.localization(rows-1, 0, 0)
BLlon, BLlat = rpc.localization(0, cols-1, 0)
BRlon, BRlat = rpc.localization(rows-1, cols-1, 0)
Clon, Clat = rpc.localization(int(round(rows/2)-1), int(round(cols/2)-1), 0)
Qlon41, Qlat41 = rpc.localization(int(round(rows/4)-1), int(round(cols/4)-1), 0)
Qlon43, Qlat43 = rpc.localization(int(round(rows*3/4)-1), int(round(cols*3/4)-1), 0)
Qlon41_43, Qlat41_43 = rpc.localization(int(round(rows/4)-1), int(round(cols*3/4)-1), 0)
Qlon43_41, Qlat43_41 = rpc.localization(int(round(rows*3/4)-1), int(round(cols/4)-1), 0)
Qlon21_41, Qlat21_41 = rpc.localization(int(round(rows/2)-1), int(round(cols/4)-1), 0)
Qlon21_43, Qlat21_43 = rpc.localization(int(round(rows/2)-1), int(round(cols*3/4)-1), 0)
Qlon41_21, Qlat41_21 = rpc.localization(int(round(rows/4)-1), int(round(cols/2)-1), 0)
Qlon43_21, Qlat43_21 = rpc.localization(int(round(rows*3/4)-1), int(round(cols/2)-1), 0)

# # rows ,cols = rpc.projection(lon, lat ,h )
# # print (" rows and cols : ", rows ,cols )
# #测试反投影
# lon ,lat = rpc.localization(rows ,cols ,h )
# print ( " lon and lat : ", lon, lat)


# gcps = [gdal.GCP(TLlon, TLlat, 0, 3, 0),
#         gdal.GCP(TRlon, TRlat, 0, rows+2, 0),
#         gdal.GCP(BLlon, BLlat, 0, 3, cols-1),
#         gdal.GCP(BRlon, BRlat, 0, rows+2, cols-1),
#         gdal.GCP(Qlon41, Qlat41, 0, int(round(rows/4)+2), int(round(cols/4))-1),
#         gdal.GCP(Qlon43, Qlat43, 0, int(round(rows*3/4)+2), int(round(cols*3/4))-1),
#         gdal.GCP(Clon, Clat, 0, int(round(rows/2)+2), int(round(cols/2))-1),
#         gdal.GCP(Qlon41_43, Qlat41_43, 0, int(round(rows/4)+2), int(round(cols*3/4))-1),
#         gdal.GCP(Qlon43_41, Qlat43_41, 0, int(round(rows*3/4)+2), int(round(cols/4))-1),
#         gdal.GCP(Qlon21_41, Qlat21_41, 0, int(round(rows/2)+2), int(round(cols/4))-1),
#         gdal.GCP(Qlon21_43, Qlat21_43, 0, int(round(rows/2)+2), int(round(cols*3/4))-1),
#         gdal.GCP(Qlon41_21, Qlat41_21, 0, int(round(rows/4)+2), int(round(cols/2))-1),
#         gdal.GCP(Qlon43_21, Qlat43_21, 0, int(round(rows*3/4)+2), int(round(cols/2))-1),
#         ]
gcps = [gdal.GCP(TLlon, TLlat, 0, 0, 0),
        gdal.GCP(TRlon, TRlat, 0, rows-1, 0),
        gdal.GCP(BLlon, BLlat, 0, 0, cols-1),
        gdal.GCP(BRlon, BRlat, 0, rows-1, cols-1),
        gdal.GCP(Qlon41, Qlat41, 0, int(round(rows/4)-1), int(round(cols/4))-1),
        gdal.GCP(Qlon43, Qlat43, 0, int(round(rows*3/4)-1), int(round(cols*3/4))-1),
        gdal.GCP(Clon, Clat, 0, int(round(rows/2)-1), int(round(cols/2))-1),
        gdal.GCP(Qlon41_43, Qlat41_43, 0, int(round(rows/4)-1), int(round(cols*3/4))-1),
        gdal.GCP(Qlon43_41, Qlat43_41, 0, int(round(rows*3/4)-1), int(round(cols/4))-1),
        gdal.GCP(Qlon21_41, Qlat21_41, 0, int(round(rows/2)-1), int(round(cols/4))-1),
        gdal.GCP(Qlon21_43, Qlat21_43, 0, int(round(rows/2)-1), int(round(cols*3/4))-1),
        gdal.GCP(Qlon41_21, Qlat41_21, 0, int(round(rows/4)-1), int(round(cols/2))-1),
        gdal.GCP(Qlon43_21, Qlat43_21, 0, int(round(rows*3/4)-1), int(round(cols/2))-1),
        ]
sr = osr.SpatialReference()
sr.SetWellKnownGeogCS('WGS84')
# 添加控制点
dataset.SetGCPs(gcps, sr.ExportToWkt())
# tps校正 重采样:线性插值法
dst_ds = gdal.Warp(outGeoName, dataset, format='GTiff', tps=True,
                   resampleAlg=gdal.GRIORA_NearestNeighbour, outputType=gdal.GDT_Float64)
# xres= 0.332980027169718, yres=0.469555687731528,  dstNodata=-9999, srcNodata=-9999,width=rows, height=cols,
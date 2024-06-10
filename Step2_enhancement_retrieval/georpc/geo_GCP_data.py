def geoGCP(dataset, outGeoName, rpcFileName):
    from osgeo import gdal
    from osgeo import osr
    import geo_rpc_copy

    # dataFilename = r'H:\匹配滤波正规代码-230515\jihejiaoz.tif'
    # outGeoName = dataFilename.strip('.tif') + 'GDAL几何校正.tif'
    # rpcFileName = r'G:\BaiduNetdiskDownload\大庆高分五\GF5B_AHSI_E124.8_N46.6_20230111_007153_L10000270864.tar\GF5B_AHSI_E124.8_N46.6_20230111_007153_L10000270864\GF5B_AHSI_E124.8_N46.6_20230111_007153_L10000270864_SW.rpb'
    # dataset = gdal.Open(data, gdal.GA_Update)
    # 实际控制点肯定要多的多，这里只写了四个点.
    rpc = geo_rpc_copy.read_rpc_file(rpcFileName)

    rows = dataset.RasterXSize
    cols = dataset.RasterYSize
    TLlon, TLlat = rpc.localization(1, 1, 0)
    TRlon, TRlat = rpc.localization(rows, 1, 0)
    BLlon, BLlat = rpc.localization(1, cols, 0)
    BRlon, BRlat = rpc.localization(rows, cols, 0)
    # 取一个在该rpc范围内的经纬度，并假定一个高程值
    # lon, lat ,h  = 112.961403969,34.452284651 ,100
    # rows = 2009
    # cols = 1
    # h = 1
    # #测试正投影
    # # rows ,cols = rpc.projection(lon, lat ,h )
    # # print (" rows and cols : ", rows ,cols )
    # #测试反投影
    # lon ,lat = rpc.localization(rows ,cols ,h )
    # print ( " lon and lat : ", lon, lat)


    gcps = [gdal.GCP(TLlon, TLlat, 0, 1, 1),
            gdal.GCP(TRlon, TRlat, 0, rows, 1),
            gdal.GCP(BLlon, BLlat, 0, 1, cols),
            gdal.GCP(BRlon, BRlat, 0, rows, cols)]
    sr = osr.SpatialReference()
    sr.SetWellKnownGeogCS('WGS84')
    # 添加控制点
    dataset.SetGCPs(gcps, sr.ExportToWkt())
    # tps校正 重采样:线性插值法
    dst_ds = gdal.Warp(outGeoName, dataset, format='GTiff', tps=True,
                       width=rows, height=cols,
                       resampleAlg=gdal.GRIORA_Bilinear, outputType=gdal.GDT_Float64)
    # xres= 0.332980027169718, yres=0.469555687731528,  dstNodata=-9999, srcNodata=-9999,
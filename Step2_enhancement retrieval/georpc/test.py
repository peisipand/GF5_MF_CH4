import geo_GCP
dataFilename = r'F:\博士\山西煤矿调查\代码\Step2_浓度增强反演\output_data\GF5B_AHSI_E113.0_N36.3_20220504_003482_L10000124874_SW.tiftemptif.tif'
outGeoName = r'F:\博士\山西煤矿调查\代码\Step2_浓度增强反演\output_data\GF5B_AHSI_E113.0_N36.3_20220504_003482_L10000124874_SW.tif几何校正tif.tif'
rpcFileName = r'H:\裴志鹏\GF5B_shanxi\GF5B_AHSI_E113.0_N36.3_20220504_003482_L10000124874\GF5B_AHSI_E113.0_N36.3_20220504_003482_L10000124874_SW.rpb'

geo_GCP.geoGCP(dataFilename, outGeoName, rpcFileName)


This folder contains the files and code needed to convert ward polygons into reporting unit polygons.

## source

The file `WI_Municipal_Wards_November_2022.geojson` contains, as accurately as practical, all the wards used by local elections administrators in November 2022. I began with with the [July 2022 WI Municipal Wards](https://data-ltsb.opendata.arcgis.com/maps/wi-municipal-wards-july-2022-1/) file provided by the LTSB. Because of significant changes to ward boundaries between July and November, I replaced Dane, Rock, Waushara, and Jackson counties with new sets of polygons provided by county administrators.

## process

1. `ExtractWardsFromReportingUnits.R` identifies the individual wards included in each reporting unit. It outputs `WardsInRepUnits.csv`.
2. `MatchReportingUnitsToWardIDs.R` matches the individual wards to their corresponding WardID from the polygon file. It outputs `ReportingUnitsWithWardIDs.csv`.
3. `BuildReportingUnitPolygons.R` dissolves the individual ward polygons into larger reporting unit polygons. The output is `ReportingUnitPolygons.geojson`.

I have made extensive efforts to obtain updated ward boundaries where changes have been made, and I have manually renamed a number of mislabelled polygons. See `TechnicalDetails.md` for details. At this point, all votes cast in November 2022 are assigned a reporting unit polygon, but I cannot guarantee the absence of any errors. For instance, if a ward changed boundaries between July 2022 but retained the identical name, I would be unable to identify that from existing data sources.
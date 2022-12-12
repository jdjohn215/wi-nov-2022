# Errata

## Reporting Units

### changes

* The following municipality names were reformated as indicated:
  * "Grand View" = "Grandview"
  * "Fontana" = "Fontana-on-Geneva Lake"
  * "Land O-Lakes" = "Land O'Lakes"
  * "LaValle" = "La Valle"
  * "Saint Lawrence" = "St. Lawrence"
* The following two wards are named "ward 2" but only "ward 1" exists in the ward file. I believe this reflects different numbering schemes when a municipality straddles a county line.
  * Clark County VILLAGE OF UNITY Ward 2 is renamed Ward 1
  * Polk County VILLAGE OF TURTLE LAKE Ward 2 is renamed Ward 1
* Rock County City of Broadhead Wards 7 & 8 are renamed Rock County City of Brodhead Ward 1 to match the single Rock County City of Brodhead Ward existing in the polygon file

### failed matches

The following reporting units have no match in the ward polygons. No votes were cast in these wards, so I disregard them.
* EAU CLAIRE County - CITY OF EAU CLAIRE WARD 73
* LA CROSSE County - CITY OF LA CROSSE WARD 28
* WAUKESHA County - CITY OF BROOKFIELD WARD 22

A further 11 individual wards referenced in a multi-ward reporting unit have not match in the ward data. They are as follows.

| county  | reporting unit                              | missing ward  | registered voters |
|---------|---------------------------------------------|---------------|-------------------|
|BARRON     |CITY OF RICE LAKE WARDS 1-16               |16             |7                  |
|BURNETT    |TOWN OF WOOD RIVER WARDS 1-3               |3              |non-existent       |
|DODGE      |VILLAGE OF HUSTISFORD WARDS 1-2            |2              |332                |
|DODGE      |CITY OF WAUPUN WARDS 13-15                 |14             |non-existent       |
|DODGE      |CITY OF WAUPUN WARDS 13-15                 |15             |non-existent       |
|GREEN LAKE |CITY OF GREEN LAKE WARDS 1-4               |4              |non-existent       |
|JEFFERSON  |CITY OF FORT ATKINSON WARDS 1-12           |10             |non-existent       |
|JEFFERSON  |CITY OF FORT ATKINSON WARDS 1-12           |12             |1                  |
|ONEIDA     |TOWN OF STELLA WARDS 1-2                   |2              |non-existent       |
|ROCK       |CITY OF MILTON WARDS 1-11                  |11             |non-existent       |
|WINNEBAGO  |VILLAGE OF FOX CROSSING WARDS 10-12,18     |18             |non-existent       |

Only three of these individual wards include registered voters--a tiny number in the case of City of Rice Lake Ward 16 and City of Fort Atkinson Ward 12. Because the number of potential voters is so small, I'm comfortable simply assigning those votes to the area covered by the other matched ward polygons in their respective reporting units.

Village of Hustisford Ward 2 is a separate case. It includes 332 registered voters, and presumably a similarly high number of actual votes cast in Nov. 2022. According to the vote returns, Hustisford contains two wards. However, every available map I've found shows only 1 ward, covering the entire village of Hustisford. Because the two wards were combined into a single reporting unit, I'm confident that the area covered by "Village of Hustisford Wards 1-2" is equivalent to the polygon defined as "Village of Hustisford Ward 1" in the available ward polygon file.

## Wards

### changes

* The following counties were removed from the July 2022 file and replaced with an updated file obtained from county officials:
  * Dane County
  * Jackson County
  * Rock County
  * Waushara County
* A set of wards in Outagamie County are labelled "County subdivision not defined" but they use `MCD_FIPS == 5508731525`, which is the Village of Greenville. The name fields are updated to match this.
* A ward in Eau Claire county is labelled "County subdivision not defined" but is uses the `MCD_FIPS == 5503541525`, which is the Village of Lake Hallie. The name fields are updated to match this.
* The Village of Waukesha is incorrectly labelled a town in the ward file. This is fixed.
* The Village of Vernon is incorrectly labelled a town in the ward file. This is fixed.
* The Village of Solon Springs is incorrectly labelled the Town of Parkland (`OBJECTID == 1744`). This is fixed.
* Ward 2 in the Village of Sister Bay is incorrectly labelled ward 1 (`OBJECTID == 1677`). This is fixed.
* Ward 10 in the City of Sturgeon Bay is incorrectly labelled ward 6 (`OBJECTID == 1683`). This is fixed.
* Ward 2 in the Town of Sheldon is incorrectly labelled ward1 (`OBJECTID == 4050`). This is fixed.
* The Town of Flambeau has 2 polygons labelled ward 1, but one should be ward 2. I could not identify which ward is in error, but it doesn't really matter because all the Town of Flambeau wards are combined into one reporting unit. I chose `OBJECTID == 5242` and renamed it ward 2.
* Wards 35, 36, & 37 were renamed wards 21, 22, & 23, respectively, in the City of Manitowoc.

### failed matches

The following 6 wards are included in the ward polygons, but they are not referenced in any reporting unit from the Nov. 2022 general election. None of them are included in the Dec. 1, 2022 registered voter file, so I assume they are unpopulated.

| county    | municipality  | ward  | registered voters |
|-----------|---------------|-------|-------------------|
|Calumet    |Harrison T.    |1      |non-existent       |
|Dane       |Middleton C.   |24     |non-existent       |
|Manitowoc  |Kiel C.        |7      |non-existent       |
|Milwaukee  |Milwaukee C.   |316    |non-existent       |
|Milwaukee  |Milwaukee C.   |317    |non-existent       |
|Rock       |Footville V.   |2      |non-existent       |

These files are processed versions of the original certified returns stored in `raw-election-returns/`. They are cleaned using the scripts in `process-election-returns/`.

The cleaned files for individual races include more original information including candidate name and affiliation.

The cleaned files beginning with "AllRaces" only include Republican votes, Democratic votes, and total votes cast for each race. They do not include specific totals for third parties or candidate names. These files follow an 8-character naming convention derived from the Wisconsin LTSB, where the first 3 characters indicate the office, the next 3 indicate the party, and the last 2 indicate the year. For example, `GOVDEM22` means Democratic votes for governor cast in 2022. `SOSTOT22` means total votes cast for Secretary of State in 2022. The complete list of office abbreviations is as follows:

* GOV - governor
* SOS - WI Secretary of State
* USH - U.S. House
* USS - U.S. Senate
* WAG - WI Attorney General
* WSA - WI State Assembly
* WSS - WI State Senate
* WST - WI State Treasurer
clear all
ssc install frameappend
ssc install nmissing
ssc install diff
ssc install outreg2
set more off, permanently
cd "path here"   // change to the input folder
import delimited "Dataset_normalized2015.csv", varnames(1) 

// data cleaning
rename ïcountry country
rename jan14 month_1
rename feb14 month_2
rename mar14 month_3
rename apr14 month_4
rename may14 month_5
rename jun14 month_6
rename jul14 month_7
rename aug14 month_8
rename sep14 month_9
rename oct14 month_10
rename nov14 month_11
rename dec14 month_12
rename jan15 month_13
rename feb15 month_14
rename mar15 month_15
rename apr15 month_16
rename may15 month_17
rename jun15 month_18
rename jul15 month_19
rename aug15 month_20
rename sep15 month_21
rename oct15 month_22
rename nov15 month_23
rename dec15 month_24

//reshaping
gen id = country+"_"+goodtype
encode goodtype, gen(goodtype_encoded)
log using codebook.txt, text replace
codebook goodtype_encoded, tabulate (500)
log close
reshape long month_, i(id) j(month)
rename month_ value
drop id
gen id2 = country+"_"+string(month)
drop goodtype
reshape wide value, i(id2) j(goodtype_encoded)
drop id2
order country month

// convert strings to numeric
forvalues i=1/468 {
	gen x_`i' = real(value`i')
	drop value`i'
}

// Treated
gen treated = (country=="Switzerland" & month>=14)

save "synthetic_dataset.dta", replace

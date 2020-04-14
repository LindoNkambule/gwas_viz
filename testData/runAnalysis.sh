#!/usr/local/bash

# This script is for reproducing the data for testing the application

#1. Download PLINK
wget http://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20200219.zip
unzip plink_linux_x86_64_20200219.zip
sudo cp -v plink /usr/local/bin/
rm toy.* LICENSE prettify plink_linux_x86_64_20200219.zip

#2. download test data
wget https://www.cog-genomics.org/static/bin/plink/example.zip
unzip example.zip
mv example/wgas1* .
rm -rf example example.zip # remove the folder and zip file

#3. set variables
plink="/usr/local/bin/plink2"
output="gwaRs_QC"

# the below instructions are described here: http://zzz.bwh.harvard.edu/plink/res.shtml (http://zzz.bwh.harvard.edu/plink/dist/teaching.zip)

#4. CONVERT MAP/PED FILES and QAULITY CONTROL
${plink} --file wgas1 --maf 0.01 --hwe 0.001 --geno 0.05 --mind 0.05 --recode --make-bed --out ${output} --noweb

#5. Association Analysis
${plink} --bfile gwaRs_QC --assoc --out ${output} --noweb

#6. Run Principal Component Analysis
${plink} --bfile gwaRs_QC --pca --out ${output} --noweb

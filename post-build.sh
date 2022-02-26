#!/bin/sh

echo "Create JS file from search data"
mv ./public/search-data/index.html ./public/js/search-data.js
rm -rf ./public/search-data/

echo "Remove taxonomy pages"
rm -rf ./public/tags ./public/category

echo "Remove taxonomy from the sitemap"
awk 'NR==FNR{if (/muffinman.io\/(tags|category)\/.*/) for (i=-1;i<=1;i++) del[NR+i]; next} !(FNR in del)' ./public/sitemap.xml ./public/sitemap.xml > ./public/sitemap-tmp.xml

echo "Remove search data from the sitemap"
awk 'NR==FNR{if (/muffinman.io\/search-data/) for (i=-1;i<=1;i++) del[NR+i]; next} !(FNR in del)' ./public/sitemap-tmp.xml ./public/sitemap-tmp.xml > ./public/sitemap.xml

echo "Remove temp"
rm ./public/sitemap-tmp.xml

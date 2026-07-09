#!/bin/bash
# Optimize the referenced working-set images into web-ready webp + jpg fallbacks.
# Longest edge -> 2000px, quality ~82. Outputs to assets/media/.
set -u
cd "$(dirname "$0")"
OUT="assets/media"
mkdir -p "$OUT"

# src|dest (dest has no extension; we emit .jpg and .webp)
pairs=(
"DormDAO:Oregon_branding/aboutme.jpg|portrait"
"DormDAO:Oregon_branding/Dorm Imagery/dorm1-topaz-enhance-3.2x-sharpen.png|dorm-bg"
"photos/adobe.png|omniscol"
"photos/ferry.jpeg|obg-ferry"
"photos/benefitforbowie2.jpg|benefit-bowie"
"photos/Executive Team 1.jpg|obg-exec"
"photos/solanaskyline.jpg|obg-site-visit"
"photos/internship.JPG|omniscol-internship"
"photos/moreconvention.jpg|convention"
"photos/convention3.jpg|convention-2"
"photos/mogging.jpg|portrait-casual"
"photos/jeremymitaux.JPG|portrait-alt"
"henrysuncle/fallcopy.jpg|hu-fall"
"henrysuncle/IMG_8354 copy.PNG|hu-ep-cover"
"henrysuncle/DSC03542 copy.jpg|hu-live-1"
"henrysuncle/henrysuncle_copy.jpg|hu-live-2"
"henrysuncle/DSC_1142 copy.JPG|hu-live-3"
"henrysuncle/DSCF1481 copy.JPG|hu-live-4"
"henrysuncle/IMG_1911 copy.JPG|hu-live-5"
"henrysuncle/DSC03582 copy.jpg|hu-live-6"
"henrysuncle/IMG_2053 copy.JPG|hu-live-7"
"henrysuncle/DSCF.jpg|hu-live-8"
)

n=0; total=${#pairs[@]}
for p in "${pairs[@]}"; do
  src="${p%%|*}"; dest="${p##*|}"; n=$((n+1))
  if [ ! -f "$src" ]; then echo "[$n/$total] MISSING: $src"; continue; fi
  # resize + reencode to jpg (long edge 2000, q82)
  sips -Z 2000 -s format jpeg -s formatOptions 82 "$src" --out "$OUT/$dest.jpg" >/dev/null 2>&1
  # webp from the resized jpg
  cwebp -quiet -q 82 "$OUT/$dest.jpg" -o "$OUT/$dest.webp" >/dev/null 2>&1
  jsz=$(du -h "$OUT/$dest.jpg" 2>/dev/null | cut -f1)
  wsz=$(du -h "$OUT/$dest.webp" 2>/dev/null | cut -f1)
  echo "[$n/$total] $dest  jpg=$jsz  webp=$wsz"
done
echo "DONE. Optimized assets in $OUT/"
du -sh "$OUT"

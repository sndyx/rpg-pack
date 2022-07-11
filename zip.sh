zip -vr pack.zip pack/ -x "*.DS_Store"
echo Resource pack SHA-1 hash: $(shasum pack.zip | cut -c-40)
rm 00000bxvvs.zip
tar -czf 00000bxvvs.zip .
echo Resource pack SHA-1 hash: $(shasum 00000bxvvs.zip | cut -c-40)
import zipfile
with zipfile.ZipFile('dist/multi-agent-pack-v1.1.0.zip') as z:
    for info in z.infolist():
        print(info.filename)

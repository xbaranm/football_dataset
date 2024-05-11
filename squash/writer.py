class SqfsWriter:
    def __init__(self, filename, nImages):
        self.filename = filename
        self.nImages = nImages
        self.count = 0
        self.folder = os.path.join(pathlib.Path(filename).parent, pathlib.Path(filename).stem)
        os.makedirs(self.folder, exist_ok=True)

    def close(self):
        # Execute SQFS command
        p = subprocess.run(args=[
            "mksquashfs", self.folder, self.filename,
            "-noI", "-noId", "-noD", "-noF", "-noX"
        ])


    def write(self, a, b, m):
        B = a.size(0)
        for i in range(B):           
            self.writeImage(toImage(a[i]), toImage(b[i]), toImage(m[i][0:1]))

    def writeImage(self, a, b, mask):
        if (self.count >= self.nImages):
            return False
            
        iFolder = self.count // 1000
        iFile = self.count % 1000

        folder = os.path.join(self.folder, "{:04d}".format(iFolder))        
        os.makedirs(folder, exist_ok=True)

        prefix = os.path.join(folder, "{:03d}".format(iFile))
        cv2.imwrite(prefix+"_scanner.png", a)
        cv2.imwrite(prefix+"_mask.png", mask)
        cv2.imwrite(prefix+"_latent.png", b)
        self.count += 1
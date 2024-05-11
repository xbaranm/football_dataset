
import os
import random
from datetime import datetime
from torch.utils.data import Dataset

import subprocess
from PIL import Image
import wsq

import numpy as np
import torch

from contextlib import contextmanager

@contextmanager
def auto_mount_sqfs(*args, **kwds):
    auto_mounter = AutoMounter(*args, **kwds)
    try:
        auto_mounter.mount()
        yield auto_mounter
    finally:
        auto_mounter.umount()


class AutoMounter:
    def __init__(self, filename):
        self.filename = filename
        # Make random path
        timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        timestamp += "{:0>4X}".format(random.randint(0,1024*1024-1))
        self.mount_path = os.path.join("/tmp", timestamp)

    def mount(self):
        print("Mounting: {} as {}".format(self.filename, self.mount_path))
        os.makedirs(self.mount_path)
        subprocess.run([
            "squashfuse", self.filename, self.mount_path
        ])

    def umount(self):
        print("Unmounting: {}".format(self.mount_path))
        subprocess.run(["umount", self.mount_path])




class SquashFsDataset(Dataset):
    def __init__(self, folder, shape=(416,416), limit=-1):
        self.folder = folder
        self.shape = shape
        self.limit = limit
        self.len = 0
        self._assertOpen()

    def __len__(self):
        self._assertOpen()
        return self.len

    def __getitem__(self, idx):
        
        # Calculate the indices
        index_file = idx % 1000
        index_dir = idx // 1000
        dir_minor = index_dir % 1000
        dir_major = index_dir // 1000

        # Assemble the file path
        subdir = "{:04d}/{:03d}".format(dir_major, dir_minor)
        fn = "{:03d}.wsq".format(index_file)
        fn = os.path.join(self.folder, subdir, fn)

        # Load the image
        try:
            img = Image.open(fn)        
            img = np.array(img)
        except:
            print("Cannot load file: ", fn)
            img = (np.random.rand(self.shape[0], self.shape[1]) * 255.0).astype(np.uint8)

        # Crop & Pad to shape
        img = self.crop_expand(img, self.shape)

        # Degrade the image
        mask, maskContext = self.degrade(img)

        image = SquashFsDataset.toTensor(img)
        mask = torch.from_numpy(mask).float()
        maskContext = torch.from_numpy(maskContext).float()
        #mpMap = ExtractorDataset.toTensor(maps[0:1,:,:])
        return image, mask, maskContext
        

    def _assertOpen(self):
        if (self.len == 0):
            fn_count = os.path.join(self.folder, "count")
            with open(fn_count, "r") as f:
                count = int(f.readline())
            if (self.limit > 0):
                count = min(self.limit, count)
            self.len = count

    def crop_expand(self, img, shape):
        TH,TW = shape
        H,W = img.shape
        result = np.ones(shape=shape, dtype=np.uint8) * 255    
        CW = min(TW,W)
        CH = min(TH,H)
        tl = (0 if (TW <= W) else ((TW-W)//2))
        tt = (0 if (TH <= H) else ((TH-H)//2))
        sl = (0 if (W <= TW) else ((W-TW)//2))
        st = (0 if (H <= TH) else ((H-TH)//2))
        result[tt:tt+CH,tl:tl+CW] = img[st:st+CH,sl:sl+CW]

        result = np.expand_dims(result, axis=0)
        return result

    def degrade(self, img):
        C,H,W = img.shape

        mask = np.ones(shape=(1,H,W), dtype=float)
        maskContext = np.ones(shape=(1,H,W), dtype=float)

        ph = random.randint(H//6, H//2)
        pw = random.randint(W//6, W//2)
        x = random.randint(0,W-pw-1)
        y = random.randint(0,H-ph-1)

        overlap = 8

        # Fill in white
        mask[0, y:y+ph, x:x+pw] = 0.0
        maskContext[0, y+overlap:y+ph-overlap, x+overlap:x+pw-overlap] = 0.0
        return mask, maskContext

        
    @staticmethod
    def toTensor(image: np.ndarray):
        image = image.astype(np.float32)
        image = ((image / 255.0) - 0.5) * 1.0           # <-0.5; 0.5>
        return torch.from_numpy(image).float()   
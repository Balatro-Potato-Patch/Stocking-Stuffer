from PIL import Image
import os
from tkinter import Tk
from tkinter.filedialog import askopenfilename

if __name__ == "__main__":
    try:
        window = Tk()
        window.withdraw()
        small = askopenfilename(filetypes=[("Image files", ".png")],title="Select an image to upscale",initialdir="assets/1x/")
        if not os.path.isfile(small):
            raise FileNotFoundError()
        big = "assets/2x/" + os.path.basename(small)
        if os.path.isfile(big):
            raise FileExistsError()
        small_image = Image.open(small)
        new_dims = (small_image.width * 2, small_image.height * 2)
        big_image = small_image.resize(new_dims, Image.NEAREST)
        big_image.save(big)
        print("Success!")
    except FileNotFoundError:
        print("Something went wrong when getting the original image.")
    except FileExistsError:
        print("Upscaled image already exists.")

    
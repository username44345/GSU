import cv2
import matplotlib.pyplot as plt
import numpy as np

#reads file and converts to grayscale
img = cv2.imread("image.jpg")
img2 = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

#runs single value decomposition on the image to return 3 arrays
u,s,v = np.linalg.svd(img2,full_matrices =False)

#sets k values
k = [1440,1,5,10,20,40]
#sets the size of the results
plt.figure(figsize=(12, 6))
 
for i in range(len(k)):
    #uses the results of SVD to recreate the image with k singluar values
    results = u[:, :k[i]] @ np.diag(s[:k[i]]) @ v[:k[i], :]
    #shows original image
    if(i == 0):
        plt.subplot(2, 3, i+1),
        plt.imshow(results, cmap='gray'),
        plt.title(f'Original image with k = {k[i]}')
    #shows the results of the SVD reconstructions
    else:
        plt.subplot(2, 3, i+1),
        plt.imshow(results, cmap='gray'),
        plt.title(f'k = {k[i]}')
plt.show()


# Hough-Transform-Project-circles-
Circle identification MatLab project written for CSCI 158: 'Intro to Biometric Security' @ Fresno State

Hough transform works by using a parameter space that implements a 'voting system' per-pixel in order to identify a given shape in some image (a fixed-size circle of a 10-pixel radius in this project). Each pixel in the image is presented as a 'candidate' to be the center of a 10-pixel radius circle. Pixels that surround the candidate pixel would pressumably house very similar intensities; a threshold value is selected which adjusts the 'strictness' of what passes as a circle in the original image. This implementation then outputs a new resulting image which contains the circles that passed as a circle and places them in their oringial locations in B&W.

(Note: 'circles.png' is simply the original, A.I. generated image containing circles to be identified by the program)

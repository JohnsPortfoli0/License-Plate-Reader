# License Plate Reader
This project implements an optical character recognition (OCR) pipeline designed to extract alphanumeric text from vehicle license plates. The reader focuses on clean plate images as an initial scope, providing a foundation for future expansion into more challenging conditions such as motion blur, noise, and varying lighting environments.

# Running the Script
Please download the PlateReader.m file and open it in MATLAB.

1. Download and open PlateReader.m
2. Run the program and 5 figures will generate, proceed to next step
3. On Figure 5, Draw a box tightly around “U.S. GOVERNMENT“ and double click your cursor
4. Next, Figure 6 will appear. Now, draw a box tightly around the plate number “A193958” and double click your cursor
5. Observe results in Figure 7

# Script Explanation/Steps
1. Setup
  - Clears workspace (clc, clear all, close all).
  - Loads an input image (stock_plate.jpg).
    
2. Image Preprocessing
  - Displays the original image.
  - Converts to grayscale for faster and more reliable analysis.

3. Edge Detection (Used for educational purposes)
  - Applies Sobel and Canny methods.
  - Measures runtime for each and displays results side-by-side.
  - Fills holes in edge maps for better visualization of character regions.
    
4. User-Guided OCR
  - Step 1: Select plate region text (e.g., state, county, or agency).
  - Step 2: Select plate ID (letters and numbers).

  - OCR is restricted to relevant character sets (letters only for region, alphanumeric for ID). Outputs recognized text in the MATLAB console.

5. Confidence Annotation
  - High-confidence characters (≥60%) are marked green.
  - Low-confidence characters (<60%) are marked red.
  - Final annotated plate is shown with bounding boxes and confidence labels.

6. Summary Output
  - Average OCR confidence across both ROIs.
  - Edge detection runtimes (Sobel vs. Canny).
  - Total OCR processing time.


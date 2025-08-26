# License Plate Reader
This project implements an optical character recognition (OCR) pipeline designed to extract alphanumeric text from vehicle license plates. The reader focuses on clean plate images as an initial scope, providing a foundation for future expansion into more challenging conditions such as motion blur, noise, and varying lighting environments.

# Steps for Running the Script Properly
Please download the "PlateReader.m" and "test_plate.jpg" under "Project Items".

1. Open "PlateReader.m" in MATLAB.
2. Ensure that "PlateReader.m" and "test_plate.jpg" are in the same folder within your MATLAB directory.
3. Run the program and 5 figures will generate, proceed to next step.
4. On Figure 5, Draw a box tightly around “U.S. GOVERNMENT“ and double click your cursor.
5. Next, Figure 6 will appear. Now, draw a box tightly around the plate number “A193958” and double click your cursor.
6. Observe results in Figure 7.

# Script Explanation and Flow
1. Setup
  - Clears workspace (clc, clear all, close all).
  - Loads an input image (test_plate.jpg).
    
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

# Key Features
- Edge Detection Benchmarking
  - Compares Sobel vs Canny methods with runtime measurements.
  - Visualizes edge maps side-by-side.
    
- Manual ROI Selection
  - Users crop the plate region (state/county text) and plate ID.
  - Keeps focus on OCR performance instead of plate localization.
    
- OCR with Character Set Restriction
  - Region text limited to letters + periods.
  - Plate ID includes letters + digits.
  - Improves recognition accuracy by reducing false detections.
    
- Confidence-Based Annotation
  - High-confidence characters (≥60%) shown in green.
  - Low-confidence characters (<60%) flagged in red.
    
- Performance Summary
  - Reports average OCR confidence, Sobel & Canny runtimes, and total OCR time.
    
- Step-by-Step Visualization
  - Multiple figures illustrate each stage: raw image → grayscale → edges → ROIs → final annotated plate.
 
# Requirments
- MATLAB R2024a (This is what I used)
- Toolboxes
  - Control System Toolbox (transfer functions, `step`, `feedback`)
  - System Identification Toolbox (for `tfest`, `iddata`, `compare`) — only needed for identification scripts
  - Symbolic Math Toolbox (for `tf('s)`)

# License
This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.


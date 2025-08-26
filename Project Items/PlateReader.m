%% Title: Graduate Project 1 (License Plate Detection)
%
% * Objective:
%              This project provides a fundamental demonstration of license 
%              plate detection and processing techniques to extract textual 
%              information from images. Specifically, it focuses on 
%              illustrating the effectiveness of Sobel and Canny edge 
%              detection methods. These traditional image processing 
%              techniques are applied directly to clear, unaltered images 
%              of license plates to highlight their effectiveness in 
%              isolating characters. After applying edge detection, Optical 
%              Character Recognition (OCR) techniques are employed to 
%              extract the text from the processed images. Users manually 
%              select regions of interest (ROI) to guide OCR, allowing 
%              direct interaction with the processed images.
%
% * Name: John Schatzel
% 
% * Date: 4/30/2025
% * Course: ECEN 5830
%

clc
clear all
close all

%% Image Reading and Display

% loading-in images
LicensePlate = imread("test_plate.jpg"); % license plate image

% display the original image
figure(1)
imshow(LicensePlate)

% changing image to grayscale
grayPlate = rgb2gray(LicensePlate);
figure(2)
imshow(grayPlate)

%% License Plate Filtering - Edge Detection on Ideal Image
% focus on Sobel and Canny method as it is traditional in LPD.

% sobel method - ideal image 
tic;
edges_sobel = edge(grayPlate, "sobel");
sobel_time = toc;

% canny method - ideal image
tic;
edges_canny = edge(grayPlate, "canny");
canny_time = toc;

figure(3)
imshowpair(edges_sobel, edges_canny, 'montage')
title(sprintf("Ideal Edge Detection - Sobel (%.4fs) vs Canny (%.4fs)", sobel_time, canny_time))

sobel_filled = imfill(edges_sobel, "holes");
canny_filled = imfill(edges_canny, "holes");

figure(4)
montage({sobel_filled, canny_filled}, 'Size', [1 2])
title("Holes Filled - Sobel (Left) vs Canny (Right) Ideal")

%% OCR and Text Extraction

% beginning with Identification of the plates origin (county, state,
% department)
fprintf('Draw a rectangle tightly around the plate''s region (letters):\n');
figure(5)
imshow(grayPlate)
[~, ROI1] = imcrop(grayPlate); % allows user to select portion of image to read

focusedAreas = insertShape(grayPlate, "rectangle", ROI1, "color", "blue");

tic;
plateRegion = ocr(grayPlate, ROI1, ...
    CharacterSet="ABCDEFGHIJKLMNOPQRSTUVWXYZ. ", ...
    LayoutAnalysis="block");
ocr_time1 = toc;

% Extract text
region = plateRegion.Text;
fprintf(['\nLicense Plate Region: ', region])

% Detect low confidence characters and if any are less than 60%, highlight
% in red
low1 = (plateRegion.WordConfidences < 0.6);

% Annotate low confidence characters in red
% High Confidence - Green
focusedAreas = insertObjectAnnotation(focusedAreas, "rectangle", ...
    plateRegion.WordBoundingBoxes(~low1, :), ...
    strcat(plateRegion.Words(~low1), " (", string(round(plateRegion.WordConfidences(~low1)*100,1)), "%)"), "color", "green");

% Low Confidence - Red
focusedAreas = insertObjectAnnotation(focusedAreas, "rectangle", ...
    plateRegion.WordBoundingBoxes(low1, :), ...
    strcat(plateRegion.Words(low1), " (", string(round(plateRegion.WordConfidences(low1)*100,1)), "%)"), "color", "red");

% now extracting the actual license plate number
fprintf('Draw a rectangle tightly around the plate''s identification number:\n');
figure(6)
imshow(grayPlate)
[~, ROI2] = imcrop(grayPlate); % allows user to select portion of image to read

% this portion will focus on characters and numbers
tic;
plateNumber = ocr(grayPlate, ROI2, CharacterSet="ABCDEFGHIJKLMNOPQRSTUVWXYZ.0123456789 ", LayoutAnalysis="block");
ocr_time2 = toc;
number = plateNumber.Text;
fprintf(['\nLicense Plate ID: ', number])

% Detect low confidence characters and if any are less than 60%, highlight
% in red
low2 = (plateNumber.WordConfidences < 0.6);

% Annotate low confidence characters in red
% High Confidence - Green
focusedAreas = insertObjectAnnotation(focusedAreas, "rectangle", ...
    plateNumber.WordBoundingBoxes(~low2, :), ...
    strcat(plateNumber.Words(~low2), " (", string(round(plateNumber.WordConfidences(~low2)*100,1)), "%)"), "color", "green");

% Low Confidence - Red
focusedAreas = insertObjectAnnotation(focusedAreas, "rectangle", ...
    plateNumber.WordBoundingBoxes(low2, :), ...
    strcat(plateNumber.Words(low2), " (", string(round(plateNumber.WordConfidences(low2)*100,1)), "%)"), "color", "red");

% Show result of the plate region
figure(7)
imshow(focusedAreas)
title('High Confidence Characters (in green)')

%% Brief Summary
avg_confidence = mean([plateRegion.WordConfidences; plateNumber.WordConfidences]) * 100;
total_ocr_time = ocr_time1 + ocr_time2;

fprintf('\n\n--- OCR and Processing Summary ---\n');
fprintf('Average OCR Confidence: %.2f%%\n', avg_confidence);
fprintf('Sobel Edge Detection Time: %.4f seconds\n', sobel_time);
fprintf('Canny Edge Detection Time: %.4f seconds\n', canny_time);
fprintf('Total OCR Time: %.4f seconds\n', total_ocr_time);
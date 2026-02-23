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
tic; % begin stopwatch
edges_sobel = edge(grayPlate, "sobel");
sobel_time = toc; % end stopwatch

% canny method - ideal image
tic; % begin stopwatch
edges_canny = edge(grayPlate, "canny");
canny_time = toc; % end stopwatch

figure(3)
imshowpair(edges_sobel, edges_canny, 'montage')
title(sprintf("Ideal Edge Detection - Sobel (%.4fs) vs Canny (%.4fs)", sobel_time, canny_time))

sobel_filled = imfill(edges_sobel, "holes");
canny_filled = imfill(edges_canny, "holes");

figure(4)
montage({sobel_filled, canny_filled}, 'Size', [1 2])
title("Holes Filled - Sobel (Left) vs Canny (Right) Ideal")

%% OCR Setup - License Plate Region (County, State, Department)
fprintf('Draw a rectangle tightly around the plate''s region (letters):\n');
figure(5)
imshow(grayPlate)
[~, ROI1] = imcrop(grayPlate); % allows user to select portion of image to read

% OCR Function - Character and Punctuation Detection
tic; % begin stopwatch for OCR 1
plateRegion = ocr(grayPlate, ROI1, CharacterSet="ABCDEFGHIJKLMNOPQRSTUVWXYZ. ", LayoutAnalysis="block");
ocr_time1 = toc; % end stopwatch for OCR 1

% OCR 1 Outputs
RegionText = plateRegion.Text; % read word(s)
RegionWords = plateRegion.Words; % word token(s) stored in cell
RegionConfidence = plateRegion.WordConfidences; % confidence of read words
RegionRect = plateRegion.WordBoundingBoxes; % position of words

fprintf(['\nLicense Plate Region: ', RegionText]) % display Region word

%% OCR Setup - License Plate Identification Number
fprintf('Draw a rectangle tightly around the plate''s identification number:\n');
figure(6)
imshow(grayPlate)
[~, ROI2] = imcrop(grayPlate); % allows user to select portion of image to read

% OCR Function - Character and Number Detection
tic; % begin stopwatch for OCR 2
plateNumber = ocr(grayPlate, ROI2, CharacterSet="ABCDEFGHIJKLMNOPQRSTUVWXYZ.0123456789", LayoutAnalysis="block");
ocr_time2 = toc; % end stopwatch for OCR 2

% OCR 2 Outputs
IDText = plateNumber.Text; % read ID(s)
IDWords = plateNumber.Words; % word token(s) stored in cell
IDConfidence = plateNumber.WordConfidences; % confidence of read ID
IDRect = plateNumber.WordBoundingBoxes; % position of ID

fprintf(['\nLicense Plate ID: ', IDText])

%% Display Drawn ROIs on Image
rects = [ROI1; ROI2];
focusedAreas = insertShape(grayPlate, "rectangle", rects, ShapeColor=["red","blue"]);

%% Text Extraction and Confidence Scoring - 'U.S. GOVERNMENT'

% Detect low confidence words and if any are less than 60%, highlight in red
low1 = (RegionConfidence < 0.6);

% High Confidence - Green
focusedAreas = insertObjectAnnotation(focusedAreas, "rectangle", ...
    RegionRect(~low1, :), ... % position of rectangle
    strcat(RegionWords(~low1), " (", string(round(RegionConfidence(~low1)*100,1)), ... % concat. words and confidence percentage
    "%)"), "color", "green");

% Low Confidence - Red
focusedAreas = insertObjectAnnotation(focusedAreas, "rectangle", ...
    RegionRect(low1, :), ... % position of rectangle
    strcat(RegionWords(low1), " (", string(round(RegionConfidence(low1)*100,1)), ... % concat. words and confidence percentage
    "%)"), "color", "red");

%% Text Extraction and Confidence Scoring - 'A193958'
low2 = (plateNumber.WordConfidences < 0.6);

% Annotate low confidence characters in red
% High Confidence - Green
focusedAreas = insertObjectAnnotation(focusedAreas, "rectangle", ... 
    IDRect(~low2, :), ... % position of rectangle
    strcat(IDWords(~low2), " (", string(round(IDConfidence(~low2)*100,1)), ... % concat. words and confidence percentage
    "%)"), "color", "green");

% Low Confidence - Red
focusedAreas = insertObjectAnnotation(focusedAreas, "rectangle", ... 
    IDRect(low2, :), ... % position of rectangle
    strcat(IDWords(low2), " (", string(round(IDConfidence(low2)*100,1)), ... % concat. words and confidence percentage
    "%)"), "color", "red");

%% OCR Results
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

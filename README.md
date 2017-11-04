# hilores_stm2

# Version 0.1 Notes

## General Overview

There are three tasks: Gabor, STM, and Perception (see below). There are two counterbalancing conditions with different order of the tasks:
CB1: STM -> Gabor -> Perception
CB2: Perception -> Gabor -> STM

This version is a pilot version of the task. The goal is to run 6 individuals to assess levels of performance. Participants run in anything below Version 1.0 will not be included in the actual data analysis.

The aim for the first experiment is to determine in young college students whether there is any 'interference' from reusing the same images in the perception and STM tasks. To do this, we will manipulate the order of the tasks (note the Gabor task is always in the middle). Performance in the STM and Perception tasks will be analyzed with a CB order factor. If this is null, then we will conclude that interference is likely minimal. 

The monitor resolution should be set to: 1024 x 768
The monitor size is: ##"
Participants should be seated approimately ##cm from the monitor

## Gabor Task

Participants are shown two Gabor images on the screen (left and right of fixation). The judgment is a Same/Different judgment, where participants are to judge whether the two Gabors have the Same orientation or a different orientation. They are instructed to make this response when the red '+' appears as quickly as possible. 

There are an equal number of same/different trials (80 and 80) in the critical phase. On different trials, the two gabors of a difference in rotation of: 13^o

The Gabor display is presented for 300 ms, and after the response is entered there is a 200ms interval before the next trial. 

The response keys are "F" (Same) and "J" (Different).

The Gabor image was created using an [online source](https://www.cogsci.nl/gabor-generator). The settings were:
Orientation: 0 degrees (this is controlled in the stim presentation program)
Size: 200 pixels
Envelope: Circular (Sharp Edge)
Frequency: .08 (cycles/pixel)
Phase: 0
BG Color (rgb): 128,128,128
Color 1 (rgb): 255,255,255
Color 2 (rgb): 0,0,0

The image is saved as gabor_08f.png in the gabors directory.

The experimental factors are:
1. CB Order (CB1 vs. CB2)

## Short Term Memory

Participants are shown sets of 2 or 4 images, with each image being unique. Images in the Set Size 2 condition (low complexity) are presented stacked (one on top, one of bottom) and offset +/- 100 pixels in the y-dimension from fixation. Images in the Set Size 4 condition (high complexity) are presented in four quadrants of a grid defined by x- and y-offsets of +/- 100 pixels from fixation.

After a brief delay, memory for the orietnation of the image is tested. Each test probe is shown on the left and right of the screen (+/- 100 pixels from central fixation), and participants are to report which one of the two images are in the **SAME** orientation. The response options are "F" (Left) if the image on the left is the same and "J" (right) if the image on the right is the same. 

The angular difference between the lure and same image in each test probe in maniuplated as either high or low (resolution. An equal number of set size 2 and 4 image sets are assigned to the high and low resolution conditions. The rotation of the lure is equally likely to be left or right across all test probes (but not necessarily within age given set; e.g., a set size 4 trial can have 4 lures that were all rotated to the right). Likewise, the side of the same item is equally likely to be on the left or right (across trials, but not necessarily within a set). The rotation (in degrees) for the levels of the resolution factor are:

*Low: 45^o
*High: 20^o

The experimental factors are:
1. CB Order (CB1 vs. CB2)
2. Resolution (High vs. Low)
3. Complexity (Low-Set Size 2 vs. High-Set Size 4)

There are 72 images in each cell of the Resolution and Complexity variables, resulting in:
*36 trial sets for high/low resolution set size 2 trials
*18 trial sets for high/low resultion set size 4 trials

Timing:
1. Study Image Set: 3 seconds
2. Study-Test Delay (delay until first test trial): 1 second
3. Test ISI (time between test stimuli in a set): .25 seconds
4. Test ITI (time between end of last test image and next study display): 1.25

Images are 150 X 150 pixels, and are black and white line drawings. 

## Perception

This task is a cross of the Gabor and STM tasks. The images are the same as those in the STM memory condition.

Participants will be shown displays of 2 or 4 images **OF THE SAME** object. The task is essentially an 'odd-one-out' task whereby. Specifically, participants are to make a same/different judgment (similar to the Gabor task). Participants respond "same" (F) is *all* of the images have the same orientation, whereas they are instructed to responde "different" (J) if one of the images are rotated. Note that only one image on different trials is rotated, and it is equally likely to be a left or right rotation in each of the position across trials. Additionally, there are an equal number of same and different trials. 

Unlike the STM task, there are three different resolution conditions: low, middle, and high. Low and middle in the Perception phase will always be equal to the low and high resolution rotation values, and the high resolution rotation is always the same as the rotation of different trials in the Gabor task. 

There are a total of 48 images per condition formed by crossing the factors Complexity (set size) and Resolution. 

The experimental factors are:
1. CB Order (CB1 vs. CB2)
2. Resolution (High vs. Middle vs. Low)
3. Complexity (Low-Set Size 2 vs. High-Set Size 4)

Timing:
1. Image Presentation Duration: 500 ms
2. Following the same/different response, there is a 1.25 second delay

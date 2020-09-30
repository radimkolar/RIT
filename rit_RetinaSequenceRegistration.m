%%
% This script runs 2 stage registration algorithm for retinal video-sequences. 
% It implements an approach described in Kolar et al. 2016: https://biomedical-engineering-online.biomedcentral.com/articles/10.1186/s12938-016-0191-0
%
% Before you run this script:
% 1. Set appropriate folder where your AVI files with retinal video-recordings are stored 
% 2. Set name of the AVI file to register
% 3. Set the parameters
% 4. 
% After registration process, the following files are created in specified
% folder:
% 1. AVI file with postfix '_phase' where the result of the first stage registration is saved. 
%   You can use this file to check if the phase correlation method is
%   working. It corrects for large eye movements. Small movements are still
%   present.
% 2. AVI file with postfix '_registered' where the result of the first stage registration is saved. 
% 3. Excel file with the same name as the original AVI file. This file
%   contains three columns: 1st and 2nd column contains X, Y shift of each
%   frame with respect to reference frame. 3rd column contains rotation. The
%   number of rows is equal to number of frames in the sequence.
%
% Radim Kolar, Brno University of Technology, Department of Biomedical
% Engineering, Faculty of Electrical Engineering and Communication,
% Created in 2016, corrected and submitted to Github in 09/2020
%
%%
clear all
close all force
%% Set input directory and file with open dialog
% [fname,dirname,FilterIndex] = uigetfile('*.avi');

% or set the dir/file name directly
dirname = 'c:\Users\kolarr\Tmp\VOregGit\out\';
fname = 'Study_02_00008_03_R.avi';

%% Parameters
index_for_reference_frame = 1; %the first frame is the reference frame
Kvessels = 1; % parameter for thresholding during blood vessel detection; it multiplies the threshold during blood vessel detection
use_mask = 1; % set to 1 if manually determined mask is used;  the filename with binary mask is needed or the mask can be determined manually
% filename_mask = ''; % set filename with mask
ignore_borderPC = 150; % how many border pixels will be ignored; in phase correlation step
ignore_borderLK = 50; % how many border pixels will be ignored; in Lucas-Kanade step
NwinLK = 31; % window size for Lucas-Kanade tracking - this should be slightly higher than thickenss of large blood-vessels
RGB_flag = 0; % if the video is RGB, then set to 1; monochromatic - set to 0

%% Input video, reading
fnamepath = [ dirname fname];
aviobj = VideoReader( fnamepath );
nFrames = aviobj.NumberOfFrames;
nr = aviobj.Height;
nc = aviobj.Width;

%% show the reference frame
figure(1);
x2show = read( aviobj, index_for_reference_frame );
imshow( x2show, [] );

%% Mask
if use_mask==0
    mask = [];
else
    %  Read mask
    % mask = imread( [dirname filename_mask] );
    
    % or create mask
    mask = roipoly( x2show );
    mask = imdilate( mask, strel('disk', 7, 0) );
end

%% Open/Create AVI to write result of Phase Correlation
filenamepath = [ dirname fname];
filenamepath2 = [ filenamepath(1:end-4) '_phase.avi'];

aviobjPC = VideoWriter(filenamepath2, 'Motion JPEG AVI');
aviobjPC.Quality = 100;
aviobjPC.VideoCompressionMethod
aviobjPC.FrameRate = aviobj.FrameRate;

%% Reference frame
% Here the reference frame can be determined automatically via user
% function

%% Phase Correlation - the 1st stage of registration
open( aviobjPC );
shift_phase = rit_RetinaPhaseCorrelation( aviobj , aviobjPC, index_for_reference_frame, ignore_borderPC, RGB_flag );
close(aviobjPC);
% Possible to store the frame shifts estimated by PC method 
% save( [ filenamepath(1:end-4) '_phase.mat' ], 'shift_phase' );

%% Lucas-Kanade - the 2nd stage of registration

% Open/Create AVI to write the final video
filenamepath3 = [ filenamepath(1:end-4) '_registered.avi'];
aviobjLK = VideoWriter(filenamepath3, 'Motion JPEG AVI');
aviobjLK.Quality = 100;
aviobjLK.VideoCompressionMethod
aviobjLK.FrameRate = aviobj.FrameRate;

% Read AVI with phase correlation corrected video
aviobjPC = VideoReader( [ filenamepath(1:end-4) '_phase.avi'] );

open( aviobjLK );
T_transform = rit_RetinaLucasKanadeRigidRegistration( aviobjPC, aviobjLK, index_for_reference_frame, Kvessels, mask, NwinLK, ignore_borderLK, RGB_flag );
close( aviobjLK );
% Possible to store the frame shifts/rotation estimated by LK method 
% save( [ filenamepath(1:end-4) '_registered.mat' ], 'T_transform' ); %save final translation and rotation

%% Writing final shift+rotation into Excel file
% Create shift
tmpShift = T_transform(1:2,:)' + shift_phase';
    
% Add rotation in degree
tmpShift = [tmpShift (180*T_transform(3,:)/pi)'];

xlswrite( [filenamepath(1:end-4) '.xlsx'], tmpShift );

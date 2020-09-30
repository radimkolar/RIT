function shift_phase = rit_RetinaPhaseCorrelation( aviobj , aviobjOut, RefFrame, ignore_border, RGB_flag   )
% Function for image registration using phase correlation

%% Large shift correction via Phase Correlation
nFrames = aviobj.NumberOfFrames;
nr = aviobj.Height;
nc = aviobj.Width;
    
%% This is to store the shift parameters
shift_phase = zeros(2,nFrames-1);
    
%% Start registration
    
% Read reference frame
x1 = read(aviobj, RefFrame); 

if RGB_flag  % If RGB, then take only one color channel - green, which has the highest contrast
	x1 = double( x1(:,:,2) );
else
    % just for sure, take the first
    x1 = double( x1(:,:,1) );
end

% Here, it is possible to apply  preprocessing
x1b = medfilt2( x1, [3 3]);
x1b = double( adapthisteq(uint8(x1b)) );
    
% Create list of indexes for frames to register except the reference frame
FrameList = [1:nFrames];
FrameList = setdiff( FrameList, RefFrame );
flag = 1; % flag to hold if reference frame has been written into output video
 
h = waitbar(0,'The 1st stage of registration is running. Please wait...');

for ii = FrameList
    waitbar(ii/nFrames, h);
     
    % Read frame
    x2 = read(aviobj, ii);
    if RGB_flag % If RGB, then take only one color channel - green, which has the highest contrast
        x2 = double( x2(:,:,2) );
    else
        % ...will work in double
        x2 = double( x2(:,:,1) );
    end

    % Preprocessing
    x2b = medfilt2( x2, [3 3]);    
    x2b = double( adapthisteq(uint8(x2b)) );

    % Estimate the shift
        [x22b, r_x, c_x] = rit_ShiftEstimatePhaseCorrelation( x1b, x2b, ignore_border );

        % Apply the estimated shifts on the original frame (without preprocessing)
        x2 = rit_ShiftCorrection( x2, r_x, c_x );
     
        % Store shift coordinates 
        shift_phase(:,ii) = [c_x; r_x ];
    
        if RGB_flag == 0
            % Write frame
            tmp = uint8( floor(x2) );
        else
            tmp2 = read(aviobj, ii);
            tmp(:,:,1) = uint8( floor( rit_ShiftCorrection( tmp2(:,:,1), r_x, c_x ) ) );
            tmp(:,:,2) = uint8( floor(x2) );
            tmp(:,:,3) = uint8( floor( rit_ShiftCorrection( tmp2(:,:,3), r_x, c_x ) ) );
        end
        
        writeVideo( aviobjOut, tmp );
        
        % Write reference frame into output sequence
        if (RefFrame<ii && flag==1)
             writeVideo( aviobjOut, uint8( floor(x1)) );
            flag = 0;
        end
        
        % Write reference frame into output sequence - if the reference
        % frame is the last frame in sequence
         if ( (RefFrame-1) == ii && flag==1)
             writeVideo( aviobjOut, uint8( floor(x1)) );
            flag = 0;
         end
        
    end
    
    shift_phase(:,RefFrame) = [0;0];
    
    % Close and return parameters
    close(h) 
end



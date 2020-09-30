function [ind, im] = rit_FindFeaturePoints( im, K, vis )

%% Preprocessing
if size(im,3)==3
    im = double(rgb2gray(im) );
end
im_orig = im;

im = medfilt2( im, [5 5]);
im = double( adapthisteq(uint8(im)) );
im = rit_blood_vessel_detection( im, 0 );
im = rit_ImageNorm( im, [0 1]);

% im = vessel_Processing( im, ones(size(im)), 11 );
%% Thresholding
Topt = K*rit_Threshold_Kittler( im(11:end-10, 11:end-10) );  % Ralf
tmp = zeros( size( im) );
ind = find( im>Topt /10);
tmp(ind) = 1;

%% Postprocessing
% MarginX = 5; % Ralf
% MarginY = 5; % Ralf
% % 
MarginX = 100; % Ralf
MarginY = 60; % Ralf

% Clean Margin
tmp( 1:MarginY, : ) = 0;
tmp( end-MarginY:end, : ) = 0;
tmp( :, 1:MarginX ) = 0;
tmp( :, end-MarginX:end ) = 0;

% Clean Small Regions
% % [L,N] = bwlabeln( tmp );
% % for ii = 1:N
% %     ind = find( L==ii );
% % %     if length( ind )<500
% %         if length( ind )<200
% %         tmp(ind) = 0;
% %     end
% % end

% Create Skeleton
tmp2 = tmp;
tmp2 = bwmorph( tmp2, 'spur' );
tmp2 = bwmorph( tmp, 'thin', Inf );
tmp2 = bwmorph( tmp2,  'spur');
[l, num] = bwlabeln( tmp2 );

for ii = 1:num
    ind = find(l==ii);
    if numel( ind ) <100
        tmp2(ind) = 0;
    end
end


% Find Location
ind = find( tmp2~=0);
% Take only half points
% ind = ind(1:8:end);

if nargout==1, im=[]; end

%% 
if vis==1
%     figure(1); 
%     subplot(411); imshow( im(6:end-5, 6:end-5), []);
%     subplot(412); imhist( im(6:end-5, 6:end-5) );
%     subplot(413); imshow( tmp, []);
%     subplot(414); imshow( tmp2, []);
    figure(1); 
    subplot(221);  imshow( im_orig(6:end-5, 6:end-5), []);
    subplot(222); imshow( im(6:end-5, 6:end-5), []);

%     figure(2);
    subplot(223); imhist( im(6:end-5, 6:end-5) );
    hold on
    line([Topt Topt], [ 0 10000])
%     subplot(221); imshow( tmp, []);
    subplot(224); imshow( tmp2, []);
    
    im_orig(ind) = max(max(im_orig)); % 200;
    figure(2);
    imshow( im_orig, [] );
    
end

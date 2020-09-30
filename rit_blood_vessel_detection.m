function out = rit_blood_vessel_detection( im1, vis )
% im1 - 2D obraz
% vis - pokud je 1, tak se bude vykreslovat do figure 1
% out - 2D obraz

% if vis==1, figure(1); subplot(131); imshow( im1, []); end
%% FILTRACE - ROZMAZANI - POTLACENI SUMU A MALYCH HRAN
% h = fspecial( 'gaussian', 11, 2.5 ); 
h = fspecial( 'gaussian', 17, 4 ); 
im1 = conv2( im1, h, 'same' );
% im1 = double( adapthisteq(uint8(im1)) );
% im1 = conv2( im1, h, 'same' );

% if vis==1, subplot(132); imshow( im1, []); end
%% Sobel
gy = fspecial('sobel'); 
gx = gy';
%% First differences
Ix = conv2( im1, gx, 'same' );
Iy = conv2( im1, gy, 'same' );

%% Second differences
Ixx = conv2( Ix, gx, 'same' );
Iyy = conv2( Iy, gy, 'same' );
Ixy = conv2( Ix, gy, 'same' );

%% Eigenvalues
[nr, nc] = size( Ixx );
l1 = zeros( nr, nc );
l2 = zeros( nr, nc );

%% Determinant
D = sqrt( (Ixx+Iyy).^2 + 4*Ixy.^2 - 4*Ixx.*Iyy );
l1 = (-(Ixx + Iyy) + D)/2;
l2 = (-(Ixx + Iyy) - D)/2;
out = abs(l2);

% if vis==1, subplot(133); imshow( out(10:end-10,10:end-10), []); end


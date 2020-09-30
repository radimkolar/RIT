function out = rit_SolveRotationTranslation( XY, xy, method )

if nargin==2
    [nr, nc] = size( XY );

    M = zeros( 3, 3 );
    b = zeros( 3, 1 );

    for ii = 1:nr
        M = M +  [-1, 0, xy(ii,2); 0, -1, -xy(ii,1); -xy(ii,2), xy(ii,1), xy(ii,1)^2 + xy(ii,2)^2 ];
        b = b + [XY(ii,1)-xy(ii,1); XY(ii,2)-xy(ii,2); (XY(ii,1)-xy(ii,1))*xy(ii,2) - (XY(ii,2)-xy(ii,2))*xy(ii,1)];
    end

    out = M\b;

else
    
    im = XY;
    
    xt = xy(1);
    yt = xy(2);
    fi = xy(3);
    
    [yi,xi] = ndgrid(1:1:size(im,1),1:1:size(im,2) );
    xxi = xi*cos(fi) - yi*sin(fi) + xt;
    yyi = xi*sin(fi) + yi*cos(fi) + yt;
    
    if size(im,3)==1
        out = interp2( xi, yi, double(im), xxi, yyi, method);
    else
        out(:,:,1) = interp2( xi, yi, double(im(:,:,1)), xxi, yyi, method);
        out(:,:,2) = interp2( xi, yi, double(im(:,:,2)), xxi, yyi, method);
        out(:,:,3) = interp2( xi, yi, double(im(:,:,3)), xxi, yyi, method);
%         out(:,:,1) = interp2( xi, yi, (im(:,:,1)), xxi, yyi, method);
%         out(:,:,2) = interp2( xi, yi, (im(:,:,2)), xxi, yyi, method);
%         out(:,:,3) = interp2( xi, yi, (im(:,:,3)), xxi, yyi, method);
    end
    
    ind = find( isnan( out) );
    out( ind ) = 0;

end
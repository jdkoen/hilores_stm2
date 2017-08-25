function gabor = make_gabor(res,sf,sc,deg,contrast)

tilt = deg * pi/180;
[gab_x gab_y] = meshgrid(0:(res(1)-1), 0:(res(2)-1));
a = cos(tilt)*sf*360;
b = sin(tilt)*sf*360;
multConst = 1/(sqrt(2*pi)*sc);
x_factor = -1*(gab_x-x).^2;
y_factor = -1*(gab_y-y).^2;
sinWave = sin(deg2rad(a*(gab_x - x) + b*(gab_y - y)+phase));
varScale = 3*sc^2;
gabor = 0.5 + ...
    contrast*(multConst*exp(x_factor/varScale+y_factor/varScale).*sinWave)';

end

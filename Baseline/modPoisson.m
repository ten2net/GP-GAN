% modPoisson reconstructs an image from the gradient feature data.
%
% Y = modPoisson1( X, param, ep, smallpositive )
%Output parameters:
% Y: the reconstructed image
%
%
%Input parameters:
% X: the input feature data
% param (optional): the parameters which is generated by buildModPoissonParam
% ep (optional): constraint parameter
% smallpositive (optional): small positive value to avoid divided-by-zero
%
%
%Example:
% x = double(imread('img.png'));
% y = imGradFeature(x);
% param = buildModPoissonParam( [size(x,1), size(x,2)] );
% X = modPoisson( y, param, 1E-8);
%
%
%Version: 20160622

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modified Poisson                                              %
%                                                               %
% Copyright (C) 2012-2016 Masayuki Tanaka. All rights reserved. %
%                    mtanaka@ctrl.titech.ac.jp                  %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Y = modPoisson( X, param, ep, smallpositive )

if( ~exist('smallpositive') )
 smallpositive = 1E-12;
end

if( ~exist('ep') )
 ep = 1E-8;
end

s = [size(X,1), size(X,2), size(X,3)];

if( ~exist('param') )
 param = buildModPoissonParam(s);
else
 sk = size(param);
 if( s(1) ~= sk(1) || s(2) ~= sk(2) )
  param = buildModPoissonParam(s);
 end
end

Fh = ( X(:,:,:,2) + circshift(X(:,:,:,4),[0,-1])) / 2;
Fv = ( X(:,:,:,3) + circshift(X(:,:,:,5),[-1,0])) / 2;
L = circshift(Fh,[0,1]) + circshift(Fv,[1,0]) - Fh - Fv;

paramep = avoidzero( param + ep, smallpositive );

Y = zeros(s);
for i=1:s(3)
 Xdct = dct2(X(:,:,i));
 Ydct = ( dct2(L(:,:,i)) + ep * Xdct  ) ./ paramep;
 Y(:,:,i) = idct2(Ydct);
end


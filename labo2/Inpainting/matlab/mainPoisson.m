close all
clear all
clc

%% Effectue un collage avec la méthode de Poisson

folder = '../data/testPoisson/test2/';

% Image à compléter
[src, ~, alpha] = imread([ folder 'squirrel_src.png' ]);

% Image à coller
target = imread([ folder 'squirrel_target.jpg' ]);

% Méthode de Poisson
dst = poissonBlending( src, target, alpha );

imshow(dst);

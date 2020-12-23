function [ dst ] = poissonBlending( src, target, alpha )
%POISSONBLENDING Effectue un collage avec la méthode de Poisson
%   Remplit la zone de 'src' où 'alpha'=0 avec le laplacien de 'target'

    % Le problème de Poisson s'énonce par :
    % 'le laplacien de src est égal à celui de target là où alpha=0'
    % Pour résoudre ce problème, on utilise la méthode de Jacobi :
    % à chaque itération, un pixel est égal à la moyenne de ses voisins +
    % la valeur du laplacien cible

    % Process inputs
    src = double(src);
    target = double(target);
    alpha = double(repmat(alpha, [1,1,3]));
    alpha = alpha ./ max(alpha(:));

    % Pre-process/init
    dst = src .* alpha + target .* (1-alpha);
    weightsNeighbours = [
        0 1 0;
        1 0 1;
        0 1 0
    ];
    weightsLapl = [
         0 -1  0;
        -1  4 -1;
         0 -1  0
    ];
    laplTarget = imfilter(target, weightsLapl);

    % Use Jacobi method, and iterate until the difference is small enough
    meanDiff = 10000000;
    while meanDiff > 0.0001
        % Assign average of previous neighbours (computed using filter)
        % with the laplacian of the original target
        tmpNeighbours = imfilter(dst, weightsNeighbours);
        tmp = (laplTarget + tmpNeighbours) ./ 4.0;

        % Compute mean difference between this iteration and the last one
        futureDst = src .* alpha + tmp .* (1 - alpha);
        meanDiff = mean2(abs(dst - futureDst));
        dst = futureDst;
    end

    dst = uint8(dst);
end


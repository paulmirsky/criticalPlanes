clear all
close all
dbstop on error
clc
addpath([ fileparts(mfilename('fullpath')), '\referenced' ]);

% input parameters
a = 2;
b = 3;
c = 2;
d = 72; % just large enough to pad
zLateElbow = (a^2*b^2*c);
allZs = [0 1 2 3] * zLateElbow;

figCorner = [100 100];
zScale = 60;
spreadVsRange = 16;

% go through each Z
for ii = 1:numel(allZs)
    
    thisFactor = allZs(ii) / zLateElbow;
    if (thisFactor==0)
        featureSizes = [a b c d];
    else
        featureSizes = [ a*b*c*thisFactor c b d/c/b/thisFactor ]; % first index is the *innermost
    end
    
    % plot physical diagrams
    spatial = spatialDiagram10;
    spatial.featureSizes = featureSizes;
    spatial.featureTypes = { 'bright', 'dark', 'bright', 'dark' };
    spatial.calcPlane;
    spatial.figureCorner = figCorner + [0 zScale*thisFactor];
    if (ii==1)
        spread = ceil(spreadVsRange*(spatial.maxX-spatial.minX));
    end
    spatial.plot([spatial.centralX-spread,spatial.centralX+spread]);
        
end




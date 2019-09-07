clear all
close all
dbstop on error
clc
addpath([ fileparts(mfilename('fullpath')), '\referenced' ]);

% note: this calculation does not stagger the revival at the medial

% input parameters
a = 2;
b = 6;
c = 5;
d = 3; % just large enough to pad
zCoreStart = (a^2*b);
allZs = [0 1 2 3 6] * zCoreStart;

figCorner = [100 100];
zScale = 60;
spreadVsRange = .5;

% go through each Z
for ii = 1:numel(allZs)
    
    thisFactor = allZs(ii) / zCoreStart;
    if (thisFactor==0)
        featureSizes = [a b 1 c d];
    else
        featureSizes = [a thisFactor b/thisFactor c d]; % first index is the *innermost
    end
    
    % plot physical diagrams
    spatial = spatialDiagram10;
    spatial.featureSizes = featureSizes;
    spatial.featureTypes = { 'bright', 'dark', 'bright', 'bright', 'dark' };
    spatial.calcPlane;
    spatial.figureCorner = figCorner + [0 zScale*thisFactor];
    if (ii==1)
        spread = ceil(spreadVsRange*(spatial.maxX-spatial.minX));
    end
    spatial.plot([spatial.centralX-spread,spatial.centralX+spread]);
        
end




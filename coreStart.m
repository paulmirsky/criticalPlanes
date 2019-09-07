clear all
close all
dbstop on error
clc
addpath([ fileparts(mfilename('fullpath')), '\referenced' ]);

% input parameters
a = 2;
b = 4;
c = 8;
d = 3; % just large enough to pad 
zElbow = (a^2);
allZs = [0 1 2 4] * zElbow;

figCorner = [100 100];
zScale = 60;
spreadVsRange = .8;

% go through each Z
for ii = 1:numel(allZs)
    
    thisFactor = allZs(ii) / zElbow;
    if (thisFactor==0)
        featureSizes = [a 1 b c d];
    else
        featureSizes = [a thisFactor b/thisFactor c d]; % first index is the *innermost
    end
    
    % plot physical diagrams
    spatial = spatialDiagram10;
    spatial.featureSizes = featureSizes;
    spatial.featureTypes = { 'bright', 'bright', 'dark', 'bright', 'dark' };
    spatial.calcPlane;
    spatial.figureCorner = figCorner + [0 zScale*thisFactor];
    if (ii==1)
        spread = ceil(spreadVsRange*(spatial.maxX-spatial.minX));
    end
    spatial.plot([spatial.centralX-spread,spatial.centralX+spread]);
        
end




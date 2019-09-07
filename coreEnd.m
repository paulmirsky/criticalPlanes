clear all
close all
dbstop on error
clc
addpath([ fileparts(mfilename('fullpath')), '\referenced' ]);

% input parameters
a = 2;
b = 3;
c = 12;
d = 9; % just large enough to pad
zBreakout = (a^2*b*(c/b));
allZs = [0 1 3] * zBreakout;

figCorner = [100 100];
zScale = 60;
spreadVsRange = 2;

% go through each Z
for ii = 1:numel(allZs)
    
    thisFactor = allZs(ii) / zBreakout;
    if (thisFactor==0)
        featureSizes = [a 1 b c 1 d];
    else
        featureSizes = [a thisFactor b/thisFactor 12 thisFactor d/thisFactor]; % first index is the *innermost
    end
    
    % plot physical diagrams
    spatial = spatialDiagram10;
    spatial.featureSizes = featureSizes;
    spatial.featureTypes = { 'bright', 'bright', 'dark', 'bright', 'bright', 'dark' };
    spatial.calcPlane;
    spatial.figureCorner = figCorner + [0 zScale*thisFactor];
    if (ii==1)
        spread = ceil(spreadVsRange*(spatial.maxX-spatial.minX));
    end
    spatial.plot([spatial.centralX-spread,spatial.centralX+spread]);
        
end




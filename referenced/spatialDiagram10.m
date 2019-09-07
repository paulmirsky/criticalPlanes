classdef spatialDiagram10  < handle
    
    properties
        featureSizes        
        featureTypes
        planePattern
        nFeatures
        nPoints
        
        % parameters for drawing
        minX
        maxX
        centralX
        brightPositions
        darkPositions
        thisAx % the axes obj
        figureCorner = [100 100] % x, y; this is the *starting corner, and then it moves
        axesDistFromEdge = 15
        axesLineWidth = 3
        axesSize = [600 45] % x, y
        barWidth = 0.7
        barColor = [1 0 0]
        figBackgndColor = [1 1 1]
        brightColor = [255 0 0]/255
        darkColor = [160 195 230]/255
        
    end
    properties (Access = 'private')
    
    end

    
    methods
        
        % constructor
        function this = spatialDiagram10()            
            %  
        % constructor end
        end 
        

        
        
        % 
        function calcPlane(this)

            this.nFeatures = numel(this.featureSizes);
            this.nPoints = prod(this.featureSizes);

            % for each feature...
            this.planePattern = 1; % it starts off trivially
            for ii = 1:this.nFeatures
                nPatches = this.featureSizes(ii);  
                % get the state vector for the feature
                if strcmp(this.featureTypes(ii),'dark')
                    thisStateVec = zeros([nPatches,1]);
                    if ~isItEven(nPatches) % if it's symmetrical            
                        zeroPoint = ceil(nPatches/2);
                    else % if it's not symmetrical
                        zeroPoint = floor(nPatches/2) + 1;
                    end
                    thisIndex = mod((zeroPoint-1),nPatches)+1;      
                    thisStateVec(thisIndex) = 1;        
                elseif strcmp(this.featureTypes{ii},'bright')
                    thisStateVec = ones([nPatches,1]);     
                else
                    error('invalid feature type!')
                end
                % take the outer product of this feature with the cumulative outer product 
                nPointsTotal = numel(this.planePattern)*numel(thisStateVec);
                this.planePattern = reshape(this.planePattern*thisStateVec.', nPointsTotal, 1);                                
            end
            
            % scale it
            this.planePattern = this.planePattern / sum(this.planePattern);
            
            % get important points for plotting
            this.minX = find(this.planePattern,1,'first');
            this.maxX = find(this.planePattern,1,'last');
            this.centralX = ceil( ( this.minX + this.maxX )/2 );
            this.brightPositions = ~(this.planePattern==0); % the xVals where there is nonzero amplitude
            this.darkPositions = (this.planePattern==0); % the xVals where there is nonzero amplitude
            
        % function end
        end
        
        
                          
        
        % varargin is optional [xMin xMax for limits]
        function plot(this, varargin)
                        
            % create axes
            thisFig = figure('position',[ this.figureCorner, this.axesSize+2*this.axesDistFromEdge ],...
                'Color',this.figBackgndColor);
            this.thisAx = axes('parent',thisFig,'units','pixels','LineWidth',this.axesLineWidth,...
                'position',[ this.axesDistFromEdge this.axesDistFromEdge this.axesSize ],...
                'XTick',[],'YTick',[]);
            box(this.thisAx,'on');
            hold on

            % plot the bright patches
            xVals = 1:(this.nPoints);
            bar(this.thisAx,xVals(this.brightPositions),this.planePattern(this.brightPositions),...
                'FaceColor',this.brightColor,'EdgeColor','none','barWidth',this.barWidth);
            
            % plot dark patches
            darkFunction = max(this.brightPositions) * ones([sum(this.darkPositions),1]);
            bar(this.thisAx,xVals(this.darkPositions),darkFunction,...
                'FaceColor',this.darkColor,'EdgeColor','none','barWidth',this.barWidth);
            this.thisAx.YLim(2) = max(this.planePattern);

            % modify x limits
            if nargin > 1
                limits = varargin{1};
                set(this.thisAx,'XLim',limits);
            end
            
        % function end
        end

        
        
    % end of methods           
    end

% end of class       
end


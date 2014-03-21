classdef ErrorCorrectingCode < Wrapper
    % ERRORCORRECTINGCODE Wraps a multiclass classification problem with an
    % error correcting output. The error code can be computed as an Hamming
    % code if the number of classes is < 8, or it can be constructed using
    % a randomized hill climbing similar to what described in:
    %
    % [1] Dietterich, Thomas G., and Ghulum Bakiri. "Solving Multiclass 
    % Learning Problems via Error-Correcting Output Codes." Journal of 
    % Artificial Intelligence Research 2.263 (1995): 286.
    
    % License to use and modify this code is granted freely without warranty to all, as long as the original author is
    % referenced and attributed as such. The original author maintains the right to be solely associated with this work.
    %
    % Programmed and Copyright by Simone Scardapane:
    % simone.scardapane@uniroma1.it
    
    properties
        models;
        code;
    end
    
    methods
        
        function obj = ErrorCorrectingCode(wrappedAlgo, varargin)
            obj = obj@Wrapper(wrappedAlgo, varargin);
            if(~obj.wrappedAlgo.isTaskAllowed(Tasks.BC))
                error('LearnToolbox:Logic:UnsupportedAlgorithm', 'ErrorCorrectingCode requires a base algorithm supporting binary classification');
            end
        end
        
        function initParameters(~, p)
            p.addParamValue('codeType', 'randomized');
            p.addParamValue('n', 20);
        end
        
        function obj = train(obj, Xtr, Ytr)
            
            if(~(obj.getTask() == Tasks.MC))
                
                obj.wrappedAlgo = obj.wrappedAlgo.setTask(obj.getTask());
                obj.wrappedAlgo = obj.wrappedAlgo.train(Xtr, Ytr);
                
            else
                
                nClasses = max(Ytr);
                
                % Generates the code
                obj.code = obj.generateCode(nClasses);
                bits = size(obj.code, 2);
                
                % Initialize the cell array of models
                obj.models = cell(1, bits);
                
                obj.wrappedAlgo = obj.wrappedAlgo.setTask(Tasks.BC);
                
                for i = 1:bits
                   
                    Y = zeros(size(Ytr,1), 1);
                    currentClasses = find(obj.code(:, i) == 1);
                    
                    Y(ismember(Ytr, currentClasses)) = 1;
                    Y(~ismember(Ytr, currentClasses)) = -1;
                    
                    obj.models{i} = obj.wrappedAlgo.train(Xtr, Y);
                    
                end
                
            end
            
        end
    
        function [labels, scores] = test(obj, Xts)
            if(obj.getTask() ~= Tasks.MC)
                [labels, scores] = obj.wrappedAlgo.test(Xts);
            else
                bits = size(obj.code, 2);
                scores = zeros(size(Xts,1), bits);
                
                for i=1:bits
                    [~, scores(:,i)] = obj.models{i}.test(Xts);
                end
                
                scores = sign(scores);
                labels = zeros(size(Xts, 1), 1);
                for i=1:size(Xts,1)
                    [~, labels(i)] = min(pdist2(scores(i,:), obj.code, 'hamming'));
                end
            end
        end
        
        function res = isTaskAllowed(obj, task)
           res = (task == Tasks.MC) || obj.wrappedAlgo.isTaskAllowed(task); 
        end
        
        function code = generateCode(obj, nClasses)
           if(strcmp(obj.trainingParams.codeType, 'hamming'))
               assert(nClasses <= 7, 'Hamming code can be used only with up to 7 classes');
               code = hammgen(nClasses);
           elseif(strcmp(obj.trainingParams.codeType, 'randomized'))
               code = randi([0 1], [nClasses obj.trainingParams.n])*2 - 1;
               optimized = false;
               hammingDistancesRows_old = Inf;
               hammingDistancesColumns_old = Inf;
               while(~optimized)
                  % Find the rows closest in Hamming distance
                  hammingDistancesRows = squareform(pdist(code, 'hamming'));
                  minHammingDistanceRows = min(min(hammingDistancesRows(hammingDistancesRows~=0)));
                  [row1,row2] = find(hammingDistancesRows==minHammingDistanceRows);
                  
                  % Find the columns with the most "extreme" Hamming
                  % distance
                  hammingDistancesColumns = squareform(pdist(code', 'hamming'));
                  minHammingDistanceColumns = min(min(hammingDistancesColumns(hammingDistancesColumns~=0)));
                  maxHammingDistanceColumns = max(max(hammingDistancesColumns(hammingDistancesColumns~=0)));
                  if(minHammingDistanceColumns >= maxHammingDistanceColumns)
                      [col1,col2] = find(hammingDistancesColumns==minHammingDistanceColumns);
                  else
                      [col1,col2] = find(hammingDistancesColumns==maxHammingDistanceColumns);
                  end
                  
                  code(row1(1), col2(1)) = -1*code(row1(1), col1(1));
                  code(row2(1), col1(1)) = -1*code(row1(1), col1(1));
                  code(row2(1), col2(1)) = code(row1(1), col1(1));
                  
                  if(minHammingDistanceColumns >= hammingDistancesColumns_old && minHammingDistanceRows >= hammingDistancesRows_old)
                      optimized = true;
                  else
                     hammingDistancesColumns_old = minHammingDistanceColumns;
                     hammingDistancesRows_old = minHammingDistanceRows;
                  end
               end
           
           else
               error('Code not recognized');
           end
        end
    
    end
    
    methods(Static)
        function info = getInfo()
            info = 'Performs multi-class classification using an Error-Correcting Code strategy';
        end
        
        function pNames = getParametersNames()
            pNames = {'codeType', 'n'}; 
        end
        
        function pInfo = getParametersInfo()
            pInfo = {'Type of error-correcting code', 'Size of the code (only for randomized'};
        end
        
        function pRange = getParametersRange()
            pRange = {'String in {hamming, randomized}, default randomized', 'Positive integer, default 20'};
        end
    end
    
end
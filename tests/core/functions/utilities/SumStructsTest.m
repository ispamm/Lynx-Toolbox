classdef SumStructsTest < matlab.unittest.TestCase
   
    properties
        cellArray;
    end
    
    methods(TestMethodSetup)
        function initCellArray(testCase)
            testCase.cellArray = cell(2,1);
        end
    end
    
    methods (Test)
        
        function testNonCellArray(testCase)
            res = sum_structs([0 1 2]);
            testCase.verifyEqual(res, [0 1 2]);
        end
        
        function testEmptyCellArray(testCase)
            res = sum_structs(testCase.cellArray);
            testCase.verifyEmpty(fieldnames(res));
        end
        
        function testSingleDouble(testCase)
           testCase = testCase.addElement('a', {1, 2}); 
           res = sum_structs(testCase.cellArray);
           testCase.verifyEqual(res.a, 1.5);
        end
        
        function testSingleVector(testCase)
           testCase = testCase.addElement('v', {[0, 1], [1.5, 3]}); 
           res = sum_structs(testCase.cellArray);
           testCase.verifyEqual(res.v, [0.75, 2]);
        end
        
        function testSingleString(testCase)
           testCase = testCase.addElement('s', {'value1', 'value2'}); 
           res = sum_structs(testCase.cellArray);
           testCase.verifyEqual(res.s, {'value1', 'value2'});
        end
        
        function testDoubleAndStringElements(testCase)
           testCase = testCase.addElement('a', {1, 2}); 
           testCase = testCase.addElement('s', {'value1', 'value2'}); 
           res = sum_structs(testCase.cellArray);
           testCase.verifyEqual(res.a, 1.5);
           testCase.verifyEqual(res.s, {'value1', 'value2'});
        end
        
    end  
    
    methods
        function obj = addElement(obj, id, elements)
            obj.cellArray{1}.(id) = elements{1};
            obj.cellArray{2}.(id) = elements{2};
        end
    end
            
    
end


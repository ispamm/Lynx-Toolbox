classdef PrincipalComponentAnalysisTest < matlab.unittest.TestCase
    % The data is taken from:
    %   http://nyx-www.informatik.uni-bremen.de/664/1/smith_tr_02.pdf
    
    properties(Constant)
        data = [2.5 2.4;
                0.5 0.7;
                2.2 2.9;
                1.9 2.2;
                3.1 3.0;
                2.3 2.7;
                2.0 1.6;
                1.1 1.1;
                1.5 1.6;
                1.1 0.9];
            
         transformedData = [ -.827970186 -.175115307;
                            1.77758033 .142857227;
                            -.992197494 .384374989;
                            -.274210416 .130417207;
                            -1.67580142 -.209498461;
                            -.912949103 .175282444;
                            .0991094375 -.349824698;
                            1.14457216 .0464172582;
                            .438046137 .0177646297;
                            1.22382056 -.162675287];
                        
          transformedDataWithOnePrincipalComponent = [-.827970186;
                                                      1.77758033;
                                                      -.992197494;
                                                      -.274210416;
                                                      -1.67580142;
                                                      -.912949103;
                                                      .0991094375;
                                                      1.14457216;
                                                      .438046137;
                                                      1.22382056];

    end
    
    methods (Test)
        
        function testWithAllPrincipalComponents(testCase)
           d = Dataset.generateAnonymousDataset(Tasks.R, testCase.data, (1:2:20)');
           p = PrincipalComponentAnalysis('varianceToPreserve', 1);
           d = p.process(d);
           testCase.assertLessThan(abs(abs(d.X) - abs(testCase.transformedData)), 10^-1);
           testCase.assertEqual(d.Y, (1:2:20)');
           testCase.assertEqual(d.task, Tasks.R);
        end
        
        function testWithOnePrincipalComponent(testCase)
           d = Dataset.generateAnonymousDataset(Tasks.R, testCase.data, (1:2:20)');
           p = PrincipalComponentAnalysis('varianceToPreserve', 0.98);
           d = p.process(d);
           testCase.assertLessThan(abs(abs(d.X) - abs(testCase.transformedDataWithOnePrincipalComponent)), 10^-1);
           testCase.assertEqual(d.Y, (1:2:20)');
           testCase.assertEqual(d.task, Tasks.R);
        end
        
        function testProcessAsBefore(testCase)
            d = Dataset.generateAnonymousDataset(Tasks.R, testCase.data, (1:2:20)');
            p = PrincipalComponentAnalysis('varianceToPreserve', 1);
            [~, p] = p.process(d);
            d = Dataset.generateAnonymousDataset(Tasks.R, testCase.data(1:4,:), (1:4)');
            d = p.processAsBefore(d);
            testCase.assertLessThan(abs(abs(d.X) - abs(testCase.transformedData(1:4,:))), 10^-1);
        end
        
    end  
    
end


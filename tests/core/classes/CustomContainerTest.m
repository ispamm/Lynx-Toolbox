classdef CustomContainerTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testFindById(testCase)
            c = CustomContainer();
            testCase.assertError(@() c.findById('a'), 'Lynx:Runtime:ElementNotFound');
            c = c.addElement(BaselineModel('b', '1'));
            c = c.addElement(BaselineModel('a', '2'));
            testCase.assertEqual(c.findById('a'), 2);
            testCase.assertEqual(c.findById('b'), 1);
            testCase.assertEqual(c.getById('a').id, 'a');
            testCase.assertEqual(c.getById('a').name, '2');
        end
        
        function testFindByIdWithRegexp(testCase)
            c = CustomContainer();
            c = c.addElement(BaselineModel('b', '1'));
            c = c.addElement(BaselineModel('a', '2'));
            c = c.addElement(BaselineModel('b-2', '1'));
            testCase.assertEqual(c.findByIdWithRegexp('a'), 2);
            testCase.assertEqual(c.findByIdWithRegexp('b.*'), [1; 3]);
        end
        
        function testRemove(testCase)
            c = CustomContainer();
            c = c.addElement(BaselineModel('b', '1'));
            c = c.addElement(BaselineModel('a', '2'));
            testCase.assertError(@() c.remove('c'), 'Lynx:Runtime:ElementNotFound');
            c = c.remove('b');
            testCase.assertEqual(c.findById('a'), 1);
            testCase.assertEqual(c.getById('a').id, 'a');
            testCase.assertEqual(c.getById('a').name, '2');
        end
       
    end  
    
end


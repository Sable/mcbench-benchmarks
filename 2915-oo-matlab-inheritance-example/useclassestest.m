function useclassestest

c = samplederived; % instantiate a "Derived" object instance
DoSomething(c,'My string');
DoSomething(c);
DoIntSomething(c); % Call the base class' method
DoSomethingFirst(c); 

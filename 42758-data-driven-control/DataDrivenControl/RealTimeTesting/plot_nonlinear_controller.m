%Copyright 2013 The MathWorks, Inc.

plot( sm.simnlres.Time, sm.simnlres.Data,'r')
hold on
plot( ha.getElement(1).Values.Time, ha.getElement(1).Values.Data,'b')
plot( ha.getElement(2).Values.Time, ha.getElement(2).Values.Data,'g')
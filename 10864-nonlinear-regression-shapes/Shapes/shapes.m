%{

Curve fitting, empirical modeling, and an appreciation of shape?

What do I mean by that last part, and how does it fit in with the rest?

People use specific curve fitting tools (the optimization toolbox, splines
toolbox, curvefitting toolbox, and many other tools that are found on the
file exchange) for many different reasons. I'll discuss some ideas of
empirical/mathematical modeling in this document that I hope will help you
to build better models from your data.

Who is this submission target towards? I've aimed it at the reader who
wants to understand how they might build purely empirical nonlinear
regression models for their data. I provide a general paradigm for
modeling, as well as (in my bestiary) a compendium of functional
forms they can combine together to build a model.

How should you read the document? Perhaps the best way is to use the Matlab
editor (or the publish function in Matlab) to publish this file. Publish
will build an html document, with all figures nicely included. Or, you
can use the cell mode built into the editor to execute chunks of code.
I've enabled this by separating each block with pairs of %% lines. Finally
you could just use cut and paste. This entire document is an executable
Matlab script, as long as you have release 14 or higher of Matlab. Users
of older Matlab releases can still use the ideas, although they will wish
to convert the anonymous functions I have used into inline functions.

Author: John D'Errico
E-mail address: woodchips@rochester.rr.com
Release: 1
Release date: 4/25/06

%}

%% 1. A philosophy of modeling

%{
I'll start this document with a quick discussion of my own modeling
philosophy.

Why do we, as scientists and engineers, fit a curve to data? There are
really two basic reasons why, if we ignore the common "My boss told me
to do this." (I'll limit this entire document to discussions of fitting
a single dependent variable as a function of a single independent variable,
although the same ideas can carry through to higher dimensions.)

The first such reason is for predictive value. We may wish to reduce some set
of data to a simply accessible functional relationship for future use. We may
also wish to be able to predict/estimate some parameter of the relationship,
such as a minimum or maximum value, or perhaps a maximum slope or a rate
parameter.

The second reason for model building is for understanding. Here we have some
data that we wish to interrogate to learn something about an underlying
process. Admittedly, this case applies more to problems with many variables.
For simple one variable problems, we can learn much of what we need to know
with a single plot, but we may need to estimate an asymptote value, or
perhaps a maximum slope.

If we are to fit a model to data, what kind of models do we use, and how
does the model class reflect our goals in the modeling process?

To answer this question, I'll first look at the common modeling tools we
might see. First and most primeval is polyfit. Polyfit allows us to fit a
polynomial model to our data. Such a model tells us little about our process
beyond perhaps a simple slope. These models are really of value only for
very simple relationships, where we are willing to invest little in the
modeling process. Many of the individuals who use polynomial modeling tools
do so for the wrong reasons. They use higher order fits to get a better
approximation to their data, not realizing the problems inherent with
those higher order polynomials. At the other end of the spectrum, one sees
individuals using nonlinear regression to fit a large variety of curves to
data. Exponential terms, gaussian-like modes, sigmoid shapes, as well as
may more. Did these model forms result from valid mechanistic arguments?
Sometimes it is so, but far more often one uses these basic shapes because
the individual knows something about the basic underlying process, and the
model chosen has the correct basic shape.

There is a subtle variation on the mechanistic model. I call it the
metaphorical model. Here we use a mathematical model of one process that
we do understand, used as a model for a process that we do not really
understand. My favorite examples of such metaphorical models are cubic
splines, where a mathematical model of a thin flexible beam is used to
predict many other processes, and epidemiological models as used to predict
sales of some product. There are many other examples of course. An advantage
of a metaphorical model is it may help us to understand/predict/even
extrapolate future behavior based on our knowledge of the metaphor.

This document is a discussion of model building from the totally empirical
point of view. Its for the analyst who needs to build a model, not from
physical principles or a differential equation describing the behavior of
a system, but merely from knowing something about the basic shape of the
uderlying relationship under study.

Before I get into nuts and bolts of building an empirical model using
nonlinear regression, I'd like to emphasize some ideas. An important
part of the modeling process is knowing your data. You need to know the
system under study well enough that you know if the bumps and wiggles in
your data are worth chasing, or if they are just noise. You need to
understand your goals, in terms of predictive accuracy, or if there are
specific parameters that you must estimate.

Finally, whenever you build any model, in any form, always plot your data.
Plot the curve fit. Plot the residuals. If the data was generated in a
specific order, then plot the residuals in the order they were generated.
Think about your results. Look for patterns. See if the final parameters
make physical sense. Look at any statistics on the modeling process, but
any single number is secondary to thought about those same results. Should
you look at the value of R^2? I don't. I never have. If I'm satisfied with
the fit, why bother? If I'm dissatisfied, no single number will change my
mind.

On to modeling...

%}

%% 2. A model paradigm

%{
Many nonlinear regression models can be written in a simple form, as
an additive sum of terms. Thus

  y = F1(x) + F2(x) + F3(x) + ...

Likewise, each of these terms can typically be expressed in a simple
form, as one of these alternatives

  F1(x) = a1*f1((x - b1)/c1)

  F1(x) = a1*f1(c1*(x - b1))

Occasionally, we might see a form like

  F1(x) = a1*f1(c1*(x - b1).^d1)

although the exponent will generally not leave the term shape invariant.
(See section 4 for a discussion of shape invariance.)

Some example models in this general paradigm are

1. y = a + b*x
2. y = a + b*x + c*x.^2 + d*x.^3
3. y = a*exp(-b*x)
4. y = a*exp(-b*x) + c*exp(-d*x)
5. y = a + b./(1+exp(-c*x))
6. y = a*exp(-((x-b)/c).^2/2)

I could go on virtually forever with this list. I will try to expand it in
the later chapters of this document. But before I do, first let me make a
few comments. In the general form

  F1(x) = a1*f1(c1*(x - b1))

if we use f1(x)=x, then this term becomes

  F1(x) = a1*c1*(x-b1)

First, note that a1*c1 is really only a single parameter, since I can trade
off any increase in a1 with a proportionate decrease in c1. So we really
should drop either a1 or c1 from this term.

  F1(x) = a1*(x-b1)

Next, if we expand the term, and if we also had a constant term in our overall
model, then the a1*b1 term can be similarly absorbed into the constant term,
leaving us with a term in its simplest form

  F1(x) = a1*x

Our model as we might estimate it might then look like

  F(x) = a1*x + a2

Likewise, given an exponential term,

  F1(x) = a1*exp(c1*(x-b1))

we can manipulate this term again to look like

  F1(x) = (a1*exp(-c1*b1))*exp(c1*x)
  
Again, we can absorb the entire mess (a1*exp(-c1*b1)) into a single
multiplicative factor to estimate.

  F1(x) = a1*exp(c1*x)

Another aspect of parameter manipulations is seen best with trigonometric
terms in a model and trigonometric identities. Consider the model

  y = a1*sin(c1*(x-b1)) = a1*sin(c1*x - b1*c1)

We can use a trig identity for the sine of a difference of angles to expand
the sine term into a pair of terms

  y = a1*sin(c1*x) + a2*cos(c1*x)

This latter form may be easier to estimate than the former. Post-estimate
reversion to the original phase shifted form is quite simple.

%}

%% 3. Linear versus nonlinear parameters

%{
The concept of a linear parameter versus a nonlinear one is pertinent to
partitioned least squares solvers, such as my fminspleas and pleas codes
on the file exchange. 

Pleas is included in:

http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=8553&objectType=FILE

And fminspleas is to be found here:

http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=10093&objectType=FILE

You will find a discussion of partitioned (sometimes known as separable
nonlinear least squares) in Seber & Wild, "Nonlinear Regression", or at the
folowing URL:

http://64.233.161.104/search?q=cache:KmOn6r0gmn0J:www.statsci.org/smyth/pubs/eoe_nr.pdf+watts+partitioned+least+squares&hl=en&client=safari


Consider the expression

  y = a1*f1((x-b1)/c1) + a2*f2((x-b2)/c2)

If {b1,c1,b2,c2} were all given as some known (fixed!) values, then we could
estimate the coefficients {a1,a2} using LINEAR least squares techniques from
data. This is the procedure used in the pleas variants above. Nonlinear
estimation techniques are still used on the parameters {b1,c1,b2,c2}.

These parameters would be referred to as intrinsically nonlinear parameters,
and the parameters {a1,a2} are intrinsically linear.

%}

%% 4. The invariance of shape

%{
Consider the single model term:

  a1*x

Suppose we were to change the value of a1? Double it perhaps. Will the general
shape of this term change? Its still a straight line, only the slope will be
different. Any finite value of a1 will merely change the slope. No fixed value
of a1 will make this a curved line though, or even change the x or y intercept.

Now consider a more complex term:

  a1*sin((x-b1)/c1)

What do each of these parameters do to this term?

The (intrinsically linear) parameter a1 changes the amplitude of the sine wave.

The (intrinsically nonlinear) parameter b1 shifts the entire sine wave along
the x axis.

The (intrinsically nonlinear) parameter c1 changes the frequency of the sine
wave.

Again, none of these parameters changes anything about the fundamental shape
of our sine wave. All are simple shifts or scale factors. No values of these
parameters will change the fundamental shape of a sine wave into an exponential
rise.

%}

%%

% I'll give some examples of how these parameters work on a sine wave.
% First, changes in ampitude, given by abs(a)

fun = @(x,a,b,c) a*sin((x-b)/c);

close
fplot(@(x) fun(x,1,0,1),[-10,10],'r-')
hold on
fplot(@(x) fun(x,2,0,1),[-10,10],'b-')
fplot(@(x) fun(x,4,0,1),[-10,10],'g-')
fplot(@(x) fun(x,8,0,1),[-10,10],'y-')
fplot(@(x) fun(x,-1,0,1),[-10,10],'m-')
hold off
grid on
title 'Amplitude variations'
legend('a == 1','a == 2','a == 4','a == 8','a == -1')

%%

% Shifts (translations) in x

close
fplot(@(x) fun(x,1,0,1),[-10,10],'r-')
hold on
fplot(@(x) fun(x,1,pi/4,1),[-10,10],'b-')
fplot(@(x) fun(x,1,pi/3,1),[-10,10],'g-')
fplot(@(x) fun(x,1,pi/2,1),[-10,10],'y-')
fplot(@(x) fun(x,1,pi,1),[-10,10],'m-')
hold off
grid on
title 'x axis Translations'
legend('b == 0','b == pi/4','b == pi/3','b == pi/2','b == pi')

%%

% x axis scale factors

close
fplot(@(x) fun(x,1,0,1),[-10,10],'r-')
hold on
fplot(@(x) fun(x,1,0,2),[-10,10],'b-')
fplot(@(x) fun(x,1,0,4),[-10,10],'g-')
fplot(@(x) fun(x,1,0,1/2),[-10,10],'y-')
fplot(@(x) fun(x,1,0,1/4),[-10,10],'m-')
hold off
grid on
title 'x axis scale'
legend('c == 1','c == 2','c == 4','c == 1/2','c == 1/4')

%% 5. Parameterization subtleties
%{
I discussed the simple form f(x)=a*(x-b) in section 2. Its an illustrative
model form, in that we could also write a linear model as f(x)=a*x+b. Both
of these forms equally well describe a straight line. How do they differ?

The first form, f(x)=a*(x-b), intercepts the x axis at x = b. The second
form intersects the y axis at y = b. We can estimate either model form
as easily as the other. It is you, the end user doing the modeling, that
must make the decision of whether one of these forms is better than the
other for your own purposes.

As another example, consider the model

  f(x) = a*exp(-((x-b)/c)^2/2)

This is a simple gaussian form. The parameters can be interpreted as:

- b is the mode of the bell shaped curve
- c is the "standard deviation", a measure of the width of the curve
- a is the height of this curve at x == b.

We could have parameterized this slightly differently to make the area
under the curve over [-inf,inf] fixed at 1. This would have meant an
extra scale factor in front.

I like this parameterization of a bell curve:

  f(x) = a*exp(-log(2)*((x-b)/c)^2)

Here, a and b have the same interpretations as above, but c now has a
nice interpretation as the half-width at half-height. Thus it tells us
the "width" of the bell curve, using a visually meaningful parameter.

The point of this section? Artful choice of the parameters of a nonlinear
(or linear) model can give a set of parameters with meaning in the problem
context.

%}

%% 6. Combinations of terms
%{
Perhaps its best to give a few examples in this section.

- Consider the function y = a*x^2. Adding some constant to this function,
so that it becomes y = a*x^2 + b will translate the entire function upward
in y by an amount b.

- Start with a simple function, y = a*x. It has a slope of a, and passes
through the origin. Next, expanding the function with an additional term,
y = a*x + b*exp(-c*x)*sin(d*x), results in a form that oscillates above
and below the line sinusoidally, but by a decreasing amount as x increases.
The curve will approach y = a*x as an asymptote.

- A sum of erfs, in the form y = a*erf(x) - a*erf(10-x). This looks like
a smooth step up from zero to a height of a at x=0, then drops back down
to zero around x=10. Both transitions are smooth.

- The simple absolute value function, y = a*abs(x), is a pair of intersecting
lines, one with a slope of -a for x below zero, then above 0, the line has
a slope of +a. Combine this with a second term, y = a*abs(x) + b*x. For x
below zero, we have a straight line with a slope of b-a. For x above zero,
we have a straight line with a slope of b+a. In effect, this is a simple
way to build a piecewise linear spline. Additional terms of the form
c*abs(x-d) can add knots to the "spline".

The trick is to visualize the underlying shape of your data, then learn
to break it into some set of atomic elements, modified appropriately.
Are there any fundamental behaviors that you recognize, such as an
asymptote? Is there oscillatory behavior?

%}

%%

% Not all bell curves are symmetric in shape, however the standard forms
% often are symmetrical. How might we build an asymmetrical bell curve?

% A simple bell curve
f0 = @(x) 1./(1+x.^2);
% and its derivative
f1 = @(x) 2*x.*(1+x.^2).^(-3/2);

close
c = 0.5;
fplot(@(x) f0(x) + c*f1(x),[-5,5])
title 'An asymmetrical bell curve, positively skewed, c = 0.5'

%%

% Varying c can change the shape of our composite curve
close
c = -.3;
fplot(@(x) f0(x) + c*f1(x),[-5,5])
title 'An asymmetrical bell curve, negatively skewed. c = -0.3'

%% 7. Shape, wonderful shape
%{
I once was posed a problem equivalent to finding a model for a system
that was asymptotically linear as x approaches both +inf and -inf,
but the slope of this curve was different for each asymptote. There
was a smooth transition between the two linear portions of the curve. 
(Yes, a spline model would work well here, but this is not a treatise
on spline building.) Can we do this with a nonlinear model? I showed
such a trick for a piecewise linear model in section 6.

What property would a model have that is asymptotically linear in
both directions, but has the desired shape? What would its second
derivative function look like? The second derivative must approach
zero in both directions. A bell curve (say a Gaussian variant of
some form) has this property, as well as the shape I'll need.
Integrate twice, the first integral will be an erf, the second
integral will have the form...

  y(x) = a + b*x + c*erfi((x-d)/e)

where I'll define erfi as

  erfi(x) = integral(erf(z)*dz,0,x)

          = x*erf(x) + exp(-x^2)/sqrt(pi)

%}

%%

% Look at the shape of this erfi term. Note the similarity to abs(x).
% I'll overlay abs(x) on top, just as a comparison
fplot(@(x) x.*erf(x)+exp(-x.^2)/sqrt(pi),[-2,2],'b-') 
hold on
fplot(@(x) abs(x),[-2,2],'r--')
hold off
legend('erfi(x)','abs(x)')

%%

% We could have used a similar approach to develope a model form by
% starting with a different bell curve. I'll leave this derivation
% to my readers, but what if I had started with 1/(1+x.^2) as the
% bell curve?

%%

% Here is another variant on the asymptote theme. Start with a
% hyperbola, u = 1/v, then rotate the axes.
%
% y = u + v
%
% x = u - v
%
% Substitute in for u and v, then solve for y as a function of x.
%
% y = sqrt(1+x.^2)
%
% Compared to the previous erfi term, the shape is subtly different.
fplot('sqrt(1+x.^2)',[-2,2],'b-') 
hold on
fplot(@(x) x.*erf(x)+exp(-x.^2)/sqrt(pi),[-2,2],'g-') 
hold on
fplot(@(x) abs(x),[-2,2],'r--')
hold off
legend('Hyperbola: y = sqrt(1+x.^2)','erfi(x)','abs(x)')

%% 

% A numerical example might be nice.
t = [0.22 1.19 1.58 2.95 3.94 4.85 5.65 7.18 8.20 9.23 9.98...
  11.06 11.62 12.95 14.22 15.39 15.77 16.76 18.37 18.73 20.31];

v = [0.176 0.068 0.077 0.567 0.775 1.068 1.012 1.405 1.55 1.83...
  2.30 3.14 3.68 5.63 6.88 8.48 8.80 10.21 12.15 12.44 13.96];

tpred = 0:.01:21;

close
plot(t,v,'.')

%%

% A simple, piecewise linear model for the curve might be found by
plusfun = @(x) max(0,x);
f = {1, @(c,x) x, @(c,x) plusfun(x-c)};

[INLP,ILP] = fminspleas(f,12,t,v)

% model predictions
vpred = ILP(1) + ILP(2)*tpred + ILP(3)*plusfun(tpred-INLP);
plot(t,v,'ro',tpred,vpred,'b-')
title 'Piecewise linear spline'

%%

% An alternative model
f3 = @(x) x.*erf(x) + exp(-x.^2)/sqrt(pi);
f = {1, @(c,x) x, @(c,x) f3((x-c(1))/c(2))};

[INLP,ILP] = fminspleas(f,[12,2],t,v)

% model predictions
vpred = ILP(1) + ILP(2)*tpred + ILP(3)*f3((tpred-INLP(1))/INLP(2));
plot(t,v,'ro',tpred,vpred,'b-')
title 'Erf integral'

%%

% A second alternative
f3 = @(x) sqrt(1+x.^2);
f = {1, @(c,x) x, @(c,x) f3((x-c(1))/c(2))};

[INLP,ILP] = fminspleas(f,[12,2],t,v)

% model predictions
vpred = ILP(1) + ILP(2)*tpred + ILP(3)*f3((tpred-INLP(1))/INLP(2));
plot(t,v,'ro',tpred,vpred,'b-')
title 'Hyperbola'

%%

% A third alternative
f3 = @(x) (x/pi+0.5).*(x>=0) + (atan(x)/pi+0.5).*(x<0);
f = {1, @(c,x) x, @(c,x) f3((x-c(1))/c(2))};

[INLP,ILP] = fminspleas(f,[12,2],t,v)

% model predictions
vpred = ILP(1) + ILP(2)*tpred + ILP(3)*f3((tpred-INLP(1))/INLP(2));
plot(t,v,'ro',tpred,vpred,'b-')
title 'Piecewise atan/linear segment'

% Which one of these was the correct model for this data? Only I know,
% but any one of the above models look to be a quite reasonable fit to
% this data.

%%

% I'll add a note about the subtle differences in shape of some
% functional forms. I provide 4 distinct model terms in my bestiary,
% each of which takes the general form of a bell function. I've also
% built them all in such a way that all have the same peak height and
% width at half height.

% Subtle differences in shape between 4 different bell curves.
f = @(x) exp(-log(2)*x.^2);
fplot(f,[-5,5],'r')
hold on

f = @(x) 1./(1+x.^2);
fplot(f,[-5,5],'g')

f = @(x) 4*exp(log(3-sqrt(8))*x)./(1+exp(log(3-sqrt(8))*x)).^2;
fplot(f,[-5,5],'b')

f = @(x) sech(x*asech(sqrt(1/2))).^2;
fplot(f,[-5,5],'y')
grid on
hold off
legend('Gaussian','Inverse quadric','Logistic','Sech^2','Location','NorthWest')

% Note that the yellow and blue curves overlay each other. They
% are in fact identically the same curves, although derived in
% different ways.

%%

% In the end, what matters is that you think about your model and your
% data, and always apply a little creativity to your model building!


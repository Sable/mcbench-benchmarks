%
%  radar_detector models a Markov-Chain representation of
%  a patrol car looking for speeding cars to ticket
%
%  RADAR moves from state to state when bounce-back pulse is 
%  received.  The state transistion is also dependent on the 
%  probability that the transition will occur.
%
%  The states that are traveled through are an initialization 
%  stage (Init), two seeking substates where the car is detected 
%  or not (Acquired, not_Acquired), a waiting state (Wait) 5 seconds 
%  before the final state and a final state where the
%  speed of the car has been determined (Locked).
%
%  A parallel state is used to track the time taken to determine 
%  the car's speed.  A ticket can be given if the speed was determined
%  within 8 seconds - to allow the police officer to maintain visual
%  contact with car.
%
%  The 5 second is required to correctly determine the car's speed
%  due to the number of RADAR pulses (2 to 3) recieved in that time.
%  
%  Transition probabilities were selected to mimic a moderately
%  successful RADAR.  If you wish to see a failure to ticket, try
%  using the seed values of 20192, or 598345 in the uniform random
%  number block.
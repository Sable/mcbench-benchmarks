%#codegen
function leds_out = ...
  blink_leds(num_leds_pow2_in, cycles_per_count_in)
 
persistent value count
 
if isempty(value)
    count = 0;
    value = 0;
end
 
leds_out = value;
 
count = count + 1;
 
if count >= cycles_per_count_in
    count = 0;
    value = value + 1;
    if value >= num_leds_pow2_in
        value = 0;
    end
end
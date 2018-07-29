cycles_per_count_in = 2;
num_leds = 2;
 
for i1 = 1:20
    leds_out(i1) = ...
        blink_leds(2^num_leds, cycles_per_count_in);
end
 
plot(leds_out,'o');
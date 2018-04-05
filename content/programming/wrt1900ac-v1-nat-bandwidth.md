Title:  WRT1900AC v1 NAT Bandwidth Test
Date:   2018-02-25 14:58:00 +0000
Status: draft

# Why
I recently acquired a [Linksys WRT1900ACv1](https://wikidevi.com/wiki/Linksys_WRT1900AC_v1) router/access point (on sale from the Linksys page for $129). Since I've recently gotten gigabit internet from ~~the evil empire~~ AT&T, I'm keenly interested in getting a router that will allow my internal network (with ~20 devices/VMs on it at any given time) to access the internet at full speed. 

For background, my current Buffalo [WZR-600-DHP](https://wikidevi.com/wiki/Buffalo_WZR-600DHP), running OpenWRT Barrier Breaker 14.07](https://wiki.openwrt.org/doc/barrier.breaker) gets about 150-200Mbps (both up and down) out to the internet (speedtest.net web check, Microsoft Azure East US iperf3, Digital Ocean NYC2 iperf3), depending on time of day...AT&T aparently has some very congested links that can go do to 50Mbps down. 

Now that I've got something new, I wanted to put it through its paces in a controlled environment so that I can see how it handles the load of doing NAT for gigabit class connections. To minimize variables, I'm going to do this on my local network. 

# Testing
For this experiement I'm going to be conducting three tests:

1.  Laptop A -> WZR-600-DHP LAN Gigabit -> Gigabit Switch -> Laptop B. This does no NAT translation during the transfer.
2.  Laptop A -> WRT1900ACv1 with stock firmware (LAN Gigabit -> NAT -> WAN Gigabit) -> WZR-600-DHP LAN Gigabit -> Gigabit Swtich -> Laptop B
3.  Laptop A -> WRT1900ACv1 with OpenWRT/LEDE 17.04.1 (LAN Gigabit -> NAT -> WAN Gigabit) -> WZR-600-DHP LAN Gigabit -> Gigabit Swtich -> Laptop B

For each of these tests, I will run iperf3 with the server being on Laptop B (10.53.1.13) and the client on Laptop A. I will run `iperf3 -c 10.53.1.13` to get the upstream bandwidth (like I am uploading to the internet) and then immediately run `iperf3 -c 10.53.1.13 -R` to get the downstream bandwidth (like I am downloading from the internet). 

This methodology should be similar enough, that the results can be compared against those run against the instructions provided on the [OpenWRT Benchmark Network Address Translation](https://wiki.openwrt.org/doc/howto/benchmark.nat) page. 

## Experiment 1 - No NAT
Laptop A -> WZR-600-DHP LAN Gigabit -> Gigabit Switch -> Laptop B. This does no NAT translation during the transfer

**Result: 940Mbps Down, 942Mbps Up**

This indicates that both the sender and receiver are running at gigabit speeds and that the various LAN switches in the middle don't have any serious impact on speed.

## Experiment 2 - Stock Firmware NAT
Laptop A -> WRT1900ACv1 with stock firmware (LAN Gigabit -> NAT -> WAN Gigabit) -> WZR-600-DHP LAN Gigabit -> Gigabit Swtich -> Laptop B

**Result: 941Mbps Down, 937Mbps Up**

This indicates that with the stock firmware, the hardware is sufficient to not impose a penalty on the NAT traversal. 

## Experiment 3 - OpenWRT/LEDE Firmware NAT
Laptop A -> WRT1900ACv1 with OpenWRT/LEDE 17.04.1 (LAN Gigabit -> NAT -> WAN Gigabit) -> WZR-600-DHP LAN Gigabit -> Gigabit Swtich -> Laptop B

**Result: 922Mbps Down, 937Mbps Up**





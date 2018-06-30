Title:  "Updating a Moto G"
Date:   2018-06-21 22:00:00 -0500

Several years ago, I got my wife a Moto G phone. At the time $180 for an unlocked/no-contract phone was revolutionary, but now there are lots of cheap phones out there. Still it was nice that this was a near-default configuration.

Anyway, over a year ago, she updated to a [Google Pixel (5")](https://www.gsmarena.com/google_pixel-8346.php). Since then the old Moto G had been sitting on my desk, waiting for something to happen with it. We recently took a trip to South America, and my wife didn't want to bring her Pixel, so I suggested she bring the Moto G. However, when I looked at it, I noticed that the case was swollen, like I've seen a couple times before when a battery vents some gas. (An [article](https://www.howtogeek.com/244846/what-to-do-when-your-phone-or-laptop-has-a-swollen-battery/) from howtogeek about this phenomon, this phone had been charging for an unknown amount of time in this state.) At this point, I figured I could get a battery in a couple days from Amazon and swap it out before the trip.

Changing the Battery
--------------------

The first thing I had to do was figure out what model of a Moto G it was. The Moto G line has been a long-running line for Motorola, from 2013 to the present. I looked back at the receipt I had saved in my e-mail, but it didn't have much information about it (except that it was purchased in 2014), maybe it was the 2nd Generation? I did find a model number on the back (inside the cover) `XT1064`. Looking at the [Lineage page for this](https://wiki.lineageos.org/devices/titan) (more on this in a bit), I was able to verify that it was the [2014/2nd Generation of the Moto G](https://www.gsmarena.com/motorola_moto_g_%282nd_gen%29-6647.php), but not the 4G variety. For Lineage (and other Roms) this is code named "titan".

Now I was off to Amazon. Unfortunately, there were only a few compatible batteries that were available, and they aparently all need to be shipped from China, because the standard shipping on them was a couple weeks. This was no good for my trip in a couple days (and I didn't want to pay $35 in shipping for a $14 battery!), so I put it on the shelf and gave my wife an old [Nexus 5](https://www.gsmarena.com/lg_nexus_5-5705.php) I had lying around (and had previously replaced a bulging battery in!). 

Upon return, I quickly ordered a battery from Amazon: [Ed30 Snn5932a](https://www.amazon.com/gp/product/B010NBTG6O/ref=oh_aui_detailpage_o02_s00?ie=UTF8&psc=1) - $14. Once this arrived (it only took 3 days, not the multiple weeks estimated), I went to the [iFixit instructions](https://www.ifixit.com/Guide/Motorola+Moto+G+2nd+Generation+Battery+Replacement/52246) and got started. There were a whole bunch of screws, (of two different sizes). Once they were removed, the power and volume buttons unexpectedly fell off. Next I had to remove three connectors that had to be removed from the motherboard. I then removed the SD/Sim adapter. There were a couple black tabs over the copper that had to be rolled back. Next, I had to take the copper foil off the battery. This was tricky, as I didn't want to rip it, I just went slow and it went fine. Now the battery didn't just fall out, it turns out that those two black tabs that I bent back were attached to strips of adhesive that was holding the battery down. I got a pry tool out and use that to pull the battery off the adhesive. Then it was a matter of putting the old battery back into about the same spot (so its connector would line up. Then putting the copper foil back on, again carefully. There wasn't any obvious way to get the SD/Sim holder lined up, so I just made sure it was in a spot where the connectors were happy. Then the last thing I did before putting the back on, was to put the power and volume buttons back in the slot. Cover on, screws in...and it booted up!

Changing the OS
---------------

Now I had a working phone, but unfortunately it hadn't gotten a security update in over a year. Not something I'd really want to put my data on. So I decided to give [Lineage](https://lineageos.org/) a try. 

I had already found the correct page for the device, now I just needed to follow the [instructions](https://wiki.lineageos.org/devices/titan/install). They're pretty good, but there were a couple spots where a first-time ROM flasher (well, actually 2nd time, I flash CyanogenMod back in ~2012 when my Nexus One's power button stopped working while I was living in Bolivia) like me didn't know what to do.

The first step was setting up adb/fastboot on my computer (Ubuntu 16.04). I've done this a couple times before, but didn't have it currently. I started with the google download, but had some permission issues with udev rules. Instead, I just `sudo apt install adb fastboot` and I was off to the races. I later learned there's also an `android-tools-adb` and `android-tools-fastboot`, which don't seem to be dependencies on each other, so I'm not sure I installed the best ones...but they worked great.

While I was downloading stuff, I also got:

*   [The Lineage ROM for titan](https://download.lineageos.org/titan)
*   [The Google Apps (ARM, 7.1, aroma)](https://opengapps.org/?api=7.1&variant=aroma)
*   [Team Win Recovery Project (TWRP) for titan](https://dl.twrp.me/titan/) recovery image

Now I was all set to start.

I connected the phone to my computer by a USB cable, then set it to USB debugging. Strangely by clicking on the Settings -> About -> Build number **seven times**, I guess they didn't want people to click it without having some idea of what they were doing.

I was then able to `adb reboot bootloader`, which set the phone into a non-gui mode. From there I was able to run `sudo fastboot devices` to see my phone. I then tried to run `fastboot oem device-info` like was mentioned in the directions, but it didn't work. Even without that, I proceeded to contact [Motorola Support](http://motorola-global-portal.custhelp.com/app/standalone/bootloader/unlock-your-device-a) to get the unlock code. They said that I instead needed to run `sudo fastboot oem get_unlock_data` instead. With that, I got five lines of hex data out, that I had to concatenate together and submit to get the code. With the unlock code in hand, I ran `sudo fastboot oem unlock CODE_HERE`. It responded with:

    ...
    (bootloader) Unlock code = CODE_HERE
    
    (bootloader) Partition not found
    (bootloader) Phone is unlocked successfully!
    OKAY [  0.918s]
    finished. total time: 0.918s

Which despite the "Partition not found" seemed good. 

I then rebooted and then back into the bootloader. Now I was ready to flash the recovery image.

    $ sudo fastboot flash recovery twrp-3.2.1-0-titan.img 
    target reported max download size of 536870912 bytes
    sending 'recovery' (6 KB)...
    OKAY [  0.036s]
    writing 'recovery'...
    (bootloader) Invalid boot image
    FAILED (remote failure)
    finished. total time: 0.072s

Aparently I had a corrupted download! Only 6KB. Luckily the flash command realized that this was corrupted...otherwise I would have had a nice slim brick. Let this be a lesson...always check the file hash! I got the correct file, verified with gpg, then uploaded.

    $ sudo fastboot flash recovery twrp-3.2.1-0-titan.img 
    target reported max download size of 536870912 bytes
    sending 'recovery' (8162 KB)...
    OKAY [  0.281s]
    writing 'recovery'...
    OKAY [  0.354s]
    finished. total time: 0.635s

This worked much better.

Now I uploaded the images to the phone.

    $ adb push lineage-14.1-20180617-nightly-titan-signed.zip /sdcard/
    4882 KB/s (333346542 bytes in 66.667s)
    $ adb push open_gapps-arm-7.1-aroma-20180620.zip /sdcard/
    5932 KB/s (1201805700 bytes in 197.828s)

After this, I don't remember all the steps...there was a bit of stress, so I'm going to try to remember the GUI stuff as well as I can.

The instructions recommended doing a backup, so I went through those steps in the GUI. I'm not sure what this is for, I don't have any data on this phone...do I need to backup the OS? 

Next I Selected the "Install" option, and browsed to the lineage-titan image. I installed it, and it went smoothly. 

Now the directions indicated that if I wanted the Google Apps, I should install them now. Somewhere in the documentation I read that Apps installed now go onto the system partition, which I thought would be a good idea since the phone doesn't have a ton of space...this could save space on the main partition. So I selected most of the options from the menu...at least all the stuff I use regurally. Skipped the foreign keyboards and some garbage like Google Newstand. Then I ran the install command. After a few seconds, it came back with a message saying that there wasn't enough space and the installer was exiting.

Yikes, at first I was very stressed. I had already installed the main ROM and knew that as soon as I rebooted I'd be into it and wouldn't have another chance to install the GApps. After stopping and thinking about it for a second, I went back and tried installing that again. It seemed to not care that I had already tried (and failed) and was willing to try again. It even remembered my app selections. This time I went through and removed a lot of the more crufty stuff to trim it down....still not enough space. I tried a few more times, eventually getting down to a list where everything on it was stuff I'd definatly be using, and there still wasn't enough space. I even tried removing the backups that I'd previously made to see if it would help. It didn't seem to, I'm not sure if that is even on the same partition that the apps are installing to. I hope that backup isn't important. (In retrospect, I should have used adb pull to grab it off onto my PC) At this point, I noticed that it was outputting a log file, so I used adb to pull that off

    adb adb pull /sdcard/open_gapps_log.txt

This file was great. It listed all the apps I was trying to install, how much space each took and how much space was available for them. 

Also at this point, I realized that not installing any particular app wasn't going to be an issue, I could just get it through google play. So I got rid of a couple big ones: maps, docs, sheets and was under the size limit. Now the command worked! 

In retrospect, I would have gone with a much smaller install. Maybe just the play store and play services? Everything else is getting regular updates, and I assume these updates have to go on the normal partition, even if it was perviously on the system partition...so any space saving I get here will be temporary. 

After this I was able to reboot (startup took a while) and I was in to a running Lineage!

It was little stressful when I was worried I might be messing things up, but that just makes victory even sweeter in the end. All in all, it was a fun little project and only took me an hour or two. There wasn't much that was super advanced here, I think I could sit down with just about anybody and talk them through doing it to their phone. Hopefully I can get more converts to using a non-stock rom!

Thanks to all the volunteers at lineage (and TWRP/Gapps) for their great software and good documentation!

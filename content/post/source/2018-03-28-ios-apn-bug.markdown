---
comments: true
date: 2018-03-28T00:00:00Z
keywords: ios, 11, ios11, bug, apn, 
title: 'IOS 11: Fixing APN Configuration Issues'
url: /2018/03/28/ios-apn-bug/
draft: false
---

So a few days ago I’ve decided to move to another cellular carrier. I pushed the new sim-card in, and got greeted with “Could not activate cellular data network”. First instinct was to install the new carrier’s APN configuration profile, but this resulted in another bummer: “Only one APN configuration can be installed at a time”. Ok, so I have to delete the previous carrier’s profile. Settings -> General -> Profiles …and there weren’t any profiles: “No profiles are currently installed”. Wat?

So out of desperation I tried to erase the phone, and set it up as a new - problem solved. Restored my data from backup - problem restored as well. But I wasn’t really up to installing everything from scratch.

To make matters a bit more complicated, the new carrier’s sim was set to block displaying APN configuration (Settings -> Cellular -> Cellular Data Options -> Cellular Network). Luckily, [another iOS bug](https://forums.macrumors.com/threads/apn-help-problem-after-upgrading-to-ios7.1642124/) allowed to see the data:

<img src="/images/iosbug/badapn.jpg" alt="" width="300"/>

Ok. So the MMS APN was setup correctly, however the cellular data APN reverted back to the one of the previous carrier. No wonder it couldn’t activate cellular data network.

After some more googling, [I found that there is a file](https://discussions.apple.com/thread/8143573), that might be cause this issue:
com.apple.managedCarrier.plist

And it did. I used the [iBackupBot](http://www.icopybot.com/itunes-backup-manager.htm) software to analyze the iPhone’s backup file, found the file, deleted it, restored the phone from the modified backup, and voila - problem solved!
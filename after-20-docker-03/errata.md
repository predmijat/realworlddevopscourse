#### Errata

##### 05: VPS

Pricing changed since I've created the course.

When you see the monthly price, it really does sound a lot, but you can finish the course in a few days and then destroy the Linode.
You pay for what you use, so plan a weekend to do the course and you will save a lot of money.

##### 19: WireGuard - Part 1

Having VPS' public IP in AllowedIPs in client config will not work by default - macOS GUI app does some magic under the hood to make it work.
If you're not using macOS GUI app, check the Q&A for this lecture, there's a solution and a workaround provided.

---

Name of the file where you configure WireGuard server (in my case `wg-do-p.conf`) should be maximum 15 characters long (exluding the `.conf`)!

This will also be used for the interface name which at the moment I'm writing this is limited to 15 characters in Linux kernel.

Special THANK YOU goes to Bojana Dejanovic for reporting this one!

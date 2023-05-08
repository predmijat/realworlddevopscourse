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

##### 24: iRedMail - Part 1

Linode blocks port 25 on all accounts created after November 5th, 2019.

If you are in this category, you'll have to open a support ticket with Linode after you finish setting up your mail server. Check [Running a Mail Server](https://www.linode.com/docs/guides/running-a-mail-server/#sending-email-on-linode) for more information.

This is only if you are planning to send external email - to connect to another email server, Linode needs to unblock port 25 for you.

If, however, you are planning to use this mail server only for notifications, you don't have to go through this - email will be sent from your mail server to your mail server and will never leave your VPS.

##### 27: Traefik - Part 2

Do not use `.` (dot) in the service name (`service=...` in `.env`). If you take a look at the Docker labels, you'll see that a dot is used to separate the fields, so using a dot in a service name will break your `docker-compose.yml`.

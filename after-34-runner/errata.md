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

##### 21: MariaDB

In the video I say that `mysql` and `mariadb` commands are interchangeable. Since then, MariaDB has deprecated the `mysql` command and it will remove it in a future version. You can either use `mariadb` command, or if you really want to conitinue to use `mysql` you can create a symlink like we did with `vi` -> `vim` in `essentials/tasks/packages.yml`. To do that, add the following block to `mariadb/tasks/main.yml`:
```
- name: symlink mysql
  ansible.builtin.file:
    src: /usr/bin/mysql
    dest: /usr/bin/mariadb
    state: link
```

##### 24: iRedMail - Part 1

Linode blocks port 25 on all accounts created after November 5th, 2019.

If you are in this category, you'll have to open a support ticket with Linode after you finish setting up your mail server. Check [Running a Mail Server](https://www.linode.com/docs/guides/running-a-mail-server/#sending-email-on-linode) for more information.

This is only if you are planning to send external email - to connect to another email server, Linode needs to unblock port 25 for you.

If, however, you are planning to use this mail server only for notifications, you don't have to go through this - email will be sent from your mail server to your mail server and will never leave your VPS.

##### 27: Traefik - Part 2

Do not use `.` (dot) in the service name (`service=...` in `.env`). If you take a look at the Docker labels, you'll see that a dot is used to separate the fields, so using a dot in a service name will break your `docker-compose.yml`.

##### 31: checkmk- Part 1

In the video, I missed the `mailer_hostname` variable in `.env` file, but it is present in `.env-dist` file I shared already.

---

If your `checkmk` container hangs on `### STARTING MAIL SERVICES`, you are experiencing an issue that only happens sometimes and that I have no solution for.

Check [this](https://forum.checkmk.com/t/checkmk-in-docker-with-mail-relay-host-wont-start/37008/3) thread on checkmk forums and maybe contribute if you have some additional information.

In the meantime, you probably want to remove `MAIL_RELAY_HOST` and configure Zulip notifications by following [this](https://docs.checkmk.com/latest/en/notifications_slack.html) guide. In short:

1) In Zulip, go to Personal settings, Bots and add a bot - write down API KEY
2) In Zulip, create a stream, e.g. `checkmk`
3) In checkmk, go to Setup, Notifications, Add Rule, Notification Method: Slack or Mattermost, Webhook URL:

`https://$PUT_YOUR_DOMAIN_HERE/api/v1/external/slack_incoming?api_key=$PUT_YOUR_API_KEY_HERE&stream=$PUT_YOUR_STREAM_HERE&topic=$PUT_YOUR_TOPIC_HERE`

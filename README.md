# AWS SES -> kindle (via nodemailer) demo

The issue I'm having is that I can't send an email with *only* an attachment to my kindle. I'm having this problem when sending an email using nodemailer that contains only an attachment.

As you will see in the sections below, this seems to be either an SMTP generation issue from nodemailer, or an SMTP parsing issue from the kindle email client. I'm not sure which.


## >> Working Script example

Let's start with a working example, below is a command you can use to send an email.

You'll need to substitute your own correct email addresses. `FROM_ADDRESS` should be an email setup in AWS SES, and `TO_ADDRESS` should be the email address of a kindle.

```bash
$ FROM_ADDRESS="example@example.com" TO_ADDRESS="kindle@address.com" ./send-demo.sh
```

This sends an email with `test.png` attached to the kindle with no issues.



## >> Not working node example

This example needs a little setup:

You'll need to install node however you do that normally (see the node website I guess).

The below will setup the project:
```bash
$ npm install
```

And this command will run the project:
```bash
FROM_ADDRESS="example@example.com" TO_ADDRESS="kindle@address.com" node index.js
```

This will fail to send the attachment, there doesn't seem to be any error message either.

I had a look at what the difference could be in the SMTP that was sent between the script and nodemailer. I've included a file (`./not-working-smtp.txt`) which has smtp from nodemailer.

As you can see, the nodemailer version doesn't have the `boundaries` that the script version does. So either nodemailer doesn't generate valid SMTP in this case, or the kindle client can't handle this edge case. I'm not sure which.



## >> Working node example

Just to show that it's possible to send messages with nodemailer and that it's a SMTP formatting issue I've attached a patch that you can apply like so:

```bash
git apply working.patch
```

Once applied you can re-run the the project:
```bash
FROM_ADDRESS="example@example.com" TO_ADDRESS="kindle@address.com" node index.js
```

And the email is sent to the kindle just fine.

The produced smtp text is in the file `./working-smtp.txt` which has the `boundaries`.

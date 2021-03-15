let nodemailer = require("nodemailer");
let aws = require("@aws-sdk/client-ses");

// configure AWS SDK
const ses = new aws.SES({
  apiVersion: "2010-12-01",
  region: "eu-west-3",
});

// create Nodemailer SES transporter
let transporter = nodemailer.createTransport({
  SES: { ses, aws },
});

const fromAddress = process.env.NODE_ENV;
const toAddress = process.env.NODE_ENV;
if (fromAddress === undefined || toAddress === undefined) {
    throw new Error("Must set from and to addresses")
}


// Presumes the attachment is in the running directory
const attachmentFilename = "test.png";

// send some mail
transporter.sendMail(
  {
      from: fromAddress,
      to: toAddress,
      attachments: [
          {
              filename: attachmentFilename,
              path: `./${attachmentFilename}`
          }
      ],
  },
  (err, info) => {
    console.log(info.envelope);
    console.log(info.messageId);
  }
);

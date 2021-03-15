#!/bin/sh

# Presumes the attachment is in the running directory
attachment_filename="test.png"

read -r -d '' data <<MESSAGE
From: $FROM_ADDRESS
To: $TO_ADDRESS
Content-Type: multipart/mixed;
    boundary="attachment"

--attachment
Content-Type: image/png; name="$attachment_filename"
Content-Description: test.png
Content-Disposition: attachment;filename="$attachment_filename";
    creation-date="Sat, 05 Aug 2017 19:35:36 GMT";
Content-Transfer-Encoding: base64

$(base64 "$attachment_filename")

--attachment--
MESSAGE

# Encode message
data=$(echo "$data" | base64)

# Wrap message
data="{\"Data\":\"$data\"}"

# Add data to temp file
tmpfile=$(mktemp /tmp/send-demo.XXXXXX)
echo "$data" > "$tmpfile"

# Send the message
aws ses send-raw-email --raw-message "file://$tmpfile"

rm "$tmpfile"

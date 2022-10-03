# mail-with-php
Php simple dockerized app to send mail. You can use it as docker-compose service with Node JS project and more.
It uses PHPMailer (https://github.com/PHPMailer/PHPMailer)

## build example
```sh
docker build -t lbgm/mailer  -f Dockerfile ./ --build-arg MAIL_SERVER=mail.example.com --build-arg MAIL_PORT=465 --build-arg MAIL_SECURE=ssl --build-arg MAIL_ACCOUNT=noreply@example.com --build-arg MAIL_ACCOUNT_PASSWORD=password --build-arg FROM_MAIL=noreply@example.com --build-arg SMTP_DEBUG=4
```

## Request payload
make http post request on http://yout_image_name_or_localhost:port/send-mail/

```json
{
  "title": "it work lbgm !",
  "to_mail": "b*****@gmail.com",
  "to_name": "Balthazar DOSSOU",
  "message": "Hi Balthazar, your mail-with-php docker app work well !",
  "from_name": "Mail With PHP"
}
```
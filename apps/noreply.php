<?php

require 'PHPMailer/src/PHPMailer.php';
require 'PHPMailer/src/Exception.php';
require 'PHPMailer/src/SMTP.php';
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;


class mailer {
//
private $mail;
/////////////////edit this////////////////
private $smtp_serv="";//server
private $port=465;
private $secure="ssl";
//
protected $account="";
protected $acc_pswd="";
protected $from="";//email
/////////////////////////////////////////


public function __construct() //constructor
{
$this->smtp_serv=$_ENV['MAIL_SERVER'];//server
$this->port=(int)$_ENV['MAIL_PORT'];
$this->secure=$_ENV['MAIL_SECURE'];
$this->account=$_ENV['MAIL_ACCOUNT'];
$this->acc_pswd=$_ENV['MAIL_ACCOUNT_PASSWORD'];
$this->from=$_ENV['FROM_MAIL'];//email


$this->mail = new PHPMailer;
$this->mail->SMTPDebug =(int)$_ENV['SMTP_DEBUG'];/* 0==no verbose to 1-4==verbose type*/
$this->mail->isSMTP();
$this->mail->Host = $this->smtp_serv;
$this->mail->Port = $this->port;
$this->mail->SMTPAuth = true;
$this->mail->Username = $this->account;
$this->mail->Password = $this->acc_pswd;
$this->mail->SMTPSecure = $this->secure;
$this->mail->CharSet='utf-8';
}

public function __destruct() //desctructor
{
 $this->mail = null;
}

public function __debugInfo()
{
  return ['Mailer'];
}

public function __toString()
{
  return 'Mailer';
}

public function __sleep()
{

}

public function __wakeup()
{
  $this->mail = new PHPMailer;
}

public static function getInstance()
{
  static $instance;
  if(!is_object($instance))
  {
    $instance= new mailer();
  }

  return $instance;
}

public static function createInstance()
{
  $instance= new mailer();
  return $instance;
}


public function sendMail($title,$to,$to_name,$message,$from_name)//mail sender
{
$this->mail->setFrom($this->from, $from_name);
$this->mail->addAddress($to, $to_name);
$this->mail->Subject = $title;
$this->mail->isHTML(true);
//content
//
$this->mail->Body = $message;
//send mail
if(!$this->mail->send()) return false;
else return true;
}

}//class mailer end

?>
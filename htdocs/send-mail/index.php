<?php

header('Content-Type:application/json');
header('Connection: keep-alive');
header('Cache-Control: no-store');
header('Access-Control-Allow-Origin: *');

if(empty($_POST)) {
  $POST=file_get_contents("php://input");
  $POST=json_decode($POST,true);
  $_POST=$POST;
}

require_once dirname(dirname(__FILE__)).'/apps/noreply.php';

$json = null;

if(!empty($_POST)) {
  $json = mailer::createInstance()->sendMail(
    $_POST['title'],
    $_POST['to_mail'],
    $_POST['to_name'],
    $_POST['message'],
    $_POST['from_name']
  );
}

if($json===true)
{
 return http_response_code(201);
}

return http_response_code(403);


?>
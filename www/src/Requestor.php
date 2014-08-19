<?php
namespace WorldNews;

use GuzzleHttp\Client as GuzzleClient;

class Requestor {
	public static function GET($url)
	{
		$client = new GuzzleClient();
		$res = $client->get($url);
		return $res->getBody();
	}
	public static function GETAsJson($url)
	{
		return json_decode(self::GET($url));
	}
}

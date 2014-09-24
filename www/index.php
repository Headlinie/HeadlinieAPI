<?php
//define('APP_PATH', '/');
//
//dispatch(substr($_SERVER['REQUEST_URI'], strlen(APP_PATH)));
//
//echo "<pre>";
//var_dump($_REQUEST);
//var_dump($_SERVER);
//echo "</pre>";
//die();

require_once '/composer/autoload.php';

$klein = new \Klein\Klein();

//$request = \Klein\Request::createFromGlobals();

// Grab the server-passed "REQUEST_URI"
//$uri = $request->server()->get('REQUEST_URI');

// Set the request URI to a modified one (without the "subdirectory") in it
//$request->server()->set('REQUEST_URI', substr($uri, strlen(APP_PATH)));



//Approved classes, required for get_declared_classes() to work
new WorldNews\Sources\Reddit();
new WorldNews\Sources\HackerNews();

//End approved classes

$klein->respond('GET', '/', function() {
    $sources = \WorldNews\BaseSource::getAllSources();

    header("Content-Type: application/json");
    return $sources->toJson();
});

$klein->respond('GET', '/sources', function() {
    $sources = \WorldNews\BaseSource::getAllSources();

    header("Content-Type: application/json");
    return $sources->toJson();
});

$klein->respond('GET', '/sources/[:source_name]', function ($req, $res) {
    $source = \WorldNews\BaseSource::loadSource($req->source_name);

    header("Content-Type: application/json");
    return json_encode($source);
});

$klein->respond('GET', '/sources/[:source_name]/articles', function ($req, $res) {
    $source = \WorldNews\BaseSource::loadSource($req->source_name);
    $articles = $source->getTopArticles();
    $response = [
	'articles' => $articles,
	'metadata' => [
	    'source' => $req->source_name
	]
    ];
    header("Content-Type: application/json");
    return json_encode($response);
});

$klein->respond('GET', '/sources/[:source_name]/articles/[:article_url]', function ($req, $res) {
    //TODO move all this logic into a proper place

    $article_url = urldecode($req->article_url);

    $domain = \WorldNews\Utils::get_domain($article_url);

    $cache_name = $domain . '/' . md5($article_url);

    $cache = new \WorldNews\Cache("cache");

    $response = null;

    if($cache->exists($cache_name)) {
	$response = $cache->retrieve($cache_name);
    } else {
	$url = "http://www.readability.com/api/content/v1/parser?url=";
	$url = $url . $article_url;
	//TODO Move away the readability token to configuration/environmental variable
	//TODO make sure this doesnt stick in SCM after removal
	$url = $url . "&token=8680f644ff6278a311ff8c0a4713223b20a24f48";

	try {
	    $response = \WorldNews\Requestor::GET($url);
	    $cache->save($cache_name, $response);
	} catch (Exception $e) {
	    //TODO fix proper error message
	    $response = '{messages: "Something went wrong... Article ID: ' .md5($article_url). '"}';
	}
    }

    $decoded = json_decode($response);
    if(isset($decoded->content)) {
	$decoded->content = \WorldNews\Utils::replace_images($decoded->content);
	$decoded->content = \WorldNews\Utils::make_links_external($decoded->content);
    }
    $encoded = json_encode($decoded);


    header("Content-Type: application/json");
    return $encoded;
});


// Pass our request to our dispatch method
//$klein->dispatch($request);
$klein->dispatch();

//TODO remove all this code
die();

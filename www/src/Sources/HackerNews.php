<?php

namespace WorldNews\Sources;

use WorldNews\BaseSource;
use WorldNews\Article;
use WorldNews\Requestor;

class HackerNews extends BaseSource implements ISource {
	public $name = "HackerNews";
	public $url = "https://news.ycombinator.com";
	public $endpoint = "http://hnify.herokuapp.com/get/top/";
	public $category = "";

	public function convertToArticleObject($article)
	{
		$ret = new Article();
		$ret->title = $article->title;
		$ret->content = null;
		$ret->date_posted = $article->published_time;
		$ret->domain = $article->domain;
		$ret->comments = $article->comments_link;
		$ret->link = $article->link;
		$ret->category = null;
		return $ret;
	}

	public function getTopArticles() {
		$body = Requestor::GETAsJson($this->endpoint);
		$articles = $body->stories;
		$ret = [];
		foreach($articles as $article) {
			$ret[] = $this->convertToArticleObject($article);
		}
		return $ret;
	}
};

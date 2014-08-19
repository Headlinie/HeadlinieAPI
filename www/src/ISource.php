<?php
namespace WorldNews\Sources;

interface ISource {
	function getTopArticles();
	function convertToArticleObject($article);
}

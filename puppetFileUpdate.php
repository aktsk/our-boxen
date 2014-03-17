<?php

define("READ_START_SYMBOL", "# ---auto update---");
define("READ_END_SYMBOL", "# ---/auto update---");

function notify_update($name, $from, $to) {
    echo "updated '".$name."' from ".$from." to ".$to."\n";
}

function fetch_new_version($repo) {
    $url = "https://api.github.com/repos/".$repo."/tags";

    $context = stream_context_create(array('http' => array(
      'method' => 'GET',
      'header' => 'User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)',
    )));
    $res = file_get_contents($url, false, $context);
    $json = json_decode($res);

    if(preg_match("/^\d/", $json[0]->name) >= 1) {
      return $json[0]->name;
    }
    else {
      return null;
    }
}

function update_version($line) {
    // 空行、コメントの行、githubで始まらない行は対象外
    if ( strlen($line) === 0 || $line[0] === "#" || strpos($line, "github") === false ) {
        return $line;
    }

    // 現在Puppetfileに書かれているResourcesとバージョンを取得
    preg_match("/^github \"(\w+)\",\s*\"(\d+\.\d+\.\d+)\"(, :repo =>.+)?/", $line, $match);
    $name = $match[1];
    $version = $match[2];
    $option = $match[3];
    $repo = "boxen/puppet-".$name;
    if($option) {
      preg_match("/^, :repo => \"(.+)\"/", $option, $match);
      $repo = $match[1];
    }

    // Github APIを利用して最新バージョンを取得
    $new_version = fetch_new_version($repo);

    // 500等でバージョンの取得に失敗した場合更新をかけない
    if ( $new_version == null ) return $line;

    // アップデートがあれば標準出力にて通知
    if ( $new_version !== $version ) notify_update($name, $version, $new_version);

    // バージョンの部分を最新バージョンに置き換え
    return str_replace($version, $new_version, $line);
}

$Puppetfile = file_get_contents("./Puppetfile");
$Puppetfile = explode("\n", $Puppetfile);

// 自動更新する範囲を取得
$read_flg = false;

$Puppetfile = array_map(function($line) {
    global $read_flg;

    // 読み取り開始/終了
    if ( strpos($line, READ_START_SYMBOL) !== false ) $read_flg = true;
    if ( strpos($line, READ_END_SYMBOL) !== false ) $read_flg = false;

    if ( $read_flg ) {
        // 自動更新の範囲内なら更新を行う
        return update_version($line);
    } else {
        return $line;   // 何もしない
    }
}, $Puppetfile);

// 変更した内容でPuppetfileを上書き
file_put_contents("./Puppetfile", implode("\n", $Puppetfile));


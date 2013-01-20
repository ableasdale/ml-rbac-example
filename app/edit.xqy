xquery version "1.0-ml";

import module namespace common = "http://www.example.com/common" at "/common.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

(::::::::::::::::::::::::::)
(: Main Module Code below :)
(::::::::::::::::::::::::::)
    
let $e := try {
    xdmp:node-replace(doc(xdmp:get-request-field("uri"))/node(), xdmp:unquote(xdmp:get-request-field("doc"), (), ("format-xml" ) )/node())     
} catch($e) {
    $e
} 
return if (local-name($e) eq "error")
then (common:build-page(<div class="container"><h1>{$e/error:code/string()} Exception Caught</h1><h2>{$e/error:message/string()}</h2><p>Details below:</p><textarea rows="20" cols="80">{$e}</textarea></div>))
else (common:build-page(<div class="container"><h1>Doc {xdmp:get-request-field("uri")} has been updated</h1><p>[<a href="{concat("/view.xqy?id=", xdmp:get-request-field("uri"))}">View</a>] [<a href="/">Home</a>]</p></div>)) 
 
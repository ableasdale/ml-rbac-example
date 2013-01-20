xquery version "1.0-ml";

import module namespace common = "http://www.example.com/common" at "/common.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare function local:summary-restricted-catalogue(){
<div id="restricted-docs">
<h3>You currently have access to {xdmp:estimate(collection("restricted-book-catalogue"))} documents in the restricted catalogue - here are 10 of those:</h3>
<ul>
{for $doc in collection("restricted-book-catalogue")[1 to 10]
return element li {element a {attribute href {concat("/view.xqy?id=",xdmp:node-uri($doc))}, xdmp:node-uri($doc)}} 
}
</ul>
</div>
};


declare function local:summary-unpublished-catalogue(){
<div id="restricted-docs">
<h3>You currently have access to {xdmp:estimate(collection("unpublished-book-catalogue"))} documents in the unpublished catalogue - here are 10 of those:</h3>
<ul>
{for $doc in collection("unpublished-book-catalogue")[1 to 10]
return element li {element a {attribute href {concat("/view.xqy?id=",xdmp:node-uri($doc))}, xdmp:node-uri($doc)}}
}
</ul>
</div>
};

(::::::::::::::::::::::::::)
(: Main Module Code below :)
(::::::::::::::::::::::::::)

common:build-page(
<div class="container">
<h1>Application Test</h1>  
<div id="status">{ 
if (xdmp:get-current-user() eq "nobody") 
then (common:login-form())
else (
<div id="user-info">
<h2>You are logged in as {xdmp:get-current-user()} (<a href="/logout.xqy">logout</a>)</h2>
<h3>You currently have access to {xdmp:estimate(collection("main-book-catalogue"))} documents in the main catalogue - here are 10 of those:</h3>
<ul>
{for $doc in collection("main-book-catalogue")[1 to 10]
return element li {element a {attribute href {concat("/view.xqy?id=",xdmp:node-uri($doc))}, xdmp:node-uri($doc)}}
}
</ul>
{local:summary-restricted-catalogue()} 
{local:summary-unpublished-catalogue()}
</div>
)
}</div> 
</div>)

xquery version "1.0-ml";

import module namespace common = "http://www.example.com/common" at "/common.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare variable $docid := xdmp:get-request-field("id");

declare function local:comment-on-content() as element(form){

element form {attribute method {"post"}, attribute action {"/comment.xqy"}, attribute accept-charset{"utf8"}, attribute enctype{"multipart/form-data"},
    element fieldset {
        element legend {"Comment on doc ", $docid}, 
        element p {"There are ", element strong {xdmp:estimate(collection("comments")/comment[doc-uri eq $docid])}, " comments for doc", $docid},
        for $i in collection("comments")/comment[doc-uri eq $docid]
        order by $i/date-time descending
        return
        element p {attribute class {"info"}, $i/comment/text(), " by ", $i/user/text(), " at ", $i/date-time/text() },  
        element p {element label {attribute for {"comment"}, "Comment:"}, element br {}, element input {attribute class {"title"}, attribute type {"text"}, attribute name {"comment"}}},
        element input {attribute type {"hidden"}, attribute name {"uri"}, attribute value {$docid}},
        element p {element input {attribute type {"submit"}, attribute name {"update"}, attribute value {"Add Comment"}}, " (All Users)"} 
    } 
} 
};

common:build-page(
<div class="container">
{common:html-page-header(concat("Viewing Doc: ", $docid))}
<form method="post" action="/edit.xqy" accept-charset="utf-8" enctype="multipart/form-data"> 
    <textarea name="doc">
        {xdmp:quote(doc($docid))}
    </textarea> 
    <input type="hidden" name="uri" value="{$docid}" />
    <p><input type="submit" name="save" value="Save/Edit" /> (Author/Editor/Publisher role required)</p>
</form>  
{local:comment-on-content()} 
<form method="post" action="/publish.xqy" accept-charset="utf-8" enctype="multipart/form-data">
<fieldset>
    <legend>Publish doc {$docid}:</legend>
    <p>This can only be performed if the doc is unpublished and if the user is a publisher</p>
    <input type="hidden" name="uri" value="{$docid}" /> 
    <p><input type="submit" name="publish" value="Publish" /> (Publishers only)</p>
</fieldset>    
</form>      
 
</div>)

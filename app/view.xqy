xquery version "1.0-ml";

import module namespace common = "http://www.example.com/common" at "/common.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare variable $docid := xdmp:get-request-field("id");

declare function local:viewer-component() as element(form) {
element form {attribute method {"post"}, attribute action {"/edit.xqy"}, attribute accept-charset{"utf8"}, attribute enctype{"multipart/form-data"},
    element fieldset {
        element legend {"Viewing doc ", $docid},
        element textarea {attribute name {"doc"}, xdmp:quote(doc($docid))},   
        element input {attribute type {"hidden"}, attribute name {"uri"}, attribute value {$docid}},
        element p {element input {attribute type {"submit"}, attribute name {"save"}, attribute value {"Save/Edit"}}, " (Author/Editor/Publisher role required)"}   
    }        
} 
};

declare function local:comment-on-content() as element(form) { 
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

declare function local:publisher-component() as element(form) {
element form {attribute method {"post"}, attribute action {"/publish.xqy"}, attribute accept-charset{"utf8"}, attribute enctype{"multipart/form-data"},
    element fieldset {
        element legend {"Publish doc ", $docid},
        element p {attribute class {"notice"}, "This can only be performed if the doc is ", element strong {"unpublished"}, " and if the user has the ", element strong {"publisher"}, " role"},
        element input {attribute type {"hidden"}, attribute name {"uri"}, attribute value {$docid}},
        element p {element input {attribute type {"submit"}, attribute name {"publish"}, attribute value {"Publish"}}, " (Publishers only)"}  
    }    
} 
};

(::::::::::::::::::::::::::)
(: Main Module Code below :)
(::::::::::::::::::::::::::)

if (xdmp:get-current-user() eq "nobody")
then (xdmp:redirect-response("/"))
else( 
common:build-page(
element div {attribute class {"container"},
    common:html-page-header(concat("Viewing Doc: ", $docid)),
    local:viewer-component(),
    local:comment-on-content(),
    local:publisher-component() 
})
)
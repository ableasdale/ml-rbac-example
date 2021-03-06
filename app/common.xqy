xquery version "1.0-ml"; 

module namespace common="http://www.example.com/common";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare namespace xhtml = "http://www.w3.org/1999/xhtml";
 
(: note that application/xhtml+xml is *still* not supported by several modern browsers... :)
 
declare function common:exception($e as element(error:error)){
element div {attribute class{"container"},
    common:html-page-header(concat("Exception Caught: ", $e/error:code/string())),
    element div {attribute class{"error"},
        element h2 {$e/error:message/string()},
        element p {"Details below:"},
        element textarea {$e}
    } 
} 
};  
 
declare function common:success($message as xs:string, $html as element()){
element div {attribute class{"container"},
    common:html-page-header($message), 
    element div {attribute class{"success"},
        $html
    } 
} 
};   

declare function common:build-page($html as element(div)){
xdmp:set-response-content-type("text/html; charset=utf-8"),
'<?xml version="1.0" encoding="UTF-8"?>',
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
common:html-page-enclosure($html)
};

declare function common:html-head() {
element link {attribute rel {"stylesheet"}, attribute type{"text/css"}, attribute href {"http://www.blueprintcss.org/blueprint/screen.css"}}
};

declare function common:show-current-user(){
if (xdmp:get-current-user() eq "nobody")
then (element p {element em {"You are not logged in"}})
else (element p {"You are logged in as ", element strong {xdmp:get-current-user()}}) 
};

declare function common:create-navlink($href as xs:string, $name as xs:string, $end as xs:boolean){
    "[", element a {attribute href {$href}, $name} ,"]", 
    if(not($end))
    then("&nbsp;")
    else()
};

declare function common:create-navlinks(){
element p {attribute class {"right"}, 
    common:create-navlink("/", "Home", false()),
    common:create-navlink("/logout.xqy", "Logout", true()) 
}  
};

declare function common:html-page-header($header as xs:string) as element(div) {
element div {attribute id {"page-header"},
    element div {attribute id {"header"}, attribute class {"span-24 last"},
        element h1 {$header}
    },
    element hr {},
    element div {attribute id {"subheader"}, attribute class {"span-12"}, common:show-current-user()},    
    element div {attribute id {"subheader"}, attribute class {"span-12 last"}, common:create-navlinks()},      
    element hr {}
} 
};
 
declare function common:html-page-footer() as element(div){
element div {attribute id {"footer"},   
    element p {attribute align {"center"}, "Application footer"},
    element hr {}
}   
}; 
 

declare function common:html-page-enclosure($content as element()) as element(html){
element html {attribute lang {"en"}, attribute xml:lang {"en"},
    element head {common:html-head()},
    element body {$content}
}
};

declare function common:login-form() as element(form) {
element form { attribute method {"post"}, attribute action {"/login.xqy"},
    element fieldset {
        element legend {"Log-in:"},
        element p {element label {attribute for {"username"}, "Username: "}, element br {}, element input {attribute class {"title"}, attribute type {"text"}, attribute name {"username"}}},
        element p {element label {attribute for {"password"}, "Password: "}, element br {}, element input {attribute class {"title"}, attribute type {"password"}, attribute name {"password"}}},
        element p {element input {attribute type {"submit"}, attribute name {"login"}, attribute value {"Login!"}}} 
    }
}
};

declare private function common:random-hex($seq as xs:integer*) as xs:string+ {
  for $i in $seq return 
    fn:string-join(for $n in 1 to $i
      return xdmp:integer-to-hex(xdmp:random(15)), "")
};

declare function common:guid() as xs:string {
  fn:string-join(common:random-hex((8,4,4,4,12)),"-")
}; 

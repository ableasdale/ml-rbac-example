xquery version "1.0-ml"; 

(:~ 
 : Security Setup Module for creating the Generic Database Users and roles
 :
 : Run against the Security Database to create the Model
 :
 : @version 1.0
 :)

import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy"; 

(: General roles :)
declare variable $MAIN-COLLECTION-CREATE-ROLE-NAME as xs:string := "main-collection-create";
declare variable $MAIN-COLLECTION-CREATE-ROLE-DESCRIPTION as xs:string := "Create New Documents in the Main Collection";

declare variable $MAIN-COLLECTION-READ-ROLE-NAME as xs:string := "main-collection-read";
declare variable $MAIN-COLLECTION-READ-ROLE-DESCRIPTION as xs:string := "View Documents in the Main Collection";

declare variable $MAIN-COLLECTION-UPDATE-ROLE-NAME as xs:string := "main-collection-update";
declare variable $MAIN-COLLECTION-UPDATE-ROLE-DESCRIPTION as xs:string := "Update Documents in the Main Collection";

declare variable $UNPUBLISHED-COLLECTION-CREATE-ROLE-NAME as xs:string := "unpublished-collection-create";
declare variable $UNPUBLISHED-COLLECTION-CREATE-ROLE-DESCRIPTION as xs:string := "Create New Documents in the Unpublished Collection";

declare variable $UNPUBLISHED-COLLECTION-READ-ROLE-NAME as xs:string := "unpublished-collection-read";
declare variable $UNPUBLISHED-COLLECTION-READ-ROLE-DESCRIPTION as xs:string := "View Documents in the Unpublished Collection";

declare variable $UNPUBLISHED-COLLECTION-UPDATE-ROLE-NAME as xs:string := "unpublished-collection-update";
declare variable $UNPUBLISHED-COLLECTION-UPDATE-ROLE-DESCRIPTION as xs:string := "Update Documents in the Unpublished Collection";
 
declare variable $RESTRICTED-COLLECTION-CREATE-ROLE-NAME as xs:string := "restricted-collection-create";
declare variable $RESTRICTED-COLLECTION-CREATE-ROLE-DESCRIPTION as xs:string := "Create New Documents in the Restricted Collection";

declare variable $RESTRICTED-COLLECTION-READ-ROLE-NAME as xs:string := "restricted-collection-read";
declare variable $RESTRICTED-COLLECTION-READ-ROLE-DESCRIPTION as xs:string := "View Documents in the Restricted Collection";

declare variable $RESTRICTED-COLLECTION-UPDATE-ROLE-NAME as xs:string := "restricted-collection-update";
declare variable $RESTRICTED-COLLECTION-UPDATE-ROLE-DESCRIPTION as xs:string := "Update Documents in the Restricted Collection";
 
declare variable $COMMENT-ROLE-NAME as xs:string := "comment-role";
declare variable $COMMENT-ROLE-DESCRIPTION as xs:string := "Allows Comments on Content in any Collection";

declare variable $REPORT-EXECUTOR-ROLE-NAME as xs:string := "report-executor-role";
declare variable $REPORT-EXECUTOR-ROLE-DESCRIPTION as xs:string := "Report Generation based on Content in Collection";

(: Role names and descriptions :)   

declare variable $AUTHOR-ROLE-NAME as xs:string := "author-role";
declare variable $AUTHOR-ROLE-DESCRIPTION as xs:string := "Generic Author Role";

declare variable $EDITOR-ROLE-NAME as xs:string := "editor-role";
declare variable $EDITOR-ROLE-DESCRIPTION as xs:string := "Generic Editor Role";

declare variable $PUBLISHER-ROLE-NAME as xs:string := "publisher-role";
declare variable $PUBLISHER-ROLE-DESCRIPTION as xs:string := "Generic Publisher Role";
 
declare variable $REVIEWER-ROLE-NAME as xs:string := "reviewer-role";
declare variable $REVIEWER-ROLE-DESCRIPTION as xs:string := "Generic Reviewer Role";

declare variable $SECRET-NOSQL-BOOK-ROLE-NAME as xs:string := "secret-nosql-book";
declare variable $SECRET-NOSQL-BOOK-ROLE-DESCRIPTION as xs:string := "Secret NoSQL Book Role";
 
(: Users :)
declare variable $AUTHOR-USER-NAME as xs:string := "author";
declare variable $AUTHOR-USER-DESCRIPTION as xs:string := "Generic Author User";
declare variable $AUTHOR-USER-PASSWORD as xs:string := "password";

declare variable $EDITOR-USER-NAME as xs:string := "editor";
declare variable $EDITOR-USER-DESCRIPTION as xs:string := "Generic Editor User";
declare variable $EDITOR-USER-PASSWORD as xs:string := "password";

declare variable $PUBLISHER-USER-NAME as xs:string := "publisher";
declare variable $PUBLISHER-USER-DESCRIPTION as xs:string := "Generic Publisher User";
declare variable $PUBLISHER-USER-PASSWORD as xs:string := "password";

declare variable $REVIEWER-USER-NAME as xs:string := "reviewer";
declare variable $REVIEWER-USER-DESCRIPTION as xs:string := "Generic Reviewer User";
declare variable $REVIEWER-USER-PASSWORD as xs:string := "password";

declare variable $SECRET-NOSQL-BOOK-USER-NAME as xs:string := "nosql";
declare variable $SECRET-NOSQL-BOOK-USER-DESCRIPTION as xs:string := "Secret NoSQL Book User";
declare variable $SECRET-NOSQL-BOOK-USER-PASSWORD as xs:string := "password";

(:
Authors and Editors may change content, but only users with the Publisher role can make a document available to reviewers. Reviewers have collections configured so that they can add comments in a comment log, but they can't change the main document content.
 :)
 

declare function local:create-primary-roles() as xs:unsignedLong+ { 
    sec:create-role($MAIN-COLLECTION-CREATE-ROLE-NAME, $MAIN-COLLECTION-CREATE-ROLE-DESCRIPTION,(),(),()),
    sec:create-role($MAIN-COLLECTION-READ-ROLE-NAME, $MAIN-COLLECTION-READ-ROLE-DESCRIPTION,(),(),()),
    sec:create-role($MAIN-COLLECTION-UPDATE-ROLE-NAME, $MAIN-COLLECTION-UPDATE-ROLE-DESCRIPTION,(),(),()),
    sec:create-role($UNPUBLISHED-COLLECTION-CREATE-ROLE-NAME, $UNPUBLISHED-COLLECTION-CREATE-ROLE-DESCRIPTION,(),(),()),
    sec:create-role($UNPUBLISHED-COLLECTION-READ-ROLE-NAME, $UNPUBLISHED-COLLECTION-READ-ROLE-DESCRIPTION,(),(),()),
    sec:create-role($UNPUBLISHED-COLLECTION-UPDATE-ROLE-NAME, $UNPUBLISHED-COLLECTION-UPDATE-ROLE-DESCRIPTION,(),(),()),
    sec:create-role($RESTRICTED-COLLECTION-CREATE-ROLE-NAME, $RESTRICTED-COLLECTION-CREATE-ROLE-DESCRIPTION,(),(),()), 
    sec:create-role($RESTRICTED-COLLECTION-READ-ROLE-NAME, $RESTRICTED-COLLECTION-READ-ROLE-DESCRIPTION,(),(),()),
    sec:create-role($RESTRICTED-COLLECTION-UPDATE-ROLE-NAME, $RESTRICTED-COLLECTION-UPDATE-ROLE-DESCRIPTION,(),(),()),
    sec:create-role($COMMENT-ROLE-NAME, $COMMENT-ROLE-DESCRIPTION,(),(),()),
    sec:create-role($REPORT-EXECUTOR-ROLE-NAME, $REPORT-EXECUTOR-ROLE-DESCRIPTION,(),(),())
};


(: To enforce the contract rules we create a new role for the project called "secret-nosql-book"   :)
(:~
 : Create new Database access roles:
 :
 : <ul>
 : <li>Author</li>
 : <li>Editor</li>
 : <li>Publisher</li>
 : <li>Reviewer</li> 
 : <li>Secret NoSQL Book</li>
 : </ul>
 :)
declare function local:create-secondary-roles() as xs:unsignedLong+ {   
    sec:create-role($AUTHOR-ROLE-NAME, $AUTHOR-ROLE-DESCRIPTION,($COMMENT-ROLE-NAME, $MAIN-COLLECTION-READ-ROLE-NAME, $MAIN-COLLECTION-UPDATE-ROLE-NAME),(),()),
	sec:create-role($EDITOR-ROLE-NAME, $EDITOR-ROLE-DESCRIPTION,($COMMENT-ROLE-NAME, $MAIN-COLLECTION-READ-ROLE-NAME, $MAIN-COLLECTION-UPDATE-ROLE-NAME),(),()),
	sec:create-role($PUBLISHER-ROLE-NAME, $PUBLISHER-ROLE-DESCRIPTION,($COMMENT-ROLE-NAME, $MAIN-COLLECTION-READ-ROLE-NAME, $MAIN-COLLECTION-UPDATE-ROLE-NAME, $MAIN-COLLECTION-CREATE-ROLE-NAME, $UNPUBLISHED-COLLECTION-READ-ROLE-NAME, $UNPUBLISHED-COLLECTION-UPDATE-ROLE-NAME, $UNPUBLISHED-COLLECTION-CREATE-ROLE-NAME),(),()),
	sec:create-role($REVIEWER-ROLE-NAME, $REVIEWER-ROLE-DESCRIPTION,($COMMENT-ROLE-NAME, $MAIN-COLLECTION-READ-ROLE-NAME),(),()), 
    sec:create-role($SECRET-NOSQL-BOOK-ROLE-NAME, $SECRET-NOSQL-BOOK-ROLE-DESCRIPTION,($COMMENT-ROLE-NAME, $MAIN-COLLECTION-READ-ROLE-NAME, $RESTRICTED-COLLECTION-READ-ROLE-NAME),(),())
};

(:~
 : Create new users:
 :
 : <ul>
 : <li>Author</li>
 : <li>Editor</li>
 : <li>Publisher</li>
 : <li>Reviewer</li> 
 : <li>Secret NoSQL Book</li>
 : </ul>
 :
 : This step is optional; DBAs may want to manually create these users
 :)
declare function local:create-users() as xs:unsignedLong+ {
	sec:create-user(
                $AUTHOR-USER-NAME, 
                $AUTHOR-USER-DESCRIPTION,
                $AUTHOR-USER-PASSWORD,
                ($AUTHOR-ROLE-NAME), (: roles :)
                (), (: permissions :)
                () (: collections :)
    ),      
	sec:create-user(
                $EDITOR-USER-NAME, 
                $EDITOR-USER-DESCRIPTION,
                $EDITOR-USER-PASSWORD,
                ($EDITOR-ROLE-NAME), (: roles :)
                (), (: permissions :)
                () (: collections :)
    ),
    sec:create-user(
                $PUBLISHER-USER-NAME, 
                $PUBLISHER-USER-DESCRIPTION,
                $PUBLISHER-USER-PASSWORD,
                ($PUBLISHER-ROLE-NAME), (: roles :)
                (), (: permissions :)
                () (: collections :)
    ),
    sec:create-user(
                $REVIEWER-USER-NAME, 
                $REVIEWER-USER-DESCRIPTION,
                $REVIEWER-USER-PASSWORD,
                ($REVIEWER-ROLE-NAME), (: roles :)
                (), (: permissions :)
                () (: collections :)
    ),
    sec:create-user(
                $SECRET-NOSQL-BOOK-USER-NAME, 
                $SECRET-NOSQL-BOOK-USER-DESCRIPTION,
                $SECRET-NOSQL-BOOK-USER-PASSWORD,
                ($SECRET-NOSQL-BOOK-ROLE-NAME), (: roles :)
                (), (: permissions :)
                () (: collections :)
    )
};

declare function local:create-privileges() as empty-sequence() {
    sec:privilege-add-roles("http://marklogic.com/xdmp/privileges/any-uri","execute", $COMMENT-ROLE-NAME),
    sec:privilege-add-roles("http://marklogic.com/xdmp/privileges/unprotected-collections","execute", $COMMENT-ROLE-NAME)  
};  

(::::::::::::::::::::::::::)
(: Main Module Code below :)
(::::::::::::::::::::::::::)

(: local:create-primary-roles() :)
 
(: local:create-secondary-roles() :)

(local:create-privileges(), local:create-users())
Feature: PHPCR-ODM resource repository
    In order to retrieve data from the resource webservice
    As a webservice user
    I need to be able to query the webservice

    Background:
        Given the test application has the following configuration:
            """
            cmf_resource:
                repository:
                    doctrine_phpcr_odm:
                        phpcrodm_repo:
                            basepath: /tests/cmf/articles

            cmf_resource_rest:
                payload_alias_map:
                    article: 
                        repository: doctrine_phpcr_odm
                        type: "Symfony\\Cmf\\Bundle\\ResourceRestBundle\\Tests\\Resources\\TestBundle\\Document\\Article"
            """


    Scenario: Retrieve a PHPCR-ODM resource
        Given there exists a "Article" document at "/cmf/articles/foo":
            | title | Article 1 |
            | body | This is my article |
        Then I send a GET request to "/api/phpcrodm_repo/foo"
        And print response
        And the response code should be 200
        And the response should contain json:
            """
            {
                "repository_alias": "phpcrodm_repo",
                "repository_type": "doctrine_phpcr_odm",
                "payload_alias": "article",
                "payload_type": "Symfony\\Cmf\\Bundle\\ResourceRestBundle\\Tests\\Resources\\TestBundle\\Document\\Article",
                "path": "\/foo",
                "repository_path": "\/foo",
                "children": []
            }
            """

    Scenario: Retrieve a PHPCR-ODM resource with children
        Given there exists a "Article" document at "/cmf/articles/foo":
            | title | Article 1 |
            | body | This is my article |
        And there exists a "Article" document at "/cmf/articles/foo/bar":
            | title | Article child |
            | body | There are many like it |
        And there exists a "Article" document at "/cmf/articles/foo/boo":
            | title | Article child |
            | body | But this one is mine |
        Then I send a GET request to "/api/phpcrodm_repo/foo"
        And print response
        And the response code should be 200
        And the response should contain json:
            """
            {
                "repository_alias": "phpcrodm_repo",
                "repository_type": "doctrine_phpcr_odm",
                "payload_alias": "article",
                "payload_type": "Symfony\\Cmf\\Bundle\\ResourceRestBundle\\Tests\\Resources\\TestBundle\\Document\\Article",
                "path": "\/foo",
                "repository_path": "\/foo",
                "children": {
                    "bar": {
                        "repository_alias": "phpcrodm_repo",
                        "repository_type": "doctrine_phpcr_odm",
                        "payload_alias": "article",
                        "payload_type": "Symfony\\Cmf\\Bundle\\ResourceRestBundle\\Tests\\Resources\\TestBundle\\Document\\Article",
                        "path": "/foo/bar",
                        "repository_path": "/foo/bar",
                        "children": [ ]
                    },
                    "boo": {
                        "repository_alias": "phpcrodm_repo",
                        "repository_type": "doctrine_phpcr_odm",
                        "payload_alias": "article",
                        "payload_type": "Symfony\\Cmf\\Bundle\\ResourceRestBundle\\Tests\\Resources\\TestBundle\\Document\\Article",
                        "path": "/foo/boo",
                        "repository_path": "/foo/boo",
                        "children": [ ]
                    }
                }
            }
            """

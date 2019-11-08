Custom Error Message
====================

This plugin gives you the option to not have your custom validation error message 
prefixed with the attribute name.


Integrate and develop with your own apps
-------

download the repo to your local folder say `path/better_error_msg_gem` which is under the parallel folder of your app

add `gem "better_error_message_gem", :path => "../better_error_msg_gem/"` to your Gemfile of your app

run `./compile.sh`, then the gem can be used in your own app




Usage
-----

Sometimes generated error messages don't make sense.

    validates_inclusion_of :domain, :in => {'.com', 'cn'}
    
input is not included in the list,

should be 

inputs is not included in the list, you should choose from [.com, .cn]


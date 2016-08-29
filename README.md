### [教材出處](http://kakas-blog.logdown.com/posts/737732-using-ajax-in-rails-simple-examples)
## step.1 安裝Bootstrap

rails new kakasAJAX

add to Gemfile
  gem "bootstrap"
  gem "bootstrap_form"

rename application.css to application.css.scss

add to application.css.scss
  @import "bootstrap-sprockets";
  @import "bootstrap";

add to application.js
  //= require bootstrap/modal

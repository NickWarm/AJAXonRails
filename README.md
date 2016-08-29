### [教材出處](http://kakas-blog.logdown.com/posts/737732-using-ajax-in-rails-simple-examples)
## step.1 安裝Bootstrap
```
rails new kakasAJAX
```

add to Gemfile
```
gem "bootstrap"
gem "bootstrap_form"
```
rename application.css to application.css.scss

add to application.css.scss
```
@import "bootstrap-sprockets";
@import "bootstrap";
```
add to application.js
```
//= require bootstrap/modal
```
## step.2

安裝model、controller

rails g model Product title price:integer
rails g controller product
rake db:migrate

在product.rb加入驗證碼，注意validates要加s

class Product < ActiveRecord::Base
  validates :title, presence: true
  validates :price, presence: true, numericality: true
end

增加種子檔，讓你一次輸入五筆資料，去db/seed.rb輸入

Product.delete_all
Product.create!(title: "大麥客", price: 55)
Product.create!(title: "可樂", price: 30)
Product.create!(title: "中薯", price: 40)
Product.create!(title: "大薯", price: 55)
Product.create!(title: "雞塊", price: 45)

完成後，你可以進入console

rails c
p = Product
p.count

你可以看到有五筆資料

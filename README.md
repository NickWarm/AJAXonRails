### 教材出處：[在 Rails 中使用 AJAX 簡易範例](http://kakas-blog.logdown.com/posts/737732-using-ajax-in-rails-simple-examples)
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
## step.2 安裝model、controller
```
rails g model Product title price:integer
rails g controller products
rake db:migrate
```
在product.rb加入驗證碼，注意validates要加s
```
class Product < ActiveRecord::Base
  validates :title, presence: true
  validates :price, presence: true, numericality: true
end
```
增加種子檔，讓你一次輸入五筆資料，去db/seed.rb輸入
```
Product.delete_all
Product.create!(title: "大麥客", price: 55)
Product.create!(title: "可樂", price: 30)
Product.create!(title: "中薯", price: 40)
Product.create!(title: "大薯", price: 55)
Product.create!(title: "雞塊", price: 45)
```
完成後，你可以進入console
```
rails c
p = Product
p.count
```
你可以看到有五筆資料


## step.3 設定index頁面

設定路由，在route.rb加入
```
resources :products
root "products#index"
```

先在products_controller加入index action
```
def index
  @products = Product.all
end
```

然後新增views/product/index.html.erb
```html
<div class="container">
  <div class="well">
    <!-- link_to 加上 remote: true 就是跟 rails 說這個地方我們要使用 AJAX -->
    <!-- 像這裡他在跑完 new action 之後，就會去找 new.js.erb 檔 -->
    <%= link_to "New Product", new_product_path, remote: true, class: "btn btn-primary" %>
  </div>
</div>

<table class="table table-bordered table-striped">
  <thead>
    <tr>
      <th>Title</th>
      <th>Price</th>
      <td>Edit</td>
      <td>Delete</td>
    </tr>
  </thead>

  <tbody class="product-index">
    <%= render "index" %>
    <!-- tbody 裡就是資料會變動的地方，資料變動時只重新載入此處 -->
  </tbody>
</table>

<!-- 跳出視窗：我們可以利用 AJAX 跟 JavaScript 塞東西到裡面去 -->
<!-- 譬如要 Edit Product，我們就可以塞 Edit 的 form 到這裡 -->
<div id="product-modal" class="modal fade"></div>
```

然後新增views/product/\_index.html.erb
```html
<% @products.each do |product| %>
  <tr>
    <td><%= product.title %></td>
    <td><%= product.price %></td>
    <td><%= link_to "Edit", edit_product_path(product),
                            remote: true, class: "btn btn-primary" %></td>
    <td><%= link_to "Delete", product_path(product), method: :delete,
                              remote: true, class: "btn btn-primary",
                              data: { confirm: "Are you sure?" } %></td>
  </tr>
<% end %>

```
## 錯誤成功修正

首先修改route.rb，改成
```
resources :products
```
然後drop out db，重建一個
```
rake db:drop
rake db:create
rake db:migrate
```
重新跑一次seed
```
rake db:seed
```

## 解掉modal跳不出來的bug
這次小錯誤滿多的

products_controller.rb
create action裡面，要存檔的那段code，success筆誤成sucess，應該是
```rb
render "success"
```

views/products/\_new.html.erb
裡面第三層div筆誤寫成model，應該是
```
div.modal-header
```

最後是一直跳不出來的關鍵
views/products/new.js.erb，jquery selector要選#product-modal才對，但我少寫了#
最初筆誤
```js
$("product-modal").modal("show")
```
正確應該是
```js
$("#product-modal").modal("show")
```

## step.4 new action

products_controller.rb
```rb
def new
  @product = Product.new
end
```

我們在index.html.erb有段link_to
```
<%= link_to "New Product", new_product_path, remote: true, class: "btn btn-primary" %>
```
link_to 加上 remote: true 就是跟 rails 說這個地方我們要使用 AJAX
像這裡他在跑完 new action 之後，就會去找 new.js.erb 檔

add views/products/new.js.erb
```js
// 把 _new.html.erb 內容塞到 modal 裡，j 是 escape_javascript 的 sugar 語法
$("#product-modal").html("<%= j render 'new' %>")

// 讓 modal 跳出來
$("#product-modal").modal("show")
```

add views/products/\_new.html.erb
```html
<div class="modal-dialog">
  <div class="modal-content">
    <div class="modal-header">
      <h3>New Product</h3>
    </div>
    <%= render "form" %>
  </div>
</div>
```

add views/products/\_form.html.erb
```html
<%= bootstrap_form_for @product, remote: true do |f| %>
  <div class="modal-body">
    <%= f.text_field :title %>
    <%= f.text_field :price %>
  </div>
  <div class="modal-footer">
    <%= f.submit class: "btn btn-primary" %>
    <%= link_to "取消", "#", class: "btn btn-default",
                            data: { dissmiss: "modal" } %>
  </div>
<% end %>
```

add create action to controller
```rb
class ProductsController < ApplicationController
...

  def create
    @products = Product.all #給_index.html.erb用
    @product = Product.new(product_params)

    if @product.save
      render "success"
    else
      render :new
    end
  end

  private
  def product_params
    params.require(:product).permit(:title, :price)
  end
end

```

add views/products/success.js.erb
```js
$(".product-index").html("<%= j render 'index' %>")

// 把modal隱藏起來
$(#product-modal).modal("hide")

```

##  修正AJAX新增表單後，沒有自動關掉modal的bug

views/products/success.js.erb
手誤寫成
```js
$(#product-modal).modal("hide")
```
因為選擇器沒用""包起來所以失敗，應該是
```js
$("#product-modal").modal("hide")
```

## step.5 edit action
add edit action to products_controller
```rb
def edit
  @product = Product.find(params[:id])
end
```

add views/products/edit.js.erb
```js
$("#product-modal").html("<%= j render "edit" %>")
$("#product-modal").modal("show")
```

add views/products/\_edit.html.erb
```html
<div class="modal-dialog">
  <div class="modal-content">
    <div class="modal-header">
      <h3>Edit <%= @product.title %></h3>
    </div>
    <%= render "form" %>
  </div>
</div>
```

add update action to products_controller
```rb
def update
  @products = Product.all
  @product = Product.find(params[:id])

  if @product.update(product_params)
    render "success"
  else
    render :edit
  end
end
```

## destroy action

add destroy action to products_controller
```rb
def destroy
  @products = Product.all
  @product = Product.find(params[:id])
  @product.destroy
  render "success"
end
```

### 臨摹帖子完成

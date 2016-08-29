# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Product.delete_all
Product.create!(title: "大麥克", price: 55)
Product.create!(title: "可樂", price: 30)
Product.create!(title: "中薯", price: 40)
Product.create!(title: "大薯", price: 55)
Product.create!(title: "雞塊", price: 45)

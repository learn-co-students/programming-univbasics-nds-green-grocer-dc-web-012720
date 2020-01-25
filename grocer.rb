def find_item_by_name_in_collection(name, collection)
  collection.each do |item|
    if item[:item] == name
      return item
    end 
  end 
  nil
end 

def consolidate_cart(cart)
  new_cart = []
  cart.each do |each_cart|
    name = each_cart[:item]
    items = find_item_by_name_in_collection(name, new_cart)
    if items
      items[:count] += 1
    else
      new_cart << {
        :item => name,
        :price => each_cart[:price],
        :clearance => each_cart[:clearance],
        :count => 1
      }
    end 
  end 
  new_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |each_coupon|
    items = find_item_by_name_in_collection(each_coupon[:item], cart)
	  coupon_item = find_item_by_name_in_collection(each_coupon[:item]+" W/COUPON", cart)
    if coupon_item and items[:count] >= each_coupon[:num]
	    item_w_coupon[:count] += each_coupon[:num]
	    items[:count] -= each_coupon[:num]
	  elsif items and items[:count] >= each_coupon[:num]
      cart << {
        :item => each_coupon[:item] + " W/COUPON",
        :price => (each_coupon[:cost]/each_coupon[:num]).round(2),
        :clearance => items[:clearance],
        :count => each_coupon[:num]
      }
      items[:count] -= each_coupon[:num]
    end 
  end 
  
  cart
end 

def apply_clearance(cart)
  cart.each do |each_cart|
    if each_cart[:clearance]
      each_cart[:price] *= 0.8
    end 
  end 
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  cart_with_coupons = apply_coupons(consolidated_cart, coupons)
  updated_cart = apply_clearance(cart_with_coupons)

  total = 0
  updated_cart.each do |items|
    total += (items[:price] * items[:count]).round(2)
  end 

  if total > 100
    total = (total * 0.9).round(2)
  end 
  return total
end

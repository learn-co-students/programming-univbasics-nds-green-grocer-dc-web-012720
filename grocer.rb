require 'pry'

def find_item_by_name_in_collection(name, collection)
  collection.find{ |item| item[:item] == name } 
end

def consolidate_cart(cart)
  new_cart = []

  cart.each do |item|
    item_name = item[:item]
    found_item = find_item_by_name_in_collection(item_name, new_cart)

    if found_item
      found_item[:count] += 1
    else
      item[:count] = 1
      new_cart.push(item)
    end
  end

  new_cart
end

def apply_coupons(cart, coupons)
  # here the cart that gets passed in is a consolidated cart
  coupons.each do |coupon|
    item_name = coupon[:item]
    found_item = find_item_by_name_in_collection(item_name, cart)
    if found_item && found_item[:count] >= coupon[:num]
      discounted_num = (found_item[:count] / coupon[:num]) * coupon[:num]
      found_item[:count] = found_item[:count] - discounted_num
      item_with_coupon_hash = {:item => "#{item_name} W/COUPON", :price => coupon[:cost]/coupon[:num], :clearance => found_item[:clearance], :count => discounted_num}
      cart.push(item_with_coupon_hash)
    end
  end

  cart
end

def apply_clearance(cart)
  cart.each do |item|
    if item[:clearance] == true
      discounted_amount = (item[:price] * 0.2).round(2)
      discounted_price = item[:price] - discounted_amount
      item[:price] = discounted_price
    end
  end
  
  cart
end

def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers

  consolidated_cart = consolidate_cart(cart)
  cart_with_coupons = apply_coupons(consolidated_cart, coupons)
  cart_with_coupons_and_clearance = apply_clearance(cart_with_coupons)

  total = 0

  cart_with_coupons_and_clearance.each do |item|
    total += item[:price] * item[:count]
  end

  if total > 100
    discount = total * 0.1
    total -= discount
  end

  total
end

consolidated_cart = [
  {:item => "AVOCADO", :price => 3.00, :clearance => true, :count => 3},
  {:item => "KALE",    :price => 3.00, :clearance => false, :count => 1}
]

coupon = [{:item => "AVOCADO", :num => 2, :cost => 5.00}]

apply_coupons(consolidated_cart, coupon)
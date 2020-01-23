def find_item_by_name_in_collection(name, collection)
  i = 0
  
  while i < collection.length do
    if collection[i][:item] == name
      return collection[i]
    end
    
    i += 1
  end
  
  nil
end

def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  new_cart = []
  i = 0
  
  while i < cart.length do
    product = cart[i]
    found_item = find_item_by_name_in_collection(product[:item], new_cart)
    
    if found_item
      found_item[:count] += 1
    else
      product[:count] = 1
      new_cart << product
    end
    
    i += 1
  end
  
  new_cart
end

def apply_coupons(cart, coupons)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  i = 0
  
  while i < cart.length do #iterates through cart
    product = cart[i]
    j = 0
    
    while j < coupons.length do #iterates through coupons
      coupon = coupons[j]
      
      if coupon[:item] == product[:item] && product[:count] >= coupon[:num]  #if coupon name matches product name, create a slot
        cart << {:item => "#{product[:item]} W/COUPON", :price => coupon[:cost] / coupon[:num].round(2), :clearance => product[:clearance], :count => coupon[:num]}
        
        product[:count] -= coupon[:num]
      end
      j += 1
    end
    
    i += 1
  end
  
  cart
end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  i = 0
  
  while i < cart.length do
    if cart[i][:clearance] == true
      cart[i][:price] *= 0.8.round(2)
    end
    i += 1
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
  easy_cart = apply_coupons(consolidate_cart(cart), coupons)
  v_easy_cart = apply_clearance(easy_cart)
  i = 0
  total = 0
  
  while i < v_easy_cart.length do
    total += v_easy_cart[i][:price].round(2) * v_easy_cart[i][:count]
    i += 1
  end
  
  if total > 100.00
    return total * 0.9.round(2)
  end
  total
end

def find_item_by_name_in_collection(name, collection)
  index = 0 
  
  while index < collection.length 
    if collection[index][:item] == name
      return collection[index]
    end
    index += 1
  end
  nil
end

def consolidate_cart(cart)
  new_cart = []
  index = 0 
  
  while index < cart.length do 
    item_name = cart[index][:item]
    
    new_item = find_item_by_name_in_collection(item_name, new_cart)
    if new_item
      new_item[:count] += 1
    else
      new_item = {
        :item => cart[index][:item],
        :price => cart[index][:price],
        :clearance => cart[index][:clearance],
        :count => 1
      }
      new_cart << new_item
    end
    
    index += 1 
  end


  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  
  new_cart
end

def apply_coupons(cart, coupons)
  counter = 0 
  while counter < coupons.length
    cart_item = find_item_by_name_in_collection(coupons[counter][:item], cart)
    couponed_item_name = "#{coupons[counter][:item]} W/COUPON"
    cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
    if cart_item && cart_item[:count] >= coupons[counter][:num]
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += coupons[counter][:num]
        cart_item[:count] -= coupons[counter][:num]
      else
        cart_item_with_coupon = {
          :item => couponed_item_name,
          :price => coupons[counter][:cost] / coupons[counter][:num],
          :count => coupons[counter][:num],
          :clearance => cart_item[:clearance]
        }
        cart << cart_item_with_coupon 
        cart_item[:count] -= coupons[counter][:num]
      end
    end
    counter += 1 
  end
  cart
end

def apply_clearance(cart)
  counter = 0
  while counter < cart.length
  if cart[counter][:clearance]
    cart[counter][:price] = (cart[counter][:price] - (cart[counter][:price] * 0.20)).round(2)
  end
  counter += 1
  end
  
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  
  total = 0
  counter = 0
  while counter < final_cart.length do 
    total += final_cart[counter][:price] * final_cart[counter][:count]
    counter += 1
  end
  if total > 100
    total -= (total * 0.10)
  end
  total
end





























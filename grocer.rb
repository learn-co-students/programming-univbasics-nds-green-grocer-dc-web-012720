def find_item_by_name_in_collection(name, collection)
  i = 0 
  while i < collection.length do 
    if (name == collection[i][:item])
      return collection[i]
    end
    i+=1 
  end 
  return nil 
end

def consolidate_cart(cart)
  newArr = []
  i = 0
  while i < cart.length do
    nameOfItem = cart[i][:item]
    itemInfo = find_item_by_name_in_collection(cart[i][:item], newArr)
    if itemInfo
      itemInfo[:count] += 1
    else  
      newArr << {
        :item => cart[i][:item],
        :price => cart[i][:price],
        :clearance => cart[i][:clearance],
        :count => 1
      }
    end
    i += 1
  end 
  newArr
end

def apply_coupons(cart, coupons)
  i = 0

  while i < coupons.size do
    current_coupon = coupons[i]
    applicable_for_discount = find_item_by_name_in_collection( current_coupon[:item], cart )
      if ( applicable_for_discount[:count] / current_coupon[:num] >= 1 )
        cart.push( {:item => "#{current_coupon[:item]} W/COUPON",
                    :price => (current_coupon[:cost] / current_coupon[:num]).round(2),
                    :clearance => applicable_for_discount[:clearance],
                    :count => applicable_for_discount[:count] - ( applicable_for_discount[:count] % current_coupon[:num])})

        applicable_for_discount[:count] %= current_coupon[:num]
      end
    i += 1
  end
  cart
end
  

def apply_clearance(cart)
  i = 0 
  while i < cart.length do 
    if cart[i][:clearance]
      cart[i][:price] *= 0.8
      cart[i][:price] = cart[i][:price].round(2)
    end 
    i += 1
  end 
  cart
end

def checkout(cart, coupons)
  total = 0.0 
  newCart = consolidate_cart(cart)
  couponCart = apply_coupons(newCart,coupons) 
  finalCart = apply_clearance(couponCart)
  i = 0 
  while i < finalCart.length do 
    total += (finalCart[i][:price] * finalCart[i][:count])
    i += 1 
  end
  if total > 100
    total *= 0.9
  end 
  total.round(2)
end

def find_item_by_name_in_collection(name, collection)
  #This will return the matching hash of provided name, in the given collection (which is AoH) {:item => banana}
  i = 0
  while i < collection.length do
    if (collection[i][:item] == name)
      return collection[i]
    elsif ((collection[i][:item] != name) && (i == (collection.length - 1)))
      return nil
    else
      i += 1
    end
  end
end


def consolidate_cart(cart)

#Explanation of things before While Loop

  # variable i will be used to iterate through cart array
  # distinctIndex will be used to identify where in our return array a distinct :item is. The final value of this also represents the final length of our returned array
  # newHash ==>n {:item=>"AVOCADO", :price=>3.0, :clearance=>true}
  # newHash[:count] ==> {:item=>"AVOCADO", :price=>3.0, :clearance=>true, :count=>1}
  
  # hashItemsAdded is a map in which each key will be a distinct "String" Grocery Item and its' value is going to be the index where the item is located in our returned array.
  
  # hashItemsAdded[String first item name] = 0 
  # updates our newly created hashItemsAdded map to {"First Item" => 0}
  
  newArray = []
  i = 0 
  distinctIndex = 0 
  
  newHash = cart[i]
  newHash[:count] = 1
  newArray.push(newHash)    
  
  hashItemsAdded = Hash.new 
  hashItemsAdded[(cart[i][:item])] = distinctIndex 
  
  distinctIndex += 1
  i += 1
  
    while i < cart.length do #=> starting off: while 1 is less than cart.length
      currentItem = cart[i][:item]

      
        # if our new hashItemMap contains key "currentItem" then we know of its index in our return array. It will be distinctIndex - 1
        # This will grab the index of the current item in our result Array and increase the value associated with the :count key there by 1... 
  
        #It will not come here for the first iteration.
      if (hashItemsAdded.include?(currentItem))
        
        newArray[hashItemsAdded[currentItem]][:count] += 1
# for example                newArray[number][:count] += 1

      else #new distinct item found. add to the hashItemsAdded map and return Array.
        hashItemsAdded[currentItem] = distinctIndex
        distinctIndex+=1
        newHash = cart[i] 
        newHash[:count] = 1
        newArray.push(newHash)
      end
      i += 1
    end
  return newArray
end



def apply_coupons(cart, coupons)
  
  newArray = []
  i = 0
  while i < cart.length do
    newArray.push(cart[i])
    i += 1
  end
  
  couponMatchIndex = 0
  newCouponHash = Hash.new
  i = 0
  while i < coupons.length do
    newCouponHash[coupons[i][:item]] = couponMatchIndex #locating where couponName is located in initial input of coupon index
    couponMatchIndex += 1
    i += 1
  end
  
  i = 0
  while i < cart.length do
    if newCouponHash.include?(newArray[i][:item])
      newHash = {}
      newHash[:item] = "#{newArray[i][:item]} W/COUPON"
      couponItemIndex = newCouponHash[newArray[i][:item]] #=> a number

      couponVal = (coupons[couponItemIndex][:cost])

      numOfItemsForCouponVal = (coupons[couponItemIndex][:num])

      newHash[:price] = (couponVal)/(numOfItemsForCouponVal)

      newHash[:clearance] = newArray[i][:clearance]
      resultingNumOfDiscountItems = newArray[i][:count] / coupons[couponItemIndex][:num]
      newHash[:count] = resultingNumOfDiscountItems * coupons[couponItemIndex][:num]
      newArray.push(newHash)
      
      newArray[i][:count] = newArray[i][:count] % coupons[couponItemIndex][:num]
      i += 1
    else 
      i += 1
    end
  end
  return newArray
end

def apply_clearance(cart)
  #Returns a new Array where every unique item in the original is present but with its price reduced by 20% if its :clearance value is true
  
  newArray = []
  updatedCart = cart
  i = 0
  while i < cart.length do
    if (cart[i][:clearance] == true)
      updatedCart[i][:price] = (cart[i][:price] * (0.80)).round(2)
      newArray.push(updatedCart[i])
      i += 1
    else
      newArray.push(updatedCart[i])
      i += 1
    end
  end
  return newArray
end

def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  # BEFORE it begins the work of calculating the total (or else you might have some irritated customers
  
  #Returns Float: a total of the cart
  
  newConsolidatedCart = consolidate_cart(cart)
  appliedCouponsToCart = apply_coupons(newConsolidatedCart, coupons)
  consolidated_and_discount_applied_cart = apply_clearance(appliedCouponsToCart)
  finalCart = consolidated_and_discount_applied_cart
  grandTotal = 0
  i = 0
  while i < finalCart.length do
    specificItemTotalPrice = (finalCart[i][:price] * finalCart[i][:count])
    grandTotal += specificItemTotalPrice.round(2)
    i += 1
  end
  
  if grandTotal > 100
    grandTotal = (grandTotal * 0.90).round(2)
  end
  return grandTotal 
end

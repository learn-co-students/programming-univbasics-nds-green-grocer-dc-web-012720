# def find_item_by_name_in_collection(name, collection)
  
#   index = 0
#     while index < collection.length do 
   
#       if name == collection[index][:item]
#         result = {}
#         result[:item] = collection[index][:item]
#       end
#       index += 1
#     end 
#   result
# end


def find_item_by_name_in_collection(name, collection)
  index = 0
  while index < collection.length do 
    if collection[index][:item] == name 
      return collection[index]
    end
    index += 1 
  end 
end

  
def consolidate_cart(cart) 
  new_cart = []
  index = 0
    while index < cart.length do 
      new_item = find_item_by_name_in_collection(cart[index][:item], new_cart)
      if new_item
        new_item[:count] += 1 
      else
        new_cart << {:item => cart[index][:item], 
        :price => cart[index][:price],
        :clearance => cart[index][:clearance],
        :count => 1}
      end 
      index += 1 
    end 
    new_cart
end


#input: arary of item hashes, array of coupon hashes 
#output: new array mix of item hashes & "ITEM W/ COUPON" hashes where applicable 

# def apply_coupons(cart, coupons)
#   new_cart = []
#   index = 0 
#     while index < cart.length do 
#       binding.pry
#       coupon_hash = find_item_by_name_in_collection(cart[index][:item], coupons)
#       if coupon_hash && cart[index][:count] >= coupon_hash[:num]
#         updated_count = cart[index][:count] - coupon_hash[:num]
#         new_cart << {
#           :item => cart[index][:item], 
#           :price => cart[index][:price], 
#           :clearance => cart[index][:clearance], 
#           :count => updated_count
#           }
#         coupon_name = "#{cart[index][:name]} W/COUPON" 
#         coupon_price = coupon_hash[:cost] / coupon_hash[:num]
#         new_cart << {
#           :item => coupon_name, 
#           :price => coupon_price, 
#           :clearnace => cart[index][:clearnace],
#           :count => coupon_hash[:num]
#           }
#       else
#         new_cart << cart[index]
#       end
#       index += 1 
#     end 
#     new_cart
# end

# p apply_coupons([
#   {:item => "AVOCADO", :price => 3.00, :clearance => true, :count => 3},
#   {:item => "KALE",    :price => 3.00, :clearance => false, :count => 1}
# ], [{:item => "AVOCADO", :num => 2, :cost => 5.00}])

# [
#   {:item => "AVOCADO", :price => 3.00, :clearance => true, :count => 1},
#   {:item => "KALE", :price => 3.00, :clearance => false, :count => 1},
#   {:item => "AVOCADO W/COUPON", :price => 2.50, :clearance => true, :count => 2}
# ]

def apply_coupons(cart, coupons)
  index = 0
  while index < coupons.length do
  cart_item = find_item_by_name_in_collection(coupons[index][:item], cart)
  coupon_item_name = "#{coupons[index][:item]} W/COUPON"
  cart_item_with_coupon = find_item_by_name_in_collection(coupon_item_name, cart)
    if cart_item && cart_item[:count] >= coupons[index][:num]
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += coupons[index][:num]
        cart_item[:count] -= coupons[index][:num]
      else
        cart_item_with_coupon = {
          :item => coupon_item_name,
          :price => coupons[index][:cost] / coupons[index][:num],
          :count => coupons[index][:num],
          :clearance => cart_item[:clearance] 
        }
      end
      cart << cart_item_with_coupon
      cart_item[:count] -= coupons[index][:num]
    end
  index += 1 
  end 
  cart
end

# def apply_clearance(cart)
#   new_cart = []
#   index = 0 
#     while index < cart.length do
#       if cart[index][:clearance]
#         clearance_price = cart[index][:price] * 0.8
#         clearance_price = clearance_price.round(2)
#         new_cart<< {
#           :item => cart[index][:item],
#           :price => clearance_price,
#           :clearance => cart[index][:clearance],
#           :count => cart[index][:count]
#         }
#       else
#         new_cart << cart[index]
#       end
      
#     index += 1
#     end
#     new_cart
# end

def apply_clearance(cart)
  index = 0
  while index < cart.length do
    if cart[index][:clearance]
      cart[index][:price] = (cart[index][:price] * 0.8).round(2)
    end
  index += 1
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated_cart, coupons)
  clearance_cart = apply_clearance(coupon_cart)
  
  grand_total = 0
  index = 0
    while index < clearance_cart.length do
      grand_total += (clearance_cart[index][:price] * clearance_cart[index][:count])
      
      index += 1
    end
    
    if grand_total > 100
      grand_total = (grand_total * 0.9).round(2)
    end
    
    grand_total
end

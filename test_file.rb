cart = AoH
result = AoH with unique items add :count (> or = 1)

def consolidate_cart(cart)
  result = []
  index = 0
    while index < cart.length do 
      new_item = [cart][index][:item]
      if !result[new_item]
        result[index] = cart[index]
        result[index] << {:count => 1}
      else
        result[index][:count] += 1 
      end 
      index += 1 
    end 
    result
end

### Write the `consolidate_cart` Method

* Arguments:
  * `Array`: a collection of item Hashes
* Returns:
  * a ***new*** `Array` where every ***unique*** item in the original is present
    * Every item in this new `Array` should have a `:count` attribute
    * Every item's `:count` will be _at least_ one
    * Where multiple instances of a given item are seen, the instance in the
      new `Array` will have its `:count` increased

_Example_:

Given:

```ruby
[
  {:item => "AVOCADO", :price => 3.00, :clearance => true },
  {:item => "AVOCADO", :price => 3.00, :clearance => true },
  {:item => "KALE", :price => 3.00, :clearance => false}
]
```

then the method should return the array below:

```ruby
[
  {:item => "AVOCADO", :price => 3.00, :clearance => true, :count => 2},
  {:item => "KALE", :price => 3.00, :clearance => false, :count => 1}
]
```

You'll be wanting to check in with tests often to make sure your method is on
track. If you want to run the tests about `consolidate_cart`, you can run them
by invoking `rspec spec/grocer_spec.rb:27`. If you look at the
`spec/grocer_spec.rb` file, you'll see that all the `consolidate_cart` tests
are in a `describe` block starting on line 27. This will help your output come
out in a digestible form.
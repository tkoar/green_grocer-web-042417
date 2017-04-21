def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each do |item, item_hash|
    item_name = item.keys.first
    if consolidated_cart[item_name]
      consolidated_cart[item_name][:count] += 1
    else
      consolidated_cart[item_name] =
      { price: item[item_name][:price],
        clearance: item[item_name][:clearance],
        count: 1 }
    end
  end
  consolidated_cart
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item_name = coupon[:item]
    if cart[item_name] && cart[item_name][:count] >= coupon[:num]
      if cart["#{item_name} W/COUPON"]
        cart["#{item_name} W/COUPON"][:count] += 1
      else
        cart["#{item_name} W/COUPON"] = {
          price: coupon[:cost],
          clearance: cart[item_name][:clearance],
          count: 1
        }
      end
      cart[item_name][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item_name, item_hash|
    if item_hash[:clearance]
      item_hash[:price] = (item_hash[:price] * 0.80).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated_cart, coupons)
  clearance_cart = apply_clearance(coupon_cart)
  cart_total = 0
  clearance_cart.each do |item_name, item_hash|
    cart_total += item_hash[:price] * item_hash[:count]
  end
  cart_total *= 0.90 if cart_total > 100.00
  cart_total
end

class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def my_orders
    @orders = Order.where(:customer_id => current_user.id)
  end
end

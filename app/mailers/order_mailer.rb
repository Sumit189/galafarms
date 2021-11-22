class OrderMailer < ApplicationMailer
  def new_order
    @customer = params[:user]
    @order = Order.where(:customer_id => @customer.id).last
    @address = Address.find_by(:id =>params[:address] )
    @amount = params[:amount]
    @current_user = params[:current_user]
    mail(to: @customer.email, subject: 'Order received')
  end
end

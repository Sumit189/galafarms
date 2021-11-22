class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :update_allowed_parameters, if: :devise_controller?

  protected

  def update_allowed_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password)}
  end

  def after_sign_in_path_for(resource_or_scope)
      if session[:cart_id]
        cart = Cart.find_by(id: session[:cart_id])
        if Cart.exists?(:id => session[:cart_id])
            cart.update(:user_id => current_user.id)
        end
          session[:cart_id] = nil
      end
      super
  end

  def current_cart
    if user_signed_in?
      if current_user.carts.present? and current_user.carts.last.purchased == false
        cart = current_user.carts.last
      else
        cart = Cart.create(user_id: current_user.id)
      end
      session[:cart_id] = cart.id
      cart
    else
      if session[:cart_id]
        begin
          cart = Cart.find(session[:cart_id])
        rescue ActiveRecord::RecordNotFound
          cart = Cart.create
        end
      else
        cart = Cart.create
      end
      session[:cart_id] = cart.id
      cart
    end
  end

  # def current_cart
  #   if user_signed_in?
  #     if current_user.cart.present?
  #       cart = current_user.cart
  #     else
  #       cart = Cart.create(user_id: current_user.id)
  #     end
  #     session[:cart_id] = cart.id
  #     cart
  #   else
  #     begin
  #       cart = Cart.find(session[:cart_id])
  #     rescue ActiveRecord::RecordNotFound
  #       cart = Cart.create(user_id: nil)
  #     end
  #     session[:cart_id] = cart.id
  #     cart
  #   end
  # end
  #   def current_cart
  #     begin
  #       Cart.find(session[:cart_id])
  #     rescue ActiveRecord::RecordNotFound
  #       cart = Cart.create
  #       session[:cart_id] = cart.id
  #       cart
  #     end
  #   end
end

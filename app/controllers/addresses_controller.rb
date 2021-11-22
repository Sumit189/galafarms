class AddressesController < ApplicationController
  require 'active_merchant'
  require "active_merchant/billing/rails"
  before_action :set_address, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /addresses or /addresses.json
  def index
    @total_price = current_user.carts.last.total_price
    @addresses = current_user.addresses.all.reverse_order.paginate(page: params[:page], per_page: 2)
  end

  # GET /addresses/1 or /addresses/1.json
  def show
  end

  # GET /addresses/new
  def new
    @address = Address.new
  end

  # GET /addresses/1/edit
  def edit
  end

  def order_info
    if request.post?
      @address_id = params[:info][:selected_address]
      @month_year = params[:info][:expiry].split('-')
      @year = @month_year[0]
      @month = @month_year[1]
      # Use the TrustCommerce test servers
      ActiveMerchant::Billing::Base.mode = :test

      gateway = ActiveMerchant::Billing::TrustCommerceGateway.new(
        :login => 'TestMerchant',
        :password => 'password')

      # ActiveMerchant accepts all amounts as Integer values in cents
      amount = current_user.carts.last.total_price
      print(amount)
      # $10.00

      # The card verification value is also known as CVV2, CVC2, or CID
      credit_card = ActiveMerchant::Billing::CreditCard.new(
        :first_name         => params[:info][:first_name],
        :last_name          => params[:info][:last_name],
        :number             => params[:info][:cardNumber],
        :month              => @month,
        :year               => @year,
        :verification_value => params[:info][:cvv])

      # Validating the card automatically detects the card type
      if credit_card.validate.empty?
        # Capture $10 from the credit card
        response = gateway.purchase(amount, credit_card)

        if response.success?
          puts "Successfully charged $#{sprintf("%.2f", amount / 100)} to the credit card #{credit_card.display_number}"

          OrderMailer.with(user: current_user, address: @address_id, amount: amount, current_user: current_user).new_order.deliver_now

          Order.create(:customer_id => current_user.id, :cart_id => current_user.carts.last.id, :amount => amount, :address_id => @address_id, :transaction_id => response.params["transid"])
          current_user.carts.last.update(:purchased => true)
            li = LineItem.where(:cart_id =>  current_user.carts.last.id)
            li.each do |l|
              Product.find(l.product_id).update(:stock => Product.find(l.product_id).stock - l.quantity)
            end
          redirect_to root_path, notice: "Order Successful"
        else
          raise StandardError, response.message
          render addresses_path, alert: "Provided details are invalid..."
        end
      end
    end
  end
  # POST /addresses or /addresses.json
  def create
    @address = Address.new(address_params)
    respond_to do |format|
      if @address.save
        format.html { redirect_to addresses_path, notice: "Address was successfully created." }
        format.json { render :show, status: :created, location: @address }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /addresses/1 or /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to @address, notice: "Address was successfully updated." }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1 or /addresses/1.json
  def destroy
    @address.destroy
    respond_to do |format|
      format.html { redirect_to addresses_url, notice: "Address was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def address_params
      params[:address].merge!(user_id: current_user.id)
      params.require(:address).permit(:first_name, :last_name, :address1, :address2, :city, :state, :country, :zip, :user_id)
    end
end

class CheckoutController < ApplicationController
  before_action :authenticate_user!
    def create
        @session = Stripe::Checkout::Session.create({
           customer: current_user.stripe_customer_id,
            payment_method_types: ['card'],
            line_items: @cart.collect { |item| item.to_builder.attributes! },
            mode: 'payment',
            success_url: sucess_url + "?session_id={CHECKOUT_SESSION_ID}",
            cancel_url: cancel_url,
          })    
          respond_to do |format|
            format.js
          end
    end

   def sucess
    if params[:session_id].present?
      session[:cart] = [] # empty cart = empty array
      @session_with_expand = Stripe::Checkout::Session.retrieve({id: params[:session_id], expand: ["line_items"] })  
      @session_with_expand.line_items.data.each do |line_item| 
      product = Product.find_by(stripe_product_id: line_item.price.product)
      end
    else

      redirect_to cancel_url, alert: "Sem informações para mostrar"
    end
  end

    def cancel

      

    end

end
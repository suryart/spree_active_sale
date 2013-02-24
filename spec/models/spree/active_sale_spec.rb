require 'spec_helper'

describe "Spree::ActiveSale" do
  it "should not save when name is not given" do
    active_sale = Spree::ActiveSale.new
    active_sale.name = " "
    active_sale.save
    active_sale.new_record? == true
  end
  
end

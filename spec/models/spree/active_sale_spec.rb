require 'spec_helper'

describe "Spree::ActiveSale" do
  it "should not save active sale when name is not given" do
    active_sale = Spree::ActiveSale.new
    active_sale.name = " "
    active_sale.save
    active_sale.new_record? == true
  end

  it "should save active sale when name is given" do
    active_sale = Spree::ActiveSale.new
    active_sale.name = "Dummy Sale"
    active_sale.save
    active_sale.new_record? == false
  end
  
end

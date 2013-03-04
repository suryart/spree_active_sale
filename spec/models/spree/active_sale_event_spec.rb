require 'spec_helper'

describe Spree::ActiveSaleEvent do
  it "should not save when name is not given" do
    active_sale_event = Spree::ActiveSaleEvent.new
    active_sale_event.name = " "
    active_sale_event.save
    active_sale_event.new_record? == true
  end
  
end

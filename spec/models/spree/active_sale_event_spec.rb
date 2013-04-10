require 'spec_helper'

describe Spree::ActiveSaleEvent do
  it "should not save when name is not given" do
    active_sale_event = Spree::ActiveSaleEvent.new
    active_sale_event.name = " "
    active_sale_event.save
    active_sale_event.new_record? == true
  end

  context "Eventable's instace methods" do
    let(:active_sale_event) { create :active_sale_event }

    context '#live?' do
      it "should accept the moment when the instance should be live" do
        active_sale_event.start_date = 5.days.from_now
        active_sale_event.end_date = 7.days.from_now
        active_sale_event.live?(6.days.from_now).should be true
        active_sale_event.live?.should be false
        Time.should_not_receive(:zone)
      end
    end
  
    context '#live_and_active?' do
      it "should pass the moment to #live? if present" do
        now = Time.now
        active_sale_event.should_receive(:live?).with(now)
        active_sale_event.live_and_active? now
      end
    end
  end
end

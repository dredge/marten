require "./spec_helper"

describe Marten::Template::Filter::Join do
  describe "#apply" do
    it "returns the version of the string representation of the initial value with newlines replaced by HTML <br />" do
      filter = Marten::Template::Filter::Join.new

      # val_1 = filter.apply(Marten::Template::Value.from("One+Two+Three"), Marten::Template::Value.from('+'))
      val_1 = filter.apply(Marten::Template::Value.from(["Banana", "Orange", "Apple"]), Marten::Template::Value.from(", "))
      val_2 = Marten::Template::Value.from("Banana, Orange, Apple")
      val_1.should eq val_2

      val_1 = filter.apply(Marten::Template::Value.from([1, "One", 1.0, '1']), Marten::Template::Value.from('-'))
      val_2 = Marten::Template::Value.from("1-One-1.0-1")
      val_1.should eq val_2
    end
  end
end

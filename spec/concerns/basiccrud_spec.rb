require 'spec_helper'

describe BasicCrud do

  let (:test_class) { Struct.new(:item) { include BasicCrud } }
  let (:basic_crud) { test_class.new("Stewart", "Home") }

    it "tests stuff" do
        basic_crud.method.test == "something"
    end
end

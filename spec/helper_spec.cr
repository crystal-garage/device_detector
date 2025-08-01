require "./spec_helper"

describe "Helper" do
  it "should detect capture group" do
    DeviceDetector::Helper.capture_groups?("$1").should be_true
  end
end

require 'spec_helper'

describe LeaveType do
 context "Should have name"
  it "Should not be blank"
 end
 context "Should mention maximum number of leaves"
  it "Should not be nil"
  it "Should greater than 0"
 end
 # In case of casual leaves some companies add an amount of leaves for each month
 # 1 for a month and 1 for another month  so, 1+1=2 leaves are got added for 2 months
 # These leaves should be auto increased
 it "Should mention the number of leaves which are going to increment automatically (not mandatory)"
 it "Should mention weather  leaves carry forwarded or not"
end

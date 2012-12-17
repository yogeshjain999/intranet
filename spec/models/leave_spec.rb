require 'spec_helper'

describe Leave do
 context "Validations"
  it "Should select leave type"
  it "Should mention start date"
  it "Should mention end date"
  it "Should calculate duration/number of days on start date and end date"
  it "Should have reason"
  it "Should mention contact details"
 end
 context "Leaves cannot club together"
  it "Casual leaves should not be more than 2 days"
  it "Leaves  should not be mixed"
  # such as casual leaves are 2 and 2 sick leaves
 end
end

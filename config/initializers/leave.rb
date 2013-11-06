#key will month number that is 1..12
PAID_LEAVE_MONTHLY_DISTRIBUTION = Hash.new do|hash, key| 
                                    hash[key.to_i] = 1.5 
                                  end

CAN_CARRY_FORWARD=15

PAID_LEAVE = 18
CASUAL_LEAVE = SICK_LEAVE = 6

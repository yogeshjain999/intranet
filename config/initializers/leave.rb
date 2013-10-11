#key will month number that is 1..12
PAID_LEAVE_MONTHLY_DISTRIBUTION = Hash.new do|hash, key| 
                                    if key.to_i == 6
                                      hash[key.to_i] = 2.5    
                                    elsif key.to_i <= 12
                                      hash[key.to_i] = 1.5 
                                    end    
                                  end

PAID_LEAVE = 19
CASUAL_LEAVE = SICK_LEAVE = 6

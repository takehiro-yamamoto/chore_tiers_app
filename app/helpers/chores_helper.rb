module ChoresHelper
  def tier_priority_label(priority)
    case priority
    when 1 then 'S'
    when 2 then 'A'
    when 3 then 'B'
    when 4 then 'C'
    when 5 then 'D'
    else "？"
    end
  end
end

def parrot_trouble(talking, hour)
  if talking
    if hour < 7 || hour > 20
      return true
    else
      return false
    end
  else
    return false
  end
end

# 呼び出し例
parrot_trouble(true, 6)
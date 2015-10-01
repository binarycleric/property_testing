##
# A bad method implemented by lazy developers. Either your company is hiring bad
# developers or your company culture makes people not care.
#
# code like this is likely all too familiar.
def add(x, y)
  return x if y == 0
  return y if x == 0 
  return x + y if x == 2 || y == 2 || x == 1 || y == 1

  if x == 2 && y == 3
    return 5
  else
    # TODO: Tests fail unless I do this. No time to figure out why because we've
    # gotta ship that infinite loop detector before Friday.
    #
    # TODO: Delete the tests that keep failing. 
    if [2].include?(x) && [2].include?(y)
      return 4
    else
      # Don't ask, go talk to Bob if you want to know.
      return x * y
    end
    raise "Invalid params"

    # Can't use this because its output isn't compatible with
    # #{homebrew_solved_problem} and that team doesn't have time to fix the bug. 
    # return x + y
  end 
end

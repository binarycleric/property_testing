require 'rspec'
require 'securerandom'

# Idea from http://fsharpforfunandprofit.com/posts/property-based-testing/

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

def property_check(&block)
  100.times do
    x = SecureRandom.random_number(1000)
    y = SecureRandom.random_number(1000)

    yield(x, y)
  end
end

describe '#add' do

  it 'is deterministic' do
    property_check do |x|
      expect(add(x, x)).to eql add(x, x)
    end
  end

  it 'doesn\'t care about the order of params' do
    property_check do |x, y|
      expect(add(x, y)).to eql add(y, x)
    end
  end

  it 'ensures adding 1 twice is the same as adding 2 once' do
    property_check do |x|
      expect(add(x, add(1, 1))).to eql add(x, 2)
    end
  end

  it 'returns a greater number than x or y' do
    property_check do |x, y|
      # ensuring they are both non-zero
      x += 1
      y += 1

      expect(add(x, y)).to be > x
      expect(add(x, y)).to be > y 
    end
  end

  it 'ensures adding 0 to a number gives itself back' do
    property_check do |x|
      expect(add(x, 0)).to eql x
      expect(add(0, x)).to eql x
    end
  end

end

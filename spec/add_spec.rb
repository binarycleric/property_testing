require 'rspec'
require 'securerandom'

$:<< File.join(File.dirname(__FILE__), '../lib')
require 'add'

# Idea from http://fsharpforfunandprofit.com/posts/property-based-testing/

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

  it 'ensures adding negative numbers results in a smaller number' do
    property_check do |x, y|
      y = (y + 1) * -1
      expect(add(x, y)).to be < x 
    end

    property_check do |x, y|
      x = (x + 1) * -1
      expect(add(x, y)).to be < y 
    end
  end

  it 'ensures adding 0 to a number gives itself back' do
    property_check do |x|
      expect(add(x, 0)).to eql x
      expect(add(0, x)).to eql x
    end
  end

end

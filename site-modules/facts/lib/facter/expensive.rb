require 'facter/util/caching'

Facter.add(:expensive) do
  cache_for 10, :seconds

  # The cache has to have a name, doesn't matter what it is but I would
  # recommend the same as the fact name. There is no need to use `setcode`
  # if you are caching the value
  cache(:expensive) do
    (1..500_000).to_a.reject {|n| n % 5 == 0 }
  end
end

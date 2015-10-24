def line_intend(count)
  (1..count).map { ' ' }.join
end

def as_config_generator(object, intend = 2)
  fail "expecting a Hash, but got '#{object.inspect}'" unless object.is_a?(Hash)
  data = ''
  object.each do |key, value|
    if key == 'mesh-seed-address-port'
      value.each do |server|
        data << line_intend(intend) + 'mesh-seed-address-port' + ' ' + server + "\n"
      end
      next
    end

    if value.is_a?(Hash)
      data << line_intend(intend) + key + " { \n"
      data << as_config_generator(value, intend + 2)
      data << line_intend(intend) + "} \n"
    else
      data << line_intend(intend) + key + ' ' + value.to_s + "\n"
    end
  end
  data
end

def tarball_sha256sum(edition, version)
  sha256sums = { 'community' => {}, 'enterprise' => {} }
  sha256sums['community']['3.6.3'] = 'fb0fb93e64a8559349645f20821193d1f767672bc06c7f0ad1b1b0a4bc40a7f2'
  sha256sum = sha256sums[edition][version]
  fail "sha256sum is missing for aerospike tarball edition #{edition} version #{version}" unless sha256sum
  sha256sum
end

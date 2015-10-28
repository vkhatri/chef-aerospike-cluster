def line_intend(count)
  (1..count).map { ' ' }.join
end

def as_config_generator(object, intend = 2)
  fail "expecting a Hash, but got '#{object.inspect}'" unless object.is_a?(Hash)
  data = ''
  object.each do |key, value|
    if %w(mesh-seed-address-port device).include?(key)
      fail "expecting an Array for attribute #{key}" unless value.is_a?(Array)
      # array attributes
      value.uniq.each do |v|
        data << line_intend(intend) + key + ' ' + v + "\n"
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

def package_sha256sum(edition, version, os)
  sha256sums = {
    'community' => {
      'ubuntu12.04' => {},
      'debian6' => {},
      'debian7' => {},
      'el6' => {}
    },
    'enterprise' => {}
  }

  sha256sums['community']['ubuntu12.04']['3.6.3'] = 'd47ae90cf53058e756833ddcfa57c80601e62e6756fd2f333a6e9edd1234a6c0'
  sha256sums['community']['debian6']['3.6.3'] = '8d78bde99e81efd7359cbbfc88596b4dfd8ff55258688c9bdce111e38a23ddc6'
  sha256sums['community']['debian7']['3.6.3'] = '6bd5d425af19bd13ece1890b38cdce2a4941eff4764374774c767b04031bebda'
  sha256sums['community']['el6']['3.6.3'] = '3ca3ac402beeda4a5cb2b8e45448214f1357b49ae86d3c44ff1407a406acfd5f'

  sha256sum = sha256sums[edition][os][version]
  fail "sha256sum is missing for aerospike package edition #{edition} version #{version} os #{os}" unless sha256sum
  sha256sum
end

def amc_package_sha256sum(edition, version, os)
  sha256sums = {
    'community' => {
      'ubuntu12' => {},
      'debian6' => {},
      'el6' => {}
    },
    'enterprise' => {}
  }

  sha256sums['community']['ubuntu12']['3.6.3'] = 'c1d6692cb15a7088b947a27b9f862d44d64ba4976626ee0463a196e008b90547'
  sha256sums['community']['debian6']['3.6.3'] = 'c1d6692cb15a7088b947a27b9f862d44d64ba4976626ee0463a196e008b90547'
  sha256sums['community']['el6']['3.6.3'] = '9a160f59f7a815106a39c4cf28043665383986977d14e11a681ff0f29215ace5'

  sha256sum = sha256sums[edition][os][version]
  fail "sha256sum is missing for aerospike package edition #{edition} version #{version} os #{os}" unless sha256sum
  sha256sum
end

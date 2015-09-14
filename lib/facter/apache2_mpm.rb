Facter.add("apache2_mpm_type") do
  setcode do
    require 'facter'
    # For ubuntu 14.04
    Facter::Util::Resolution.exec("/usr/sbin/a2query -M")
  end
end

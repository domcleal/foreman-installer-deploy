Facter.add(:ipaddress) do
  confine :operatingsystem => :Fedora
  setcode do
    "192.168.101.100"
  end
end

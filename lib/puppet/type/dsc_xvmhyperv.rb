require 'pathname'

Puppet::Type.newtype(:dsc_xvmhyperv) do
  require Pathname.new(__FILE__).dirname + '../../' + 'puppet/type/base_dsc'

  provide :powershell, :parent => Puppet::Type.type(:base_dsc).provider(:powershell) do
    defaultfor :operatingsystem => :windows

    def ensure_value
        'present'
    end

    def absent_value
        'absent'
    end

  end

  @doc = %q{
    The DSC xVMHyperV resource type.
    Originally generated from the following schema.mof file:
      import/dsc_resources/xHyper-V/DSCResources/MSFT_xVMHyperV/MSFT_xVMHyperV.schema.mof
  }

  validate do
      fail('dsc_name is a required attribute') if self[:dsc_name].nil?
    end

  newparam(:dscmeta_resource_friendly_name) do
    defaultto "xVMHyperV"
  end

  newparam(:dscmeta_resource_name) do
    defaultto "MSFT_xVMHyperV"
  end

  newparam(:dscmeta_import_resource) do
    newvalues(true, false)

    munge do |value|
      provider.munge_boolean(value.to_s)
    end

    defaultto true
  end

  newparam(:dscmeta_module_name) do
    defaultto "xHyper-V"
  end

  newparam(:dscmeta_module_version) do
    defaultto "3.1.0.0"
  end

  newparam(:name, :namevar => true ) do
  end

  ensurable do
    newvalue(:exists?) { provider.exists? }
    newvalue(:present) { provider.create }
    newvalue(:absent)  { provider.destroy }
    defaultto :present
  end

  # Name:         Name
  # Type:         string
  # IsMandatory:  True
  # Values:       None
  newparam(:dsc_name) do
    desc "Name of the VM"
    isrequired
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         VhdPath
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_vhdpath) do
    desc "VHD associated with the VM"
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         SwitchName
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_switchname) do
    desc "Virtual switch associated with the VM"
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         State
  # Type:         string
  # IsMandatory:  False
  # Values:       ["Running", "Paused", "Off"]
  newparam(:dsc_state) do
    desc "State of the VM."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
      unless ['Running', 'running', 'Paused', 'paused', 'Off', 'off'].include?(value)
        fail("Invalid value '#{value}'. Valid values are Running, Paused, Off")
      end
    end
  end

  # Name:         Path
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_path) do
    desc "Folder where the VM data will be stored"
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         Generation
  # Type:         uint32
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_generation) do
    desc "Virtual machine generation"
    validate do |value|
      unless (value.kind_of?(Numeric) && value >= 0) || (value.to_i.to_s == value && value.to_i >= 0)
          fail("Invalid value #{value}. Should be a unsigned Integer")
      end
    end
    munge do |value|
      value.to_i
    end
  end

  # Name:         StartupMemory
  # Type:         uint64
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_startupmemory) do
    desc "Startup RAM for the VM."
    validate do |value|
      unless (value.kind_of?(Numeric) && value >= 0) || (value.to_i.to_s == value && value.to_i >= 0)
          fail("Invalid value #{value}. Should be a unsigned Integer")
      end
    end
    munge do |value|
      value.to_i
    end
  end

  # Name:         MinimumMemory
  # Type:         uint64
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_minimummemory) do
    desc "Minimum RAM for the VM. This enables dynamic memory."
    validate do |value|
      unless (value.kind_of?(Numeric) && value >= 0) || (value.to_i.to_s == value && value.to_i >= 0)
          fail("Invalid value #{value}. Should be a unsigned Integer")
      end
    end
    munge do |value|
      value.to_i
    end
  end

  # Name:         MaximumMemory
  # Type:         uint64
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_maximummemory) do
    desc "Maximum RAM for the VM. This enable dynamic memory."
    validate do |value|
      unless (value.kind_of?(Numeric) && value >= 0) || (value.to_i.to_s == value && value.to_i >= 0)
          fail("Invalid value #{value}. Should be a unsigned Integer")
      end
    end
    munge do |value|
      value.to_i
    end
  end

  # Name:         MACAddress
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_macaddress) do
    desc "MAC address of the VM."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         ProcessorCount
  # Type:         uint32
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_processorcount) do
    desc "Processor count for the VM"
    validate do |value|
      unless (value.kind_of?(Numeric) && value >= 0) || (value.to_i.to_s == value && value.to_i >= 0)
          fail("Invalid value #{value}. Should be a unsigned Integer")
      end
    end
    munge do |value|
      value.to_i
    end
  end

  # Name:         WaitForIP
  # Type:         boolean
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_waitforip) do
    desc "Waits for VM to get valid IP address."
    validate do |value|
    end
    newvalues(true, false)
    munge do |value|
      provider.munge_boolean(value.to_s)
    end
  end

  # Name:         RestartIfNeeded
  # Type:         boolean
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_restartifneeded) do
    desc "If specified, shutdowns and restarts the VM as needed for property changes"
    validate do |value|
    end
    newvalues(true, false)
    munge do |value|
      provider.munge_boolean(value.to_s)
    end
  end

  # Name:         Ensure
  # Type:         string
  # IsMandatory:  False
  # Values:       ["Present", "Absent"]
  newparam(:dsc_ensure) do
    desc "Should the VM be created or deleted"
    validate do |value|
      resource[:ensure] = provider.munge_ensure(value.downcase)
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
      unless ['Present', 'present', 'Absent', 'absent'].include?(value)
        fail("Invalid value '#{value}'. Valid values are Present, Absent")
      end
    end
  end

  # Name:         Notes
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_notes) do
    desc "Notes about the VM."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         ID
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_id) do
    desc "VM unique ID"
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         Status
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_status) do
    desc "Status of the VM"
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         CPUUsage
  # Type:         uint32
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_cpuusage) do
    desc "CPU Usage of the VM"
    validate do |value|
      unless (value.kind_of?(Numeric) && value >= 0) || (value.to_i.to_s == value && value.to_i >= 0)
          fail("Invalid value #{value}. Should be a unsigned Integer")
      end
    end
    munge do |value|
      value.to_i
    end
  end

  # Name:         MemoryAssigned
  # Type:         uint64
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_memoryassigned) do
    desc "Memory assigned to the VM"
    validate do |value|
      unless (value.kind_of?(Numeric) && value >= 0) || (value.to_i.to_s == value && value.to_i >= 0)
          fail("Invalid value #{value}. Should be a unsigned Integer")
      end
    end
    munge do |value|
      value.to_i
    end
  end

  # Name:         Uptime
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_uptime) do
    desc "Uptime of the VM"
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         CreationTime
  # Type:         datetime
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_creationtime) do
    desc "Creation time of the VM"
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         HasDynamicMemory
  # Type:         boolean
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_hasdynamicmemory) do
    desc "Does VM has dynamic memory enabled"
    validate do |value|
    end
    newvalues(true, false)
    munge do |value|
      provider.munge_boolean(value.to_s)
    end
  end

  # Name:         NetworkAdapters
  # Type:         string[]
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_networkadapters, :array_matching => :all) do
    desc "Network adapters of the VM"
    validate do |value|
      unless value.kind_of?(Array) || value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string or an array of strings")
      end
    end
    munge do |value|
      Array(value)
    end
  end


end

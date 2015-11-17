require 'pathname'

Puppet::Type.newtype(:dsc_xpendingreboot) do
  require Pathname.new(__FILE__).dirname + '../../' + 'puppet/type/base_dsc'
  require Pathname.new(__FILE__).dirname + '../../puppet_x/puppetlabs/dsc_type_helpers'


  @doc = %q{
    The DSC xPendingReboot resource type.
    Automatically generated from
    'xPendingReboot/DSCResources/MSFT_xPendingReboot/MSFT_xPendingReboot.schema.mof'

    To learn more about PowerShell Desired State Configuration, please
    visit https://technet.microsoft.com/en-us/library/dn249912.aspx.

    For more information about built-in DSC Resources, please visit
    https://technet.microsoft.com/en-us/library/dn249921.aspx.

    For more information about xDsc Resources, please visit
    https://github.com/PowerShell/DscResources.
  }

  validate do
      fail('dsc_name is a required attribute') if self[:dsc_name].nil?
    end

  newproperty(:dscmeta_resource_friendly_name) do
    desc "A read-only value that is the DSC Resource Friendly Name ('xPendingReboot')."

    def retrieve
      'xPendingReboot'
    end

    validate do |value|
      fail 'dscmeta_resource_friendly_name is read-only'
    end
  end

  newproperty(:dscmeta_resource_name) do
    desc "A read-only value that is the DSC Resource Name ('MSFT_xPendingReboot')."

    def retrieve
      'MSFT_xPendingReboot'
    end

    validate do |value|
      fail 'dscmeta_resource_name is read-only'
    end
  end

  newparam(:dscmeta_import_resource) do
    desc "Please ignore this parameter.
      Defaults to `true`."
    newvalues(true, false)

    munge do |value|
      PuppetX::Dsc::TypeHelpers.munge_boolean(value.to_s)
    end

    defaultto true
  end

  newproperty(:dscmeta_module_name) do
    desc "A read-only value that is the DSC Module Name ('xPendingReboot')."

    def retrieve
      'xPendingReboot'
    end

    validate do |value|
      fail 'dscmeta_module_name is read-only'
    end
  end

  newproperty(:dscmeta_module_version) do
    desc "A read-only value for the DSC Module Version ('0.1.0.2').
      This is the supported version of the PowerShell module that this
      type was built on. When Puppet runs this resource, it will explicitly
      use this version."

    def retrieve
      '0.1.0.2'
    end

    validate do |value|
      fail 'dscmeta_module_version is read-only'
    end
  end

  newparam(:name, :namevar => true ) do
  end

  ensurable do
    newvalue(:exists?) { provider.exists? }
    newvalue(:present) { provider.create }
    defaultto { :present }
  end

  # Name:         Name
  # Type:         string
  # IsMandatory:  True
  # Values:       None
  newparam(:dsc_name) do
    def mof_type; 'string' end
    def mof_is_embedded?; false end
    desc "Name"
    isrequired
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         ComponentBasedServicing
  # Type:         boolean
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_componentbasedservicing) do
    def mof_type; 'boolean' end
    def mof_is_embedded?; false end
    desc "ComponentBasedServicing"
    validate do |value|
    end
    newvalues(true, false)
    munge do |value|
      PuppetX::Dsc::TypeHelpers.munge_boolean(value.to_s)
    end
  end

  # Name:         WindowsUpdate
  # Type:         boolean
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_windowsupdate) do
    def mof_type; 'boolean' end
    def mof_is_embedded?; false end
    desc "WindowsUpdate"
    validate do |value|
    end
    newvalues(true, false)
    munge do |value|
      PuppetX::Dsc::TypeHelpers.munge_boolean(value.to_s)
    end
  end

  # Name:         PendingFileRename
  # Type:         boolean
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_pendingfilerename) do
    def mof_type; 'boolean' end
    def mof_is_embedded?; false end
    desc "PendingFileRename"
    validate do |value|
    end
    newvalues(true, false)
    munge do |value|
      PuppetX::Dsc::TypeHelpers.munge_boolean(value.to_s)
    end
  end

  # Name:         PendingComputerRename
  # Type:         boolean
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_pendingcomputerrename) do
    def mof_type; 'boolean' end
    def mof_is_embedded?; false end
    desc "PendingComputerRename"
    validate do |value|
    end
    newvalues(true, false)
    munge do |value|
      PuppetX::Dsc::TypeHelpers.munge_boolean(value.to_s)
    end
  end

  # Name:         CcmClientSDK
  # Type:         boolean
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_ccmclientsdk) do
    def mof_type; 'boolean' end
    def mof_is_embedded?; false end
    desc "CcmClientSDK"
    validate do |value|
    end
    newvalues(true, false)
    munge do |value|
      PuppetX::Dsc::TypeHelpers.munge_boolean(value.to_s)
    end
  end


end

Puppet::Type.type(:dsc_xpendingreboot).provide :powershell, :parent => Puppet::Type.type(:base_dsc).provider(:powershell) do
  confine :true => (Gem::Version.new(Facter.value(:powershell_version)) >= Gem::Version.new('5.0.10240.16384'))
  defaultfor :operatingsystem => :windows

  mk_resource_methods
end

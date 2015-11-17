require 'pathname'

Puppet::Type.newtype(:dsc_xpowershellexecutionpolicy) do
  require Pathname.new(__FILE__).dirname + '../../' + 'puppet/type/base_dsc'
  require Pathname.new(__FILE__).dirname + '../../puppet_x/puppetlabs/dsc_type_helpers'


  @doc = %q{
    The DSC xPowerShellExecutionPolicy resource type.
    Automatically generated from
    'xPowerShellExecutionPolicy/DSCResources/xPowerShellExecutionPolicy/xPowerShellExecutionPolicy.schema.mof'

    To learn more about PowerShell Desired State Configuration, please
    visit https://technet.microsoft.com/en-us/library/dn249912.aspx.

    For more information about built-in DSC Resources, please visit
    https://technet.microsoft.com/en-us/library/dn249921.aspx.

    For more information about xDsc Resources, please visit
    https://github.com/PowerShell/DscResources.
  }

  validate do
      fail('dsc_executionpolicy is a required attribute') if self[:dsc_executionpolicy].nil?
    end

  newproperty(:dscmeta_resource_friendly_name) do
    desc "A read-only value that is the DSC Resource Friendly Name ('xPowerShellExecutionPolicy')."

    def retrieve
      'xPowerShellExecutionPolicy'
    end

    validate do |value|
      fail 'dscmeta_resource_friendly_name is read-only'
    end
  end

  newproperty(:dscmeta_resource_name) do
    desc "A read-only value that is the DSC Resource Name ('xPowerShellExecutionPolicy')."

    def retrieve
      'xPowerShellExecutionPolicy'
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
    desc "A read-only value that is the DSC Module Name ('xPowerShellExecutionPolicy')."

    def retrieve
      'xPowerShellExecutionPolicy'
    end

    validate do |value|
      fail 'dscmeta_module_name is read-only'
    end
  end

  newproperty(:dscmeta_module_version) do
    desc "A read-only value for the DSC Module Version ('1.0.0').
      This is the supported version of the PowerShell module that this
      type was built on. When Puppet runs this resource, it will explicitly
      use this version."

    def retrieve
      '1.0.0'
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

  # Name:         ExecutionPolicy
  # Type:         string
  # IsMandatory:  True
  # Values:       ["Bypass", "Restricted", "AllSigned", "RemoteSigned", "Unrestricted"]
  newparam(:dsc_executionpolicy) do
    def mof_type; 'string' end
    def mof_is_embedded?; false end
    desc "ExecutionPolicy - Changes the user preference for the Windows PowerShell execution policy. Valid values are Bypass, Restricted, AllSigned, RemoteSigned, Unrestricted."
    isrequired
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
      unless ['Bypass', 'bypass', 'Restricted', 'restricted', 'AllSigned', 'allsigned', 'RemoteSigned', 'remotesigned', 'Unrestricted', 'unrestricted'].include?(value)
        fail("Invalid value '#{value}'. Valid values are Bypass, Restricted, AllSigned, RemoteSigned, Unrestricted")
      end
    end
  end


end

Puppet::Type.type(:dsc_xpowershellexecutionpolicy).provide :powershell, :parent => Puppet::Type.type(:base_dsc).provider(:powershell) do
  confine :true => (Gem::Version.new(Facter.value(:powershell_version)) >= Gem::Version.new('5.0.10240.16384'))
  defaultfor :operatingsystem => :windows

  mk_resource_methods
end

require 'pathname'

Puppet::Type.newtype(:dsc_xscsmarunbookworkerserversetup) do
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
    The DSC xSCSMARunbookWorkerServerSetup resource type.
    Originally generated from the following schema.mof file:
      import/dsc_resources/xSCSMA/DSCResources/MSFT_xSCSMARunbookWorkerServerSetup/MSFT_xSCSMARunbookWorkerServerSetup.schema.mof
  }

  validate do
      fail('dsc_ensure is a required attribute') if self[:dsc_ensure].nil?
    end

  newparam(:dscmeta_resource_friendly_name) do
    defaultto "xSCSMARunbookWorkerServerSetup"
  end

  newparam(:dscmeta_resource_name) do
    defaultto "MSFT_xSCSMARunbookWorkerServerSetup"
  end

  newparam(:dscmeta_import_resource) do
    newvalues(true, false)

    munge do |value|
      provider.munge_boolean(value.to_s)
    end

    defaultto true
  end

  newparam(:dscmeta_module_name) do
    defaultto "xSCSMA"
  end

  newparam(:dscmeta_module_version) do
    defaultto "1.2.1.0"
  end

  newparam(:name, :namevar => true ) do
  end

  ensurable do
    newvalue(:exists?) { provider.exists? }
    newvalue(:present) { provider.create }
    newvalue(:absent)  { provider.destroy }
    defaultto :present
  end

  # Name:         Ensure
  # Type:         string
  # IsMandatory:  True
  # Values:       ["Present", "Absent"]
  newparam(:dsc_ensure) do
    desc "An enumerated value that describes if the SMA Runbook Worker server is expected to be installed on the machine.\nPresent {default}  \nAbsent   \n"
    isrequired
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

  # Name:         SourcePath
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_sourcepath) do
    desc "UNC path to the root of the source files for installation."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         SourceFolder
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_sourcefolder) do
    desc "Folder within the source path containing the source files for installation."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         SetupCredential
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_setupcredential) do
    desc "Credential to be used to perform the installation."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         Service
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_service) do
    desc "Service account of the web service application pool."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         ServiceUserName
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_serviceusername) do
    desc "Output username of the Service account of the web service application pool."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         SqlServer
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_sqlserver) do
    desc "Name of the SQL Server for the SMA database."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         SqlInstance
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_sqlinstance) do
    desc "Name of the SQL Instance for the SMA database."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         SqlDatabase
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_sqldatabase) do
    desc "Name of the SMA database."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         InstallFolder
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_installfolder) do
    desc "Installation folder for SMA."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         ETWManifest
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_etwmanifest) do
    desc "Log to ETW."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         SendCEIPReports
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_sendceipreports) do
    desc "Participate in the Customer Experience Improvement Program."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         MSUpdate
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_msupdate) do
    desc "Use Microsoft Update."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         ProductKey
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_productkey) do
    desc "Product key for licensed installations."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end


end

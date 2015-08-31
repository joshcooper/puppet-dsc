require 'pathname'

Puppet::Type.newtype(:dsc_xmysqlgrant) do
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
    The DSC xMySqlGrant resource type.
    Originally generated from the following schema.mof file:
      import/dsc_resources/xMySql/DscResources/MSFT_xMySqlGrant/MSFT_xMySqlGrant.schema.mof
  }

  validate do
      fail('dsc_username is a required attribute') if self[:dsc_username].nil?
      fail('dsc_databasename is a required attribute') if self[:dsc_databasename].nil?
    end

  newparam(:dscmeta_resource_friendly_name) do
    defaultto "xMySqlGrant"
  end

  newparam(:dscmeta_resource_name) do
    defaultto "MSFT_xMySqlGrant"
  end

  newparam(:dscmeta_import_resource) do
    newvalues(true, false)

    munge do |value|
      provider.munge_boolean(value.to_s)
    end

    defaultto true
  end

  newparam(:dscmeta_module_name) do
    defaultto "xMySql"
  end

  newparam(:dscmeta_module_version) do
    defaultto "1.0.0.0"
  end

  newparam(:name, :namevar => true ) do
  end

  ensurable do
    newvalue(:exists?) { provider.exists? }
    newvalue(:present) { provider.create }
    newvalue(:absent)  { provider.destroy }
    defaultto :present
  end

  # Name:         UserName
  # Type:         string
  # IsMandatory:  True
  # Values:       None
  newparam(:dsc_username) do
    desc "Name of MySQL user."
    isrequired
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         DatabaseName
  # Type:         string
  # IsMandatory:  True
  # Values:       None
  newparam(:dsc_databasename) do
    desc "MySql database name to grant permissions."
    isrequired
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         ConnectionCredential
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_connectioncredential) do
    desc "MySql connection credential used for the root."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         PermissionType
  # Type:         string
  # IsMandatory:  False
  # Values:       ["ALL PRIVILEGES", "CREATE", "DROP", "DELETE", "INSERT", "SELECT", "UPDATE", "EXECUTE"]
  newparam(:dsc_permissiontype) do
    desc "MySql user permission type."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
      unless ['ALL PRIVILEGES', 'all privileges', 'CREATE', 'create', 'DROP', 'drop', 'DELETE', 'delete', 'INSERT', 'insert', 'SELECT', 'select', 'UPDATE', 'update', 'EXECUTE', 'execute'].include?(value)
        fail("Invalid value '#{value}'. Valid values are ALL PRIVILEGES, CREATE, DROP, DELETE, INSERT, SELECT, UPDATE, EXECUTE")
      end
    end
  end

  # Name:         Ensure
  # Type:         string
  # IsMandatory:  False
  # Values:       ["Present", "Absent"]
  newparam(:dsc_ensure) do
    desc "Ensure given grant to mySql database present or absent."
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


end
